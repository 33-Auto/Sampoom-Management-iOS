//
//  OrderDetailUiState.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import Foundation

struct OrderDetailUiState {
    let orderDetail: Order?
    let orderDetailLoading: Bool
    let isProcessing: Bool
    let isProcessingCancelSuccess: Bool
    let isProcessingReceiveSuccess: Bool
    
    init(
        orderDetail: Order? = nil,
        orderDetailLoading: Bool = false,
        isProcessing: Bool = false,
        isProcessingCancelSuccess: Bool = false,
        isProcessingReceiveSuccess: Bool = false
    ) {
        self.orderDetail = orderDetail
        self.orderDetailLoading = orderDetailLoading
        self.isProcessing = isProcessing
        self.isProcessingCancelSuccess = isProcessingCancelSuccess
        self.isProcessingReceiveSuccess = isProcessingReceiveSuccess
    }
    
    func copy(
        orderDetail: Order? = nil,
        orderDetailLoading: Bool? = nil,
        isProcessing: Bool? = nil,
        isProcessingCancelSuccess: Bool? = nil,
        isProcessingReceiveSuccess: Bool? = nil
    ) -> OrderDetailUiState {
        return OrderDetailUiState(
            orderDetail: orderDetail ?? self.orderDetail,
            orderDetailLoading: orderDetailLoading ?? self.orderDetailLoading,
            isProcessing: isProcessing ?? self.isProcessing,
            isProcessingCancelSuccess: isProcessingCancelSuccess ?? self.isProcessingCancelSuccess,
            isProcessingReceiveSuccess: isProcessingReceiveSuccess ?? self.isProcessingReceiveSuccess
        )
    }
}
