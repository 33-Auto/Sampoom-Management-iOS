//
//  Order.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import Foundation

struct Order: Equatable {
    let orderId: Int
    let orderNumber: String?
    let createdAt: String?
    let status: OrderStatus
    let agencyName: String?
    let items: [OrderCategory]
}

struct OrderCategory: Equatable {
    let categoryId: Int
    let categoryName: String
    let groups: [OrderGroup]
}

struct OrderGroup: Equatable {
    let groupId: Int
    let groupName: String
    let parts: [OrderPart]
}

struct OrderPart: Equatable {
    let partId: Int
    let code: String
    let name: String
    let quantity: Int
    let standardCost: Int
}
