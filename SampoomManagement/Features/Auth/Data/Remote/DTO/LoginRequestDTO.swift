//
//  LoginRequestDTO.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/14/25.
//

import Foundation

struct LoginRequestDTO: Codable {
    let workspace: String
    let email: String
    let password: String
}


