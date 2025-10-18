//
//  RootView.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/15/25.
//

import SwiftUI

struct RootView: View {
    let dependencies: AppDependencies
    
    @StateObject private var loginViewModel: LoginViewModel
    @StateObject private var signUpViewModel: SignUpViewModel
    @State private var isAuthenticated: Bool = false
    @State private var showSignUp: Bool = false
    
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _loginViewModel = StateObject(wrappedValue: dependencies.makeLoginViewModel())
        _signUpViewModel = StateObject(wrappedValue: dependencies.makeSignUpViewModel())
    }
    
    var body: some View {
        Group {
            if !isAuthenticated {
                // 로그인 되어있으면 메인 화면
                ContentView(dependencies: dependencies)
            } else {
                // 로그인 안되어있으면 로그인/회원가입 화면
                if showSignUp {
                    NavigationStack {
                        SignUpView(
                            viewModel: signUpViewModel,
                            onSuccess: {
                                // 회원가입 성공 시 자동 로그인 완료 → 메인 화면으로
                                isAuthenticated = true
                            }
                        )
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button(action: {
                                    showSignUp = false
                                }) {
                                    Image(systemName: "chevron.left")
                                    .foregroundColor(Color(red: 0.5, green: 0.2, blue: 0.8))
                                }
                            }
                        }
                    }
                } else {
                    LoginView(
                        viewModel: loginViewModel,
                        onSuccess: {
                            // 로그인 성공 시 메인 화면으로
                            isAuthenticated = true
                        },
                        onNavigateSignUp: {
                            // 회원가입 화면으로
                            showSignUp = true
                        }
                    )
                }
            }
        }
        .onAppear {
            // 앱 시작 시 로그인 상태 확인
            checkAuthenticationStatus()
        }
    }
    
    private func checkAuthenticationStatus() {
        isAuthenticated = dependencies.authPreferences.hasToken()
    }
}
