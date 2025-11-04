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
    let userName: String
    let branch: String
    let userRole: String
    
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
                    if userRole == "ADMIN" {
                        Button(action: {}) {
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
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 16)
            }
        }
        .background(Color.background)
        .refreshable {
            viewModel.onEvent(.loadDashboard)
        }
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("\(branch)")
                .font(.gmarketTitle2)
                .fontWeight(.bold)
                .foregroundColor(.text)
            
            Group {
                Text(StringResources.Dashboard.greetingPrefix) + Text(userName).foregroundColor(.accent) + Text(StringResources.Dashboard.greetingSuffix)
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
        VStack(spacing: 16) {
            if userRole == "ADMIN" {
                buttonCard(iconName: "employee", valueText: "45", subText: StringResources.Dashboard.employee, bordered: true) {}
            }
            HStack(spacing: 16) {
                buttonCard(iconName: "parts", valueText: "1234", subText: StringResources.Dashboard.partsOnHand) {}
                buttonCard(iconName: "orders", valueText: "23", subText: StringResources.Dashboard.partsInProgress) {}
            }
            HStack(spacing: 16) {
                buttonCard(iconName: "warning", valueText: "19", subText: StringResources.Dashboard.shortageOfParts) {}
                buttonCard(iconName: "money", valueText: "4,123,200", subText: StringResources.Dashboard.orderAmount) {}
            }
        }
        .padding(.bottom, 16)
    }
    
    private func buttonCard(iconName: String, valueText: String, subText: String, bordered: Bool = false, onClick: @escaping () -> Void) -> some View {
        Button(action: onClick) {
            VStack(alignment: .center, spacing: 16) {
                Image(iconName)
                    .renderingMode(.template)
                    .foregroundStyle(Color.white)
                    .padding(8)
                    .background(.accent)
                    .clipShape(Circle())
                Text(valueText)
                    .font(.gmarketTitle2)
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
                    .stroke(bordered ? Color.accentColor : Color.clear, lineWidth: 1)
            )
        }
    }
    
    private var orderListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(StringResources.Dashboard.recentOrdersTitle)
                    .font(.gmarketTitle2)
                    .foregroundColor(.text)
                Spacer()
                Button(action: { onNavigateOrderList() }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.textSecondary)
                        .padding(8)
                }
            }
            
            if viewModel.uiState.dashboardLoading {
                HStack { Spacer(); ProgressView(); Spacer() }
                    .padding(.vertical, 32)
            } else if let error = viewModel.uiState.dashboardError {
                VStack { Text(error).foregroundColor(.red) }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
            } else if viewModel.uiState.orderList.isEmpty {
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
}


