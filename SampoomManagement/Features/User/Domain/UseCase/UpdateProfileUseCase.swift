//
//  UpdateProfileUseCase.swift
//  SampoomManagement
//
//  Created by Generated.
//

import Foundation

class UpdateProfileUseCase {
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func execute(user: User) async throws -> User {
        return try await repository.updateProfile(user: user)
    }
}

