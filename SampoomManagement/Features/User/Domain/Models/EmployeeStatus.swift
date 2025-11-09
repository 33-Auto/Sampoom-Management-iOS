//
//  EmployeeStatus.swift
//  SampoomManagement
//
//  Created by Generated.
//

import Foundation

enum EmployeeStatus: String, CaseIterable, Codable, Equatable {
    case active = "ACTIVE"
    case leave = "LEAVE"
    case retired = "RETIRED"
    
    var displayNameKo: String {
        switch self {
        case .active:
            return StringResources.Employee.statusActive
        case .leave:
            return StringResources.Employee.statusLeave
        case .retired:
            return StringResources.Employee.statusRetired
        }
    }
}


