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
    let hasMore: Bool
    let currentPage: Int
    let isLoadingMore: Bool
    
    init(
        orderList: [Order] = [],
        orderLoading: Bool = false,
        hasMore: Bool = true,
        currentPage: Int = 0,
        isLoadingMore: Bool = false
    ) {
        self.orderList = orderList
        self.orderLoading = orderLoading
        self.hasMore = hasMore
        self.currentPage = currentPage
        self.isLoadingMore = isLoadingMore
    }
    
    func copy(
        orderList: [Order]? = nil,
        orderLoading: Bool? = nil,
        hasMore: Bool? = nil,
        currentPage: Int? = nil,
        isLoadingMore: Bool? = nil
    ) -> OrderListUiState {
        return OrderListUiState(
            orderList: orderList ?? self.orderList,
            orderLoading: orderLoading ?? self.orderLoading,
            hasMore: hasMore ?? self.hasMore,
            currentPage: currentPage ?? self.currentPage,
            isLoadingMore: isLoadingMore ?? self.isLoadingMore
        )
    }
}
