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
    
    func execute(role: String, organizationId: Int, page: Int, size: Int) async throws -> (employees: [Employee], hasNext: Bool) {
        return try await repository.getEmployeeList(role: role, organizationId: organizationId, page: page, size: size)
    }
}

