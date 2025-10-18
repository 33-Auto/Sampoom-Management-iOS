//
//  PartList.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import Foundation

struct PartList: Equatable {
    let items: [Part]
    var totalCount: Int { items.count }
    var isEmpty: Bool { items.isEmpty }
    
    init(items: [Part]) {
        self.items = items
    }
    
    static func empty() -> PartList {
        return PartList(items: [])
    }
}
