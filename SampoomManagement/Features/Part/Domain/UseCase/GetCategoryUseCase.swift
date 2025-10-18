//
//  GetCategoryUseCase.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/17/25.
//

import Foundation

class GetCategoryUseCase {
    private let repository : PartRepository
    
    init (repository: PartRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> CategoryList {
        return try await repository.getCategoryList()
    }
}
