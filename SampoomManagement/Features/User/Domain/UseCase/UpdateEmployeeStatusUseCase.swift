//
//  UpdateEmployeeStatusUseCase.swift
//  SampoomManagement
//
//  Created by Generated.
//

import Foundation

class UpdateEmployeeStatusUseCase {
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func execute(employee: Employee, workspace: String) async throws -> Employee {
        return try await repository.updateEmployeeStatus(employee: employee, workspace: workspace)
    }
}


