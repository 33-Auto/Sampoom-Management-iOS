//
//  LoginUiState.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/14/25.
//

import Foundation

struct LoginUiState: UIState {
    let email: String
    let password: String
    
    // Error message
    let emailError: String?
    let passwordError: String?
    
    let loading: Bool
    let error: String?
    let success: Bool
    
    init(
        email: String = "",
        password: String = "",
        emailError: String? = nil,
        passwordError: String? = nil,
        loading: Bool = false,
        error: String? = nil,
        success: Bool = false
    ) {
        self.email = email
        self.password = password
        self.emailError = emailError
        self.passwordError = passwordError
        self.loading = loading
        self.error = error
        self.success = success
    }
    
    var isValid: Bool {
        return !email.isEmpty &&
               !password.isEmpty &&
               emailError == nil &&
               passwordError == nil
    }
    
    func copy(
        email: String? = nil,
        password: String? = nil,
        emailError: String?? = nil,
        passwordError: String?? = nil,
        loading: Bool? = nil,
        error: String?? = nil,
        success: Bool? = nil
    ) -> LoginUiState {
        return LoginUiState(
            email: email ?? self.email,
            password: password ?? self.password,
            emailError: emailError ?? self.emailError,
            passwordError: passwordError ?? self.passwordError,
            loading: loading ?? self.loading,
            error: error ?? self.error,
            success: success ?? self.success
        )
    }
}


