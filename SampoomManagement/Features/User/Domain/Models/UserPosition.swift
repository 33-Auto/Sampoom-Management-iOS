//
//  UserPosition.swift
//  SampoomManagement
//
//  Created by AI on 11/5/25.
//

import Foundation

enum UserPosition: String, CaseIterable, Codable, Equatable, Hashable {
    case staff = "STAFF"
    case seniorStaff = "SENIOR_STAFF"
    case assistantManager = "ASSISTANT_MANAGER"
    case manager = "MANAGER"
    case deputyGeneralManager = "DEPUTY_GENERAL_MANAGER"
    case generalManager = "GENERAL_MANAGER"
    case director = "DIRECTOR"
    case vicePresident = "VICE_PRESIDENT"
    case president = "PRESIDENT"
    case chairman = "CHAIRMAN"

    var displayNameKo: String {
        switch self {
        case .staff: return "사원"
        case .seniorStaff: return "주임"
        case .assistantManager: return "대리"
        case .manager: return "과장"
        case .deputyGeneralManager: return "차장"
        case .generalManager: return "부장"
        case .director: return "이사"
        case .vicePresident: return "부사장"
        case .president: return "사장"
        case .chairman: return "회장"
        }
    }
}

