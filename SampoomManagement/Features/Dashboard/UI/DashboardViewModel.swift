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
    private let getDashboardUseCase: GetDashboardUseCase
    private let getWeeklySummaryUseCase: GetWeeklySummaryUseCase
    private let messageHandler: GlobalMessageHandler
    
    init(
        getOrderUseCase: GetOrderUseCase,
        getDashboardUseCase: GetDashboardUseCase,
        getWeeklySummaryUseCase: GetWeeklySummaryUseCase,
        messageHandler: GlobalMessageHandler
    ) {
        self.getOrderUseCase = getOrderUseCase
        self.getDashboardUseCase = getDashboardUseCase
        self.getWeeklySummaryUseCase = getWeeklySummaryUseCase
        self.messageHandler = messageHandler
        loadAll()
    }
    
    func onEvent(_ event: DashboardUiEvent) {
        switch event {
        case .loadDashboard, .retryDashboard:
            loadAll()
        }
    }
    
    private func loadAll() {
        loadOrderList()
        Task { await loadDashboard() }
        Task { await loadWeeklySummary() }
    }
    
    private func loadOrderList() {
        Task {
            uiState = uiState.copy(dashboardLoading: true, dashboardError: nil)
            do {
                let orderList = try await getOrderUseCase.execute()
                uiState = uiState.copy(
                    orderList: Array(orderList.items.prefix(5))
                )
            } catch {
                uiState = uiState.copy(
                    dashboardError: error.localizedDescription
                )
            }
        }
    }
    
    private func loadDashboard() async {
        do {
            let dashboard = try await getDashboardUseCase.execute()
            uiState = uiState.copy(dashboard: dashboard, dashboardLoading: false, dashboardError: nil)
        } catch {
            messageHandler.showMessage(error.localizedDescription, isError: true)
            uiState = uiState.copy(dashboardLoading: false, dashboardError: error.localizedDescription)
        }
    }
    
    private func loadWeeklySummary() async {
        do {
            let weekly = try await getWeeklySummaryUseCase.execute()
            uiState = uiState.copy(weeklySummary: weekly, dashboardLoading: false, dashboardError: nil)
        } catch {
            messageHandler.showMessage(error.localizedDescription, isError: true)
            uiState = uiState.copy(dashboardLoading: false, dashboardError: error.localizedDescription)
        }
    }
}


