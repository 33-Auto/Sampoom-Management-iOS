//
//  LoginResponseDTO.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/14/25.
//

import Foundation

struct LoginResponseDTO: Codable {
    let userId: Int
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
}


