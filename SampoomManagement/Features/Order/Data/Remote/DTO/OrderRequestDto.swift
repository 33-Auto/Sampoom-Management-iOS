//
//  OrderRequestDto.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/31/25.
//

import Foundation

/// 주문 생성 요청 DTO
struct OrderRequestDto: Codable {
    let branch: String
    let items: [OrderItems]
}

struct OrderItems: Codable {
    let code: String
    let quantity: Int64
}


