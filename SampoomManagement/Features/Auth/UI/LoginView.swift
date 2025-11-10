//
//  LoginView.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/14/25.
//

import SwiftUI
import Toast

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    @StateObject private var keyboardObserver = KeyboardObserver()
    @State private var email = ""
    @State private var password = ""
    
    let onSuccess: () -> Void
    let onNavigateSignUp: () -> Void
    
    init(viewModel: LoginViewModel, onSuccess: @escaping () -> Void, onNavigateSignUp: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onSuccess = onSuccess
        self.onNavigateSignUp = onNavigateSignUp
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            // 로고
            Image("square_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
            
            Spacer()
                .frame(height: 48)
        
            // 이메일 입력
            CommonTextField(
                value: $email,
                placeholder: StringResources.Auth.emailPlaceholder,
                type: .email,
                isError: viewModel.uiState.emailError != nil,
                errorMessage: viewModel.uiState.emailError
            ) { text in
                viewModel.updateEmail(text)
            }
            
            Spacer()
                .frame(height: 16)
            
            // 비밀번호 입력
            CommonTextField(
                value: $password,
                placeholder: StringResources.Auth.passwordPlaceholder,
                type: .password,
                isError: viewModel.uiState.passwordError != nil,
                errorMessage: viewModel.uiState.passwordError
            ) { text in
                viewModel.updatePassword(text)
            }
            
            Spacer()
                .frame(height: 48)
            
            // 로그인 버튼
            CommonButton(
                viewModel.uiState.loading
                    ? StringResources.Auth.loginButtonLoading
                    : StringResources.Auth.loginButton,
                isEnabled: viewModel.uiState.isValid && !viewModel.uiState.loading
            ) {
                viewModel.submit()
            }
            
            Spacer()
            
            // 회원가입 안내
            Button(action: onNavigateSignUp) {
                HStack(spacing: 4) {
                    Text(StringResources.Auth.needAccount)
                        .font(.gmarketBody)
                        .foregroundColor(.text)
                    Text(StringResources.Auth.signUpLink)
                        .font(.gmarketBody)
                        .foregroundColor(.accentColor)
                        .underline()
                    
                    
                    Text(StringResources.Auth.signUpDo)
                        .font(.gmarketBody)
                        .foregroundColor(.text)
                }
            }
            .padding(.bottom, 32)
        }
        .padding(.horizontal, 16)
        //.offset(y: keyboardObserver.keyboardHeight > 0 ? -keyboardObserver.keyboardHeight / 2.5 : 0)
        .contentShape(Rectangle())
        .onTapGesture {
            hideKeyboard()
        }
        .onChange(of: viewModel.uiState.error) { _, error in
            if let message = error, !message.isEmpty {
                // 타임스탬프 제거하여 순수한 에러 메시지만 표시
                let cleanMessage = message.components(separatedBy: "_").first ?? message
                Toast.text(cleanMessage).show()
                viewModel.consumeError()
            }
        }
        .onChange(of: viewModel.uiState.success) { _, success in
            if success {
                Task { @MainActor in
                    // 상태 업데이트가 완료될 때까지 약간의 딜레이
                    try? await Task.sleep(nanoseconds: 50_000_000) // 0.05초
                    onSuccess()
                    // 다음 로그인을 위해 success 상태 리셋
                    viewModel.uiState = viewModel.uiState.copy(success: false)
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
