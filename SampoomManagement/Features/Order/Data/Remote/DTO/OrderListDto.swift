//
//  OrderListDto.swift
//  SampoomManagement
//
//  Created by 채상윤 on 11/1/25.
//

import Foundation

/// 주문 목록 페이징 DTO
struct OrderListDto: Codable {
    let content: [OrderDto]
    let totalElements: Int
    let totalPages: Int
    let number: Int  // 현재 페이지 번호
    let last: Bool   // 마지막 페이지 여부
    let size: Int
    let first: Bool
}

