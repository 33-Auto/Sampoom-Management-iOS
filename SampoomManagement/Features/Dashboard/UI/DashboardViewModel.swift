//
//  DashboardViewModel.swift
//  SampoomManagement
//
//  Created by Generated.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var uiState = DashboardUiState()
    
    private let getOrderUseCase: GetOrderUseCase
    
    init(getOrderUseCase: GetOrderUseCase) {
        self.getOrderUseCase = getOrderUseCase
        loadOrderList()
    }
    
    func onEvent(_ event: DashboardUiEvent) {
        switch event {
        case .loadDashboard, .retryDashboard:
            loadOrderList()
        }
    }
    
    private func loadOrderList() {
        Task {
            uiState = uiState.copy(dashboardLoading: true, dashboardError: nil)
            do {
                let orderList = try await getOrderUseCase.execute()
                uiState = uiState.copy(
                    orderList: Array(orderList.items.prefix(5)),
                    dashboardLoading: false,
                    dashboardError: nil
                )
            } catch {
                uiState = uiState.copy(
                    dashboardLoading: false,
                    dashboardError: error.localizedDescription
                )
            }
        }
    }
}


