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
    @Published var uiState = OrderListUiState()
    
    private let getOrderUseCase: GetOrderUseCase
    
    init(getOrderUseCase: GetOrderUseCase) {
        self.getOrderUseCase = getOrderUseCase
    }
    
    func onEvent(_ event: OrderListUiEvent) {
        switch event {
        case .loadOrderList, .retryOrderList:
            loadOrderList()
        }
    }
    
    private func loadOrderList() {
        Task {
            uiState = uiState.copy(orderLoading: true, orderError: nil)
            
            do {
                let orderList = try await getOrderUseCase.execute()
                uiState = uiState.copy(
                    orderList: orderList.items,
                    orderLoading: false,
                    orderError: nil
                )
            } catch {
                uiState = uiState.copy(
                    orderLoading: false,
                    orderError: error.localizedDescription
                )
            }
            print("OrderListViewModel - loadOrderList: \(uiState)")
        }
    }
}
