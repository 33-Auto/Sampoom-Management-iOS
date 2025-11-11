//
//  GetEmployeeCountUseCase.swift
//  SampoomManagement
//
//  Created by Generated.
//

import Foundation

class GetEmployeeCountUseCase {
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func execute(workspace: String, organizationId: Int) async throws -> Int {
        return try await repository.getEmployeeCount(workspace: workspace, organizationId: organizationId)
    }
}


