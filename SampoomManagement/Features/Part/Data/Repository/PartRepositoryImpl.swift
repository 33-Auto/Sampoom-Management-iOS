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
    
    func getPartList() async throws -> PartList {
        return try await api.getPartList()
    }
}
