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
    private let completeOrderUseCase: CompleteOrderUseCase
    private let receiveOrderUseCase: ReceiveOrderUseCase
    private let globalMessageHandler: GlobalMessageHandler
    
    private var orderId: Int = 0
    
    init(
        getOrderDetailUseCase: GetOrderDetailUseCase,
        cancelOrderUseCase: CancelOrderUseCase,
        completeOrderUseCase: CompleteOrderUseCase,
        receiveOrderUseCase: ReceiveOrderUseCase,
        globalMessageHandler: GlobalMessageHandler,
        orderId: Int = 0
    ) {
        self.getOrderDetailUseCase = getOrderDetailUseCase
        self.cancelOrderUseCase = cancelOrderUseCase
        self.completeOrderUseCase = completeOrderUseCase
        self.receiveOrderUseCase = receiveOrderUseCase
        self.globalMessageHandler = globalMessageHandler
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
            uiState = uiState.copy(orderDetailLoading: true)
            
            do {
                let order = try await getOrderDetailUseCase.execute(orderId: orderId)
                uiState = uiState.copy(
                    orderDetail: order,
                    orderDetailLoading: false
                )
            } catch {
                let errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
                globalMessageHandler.showMessage(errorMessage, isError: true)
                uiState = uiState.copy(orderDetailLoading: false)
            }
            print("OrderDetailViewModel - loadOrderDetail: \(uiState)")
        }
    }
    
    private func cancelOrder() {
        Task {
            print("OrderDetailViewModel - orderId : \(orderId)")
            uiState = uiState.copy(isProcessing: true)
            
            do {
                try await cancelOrderUseCase.execute(orderId: orderId)
                globalMessageHandler.showMessage(StringResources.Order.detailToastOrderCancel, isError: false)
                uiState = uiState.copy(
                    isProcessing: false,
                    isProcessingCancelSuccess: true
                )
                loadOrderDetail()
            } catch {
                let errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
                globalMessageHandler.showMessage(errorMessage, isError: true)
                uiState = uiState.copy(isProcessing: false)
            }
            print("OrderDetailViewModel - cancelOrder: \(uiState)")
        }
    }
    
    private func receiveOrder() {
        Task {
            uiState = uiState.copy(isProcessing: true)
            
            do {
                // 1단계: 주문 입고 처리
                try await receiveOrderUseCase.execute(orderId: orderId)
                // 2단계: 주문 완료 처리
                try await completeOrderUseCase.execute(orderId: orderId)
                
                globalMessageHandler.showMessage(StringResources.Order.detailToastOrderReceive, isError: false)
                uiState = uiState.copy(
                    isProcessing: false,
                    isProcessingReceiveSuccess: true
                )
                loadOrderDetail()
            } catch {
                let errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
                globalMessageHandler.showMessage(errorMessage, isError: true)
                uiState = uiState.copy(isProcessing: false)
            }
            print("OrderDetailViewModel - receiveOrder: \(uiState)")
        }
    }
}
