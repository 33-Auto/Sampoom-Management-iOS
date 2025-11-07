//
//  CartMappers.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import Foundation

extension CartDto {
    func toModel() -> Cart {
        return Cart(categoryId: categoryId, categoryName: categoryName, groups: groups.map { $0.toModel() })
    }
}

extension CartGroupDto {
    func toModel() -> CartGroup {
        return CartGroup(groupId: groupId, groupName: groupName, parts: parts.map { $0.toModel() })
    }
}

extension CartPartDto {
    func toModel() -> CartPart {
        return CartPart(
            cartItemId: cartItemId,
            partId: partId,
            code: code,
            name: name,
            quantity: quantity,
            standardCost: standardCost
        )
    }
}

