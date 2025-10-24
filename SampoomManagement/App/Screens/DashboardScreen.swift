//
//  DashboardScreen.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/25/25.
//

import SwiftUI

struct DashboardScreen: View {
    let dependencies: AppDependencies
    
    var body: some View {
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
                
                // 로그아웃 버튼
                Spacer()
                CommonButton(StringResources.Auth.logoutButton, backgroundColor: .red, textColor: .white) {
                    Task {
                        await dependencies.authViewModel.signOut()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                
                Spacer()
            }
            .navigationTitle(StringResources.Tabs.dashboard)
            .background(Color.background)
        }
    }
}
