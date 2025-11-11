//
//  Employee.swift
//  SampoomManagement
//
//  Created by Generated.
//

import Foundation

struct Employee: Equatable, Identifiable {
    let id: Int
    let userId: Int
    let email: String
    let role: String
    let userName: String
    let workspace: String
    let organizationId: Int
    let branch: String
    let position: UserPosition
    let status: EmployeeStatus
    let createdAt: String?
    let startedAt: String?
    let endedAt: String?
    let deletedAt: String?
}

