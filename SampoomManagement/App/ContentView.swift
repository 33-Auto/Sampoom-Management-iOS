//
//  ContentView.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var partViewModel: PartViewModel
    @State private var selectedTab = 0
    
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
            NavigationView {
                PartView()
                    .environmentObject(partViewModel)
            }
            .tabItem {
                Image(systemName: "wrench.and.screwdriver")
                Text("부품")
            }
            .tag(0)
            
            // InventoryView 탭 (임시)
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
            .tabItem {
                Image(systemName: "cube.box")
                Text("인벤토리")
            }
            .tag(1)
            
            // ProfileView 탭 (임시)
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
            .tabItem {
                Image(systemName: "person.circle")
                Text("프로필")
            }
            .tag(2)
            
            // SettingView 탭 (임시)
            NavigationView {
                VStack(spacing: 20) {
                    Spacer()
                    Text("설정")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                .navigationTitle("설정")
            }
            .tabItem {
                Image(systemName: "gearshape")
                Text("설정")
            }
            .tag(3)
        }
        .accentColor(.blue)
    }
}
