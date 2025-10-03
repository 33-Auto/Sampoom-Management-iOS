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
            Tab("부품", systemImage: "wrench.and.screwdriver", value: .part) {
                PartView()
                    .environmentObject(partViewModel)
            }
            
            // InventoryView 탭 (임시)
            Tab("인벤토리", systemImage: "cube.box", value: .inventory) {
                NavigationView {
                    VStack(spacing: 20) {
                        Spacer()
                        Text("인벤토리")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .navigationTitle("인벤토리")
                }
            }
            
            // ProfileView 탭 (임시)
            Tab("프로필", systemImage: "person.circle", value: .profile) {
                NavigationView {
                    VStack(spacing: 20) {
                        Spacer()
                        Text("프로필")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .navigationTitle("프로필")
                }
            }
            
            // SettingView 탭 (임시)
            Tab("설정", systemImage: "gearshape", value: .setting) {
                NavigationStack {
                    VStack(spacing: 20) {
                        Spacer()
                        Text("설정")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        NavigationLink {
                            DetailView()
                        } label: {
                            Text("상세 보기")
                        }
                        Spacer()
                    }
                    .navigationTitle("설정")
                }
            }
            
            Tab(value: .detail, role: .search) {
                NavigationStack {
                    Text("검색")
                }
                .navigationTitle("검색")
                .searchable(text: $searchString)
            }
        }
        .accentColor(.blue)
    }
}

struct DetailView: View {
    var body: some View {
        NavigationStack {
            Text("상세")
        }
    }
}
