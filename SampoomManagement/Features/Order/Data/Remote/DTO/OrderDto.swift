//
//  OrderDto.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import Foundation

/// 주문 DTO
struct OrderDto: Codable {
    let orderId: Int
    let orderNumber: String?
    let createdAt: String?
    let status: OrderStatus
    let agencyName: String?
    let items: [OrderCategoryDto]
}

struct OrderCategoryDto: Codable {
    let categoryId: Int
    let categoryName: String
    let groups: [OrderGroupDto]
}

struct OrderGroupDto: Codable {
    let groupId: Int
    let groupName: String
    let parts: [OrderPartDto]
}

struct OrderPartDto: Codable {
    let partId: Int
    let code: String
    let name: String
    let quantity: Int
}
