//
//  ReceiveStockRequestDto.swift
//  SampoomManagement
//

import Foundation

struct ReceiveStockRequestDto: Codable {
    let items: [ReceiveStockItemDto]
}


