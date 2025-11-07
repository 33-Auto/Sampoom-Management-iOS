//
//  GetStoredUserUseCase.swift
//  SampoomManagement
//
//  Created by Generated.
//

import Foundation

class GetStoredUserUseCase {
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func execute() throws -> User? {
        return try repository.getStoredUser()
    }
}

