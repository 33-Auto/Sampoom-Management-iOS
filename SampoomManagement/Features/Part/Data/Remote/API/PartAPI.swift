//
//  PartAPI.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import Foundation

class PartAPI {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func getCategoryList() async throws -> CategoryList {
        return try await withCheckedThrowingContinuation { continuation in
            networkManager.request(
                endpoint: "agency/category",
                responseType: [CategoryDTO].self
            ) { result in
                switch result {
                case .success(let response):
                    let categories = response.data.map { $0.toModel() }
                    let categoryList = CategoryList(items: categories)
                    continuation.resume(returning: categoryList)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func getGroupList(categoryId: Int) async throws -> PartsGroupList {
        return try await withCheckedThrowingContinuation { continuation in
            networkManager.request(
                endpoint: "agency/category/\(categoryId)",
                responseType: [GroupDTO].self
            ) { result in
                switch result {
                case .success(let response):
                    let groups = response.data.map { $0.toModel() }
                    let groupList = PartsGroupList(items: groups)
                    continuation.resume(returning: groupList)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func getPartList(groupId: Int) async throws -> PartList {
        return try await withCheckedThrowingContinuation { continuation in
            networkManager.request(
                endpoint: "agency/1/group/\(groupId)",
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
