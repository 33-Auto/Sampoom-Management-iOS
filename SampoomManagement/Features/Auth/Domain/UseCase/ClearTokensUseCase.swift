//
//  ClearTokensUseCase.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/15/25.
//

import Foundation

class ClearTokensUseCase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func execute() async throws {
        try await repository.clearTokens()
    }
}
