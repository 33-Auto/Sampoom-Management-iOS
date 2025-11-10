//
//  NetworkManager.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

@preconcurrency import Foundation
import Alamofire

class NetworkManager {
    private let baseURL = "https://sampoom.store/api/"
    private let session: Session
    
    init(authRequestInterceptor: AuthRequestInterceptor) {
        // Alamofire Session 설정 with interceptor
        let configuration = URLSessionConfiguration.default
        self.session = Session(configuration: configuration, interceptor: authRequestInterceptor)
    }
    
    // 디코딩을 main actor 컨텍스트에서 수행
    // Swift 6 strict concurrency: 타입이 actor와 격리되지 않았음을 보장하기 위해
    // @MainActor 함수에서 직접 디코딩
    @MainActor private func decodeApiErrorResponse(from data: Data) -> ApiErrorResponse? {
        let decoder = JSONDecoder()
        // @MainActor 함수 내에서는 Codable 디코딩이 actor 격리 문제 없이 수행됨
        return try? decoder.decode(ApiErrorResponse.self, from: data)
    }
    
    @MainActor private func decodeApiResponse<T: Codable>(_ type: T.Type, from data: Data) throws -> APIResponse<T> {
        let decoder = JSONDecoder()
        // @MainActor 함수 내에서는 Codable 디코딩이 actor 격리 문제 없이 수행됨
        return try decoder.decode(APIResponse<T>.self, from: data)
    }
    
    @MainActor private func decodeEmptyApiResponse(from data: Data) -> APIResponse<EmptyResponse>? {
        let decoder = JSONDecoder()
        // @MainActor 함수 내에서는 Codable 디코딩이 actor 격리 문제 없이 수행됨
        return try? decoder.decode(APIResponse<EmptyResponse>.self, from: data)
    }
    
    func request<T: Codable>(
        endpoint: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        responseType: T.Type
    ) async throws -> APIResponse<T> {
        let url = baseURL + endpoint
        
        return try await withTaskCancellationHandler(operation: {
            try await withCheckedThrowingContinuation { continuation in
                let dataRequest = session.request(
                    url,
                    method: method,
                    parameters: parameters,
                    encoding: method == .get ? URLEncoding.default : JSONEncoding.default
                )
                .validate(statusCode: 200..<300)
                
                dataRequest.responseData { response in
                    switch response.result {
                    case .success(let data):
                        Task { @MainActor in
                            do {
                                print("NetworkManager - Raw response data: \(String(data: data, encoding: .utf8) ?? "Unable to decode")")
                                let apiResponse = try self.decodeApiResponse(T.self, from: data)
                                print("NetworkManager - Decoded response: \(apiResponse)")
                                continuation.resume(returning: apiResponse)
                            } catch {
                                print("NetworkManager - Decoding error: \(error)")
                                continuation.resume(throwing: NetworkError.decodingError(error))
                            }
                        }
                    case .failure(let error):
                        print("NetworkManager - Network error: \(error)")
                        
                        if let data = response.data {
                            Task { @MainActor in
                                // 1. ApiErrorResponse 형식으로 파싱 시도
                                if let errorResponse = self.decodeApiErrorResponse(from: data) {
                                    let statusCode = errorResponse.code ?? response.response?.statusCode ?? -1
                                    continuation.resume(throwing: NetworkError.serverError(statusCode, message: errorResponse.message))
                                    return
                                }
                                
                                // 2. APIResponse 형식으로 파싱 시도
                                if let httpResponse = response.response,
                                   let apiResponse = self.decodeEmptyApiResponse(from: data) {
                                    continuation.resume(throwing: NetworkError.serverError(httpResponse.statusCode, message: apiResponse.message))
                                    return
                                }
                                
                                // 3. HTTP 상태 코드 존재 시 기본 에러
                                if let httpResponse = response.response {
                                    continuation.resume(throwing: NetworkError.serverError(httpResponse.statusCode, message: nil))
                                    return
                                }
                                
                                // 4. 기타 네트워크 에러
                                continuation.resume(throwing: NetworkError.networkError(error))
                            }
                        } else if let httpResponse = response.response {
                            continuation.resume(throwing: NetworkError.serverError(httpResponse.statusCode, message: nil))
                        } else {
                            continuation.resume(throwing: NetworkError.networkError(error))
                        }
                    }
                }
            }
        }, onCancel: {
        })
    }
    
    func request<T: Codable, E: Encodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        body: E? = nil,
        responseType: T.Type
    ) async throws -> APIResponse<T> {
        let url = baseURL + endpoint
        
        return try await withTaskCancellationHandler(operation: {
            try await withCheckedThrowingContinuation { continuation in
                let dataRequest: DataRequest
                if let body = body {
                    dataRequest = session.request(
                        url,
                        method: method,
                        parameters: body,
                        encoder: JSONParameterEncoder.default
                    )
                    .validate(statusCode: 200..<300)
                } else {
                    dataRequest = session.request(
                        url,
                        method: method,
                        encoding: method == .get ? URLEncoding.default : JSONEncoding.default
                    )
                    .validate(statusCode: 200..<300)
                }
                
                dataRequest.responseData { response in
                    switch response.result {
                    case .success(let data):
                        Task { @MainActor in
                            do {
                                print("NetworkManager - Raw response data: \(String(data: data, encoding: .utf8) ?? "Unable to decode")")
                                let apiResponse = try self.decodeApiResponse(T.self, from: data)
                                print("NetworkManager - Decoded response: \(apiResponse)")
                                continuation.resume(returning: apiResponse)
                            } catch {
                                print("NetworkManager - Decoding error: \(error)")
                                continuation.resume(throwing: NetworkError.decodingError(error))
                            }
                        }
                    case .failure(let error):
                        print("NetworkManager - Network error: \(error)")
                        
                        if let data = response.data {
                            Task { @MainActor in
                                if let errorResponse = self.decodeApiErrorResponse(from: data) {
                                    let statusCode = errorResponse.code ?? response.response?.statusCode ?? -1
                                    continuation.resume(throwing: NetworkError.serverError(statusCode, message: errorResponse.message))
                                    return
                                }
                                
                                if let httpResponse = response.response,
                                   let apiResponse = self.decodeEmptyApiResponse(from: data) {
                                    continuation.resume(throwing: NetworkError.serverError(httpResponse.statusCode, message: apiResponse.message))
                                    return
                                }
                                
                                if let httpResponse = response.response {
                                    continuation.resume(throwing: NetworkError.serverError(httpResponse.statusCode, message: nil))
                                    return
                                }
                                
                                continuation.resume(throwing: NetworkError.networkError(error))
                            }
                        } else if let httpResponse = response.response {
                            continuation.resume(throwing: NetworkError.serverError(httpResponse.statusCode, message: nil))
                        } else {
                            continuation.resume(throwing: NetworkError.networkError(error))
                        }
                    }
                }
            }
        }, onCancel: {
        })
    }
}

