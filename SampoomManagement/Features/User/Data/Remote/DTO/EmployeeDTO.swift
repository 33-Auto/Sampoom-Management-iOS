//
//  EmployeeDTO.swift
//  SampoomManagement
//
//  Created by Generated.
//

import Foundation

struct EmployeeDTO: Codable {
    let userId: Int
    let email: String
    let role: String
    let userName: String
    let workspace: String
    let organizationId: Int
    let branch: String
    let position: UserPosition
    let employeeStatus: EmployeeStatus?
    let startedAt: String?
    let endedAt: String?
}

