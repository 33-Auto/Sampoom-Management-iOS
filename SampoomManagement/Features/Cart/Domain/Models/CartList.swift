//
//  CartList.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import Foundation

struct CartList: Equatable {
    let items: [Cart]
    let totalCount: Int
    let isEmpty: Bool
    
    init(items: [Cart]) {
        self.items = items
        self.totalCount = items.count
        self.isEmpty = items.isEmpty
    }
    
    static func empty() -> CartList {
        return CartList(items: [])
    }
}

