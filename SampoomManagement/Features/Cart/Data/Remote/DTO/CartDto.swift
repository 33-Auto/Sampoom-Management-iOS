//
//  CartDto.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import Foundation

struct CartDto: Codable {
    let categoryId: Int
    let categoryName: String
    let groups: [CartGroupDto]
}

struct CartGroupDto: Codable {
    let groupId: Int
    let groupName: String
    let parts: [CartPartDto]
}

struct CartPartDto: Codable {
    let cartItemId: Int
    let partId: Int
    let code: String
    let name: String
    let quantity: Int
}

