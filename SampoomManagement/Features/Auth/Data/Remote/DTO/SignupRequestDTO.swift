//
//  SignupRequestDTO.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/14/25.
//

import Foundation

struct SignupRequestDTO: Codable {
    let userName: String
    let workspace: String
    let branch: String
    let position: String
    let email: String
    let password: String
}


