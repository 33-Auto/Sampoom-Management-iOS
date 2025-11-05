//
//  User.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/15/25.
//

import Foundation

enum UserRole: String, Codable, Equatable {
    case admin = "ADMIN"
    case user = "USER"
    case manager = "MANAGER"
    // Additional roles provided
    case staff = "STAFF"
    case seniorStaff = "SENIOR_STAFF"
    case assistantManager = "ASSISTANT_MANAGER"
    case deputyGeneralManager = "DEPUTY_GENERAL_MANAGER"
    case generalManager = "GENERAL_MANAGER"
    case director = "DIRECTOR"
    case vicePresident = "VICE_PRESIDENT"
    case president = "PRESIDENT"
    case chairman = "CHAIRMAN"

    var isAdmin: Bool { self == .admin }
}

struct User: Equatable {
    let id: Int
    let name: String
    let email: String
    let role: UserRole
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    // Additional profile fields merged after login
    let position: UserPosition
    let workspace: String
    let branch: String
    let agencyId: Int
    let startedAt: String?
    let endedAt: String?
}
