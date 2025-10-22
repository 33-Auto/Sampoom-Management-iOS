//
//  AddCartRequestDto.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import Foundation

struct AddCartRequestDto: Codable {
    let partId: Int
    let quantity: Int
}

