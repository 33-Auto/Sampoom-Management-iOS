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
        responseType: T.Type,
        completion: @escaping (Result<APIResponse<T>, NetworkError>) -> Void
    ) {
        let url = baseURL + endpoint
                
        AF.request(
            url,
            method: method,
            parameters: parameters,
            encoding: JSONEncoding.default
        )
        .responseData { response in
            switch response.result {
            case .success(let data):
                Task { @MainActor in
                    do {
                        let apiResponse = try JSONDecoder().decode(APIResponse<T>.self, from: data)
                        completion(.success(apiResponse))
                    } catch {
                        completion(.failure(.decodingError(error)))
                    }
                }
            case .failure(let error):
                Task { @MainActor in
                    completion(.failure(.networkError(error)))
                }
            }
        }
    }
}
