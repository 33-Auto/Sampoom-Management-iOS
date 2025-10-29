//
//  SignUpView.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/14/25.
//

import SwiftUI
import Toast

struct SignUpView: View {
    @ObservedObject var viewModel: SignUpViewModel
    @StateObject private var keyboardObserver = KeyboardObserver()
    @State private var name = ""
    @State private var branch = ""
    @State private var position = ""
    @State private var email = ""
    @State private var password = ""
    @State private var passwordCheck = ""
    @FocusState private var focusedField: Field?
    
    let onSuccess: () -> Void
    
    private let labelTextSize: CGFloat = 16
    
    private enum Field: Hashable {
        case name, branch, position, email, password, passwordCheck
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // 로고
                Image("oneline_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120)
                    .frame(alignment: .leading)
                
                Spacer()
                    .frame(height: 48)
                
                // 이름
                Text(StringResources.Auth.nameLabel)
                    .font(.gmarketBody)
                    .foregroundColor(Color("Text"))
                    .padding(.bottom, 4)
                CommonTextField(
                    value: $name,
                    placeholder: StringResources.Auth.namePlaceholder,
                    isError: viewModel.uiState.nameError != nil,
                    errorMessage: viewModel.uiState.nameError,
                    onTextChange: { text in viewModel.updateName(text) },
                    submitLabel: .next,
                    onSubmit: { focusedField = .branch }
                )
                .focused($focusedField, equals: .name)
                
                Spacer()
                    .frame(height: 8)
                
                // 지점
                Text(StringResources.Auth.branchLabel)
                    .font(.gmarketBody)
                    .foregroundColor(Color("Text"))
                    .padding(.bottom, 4)
                CommonTextField(
                    value: $branch,
                    placeholder: StringResources.Auth.branchPlaceholder,
                    isError: viewModel.uiState.branchError != nil,
                    errorMessage: viewModel.uiState.branchError,
                    onTextChange: { text in viewModel.updateBranch(text) },
                    submitLabel: .next,
                    onSubmit: { focusedField = .position }
                )
                .focused($focusedField, equals: .branch)
                
                Spacer()
                    .frame(height: 8)
                
                // 직급
                Text(StringResources.Auth.positionLabel)
                    .font(.gmarketBody)
                    .foregroundColor(Color("Text"))
                    .padding(.bottom, 4)
                CommonTextField(
                    value: $position,
                    placeholder: StringResources.Auth.positionPlaceholder,
                    isError: viewModel.uiState.positionError != nil,
                    errorMessage: viewModel.uiState.positionError,
                    onTextChange: { text in viewModel.updatePosition(text) },
                    submitLabel: .next,
                    onSubmit: { focusedField = .email }
                )
                .focused($focusedField, equals: .position)
                
                Spacer()
                    .frame(height: 8)
                
                // 이메일
                Text(StringResources.Auth.emailLabel)
                    .font(.gmarketBody)
                    .foregroundColor(Color("Text"))
                    .padding(.bottom, 4)
                CommonTextField(
                    value: $email,
                    placeholder: StringResources.Auth.emailPlaceholder,
                    type: .email,
                    isError: viewModel.uiState.emailError != nil,
                    errorMessage: viewModel.uiState.emailError,
                    onTextChange: { text in viewModel.updateEmail(text) },
                    submitLabel: .next,
                    onSubmit: { focusedField = .password }
                )
                .focused($focusedField, equals: .email)
                
                Spacer()
                    .frame(height: 8)
                
                // 비밀번호
                Text(StringResources.Auth.passwordLabel)
                    .font(.gmarketBody)
                    .foregroundColor(Color("Text"))
                    .padding(.bottom, 4)
                CommonTextField(
                    value: $password,
                    placeholder: StringResources.Auth.passwordPlaceholder,
                    type: .password,
                    isError: viewModel.uiState.passwordError != nil,
                    errorMessage: viewModel.uiState.passwordError,
                    onTextChange: { text in viewModel.updatePassword(text) },
                    submitLabel: .next,
                    onSubmit: { focusedField = .passwordCheck }
                )
                .focused($focusedField, equals: .password)
                
                Spacer()
                    .frame(height: 8)
                
                // 비밀번호 확인
                Text(StringResources.Auth.passwordCheckLabel)
                    .font(.gmarketBody)
                    .foregroundColor(Color("Text"))
                    .padding(.bottom, 4)
                CommonTextField(
                    value: $passwordCheck,
                    placeholder: StringResources.Auth.passwordCheckPlaceholder,
                    type: .password,
                    isError: viewModel.uiState.passwordCheckError != nil,
                    errorMessage: viewModel.uiState.passwordCheckError,
                    onTextChange: { text in viewModel.updatePasswordCheck(text) },
                    submitLabel: .done,
                    onSubmit: { focusedField = nil }
                )
                .focused($focusedField, equals: .passwordCheck)
                
                Spacer()
                    .frame(height: 48)
                
                // 회원가입 버튼
                CommonButton(
                    viewModel.uiState.loading
                        ? StringResources.Auth.signUpButtonLoading
                        : StringResources.Auth.signUpButton,
                    isEnabled: viewModel.uiState.isValid && !viewModel.uiState.loading
                ) {
                    viewModel.submit()
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            hideKeyboard()
        }
        .onChange(of: viewModel.uiState.success) { _, success in
            if success {
                onSuccess()
            }
        }
        .onChange(of: viewModel.uiState.error) { _, error in
            if let message = error, !message.isEmpty {
                // 타임스탬프 제거하여 순수한 에러 메시지만 표시
                let cleanMessage = message.components(separatedBy: "_").first ?? message
                Toast.text(cleanMessage).show()
                viewModel.consumeError()
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
