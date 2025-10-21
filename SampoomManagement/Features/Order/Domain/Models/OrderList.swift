//
//  OrderList.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import Foundation

/// 주문 목록 모델
struct OrderList {
    let items: [Order]
    let totalCount: Int
    let isEmpty: Bool
    
    init(items: [Order] = []) {
        self.items = items
        self.totalCount = items.count
        self.isEmpty = items.isEmpty
    }
    
    /// 빈 주문 목록 생성
    static func empty() -> OrderList {
        return OrderList()
    }
}
