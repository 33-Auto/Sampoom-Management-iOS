//
//  ContentView.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import SwiftUI

enum Tabs {
    case part, inventory, profile, setting, detail
}

struct ContentView: View {
    @StateObject private var partViewModel: PartViewModel
    @State private var selectedTab: Tabs = .part
    @State var searchString = ""
    
    init() {
        // DI Container에서 ViewModel 주입
        guard let viewModel = DIContainer.shared.resolve(PartViewModel.self) else {
            fatalError("PartViewModel을 DIContainer에서 찾을 수 없습니다.")
        }
        _partViewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // PartView 탭
            Tab(StringResources.Tabs.parts, systemImage: "wrench.and.screwdriver", value: .part) {
                PartView()
                    .environmentObject(partViewModel)
            }
            
            // InventoryView 탭 (임시)
            Tab(StringResources.Tabs.inventory, systemImage: "cube.box", value: .inventory) {
                NavigationView {
                    VStack(spacing: 20) {
                        Spacer()
                        Text(StringResources.Tabs.inventory)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text(StringResources.Placeholders.inventoryDescription)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                        Spacer()
                    }
                    .navigationTitle(StringResources.Tabs.inventory)
                }
            }
            
            // ProfileView 탭 (임시)
            Tab(StringResources.Tabs.profile, systemImage: "person.circle", value: .profile) {
                NavigationView {
                    VStack(spacing: 20) {
                        Spacer()
                        Text(StringResources.Tabs.profile)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text(StringResources.Placeholders.profileDescription)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                        Spacer()
                    }
                    .navigationTitle(StringResources.Tabs.profile)
                }
            }
            
            // SettingView 탭 (임시)
            Tab(StringResources.Tabs.settings, systemImage: "gearshape", value: .setting) {
                NavigationStack {
                    VStack(spacing: 20) {
                        Spacer()
                        Text(StringResources.Tabs.settings)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text(StringResources.Placeholders.settingsDescription)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                        NavigationLink {
                            DetailView()
                        } label: {
                            Text(StringResources.Navigation.detail)
                        }
                        .buttonStyle(.borderedProminent)
                        Spacer()
                    }
                    .navigationTitle(StringResources.Tabs.settings)
                }
            }
            
            Tab(value: .detail, role: .search) {
                NavigationStack {
                    VStack {
                        Text(StringResources.Search.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text(StringResources.Placeholders.searchDescription)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                }
                .navigationTitle(StringResources.Search.title)
                .searchable(text: $searchString)
            }
        }
        .accentColor(.blue)
    }
}

struct DetailView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text(StringResources.Detail.screenTitle)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Text(StringResources.Detail.description)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
            }
            .navigationTitle(StringResources.Detail.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(StringResources.Navigation.close) {
                        // 닫기 액션
                    }
                }
            }
        }
    }
}
