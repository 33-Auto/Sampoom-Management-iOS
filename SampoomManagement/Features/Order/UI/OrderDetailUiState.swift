//
//  OrderDetailUiState.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import Foundation

struct OrderDetailUiState {
    let orderDetail: [Order]
    let orderDetailLoading: Bool
    let orderDetailError: String?
    let isProcessing: Bool
    let isProcessingCancelSuccess: Bool
    let isProcessingReceiveSuccess: Bool
    let isProcessingError: String?
    
    init(
        orderDetail: [Order] = [],
        orderDetailLoading: Bool = false,
        orderDetailError: String? = nil,
        isProcessing: Bool = false,
        isProcessingCancelSuccess: Bool = false,
        isProcessingReceiveSuccess: Bool = false,
        isProcessingError: String? = nil
    ) {
        self.orderDetail = orderDetail
        self.orderDetailLoading = orderDetailLoading
        self.orderDetailError = orderDetailError
        self.isProcessing = isProcessing
        self.isProcessingCancelSuccess = isProcessingCancelSuccess
        self.isProcessingReceiveSuccess = isProcessingReceiveSuccess
        self.isProcessingError = isProcessingError
    }
    
    func copy(
        orderDetail: [Order]? = nil,
        orderDetailLoading: Bool? = nil,
        orderDetailError: String?? = nil,
        isProcessing: Bool? = nil,
        isProcessingCancelSuccess: Bool? = nil,
        isProcessingReceiveSuccess: Bool? = nil,
        isProcessingError: String?? = nil
    ) -> OrderDetailUiState {
        return OrderDetailUiState(
            orderDetail: orderDetail ?? self.orderDetail,
            orderDetailLoading: orderDetailLoading ?? self.orderDetailLoading,
            orderDetailError: orderDetailError ?? self.orderDetailError,
            isProcessing: isProcessing ?? self.isProcessing,
            isProcessingCancelSuccess: isProcessingCancelSuccess ?? self.isProcessingCancelSuccess,
            isProcessingReceiveSuccess: isProcessingReceiveSuccess ?? self.isProcessingReceiveSuccess,
            isProcessingError: isProcessingError ?? self.isProcessingError
        )
    }
}
