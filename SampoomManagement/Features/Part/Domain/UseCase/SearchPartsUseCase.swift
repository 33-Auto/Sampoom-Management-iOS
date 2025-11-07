//
//  SearchPartsUseCase.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/17/25.
//

import Foundation

class SearchPartsUseCase {
    private let repository: PartRepository
    
    init(repository: PartRepository) {
        self.repository = repository
    }
    
    func execute(keyword: String, page: Int) async throws -> (results: [SearchResult], hasMore: Bool) {
        return try await repository.searchParts(keyword: keyword, page: page)
    }
}
