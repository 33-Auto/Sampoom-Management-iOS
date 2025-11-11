//
//  GetProfileUseCase.swift
//  SampoomManagement
//
//  Created by Generated.
//

import Foundation

class GetProfileUseCase {
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func execute(workspace: String) async throws -> User {
        return try await repository.getProfile(workspace: workspace)
    }
}

