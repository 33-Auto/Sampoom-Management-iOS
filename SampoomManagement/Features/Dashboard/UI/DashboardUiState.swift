//
//  DashboardUiState.swift
//  SampoomManagement
//
//  Created by Generated.
//

import Foundation

struct DashboardUiState: Equatable {
    let orderList: [Order]
    let dashboard: Dashboard?
    let weeklySummary: WeeklySummary?
    let dashboardLoading: Bool
    let dashboardError: String?
    let weeklySummaryLoading: Bool
    let weeklySummaryError: String?
    let employeeCount: Int?
    let employeeCountLoading: Bool
    let employeeCountError: String?
    
    init(
        orderList: [Order] = [],
        dashboard: Dashboard? = nil,
        weeklySummary: WeeklySummary? = nil,
        dashboardLoading: Bool = false,
        dashboardError: String? = nil,
        weeklySummaryLoading: Bool = false,
        weeklySummaryError: String? = nil,
        employeeCount: Int? = nil,
        employeeCountLoading: Bool = false,
        employeeCountError: String? = nil
    ) {
        self.orderList = orderList
        self.dashboard = dashboard
        self.weeklySummary = weeklySummary
        self.dashboardLoading = dashboardLoading
        self.dashboardError = dashboardError
        self.weeklySummaryLoading = weeklySummaryLoading
        self.weeklySummaryError = weeklySummaryError
        self.employeeCount = employeeCount
        self.employeeCountLoading = employeeCountLoading
        self.employeeCountError = employeeCountError
    }
    
    func copy(
        orderList: [Order]? = nil,
        dashboard: Dashboard?? = nil,
        weeklySummary: WeeklySummary?? = nil,
        dashboardLoading: Bool? = nil,
        dashboardError: String?? = nil,
        weeklySummaryLoading: Bool? = nil,
        weeklySummaryError: String?? = nil,
        employeeCount: Int?? = nil,
        employeeCountLoading: Bool? = nil,
        employeeCountError: String?? = nil
    ) -> DashboardUiState {
        return DashboardUiState(
            orderList: orderList ?? self.orderList,
            dashboard: dashboard ?? self.dashboard,
            weeklySummary: weeklySummary ?? self.weeklySummary,
            dashboardLoading: dashboardLoading ?? self.dashboardLoading,
            dashboardError: dashboardError ?? self.dashboardError,
            weeklySummaryLoading: weeklySummaryLoading ?? self.weeklySummaryLoading,
            weeklySummaryError: weeklySummaryError ?? self.weeklySummaryError,
            employeeCount: employeeCount ?? self.employeeCount,
            employeeCountLoading: employeeCountLoading ?? self.employeeCountLoading,
            employeeCountError: employeeCountError ?? self.employeeCountError
        )
    }
}


