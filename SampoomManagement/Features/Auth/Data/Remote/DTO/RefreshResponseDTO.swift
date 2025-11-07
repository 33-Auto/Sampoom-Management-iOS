//
//  RefreshResponseDTO.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/15/25.
//

import Foundation

struct RefreshResponseDTO: Codable {
    let accessToken: String
    let expiresIn: Int
    let refreshToken: String
}
