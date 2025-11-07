//
//  GetPartUseCase.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import Foundation

class GetPartUseCase {
    private let repository: PartRepository
    
    init(repository: PartRepository) {
        self.repository = repository
    }
    
    func execute(groupId: Int) async throws -> PartList {
        return try await repository.getPartList(groupId: groupId)
    }
}
