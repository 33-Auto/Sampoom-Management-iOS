//
//  SignUpUseCase.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/14/25.
//

import Foundation

class SignUpUseCase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func execute(
        userName: String,
        role: String,
        branch: String,
        position: String,
        email: String,
        password: String
    ) async throws -> User {
        return try await repository.signUp(
            userName: userName,
            role: role,
            branch: branch,
            position: position,
            email: email,
            password: password
        )
    }
}

