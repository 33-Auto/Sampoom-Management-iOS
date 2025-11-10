//
//  OrderRequestDto.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/31/25.
//

import Foundation

/// 주문 생성 요청 DTO
struct OrderRequestDto: Codable {
    let agencyId: Int
    let agencyName: String
    let items: [OrderCategoryDto]
}


