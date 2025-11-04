//
//  PartRepositoryImpl.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import Foundation

class PartRepositoryImpl: PartRepository {
    private let api: PartAPI
    private let preferences: AuthPreferences
    
    init(api: PartAPI, preferences: AuthPreferences) {
        self.api = api
        self.preferences = preferences
    }
    
    func getCategoryList() async throws -> CategoryList {
        return try await api.getCategoryList()
    }
    
    func getGroupList(categoryId: Int) async throws -> PartsGroupList {
        return try await api.getGroupList(categoryId: categoryId)
    }
    
    func getPartList(groupId: Int) async throws -> PartList {
        guard let user = try preferences.getStoredUser() else {
            throw NetworkError.unauthorized
        }
        return try await api.getPartList(agencyId: user.agencyId, groupId: groupId)
    }
    
    func searchParts(keyword: String, page: Int) async throws -> (results: [SearchResult], hasMore: Bool) {
        guard let user = try preferences.getStoredUser() else {
            throw NetworkError.unauthorized
        }
        return try await api.searchParts(agencyId: user.agencyId, keyword: keyword, page: page)
    }
}
