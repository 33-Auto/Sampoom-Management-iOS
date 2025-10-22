//
//  OrderDetailViewModel.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class OrderDetailViewModel: ObservableObject {
    @Published var uiState = OrderDetailUiState()
    
    private let getOrderDetailUseCase: GetOrderDetailUseCase
    private let cancelOrderUseCase: CancelOrderUseCase
    private let receiveOrderUseCase: ReceiveOrderUseCase
    
    private var orderId: Int = 0
    
    init(
        getOrderDetailUseCase: GetOrderDetailUseCase,
        cancelOrderUseCase: CancelOrderUseCase,
        receiveOrderUseCase: ReceiveOrderUseCase,
        orderId: Int = 0
    ) {
        self.getOrderDetailUseCase = getOrderDetailUseCase
        self.cancelOrderUseCase = cancelOrderUseCase
        self.receiveOrderUseCase = receiveOrderUseCase
        self.orderId = orderId
    }
    
    func setOrderId(_ orderId: Int) {
        print("OrderDetailViewModel - SETorderId : \(orderId)")
        self.orderId = orderId
    }
    
    func onEvent(_ event: OrderDetailUiEvent) {
        switch event {
        case .loadOrder, .retryOrder:
            loadOrderDetail()
        case .receiveOrder:
            receiveOrder()
        case .cancelOrder:
            cancelOrder()
        case .clearError:
            uiState = uiState.copy(isProcessingError: nil)
        }
    }
    
    func clearSuccess() {
        uiState = uiState.copy(
            isProcessingCancelSuccess: false,
            isProcessingReceiveSuccess: false
        )
    }
    
    private func loadOrderDetail() {
        Task {
            uiState = uiState.copy(orderDetailLoading: true, orderDetailError: nil)
            
            do {
                let orderList = try await getOrderDetailUseCase.execute(orderId: orderId)
                uiState = uiState.copy(
                    orderDetail: orderList.items,
                    orderDetailLoading: false,
                    orderDetailError: nil
                )
            } catch {
                uiState = uiState.copy(
                    orderDetailLoading: false,
                    orderDetailError: error.localizedDescription
                )
            }
            print("OrderDetailViewModel - loadOrderDetail: \(uiState)")
        }
    }
    
    private func cancelOrder() {
        Task {
            print("OrderDetailViewModel - orderId : \(orderId)")
            uiState = uiState.copy(isProcessing: true, isProcessingError: nil)
            
            do {
                try await cancelOrderUseCase.execute(orderId: orderId)
                uiState = uiState.copy(
                    isProcessing: false,
                    isProcessingCancelSuccess: true,
                    isProcessingError: nil
                )
            } catch {
                uiState = uiState.copy(
                    isProcessing: false,
                    isProcessingError: error.localizedDescription
                )
            }
            print("OrderDetailViewModel - cancelOrder: \(uiState)")
        }
    }
    
    private func receiveOrder() {
        Task {
            uiState = uiState.copy(isProcessing: true, isProcessingError: nil)
            
            do {
                try await receiveOrderUseCase.execute(orderId: orderId)
                uiState = uiState.copy(
                    isProcessing: false,
                    isProcessingReceiveSuccess: true,
                    isProcessingError: nil
                )
            } catch {
                uiState = uiState.copy(
                    isProcessing: false,
                    isProcessingError: error.localizedDescription
                )
            }
            print("OrderDetailViewModel - receiveOrder: \(uiState)")
        }
    }
}
