//
//  LoginViewModel.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/14/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class LoginViewModel: ObservableObject {
    @Published var uiState = LoginUiState()
    
    private let loginUseCase: LoginUseCase
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    
    // 이메일 업데이트
    func updateEmail(_ email: String) {
        uiState = uiState.copy(email: email)
        validateEmail()
    }
    
    // 비밀번호 업데이트
    func updatePassword(_ password: String) {
        uiState = uiState.copy(password: password)
        validatePassword()
    }
    
    // 로그인 제출
    func submit() {
        Task {
            validateEmail()
            validatePassword()
            
            guard uiState.isValid else { return }
            
            let email = uiState.email
            let password = uiState.password
            
            uiState = uiState.copy(loading: true, error: nil)
            
            do {
                _ = try await loginUseCase.execute(email: email, password: password)
                uiState = uiState.copy(loading: false, success: true)
            } catch {
                uiState = uiState.copy(loading: false)
                showError(error.localizedDescription)
            }
        }
    }
    
    // 에러 소비 (Toast 표시 후 에러 상태 제거)
    func consumeError() {
        uiState = uiState.copy(error: nil)
    }
    
    // 에러 표시를 위한 강제 상태 변경
    private func showError(_ message: String) {
        // 타임스탬프를 추가하여 항상 다른 값으로 만들어 onChange 트리거 보장
        uiState = uiState.copy(error: "\(message)_\(Date().timeIntervalSince1970)")
    }
    
    // MARK: - Private Methods
    
    private func validateEmail() {
        let result = AuthValidator.validateNotEmpty(
            uiState.email,
            StringResources.Auth.emailLabel
        )
        uiState = uiState.copy(emailError: result.errorMessage)
    }
    
    private func validatePassword() {
        let result = AuthValidator.validateNotEmpty(
            uiState.password,
            StringResources.Auth.passwordLabel
        )
        uiState = uiState.copy(passwordError: result.errorMessage)
    }
}
