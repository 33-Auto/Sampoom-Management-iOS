//
//  NetworkManager.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import Foundation
import Alamofire

class NetworkManager {
    private let baseURL = "https://sampoom.store/api/"
    private let session: Session
    
    init(authRequestInterceptor: AuthRequestInterceptor) {
        // Alamofire Session 설정 with interceptor
        let configuration = URLSessionConfiguration.default
        self.session = Session(configuration: configuration, interceptor: authRequestInterceptor)
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
                
                dataRequest.responseData { response in
                    switch response.result {
                    case .success(let data):
                        do {
                            print("NetworkManager - Raw response data: \(String(data: data, encoding: .utf8) ?? "Unable to decode")")
                            let decoder = JSONDecoder()
                            let apiResponse = try decoder.decode(APIResponse<T>.self, from: data)
                            print("NetworkManager - Decoded response: \(apiResponse)")
                            continuation.resume(returning: apiResponse)
                        } catch {
                            print("NetworkManager - Decoding error: \(error)")
                            continuation.resume(throwing: NetworkError.decodingError(error))
                        }
                    case .failure(let error):
                        print("NetworkManager - Network error: \(error)")
                        continuation.resume(throwing: NetworkError.networkError(error))
                    }
                }
            }
        }, onCancel: {
        })
    }
}
