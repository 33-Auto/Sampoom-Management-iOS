//
//  OrderFormatter.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import Foundation

struct OrderFormatter {
    static func buildOrderTitle(_ order: Order) -> String {
        // 모든 파트를 평면화
        let flattened: [(category: String, group: String, part: OrderPart)] = order.items.flatMap { category in
            category.groups.flatMap { group in
                group.parts.map { part in
                    (category: category.categoryName, group: group.groupName, part: part)
                }
            }
        }
        
        // 빈 목록인 경우
        guard !flattened.isEmpty else {
            return "-"
        }
        
        let first = flattened.first!
        let groupName = first.group
        let part = first.part
        let totalParts = flattened.count
        
        // 단일 아이템인 경우
        if totalParts == 1 {
            return "\(groupName) - \(part.name) \(part.quantity)EA"
        } else {
            // 여러 아이템인 경우
            return "\(groupName) - \(part.name) \(part.quantity)EA 외 \(totalParts - 1)건"
        }
    }
}
