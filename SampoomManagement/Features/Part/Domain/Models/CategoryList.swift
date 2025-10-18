//
//  CategoryList.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/17/25.
//

import Foundation

struct CategoryList: Equatable {
    let items: [Category]
    var totalCount: Int { items.count }
    var isEmpty: Bool { items.isEmpty }
    
    init(items: [Category]) {
        self.items = items
    }
    
    static func empty() -> CategoryList {
        return CategoryList(items: [])
    }
}
