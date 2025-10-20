//
//  OutboundList.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/17/25.
//

import Foundation

struct OutboundList: Equatable {
    let items: [Outbound]
    let totalCount: Int
    let isEmpty: Bool
    
    init(items: [Outbound]) {
        self.items = items
        self.totalCount = items.count
        self.isEmpty = items.isEmpty
    }
    
    static func empty() -> OutboundList {
        return OutboundList(items: [])
    }
}
