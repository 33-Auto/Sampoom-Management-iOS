//
//  GetGroupUseCase.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import Foundation

class GetGroupUseCase {
    private let repository: PartRepository
    
    init(repository: PartRepository) {
        self.repository = repository
    }
    
    func execute(categoryId: Int) async throws -> PartsGroupList {
        return try await repository.getGroupList(categoryId: categoryId)
    }
}
