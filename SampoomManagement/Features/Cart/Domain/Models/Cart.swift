//
//  Cart.swift
//  SampoomManagement
//
//  Created by AI Assistant on 10/20/25.
//

import Foundation

struct Cart: Equatable {
    let categoryId: Int
    let categoryName: String
    let groups: [CartGroup]
}

struct CartGroup: Equatable {
    let groupId: Int
    let groupName: String
    let parts: [CartPart]
}

struct CartPart: Equatable {
    let cartItemId: Int
    let partId: Int
    let code: String
    let name: String
    let quantity: Int
}

