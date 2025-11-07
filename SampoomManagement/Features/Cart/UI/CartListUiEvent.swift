//
//  CartListUiEvent.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import Foundation

enum CartListUiEvent {
    case loadCartList
    case retryCartList
    case processOrder
    case updateQuantity(cartItemId: Int, quantity: Int)
    case deleteCart(cartItemId: Int)
    case deleteAllCart
    case dismissOrderResult
}

