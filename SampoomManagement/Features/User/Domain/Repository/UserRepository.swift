//
//  UserRepository.swift
//  SampoomManagement
//
//  Created by Generated.
//

import Foundation

protocol UserRepository {
    func getStoredUser() throws -> User?
    func getProfile(workspace: String) async throws -> User
    func updateProfile(user: User) async throws -> User
    func getEmployeeList(workspace: String, organizationId: Int, page: Int, size: Int) async throws -> (employees: [Employee], hasNext: Bool)
    func editEmployee(employee: Employee, workspace: String) async throws -> Employee
}

