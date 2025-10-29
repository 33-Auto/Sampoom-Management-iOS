//
//  DashboardUiState.swift
//  SampoomManagement
//
//  Created by Generated.
//

import Foundation

struct DashboardUiState: Equatable {
    let orderList: [Order]
    let dashboardLoading: Bool
    let dashboardError: String?
    
    init(
        orderList: [Order] = [],
        dashboardLoading: Bool = false,
        dashboardError: String? = nil
    ) {
        self.orderList = orderList
        self.dashboardLoading = dashboardLoading
        self.dashboardError = dashboardError
    }
    
    func copy(
        orderList: [Order]? = nil,
        dashboardLoading: Bool? = nil,
        dashboardError: String? = nil
    ) -> DashboardUiState {
        return DashboardUiState(
            orderList: orderList ?? self.orderList,
            dashboardLoading: dashboardLoading ?? self.dashboardLoading,
            dashboardError: dashboardError ?? self.dashboardError
        )
    }
}


