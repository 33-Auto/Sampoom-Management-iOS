//
//  PartDetailUiEvent.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/17/25.
//

import Foundation

enum PartDetailUiEvent {
    case initialize(Part)
    case increaseQuantity
    case decreaseQuantity
    case setQuantity(Int)
    case addToOutbound(partId: Int, quantity: Int)
    case addToCart(partId: Int, quantity: Int)
    case dismiss
}
