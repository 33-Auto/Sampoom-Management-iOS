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
            do {
                let orderList = try await getOrderUseCase.execute()
                uiState = uiState.copy(
                    orderList: Array(orderList.items.prefix(5)),
                    dashboardLoading: false
                )
            } catch {
                messageHandler.showMessage(error.localizedDescription, isError: true)
            }
        }
    }
    
    private func loadDashboard() async {
        uiState = uiState.copy(dashboardLoading: true, dashboardError: nil)
        do {
            let dashboard = try await getDashboardUseCase.execute()
            uiState = uiState.copy(
                dashboard: dashboard,
                dashboardLoading: false,
                dashboardError: nil
            )
        } catch {
            messageHandler.showMessage(error.localizedDescription, isError: true)
            uiState = uiState.copy(
                dashboardLoading: false,
                dashboardError: error.localizedDescription
            )
        }
    }
    
    private func loadWeeklySummary() async {
        uiState = uiState.copy(weeklySummaryLoading: true, weeklySummaryError: nil)
        do {
            let weekly = try await getWeeklySummaryUseCase.execute()
            uiState = uiState.copy(
                weeklySummary: weekly,
                weeklySummaryLoading: false,
                weeklySummaryError: nil
            )
        } catch {
            messageHandler.showMessage(error.localizedDescription, isError: true)
            uiState = uiState.copy(
                weeklySummaryLoading: false,
                weeklySummaryError: error.localizedDescription
            )
        }
    }
}


