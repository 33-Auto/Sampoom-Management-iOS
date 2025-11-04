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

enum SettingNavigation: Hashable {
    case settings
}

struct ContentView: View {
    // MARK: - Properties
    let dependencies: AppDependencies
    @StateObject private var partViewModel: PartViewModel
    @StateObject private var dashboardViewModel: DashboardViewModel
    @State private var selectedTab: Tabs = .dashboard
    @State private var ordersNavigationPath = NavigationPath()
    @State private var partsNavigationPath = NavigationPath()
    @State private var dashboardNavigationPath = NavigationPath()
    
    // MARK: - Initialization
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _partViewModel = StateObject(wrappedValue: dependencies.makePartViewModel())
        _dashboardViewModel = StateObject(wrappedValue: DashboardViewModel(getOrderUseCase: dependencies.getOrderUseCase))
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // 전체 백그라운드
            Color.background
                .ignoresSafeArea(.all)
            
            TabView(selection: $selectedTab) {
                // Dashboard 탭 (DashboardView directly)
                Tab(value: .dashboard) {
                    NavigationStack(path: $dashboardNavigationPath) {
                        let user = try? dependencies.authPreferences.getStoredUser()
                        DashboardView(
                            viewModel: dashboardViewModel,
                            onLogoutClick: {
                                Task { await dependencies.authViewModel.signOut() }
                            },
                            onNavigateOrderDetail: { order in
                                selectedTab = .orders
                                DispatchQueue.main.async {
                                    ordersNavigationPath.append(order.orderId)
                                }
                            },
                            onNavigateOrderList: {
                                selectedTab = .orders
                            },
                            onSettingClick: {
                                dashboardNavigationPath.append(SettingNavigation.settings)
                            },
                            userName: user?.name ?? "",
                            branch: user?.branch ?? "",
                            userRole: user?.role ?? .user
                        )
                        .navigationDestination(for: SettingNavigation.self) { destination in
                            switch destination {
                            case .settings:
                                SettingView(
                                    viewModel: dependencies.makeSettingViewModel(),
                                    onNavigateBack: {
                                        dashboardNavigationPath.removeLast()
                                    },
                                    onLogoutClick: {
                                        Task { await dependencies.authViewModel.signOut() }
                                    }
                                )
                            }
                        }
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
                        CartListView(
                            viewModel: dependencies.makeCartListViewModel(),
                            dependencies: dependencies
                        )
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
                            viewModel: partViewModel,
                            searchViewModel: dependencies.makeSearchViewModel()
                        )
                        .navigationDestination(for: Int.self) { groupId in
                            PartListView(
                                viewModel: dependencies.makePartListViewModel(groupId: groupId),
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
            .accentColor(.accentColor)
            .tabViewStyle(.automatic)
        }
    }
}
