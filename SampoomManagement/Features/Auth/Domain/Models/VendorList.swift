//
//  VendorList.swift
//  SampoomManagement
//
//  Created to mirror Android vendor list domain model.
//

import Foundation

struct VendorList: Equatable {
    let items: [Vendor]
    var totalCount: Int { items.count }
    var isEmpty: Bool { items.isEmpty }
    static func empty() -> VendorList { VendorList(items: []) }
}


