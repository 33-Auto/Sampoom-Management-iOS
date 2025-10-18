//
//  PartsGroupList.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/17/25.
//

import Foundation

struct PartsGroupList: Equatable {
    let items: [PartsGroup]
    var totalCount: Int { items.count }
    var isEmpty: Bool { items.isEmpty }
    
    init(items: [PartsGroup]) {
        self.items = items
    }
    
    static func empty() -> PartsGroupList {
        return PartsGroupList(items: [])
    }
}
