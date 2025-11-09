//
//  UpdateProfileBottomSheet.swift
//  SampoomManagement
//
//  Created by Generated.
//

import SwiftUI

struct UpdateProfileBottomSheet: View {
    let user: User
    @ObservedObject var viewModel: UpdateProfileViewModel
    let onProfileUpdated: (User) -> Void
    let onDismiss: () -> Void
    @State private var userName: String
    
    init(
        user: User,
        viewModel: UpdateProfileViewModel,
        onProfileUpdated: @escaping (User) -> Void = { _ in },
        onDismiss: @escaping () -> Void
    ) {
        self.user = user
        self.viewModel = viewModel
        self.onProfileUpdated = onProfileUpdated
        self.onDismiss = onDismiss
        _userName = State(initialValue: user.name)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Spacer()
                // 직급 선택
                Text(StringResources.Setting.editProfile)
                    .font(.gmarketBody)
                    .foregroundColor(Color("Text"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                
                CommonTextField(
                    value: $userName,
                    placeholder: StringResources.Setting.editProfilePlaceholderUsername,
                    type: .text
                )
                .padding(.horizontal, 16)
                
                Spacer()
                
                CommonButton(
                    StringResources.Setting.editProfile,
                    type: .filled,
                    isEnabled: !viewModel.uiState.isLoading && !userName.isEmpty && userName != user.name,
                    action: {
                        viewModel.onEvent(.updateProfile(userName))
                    }
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
        }
        .onAppear {
            viewModel.onEvent(.initialize(user))
            userName = user.name
        }
        .onChange(of: viewModel.uiState.isSuccess) { _, isSuccess in
            if isSuccess {
                if let updatedUser = viewModel.uiState.user {
                    onProfileUpdated(updatedUser)
                }
                viewModel.clearStatus()
                onDismiss()
            }
        }
    }
}

