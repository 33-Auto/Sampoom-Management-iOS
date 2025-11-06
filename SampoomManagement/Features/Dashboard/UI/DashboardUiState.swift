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
    
    init(
        orderList: [Order] = [],
        dashboard: Dashboard? = nil,
        weeklySummary: WeeklySummary? = nil,
        dashboardLoading: Bool = false,
        dashboardError: String? = nil
    ) {
        self.orderList = orderList
        self.dashboard = dashboard
        self.weeklySummary = weeklySummary
        self.dashboardLoading = dashboardLoading
        self.dashboardError = dashboardError
    }
    
    func copy(
        orderList: [Order]? = nil,
        dashboard: Dashboard?? = nil,
        weeklySummary: WeeklySummary?? = nil,
        dashboardLoading: Bool? = nil,
        dashboardError: String? = nil
    ) -> DashboardUiState {
        return DashboardUiState(
            orderList: orderList ?? self.orderList,
            dashboard: dashboard ?? self.dashboard,
            weeklySummary: weeklySummary ?? self.weeklySummary,
            dashboardLoading: dashboardLoading ?? self.dashboardLoading,
            dashboardError: dashboardError ?? self.dashboardError
        )
    }
}


