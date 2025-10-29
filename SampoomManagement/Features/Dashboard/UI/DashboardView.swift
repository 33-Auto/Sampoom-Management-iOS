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
    let userName: String
    let workspace: String
    let branch: String
    var isManager = true
    
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
                    // TODO: role-based employee button
                    if (isManager) {
                        Button(action: {}) {
                            Image("employee").renderingMode(.template).foregroundStyle(.text)
                        }
                    }
                    Button(action: {}) {
                        Image("settings").renderingMode(.template).foregroundStyle(.text)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            
            ScrollView {
                VStack(spacing: 16) {
                    // Logout (temporary)
                    CommonButton(StringResources.Auth.logoutButton, backgroundColor: .red, textColor: .white) {
                        onLogoutClick()
                    }
                    
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
            Text("\(workspace) \(branch)")
                .font(.gmarketTitle2)
                .fontWeight(.bold)
                .foregroundColor(.text)
            
            Group {
                Text("안녕하세요, ") + Text(userName).foregroundColor(.accentColor) + Text(" 님")
            }
            .font(.gmarketTitle)
            .fontWeight(.bold)
            .foregroundColor(.text)
            
            Text("필요한 정보를 한 눈에 확인하세요.")
                .font(.gmarketBody)
                .foregroundColor(.text)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 24)
    }
    
    private var buttonSection: some View {
        VStack(spacing: 16) {
            if (isManager) {
                buttonCard(iconName: "employee", valueText: "45", subText: "직원 관리", bordered: true) {}
            }
            HStack(spacing: 16) {
                buttonCard(iconName: "parts", valueText: "1234", subText: "보유 부품") {}
                buttonCard(iconName: "orders", valueText: "23", subText: "진행중 주문") {}
            }
            HStack(spacing: 16) {
                buttonCard(iconName: "warning", valueText: "19", subText: "부족 부품") {}
                buttonCard(iconName: "money", valueText: "4,123,200", subText: "주문 금액") {}
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
                    .background(Color.accentColor)
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
                Text("최근 주문")
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


