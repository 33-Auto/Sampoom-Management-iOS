//
//  ContentView.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import SwiftUI

enum Tabs {
    case dashboard, outbound, cart, orders, parts
}

struct ContentView: View {
    let dependencies: AppDependencies
    @StateObject private var partViewModel: PartViewModel
    @State private var selectedTab: Tabs = .dashboard
    @State private var ordersNavigationPath = NavigationPath()
    @State private var partsNavigationPath = NavigationPath()
    
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _partViewModel = StateObject(wrappedValue: dependencies.makePartViewModel())
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Dashboard 탭 (임시)
            Tab(value: .dashboard) {
                NavigationStack {
                    VStack(spacing: 20) {
                        Spacer()
                        Text(StringResources.Tabs.dashboard)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text(StringResources.Placeholders.inventoryDescription)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                        Spacer()
                    }
                    .navigationTitle(StringResources.Tabs.dashboard)
                }
            } label: {
                Label {
                    Text(StringResources.Tabs.dashboard)
                        .font(.gmarketSubheadline)
                } icon: {
                    Image("dashboard")
                        .renderingMode(.template)
                        .foregroundStyle(.text)
                }
            }
            
            // Outbound 탭
            Tab(value: .outbound) {
                NavigationStack {
                    OutboundListView(viewModel: dependencies.makeOutboundListViewModel())
                }
            } label: {
                Label {
                    Text(StringResources.Tabs.outbound)
                        .font(.gmarketSubheadline)
                } icon: {
                    Image("outbound")
                        .renderingMode(.template)
                        .foregroundStyle(Color.text)
                }
            }
            
            // Cart 탭
            Tab(value: .cart) {
                NavigationStack {
                    CartListView(viewModel: dependencies.makeCartListViewModel())
                }
            } label: {
                Label {
                    Text(StringResources.Tabs.cart)
                        .font(.gmarketSubheadline)
                } icon: {
                    Image("cart")
                        .renderingMode(.template)
                        .foregroundStyle(Color.text)
                }
            }
            
            // Orders 탭
            Tab(value: .orders) {
                NavigationStack(path: $ordersNavigationPath) {
                    OrderListView(
                        viewModel: dependencies.makeOrderListViewModel(),
                        onNavigateOrderDetail: { orderId in
                            ordersNavigationPath.append(orderId)
                        }
                    )
                    .navigationDestination(for: Int.self) { orderId in
                        OrderDetailView(
                            orderId: orderId,
                            viewModel: dependencies.makeOrderDetailViewModel(orderId: orderId)
                        )
                    }
                }
            } label: {
                Label {
                    Text(StringResources.Tabs.orders)
                        .font(.gmarketSubheadline)
                } icon: {
                    Image("orders")
                        .renderingMode(.template)
                        .foregroundStyle(Color.text)
                }
            }
            
            // PartView 탭
            Tab(value: .parts, role: .search) {
                NavigationStack(path: $partsNavigationPath) {
                    PartView(
                        onNavigatePartList: { group in
                            partsNavigationPath.append(group.id)
                        },
                        viewModel: partViewModel
                    )
                    .navigationDestination(for: Int.self) { groupId in
                        PartListView(
                            viewModel: PartListViewModel(
                                getPartUseCase: dependencies.getPartUseCase,
                                groupId: groupId
                            ),
                            dependencies: dependencies
                        )
                    }
                }
                .environmentObject(partViewModel)
            } label: {
                Label {
                    Text(StringResources.Tabs.parts)
                        .font(.gmarketSubheadline)
                } icon: {
                    Image("parts")
                        .renderingMode(.template)
                        .foregroundStyle(Color.text)
                }
            }
        }
        .accentColor(.blue)
    }
}
