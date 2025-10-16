//
//  ContentView.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import SwiftUI

enum Tabs {
    case dashboard, delivery, cart, orders, parts
}

struct ContentView: View {
    let dependencies: AppDependencies
    @StateObject private var partViewModel: PartViewModel
    @State private var selectedTab: Tabs = .dashboard
    
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
                } icon: {
                    Image("dashboard")
                        .renderingMode(.template)
                        .foregroundStyle(Color.text)
                }
            }
            
            // Delivery 탭 (임시)
            Tab(value: .delivery) {
                NavigationStack {
                    VStack(spacing: 20) {
                        Spacer()
                        Text(StringResources.Tabs.delivery)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text(StringResources.Placeholders.inventoryDescription)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                        Spacer()
                    }
                    .navigationTitle(StringResources.Tabs.delivery)
                }
            } label: {
                Label {
                    Text(StringResources.Tabs.delivery)
                } icon: {
                    Image("delivery")
                        .renderingMode(.template)
                        .foregroundStyle(Color.text)
                }
            }
            
            // Cart 탭 (임시)
            Tab(value: .cart) {
                NavigationStack {
                    VStack(spacing: 20) {
                        Spacer()
                        Text(StringResources.Tabs.cart)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text(StringResources.Placeholders.inventoryDescription)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                        Spacer()
                    }
                    .navigationTitle(StringResources.Tabs.cart)
                }
            } label: {
                Label {
                    Text(StringResources.Tabs.cart)
                } icon: {
                    Image("cart")
                        .renderingMode(.template)
                        .foregroundStyle(Color.text)
                }
            }
            
            // Orders 탭 (임시)
            Tab(value: .orders) {
                NavigationStack {
                    VStack(spacing: 20) {
                        Spacer()
                        Text(StringResources.Tabs.orders)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text(StringResources.Placeholders.inventoryDescription)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                        Spacer()
                    }
                    .navigationTitle(StringResources.Tabs.orders)
                }
            } label: {
                Label {
                    Text(StringResources.Tabs.orders)
                } icon: {
                    Image("orders")
                        .renderingMode(.template)
                        .foregroundStyle(Color.text)
                }
            }
            
            // PartView 탭
            Tab(value: .parts, role: .search) {
                PartView()
                    .environmentObject(partViewModel)
            } label: {
                Label {
                    Text(StringResources.Tabs.parts)
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
