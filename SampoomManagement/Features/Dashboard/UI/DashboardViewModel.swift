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
    @Published var user: User? = nil
    
    private let getOrderUseCase: GetOrderUseCase
    private let getDashboardUseCase: GetDashboardUseCase
    private let getWeeklySummaryUseCase: GetWeeklySummaryUseCase
    private let getStoredUserUseCase: GetStoredUserUseCase
    private let getEmployeeCountUseCase: GetEmployeeCountUseCase
    private let messageHandler: GlobalMessageHandler
    
    init(
        getOrderUseCase: GetOrderUseCase,
        getDashboardUseCase: GetDashboardUseCase,
        getWeeklySummaryUseCase: GetWeeklySummaryUseCase,
        getStoredUserUseCase: GetStoredUserUseCase,
        getEmployeeCountUseCase: GetEmployeeCountUseCase,
        messageHandler: GlobalMessageHandler
    ) {
        self.getOrderUseCase = getOrderUseCase
        self.getDashboardUseCase = getDashboardUseCase
        self.getWeeklySummaryUseCase = getWeeklySummaryUseCase
        self.getStoredUserUseCase = getStoredUserUseCase
        self.getEmployeeCountUseCase = getEmployeeCountUseCase
        self.messageHandler = messageHandler
        loadAll()
    }
    
    func refreshUser() {
        loadUser()
        Task { await loadEmployeeCount() }
    }
    
    private func loadUser() {
        Task {
            do {
                user = try getStoredUserUseCase.execute()
            } catch {
                print("DashboardViewModel - 사용자 정보 조회 실패: \(error)")
            }
        }
    }
    
    func onEvent(_ event: DashboardUiEvent) {
        switch event {
        case .loadDashboard, .retryDashboard:
            loadAll()
        }
    }
    
    private func loadAll() {
        loadOrderList()
        loadUser()
        Task { await loadDashboard() }
        Task { await loadWeeklySummary() }
        Task { await loadEmployeeCount() }
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
        uiState = uiState.copy(dashboardLoading: true, dashboardError: .some(nil))
        do {
            let dashboard = try await getDashboardUseCase.execute()
            uiState = uiState.copy(
                dashboard: dashboard,
                dashboardLoading: false,
                dashboardError: .some(nil)
            )
        } catch {
            messageHandler.showMessage(error.localizedDescription, isError: true)
            uiState = uiState.copy(
                dashboardLoading: false,
                dashboardError: .some(error.localizedDescription)
            )
        }
    }
    
    private func loadWeeklySummary() async {
        uiState = uiState.copy(weeklySummaryLoading: true, weeklySummaryError: .some(nil))
        do {
            let weekly = try await getWeeklySummaryUseCase.execute()
            uiState = uiState.copy(
                weeklySummary: weekly,
                weeklySummaryLoading: false,
                weeklySummaryError: .some(nil)
            )
        } catch {
            messageHandler.showMessage(error.localizedDescription, isError: true)
            uiState = uiState.copy(
                weeklySummaryLoading: false,
                weeklySummaryError: .some(error.localizedDescription)
            )
        }
    }
    
    private func loadEmployeeCount() async {
        uiState = uiState.copy(employeeCountLoading: true, employeeCountError: .some(nil))
        
        do {
            guard let storedUser = try getStoredUserUseCase.execute() else {
                uiState = uiState.copy(
                    employeeCountLoading: false,
                    employeeCountError: .some(StringResources.Employee.userNotFound)
                )
                return
            }
            let workspace = storedUser.workspace.isEmpty ? "AGENCY" : storedUser.workspace
            
            let count = try await getEmployeeCountUseCase.execute(
                workspace: workspace,
                organizationId: storedUser.agencyId
            )
            
            uiState = uiState.copy(
                employeeCount: .some(count),
                employeeCountLoading: false,
                employeeCountError: .some(nil)
            )
        } catch {
            let errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
            messageHandler.showMessage(errorMessage, isError: true)
            uiState = uiState.copy(
                employeeCountLoading: false,
                employeeCountError: .some(errorMessage)
            )
        }
    }
}


