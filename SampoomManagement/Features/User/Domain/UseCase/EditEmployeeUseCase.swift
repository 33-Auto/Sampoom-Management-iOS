//
//  EditEmployeeUseCase.swift
//  SampoomManagement
//
//  Created by Generated.
//

import Foundation

class EditEmployeeUseCase {
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func execute(employee: Employee, workspace: String) async throws -> Employee {
        return try await repository.editEmployee(employee: employee, workspace: workspace)
    }
}

