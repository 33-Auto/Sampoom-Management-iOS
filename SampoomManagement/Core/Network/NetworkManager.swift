//
//  NetworkManager.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    private let baseURL = "https://sampoom.store/api/"
    
    init() {}
    
    func request<T: Codable>(
        endpoint: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        responseType: T.Type
    ) async throws -> APIResponse<T> {
        let url = baseURL + endpoint
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                url,
                method: method,
                parameters: parameters,
                encoding: JSONEncoding.default
            )
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        print("NetworkManager - Raw response data: \(String(data: data, encoding: .utf8) ?? "Unable to decode")")
                        let apiResponse = try JSONDecoder().decode(APIResponse<T>.self, from: data)
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
    }
}
