//
//  APIResponse.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import Foundation

struct APIResponse<T: Codable>: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: T?
}

struct EmptyResponse: Codable {
}
