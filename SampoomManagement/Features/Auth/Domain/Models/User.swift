//
//  User.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/15/25.
//

import Foundation

struct User: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let role: String
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
}
