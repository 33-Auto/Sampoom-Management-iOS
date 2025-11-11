//
//  GetEmployeeUseCase.swift
//  SampoomManagement
//
//  Created by Generated.
//

import Foundation

class GetEmployeeUseCase {
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func execute(workspace: String, organizationId: Int, page: Int, size: Int) async throws -> (employees: [Employee], hasNext: Bool) {
        return try await repository.getEmployeeList(workspace: workspace, organizationId: organizationId, page: page, size: size)
    }
}

