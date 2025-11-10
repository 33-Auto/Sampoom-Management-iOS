//
//  UserRepository.swift
//  SampoomManagement
//
//  Created by Generated.
//

import Foundation

protocol UserRepository {
    func getStoredUser() throws -> User?
    func getProfile(role: String) async throws -> User
    func updateProfile(user: User) async throws -> User
    func getEmployeeList(role: String, organizationId: Int, page: Int, size: Int) async throws -> (employees: [Employee], hasNext: Bool)
    func editEmployee(employee: Employee, role: String) async throws -> Employee
    func updateEmployeeStatus(employee: Employee, role: String) async throws -> Employee
    func getEmployeeCount(role: String, organizationId: Int) async throws -> Int
}

