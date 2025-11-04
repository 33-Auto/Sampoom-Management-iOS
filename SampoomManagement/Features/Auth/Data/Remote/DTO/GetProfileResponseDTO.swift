//
//  GetProfileResponseDTO.swift
//  SampoomManagement
//
//  Created by Generated.
//

import Foundation

struct GetProfileResponseDTO: Codable {
    let userId: Int
    let userName: String
    let email: String
    let role: String
    let position: String
    let workspace: String
    let branch: String
    let organizationId: Int
    let startedAt: String
    let endedAt: String?
}


