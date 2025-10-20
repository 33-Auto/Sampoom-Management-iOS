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
        let response = try await networkManager.request(
            endpoint: "agency/category",
            responseType: [CategoryDTO].self
        )
        let categories = (response.data ?? []).map { $0.toModel() }
        return CategoryList(items: categories)
    }
    
    func getGroupList(categoryId: Int) async throws -> PartsGroupList {
        let response = try await networkManager.request(
            endpoint: "agency/category/\(categoryId)",
            responseType: [GroupDTO].self
        )
        let groups = (response.data ?? []).map { $0.toModel() }
        return PartsGroupList(items: groups)
    }
    
    func getPartList(groupId: Int) async throws -> PartList {
        let response = try await networkManager.request(
            endpoint: "agency/1/group/\(groupId)",
            responseType: [PartDTO].self
        )
        let parts = (response.data ?? []).map { $0.toModel() }
        return PartList(items: parts)
    }
}
