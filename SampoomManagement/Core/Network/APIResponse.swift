//
//  APIResponse.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

@preconcurrency import Foundation

struct APIResponse<T: Codable>: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: T?
}

struct EmptyResponse: Codable {
}

/// API 에러 응답 (안드로이드와 동일한 구조)
struct ApiErrorResponse: Codable {
    let code: Int?
    let message: String?
}
