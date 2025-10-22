//
//  OrderMappers .swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/21/25.
//

import Foundation

extension OrderDto {
    func toModel() -> Order {
        return Order(orderId: orderId, orderNumber: orderNumber, createdAt: createdAt, status: status, agencyName: agencyName, items: items.map { $0.toModel() })
    }
}

extension OrderCategoryDto {
    func toModel() -> OrderCategory {
        return OrderCategory(categoryId: categoryId, categoryName: categoryName, groups: groups.map { $0.toModel() })
    }
}

extension OrderGroupDto {
    func toModel() -> OrderGroup {
        return OrderGroup(groupId: groupId, groupName: groupName, parts: parts.map { $0.toModel() })
    }
}

extension OrderPartDto {
    func toModel() -> OrderPart {
        return OrderPart(partId: partId, code: code, name: name, quantity: quantity)
    }
}
