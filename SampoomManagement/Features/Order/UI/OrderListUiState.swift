//
//  OrderListUiState.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import Foundation

struct OrderListUiState {
    let orderList: [Order]
    let orderLoading: Bool
    let orderError: String?
    
    init(
        orderList: [Order] = [],
        orderLoading: Bool = false,
        orderError: String? = nil
    ) {
        self.orderList = orderList
        self.orderLoading = orderLoading
        self.orderError = orderError
    }
    
    func copy(
        orderList: [Order]? = nil,
        orderLoading: Bool? = nil,
        orderError: String?? = nil
    ) -> OrderListUiState {
        return OrderListUiState(
            orderList: orderList ?? self.orderList,
            orderLoading: orderLoading ?? self.orderLoading,
            orderError: orderError ?? self.orderError
        )
    }
}
