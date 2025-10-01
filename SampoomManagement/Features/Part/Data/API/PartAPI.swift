//
//  PartAPI.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import Foundation

class PartAPI {
    private let networkManager = NetworkManager.shared
    
    func getPartList() async throws -> PartList {
        return try await withCheckedThrowingContinuation { continuation in
            networkManager.request(
                endpoint: "part",
                responseType: [PartDTO].self
            ) { result in
                switch result {
                case .success(let response):
                    let parts = response.data.map { $0.toModel() }
                    let partList = PartList(items: parts)
                    continuation.resume(returning: partList)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
