//
//  PartRepositoryImpl.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import Foundation

class PartRepositoryImpl: PartRepository {
    private let api: PartAPI
    
    init(api: PartAPI) {
        self.api = api
    }
    
    func getCategoryList() async throws -> CategoryList {
        return try await api.getCategoryList()
    }
    
    func getGroupList(categoryId: Int) async throws -> PartsGroupList {
        return try await api.getGroupList(categoryId: categoryId)
    }
    
    func getPartList(groupId: Int) async throws -> PartList {
        return try await api.getPartList(groupId: groupId)
    }
    
    func searchParts(keyword: String, page: Int) async throws -> (results: [SearchResult], hasMore: Bool) {
        return try await api.searchParts(keyword: keyword, page: page)
    }
}
