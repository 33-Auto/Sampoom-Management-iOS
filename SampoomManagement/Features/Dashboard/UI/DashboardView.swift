//
//  DashboardView.swift
//  SampoomManagement
//
//  Created by Generated.
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: DashboardViewModel
    let onLogoutClick: () -> Void
    let onNavigateOrderDetail: (Order) -> Void
    let onNavigateOrderList: () -> Void
    let onSettingClick: () -> Void
    let onEmployeeClick: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Top bar
            HStack {
                Image("oneline_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 24)
                Spacer()
                HStack(spacing: 12) {
                    if let user = viewModel.user, isManagerOrAbove(user.position) {
                        Button(action: onEmployeeClick) {
                            Image("employee").renderingMode(.template).foregroundStyle(.text)
                        }
                    }
                    Button(action: onSettingClick) {
                        Image("settings").renderingMode(.template).foregroundStyle(.text)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            
            ScrollView {
                VStack(spacing: 16) {
                    titleSection
                    buttonSection
                    orderListSection
                    Spacer(minLength: 32)
                    weeklySummarySection
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 16)
            }
        }
        .background(Color.background)
        .refreshable {
            viewModel.onEvent(.loadDashboard)
            viewModel.refreshUser()
        }
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(viewModel.user?.branch ?? "")
                .font(.gmarketTitle2)
                .fontWeight(.bold)
                .foregroundColor(.text)
            
            Group {
                Text(StringResources.Dashboard.greetingPrefix) + Text(viewModel.user?.name ?? "").foregroundColor(.accent) + Text(StringResources.Dashboard.greetingSuffix)
            }
            .font(.gmarketTitle)
            .fontWeight(.bold)
            .foregroundColor(.text)
            
            Text(StringResources.Dashboard.intro)
                .font(.gmarketBody)
                .foregroundColor(.text)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 24)
    }
    
    private var buttonSection: some View {
        let dash = viewModel.uiState.dashboard
        return VStack(spacing: 16) {
            if let user = viewModel.user, isManagerOrAbove(user.position) {
                let employeeValueText = viewModel.uiState.employeeCount
                    .map { String($0) } ?? StringResources.Common.slash
                buttonCard(iconName: "employee", valueText: employeeValueText, subText: StringResources.Dashboard.employee, bordered: true, onClick: onEmployeeClick)
            }
            HStack(spacing: 16) {
                buttonCard(iconName: "car", valueText: String(dash?.totalParts ?? 0), subText: StringResources.Dashboard.partsAll)
                buttonCard(iconName: "block", valueText: String(dash?.outOfStockParts ?? 0), subText: StringResources.Dashboard.partsOutOfStock)
            }
            HStack(spacing: 16) {
                buttonCard(iconName: "warning", valueText: String(dash?.lowStockParts ?? 0), subText: StringResources.Dashboard.partLowStock)
                buttonCard(iconName: "parts", valueText: String(dash?.totalQuantity ?? 0), subText: StringResources.Dashboard.partsOnHand)
            }
        }
        .padding(.bottom, 16)
    }
    
    private func buttonCard(iconName: String, valueText: String, subText: String, bordered: Bool = false, onClick: (() -> Void)? = nil) -> some View {
        Button(action: onClick ?? {}) {
            VStack(alignment: .center, spacing: 16) {
                Image(iconName)
                    .renderingMode(.template)
                    .foregroundStyle(Color.white)
                    .padding(8)
                    .background(.accent)
                    .clipShape(Circle())
                Text(valueText)
                    .font(.gmarketTitle2)
                    .fontWeight(.bold)
                    .foregroundColor(.text)
                Text(subText)
                    .font(.gmarketBody)
                    .foregroundColor(.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(Color.backgroundCard)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(bordered ? .accent : Color.clear, lineWidth: 1)
            )
        }
    }
    
    private var orderListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(StringResources.Dashboard.recentOrdersTitle)
                    .font(.gmarketTitle2)
                    .fontWeight(.bold)
                    .foregroundColor(.text)
                Spacer()
                Button(action: { onNavigateOrderList() }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.textSecondary)
                        .padding(8)
                }
            }
            
            if viewModel.uiState.orderList.isEmpty {
                VStack { Text(StringResources.Order.emptyList).foregroundColor(.textSecondary) }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
            } else {
                VStack(spacing: 8) {
                    ForEach(viewModel.uiState.orderList, id: \.orderId) { order in
                        OrderItem(order: order) { onNavigateOrderDetail(order) }
                    }
                }
            }
        }
    }
    
    private var weeklySummarySection: some View {
        let weekly = viewModel.uiState.weeklySummary
        return VStack(alignment: .leading, spacing: 16) {
            Text(StringResources.Dashboard.weeklySummaryTitle)
                .font(.gmarketTitle2)
                .fontWeight(.bold)
                .foregroundColor(.text)
            
            HStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text(String(weekly?.inStockParts ?? 0))
                        .font(.gmarketTitle2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    Text(StringResources.Dashboard.weeklySummaryInStock)
                        .font(.gmarketBody)
                        .foregroundColor(.textSecondary)
                }
                .frame(maxWidth: .infinity)
                
                VStack(spacing: 8) {
                    Text(String(weekly?.outStockParts ?? 0))
                        .font(.gmarketTitle2)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    Text(StringResources.Dashboard.weeklySummaryOutStock)
                        .font(.gmarketBody)
                        .foregroundColor(.textSecondary)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(Color.backgroundCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func isManagerOrAbove(_ position: UserPosition) -> Bool {
        switch position {
        case .manager, .deputyGeneralManager, .generalManager, .director, .vicePresident, .president, .chairman:
            return true
        default:
            return false
        }
    }
}


