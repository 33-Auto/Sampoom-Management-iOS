//
//  OrderListViewModel.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class OrderListViewModel: ObservableObject {
    // MARK: - Properties
    @Published var uiState = OrderListUiState()
    
    private let getOrderUseCase: GetOrderUseCase
    private let globalMessageHandler: GlobalMessageHandler
    
    // MARK: - Initialization
    init(getOrderUseCase: GetOrderUseCase, globalMessageHandler: GlobalMessageHandler) {
        self.getOrderUseCase = getOrderUseCase
        self.globalMessageHandler = globalMessageHandler
    }
    
    // MARK: - Actions
    func onEvent(_ event: OrderListUiEvent) {
        switch event {
        case .loadOrderList:
            loadOrderList(page: 0, append: false)
        case .retryOrderList:
            loadOrderList(page: 0, append: false)
        case .loadMore:
            guard uiState.hasMore, !uiState.orderLoading else { return }
            loadOrderList(page: uiState.currentPage + 1, append: true)
        }
    }
    
    // MARK: - Private Methods
    private func loadOrderList(page: Int, append: Bool) {
        Task {
            if append {
                uiState = uiState.copy(isLoadingMore: true)
            } else {
                uiState = uiState.copy(orderLoading: true)
            }
            
            do {
                let (items, hasMore) = try await getOrderUseCase.execute(page: page, size: 20)
                let newOrders = append ? uiState.orderList + items : items
                
                uiState = uiState.copy(
                    orderList: newOrders,
                    orderLoading: false,
                    hasMore: hasMore,
                    currentPage: page,
                    isLoadingMore: false
                )
            } catch {
                let errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
                globalMessageHandler.showMessage(errorMessage, isError: true)
                uiState = uiState.copy(
                    orderLoading: false,
                    isLoadingMore: false
                )
            }
            print("OrderListViewModel - loadOrderList: \(uiState)")
        }
    }
}
