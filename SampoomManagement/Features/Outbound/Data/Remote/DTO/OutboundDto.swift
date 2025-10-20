//
//  OutboundDto.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/17/25.
//

import Foundation

struct OutboundDto: Codable {
    let categoryId: Int
    let categoryName: String
    let groups: [OutboundGroupDto]
}

struct OutboundGroupDto: Codable {
    let groupId: Int
    let groupName: String
    let parts: [OutboundPartDto]
}

struct OutboundPartDto: Codable {
    let outboundId: Int
    let partId: Int
    let code: String
    let name: String
    let quantity: Int
}
