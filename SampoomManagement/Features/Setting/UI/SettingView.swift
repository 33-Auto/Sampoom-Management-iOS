//
//  SettingView.swift
//  SampoomManagement
//
//  Created by Generated.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject var viewModel: SettingViewModel
    let onNavigateBack: () -> Void
    let onLogoutClick: () -> Void
    @State private var showLogoutDialog = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    if let user = viewModel.user {
                        userSection(user: user)
                    }
                    
                    settingSection()
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationTitle(StringResources.Setting.title)
        .navigationBarTitleDisplayMode(.large)
        .background(Color.background)
        .refreshable {
            viewModel.onEvent(.loadProfile)
        }
        .onAppear {
            viewModel.onEvent(.loadProfile)
        }
        .alert("로그아웃", isPresented: $showLogoutDialog) {
            Button(StringResources.Common.cancel, role: .cancel) {}
            Button(StringResources.Common.confirm) {
                Task {
                    if await viewModel.logout() {
                        onLogoutClick()
                    }
                }
            }
        } message: {
            Text(StringResources.Setting.dialogLogout)
        }
    }
    
    private func userSection(user: User) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(user.name)
                    .font(.gmarketTitle)
                    .foregroundColor(.text)
                
                Text(user.position.displayNameKo)
                    .font(.gmarketBody)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8) {
                Text(user.email)
                    .font(.gmarketBody)
                    .foregroundColor(.textSecondary)
                
                if let startedAt = user.startedAt, !startedAt.isEmpty {
                    Text(DateFormatterUtil.formatDate(startedAt))
                        .font(.gmarketBody)
                        .foregroundColor(.textSecondary)
                }
                
                if let endedAt = user.endedAt, !endedAt.isEmpty {
                    Text(DateFormatterUtil.formatDate(endedAt))
                        .font(.gmarketBody)
                        .foregroundColor(.textSecondary)
                }
            }
        }
        .padding(.vertical, 16)
    }
    
    private func settingSection() -> some View {
        VStack(spacing: 8) {
            Button(action: {
                // TODO: Edit profile
                viewModel.onEvent(.editProfile)
            }) {
                HStack {
                    Text(StringResources.Setting.editProfile)
                        .font(.gmarketBody)
                        .foregroundColor(.text)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.textSecondary)
                }
                .padding(16)
                .background(Color.backgroundCard)
                .cornerRadius(12)
            }
            
            Button(action: {
                showLogoutDialog = true
            }) {
                HStack {
                    Text(StringResources.Setting.logout)
                        .font(.gmarketBody)
                        .foregroundColor(.text)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.textSecondary)
                }
                .padding(16)
                .background(Color.backgroundCard)
                .cornerRadius(12)
            }
        }
    }
}

