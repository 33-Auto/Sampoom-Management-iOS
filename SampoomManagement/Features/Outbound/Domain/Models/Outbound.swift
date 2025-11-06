//
//  Outbound.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/17/25.
//

import Foundation

struct Outbound: Equatable {
    let categoryId: Int
    let categoryName: String
    let groups: [OutboundGroup]
}

struct OutboundGroup: Equatable {
    let groupId: Int
    let groupName: String
    let parts: [OutboundPart]
}

struct OutboundPart: Equatable {
    let outboundId: Int
    let partId: Int
    let code: String
    let name: String
    let quantity: Int
    let standardCost: Int
}
