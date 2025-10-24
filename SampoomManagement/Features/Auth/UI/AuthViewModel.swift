//
//  AuthViewModel.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/15/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    // MARK: - Properties
    @Published var isLoggedIn: Bool = false
    @Published var shouldNavigateToLogin: Bool = false
    
    private let checkLoginStateUseCase: CheckLoginStateUseCase
    private let signOutUseCase: SignOutUseCase
    private let clearTokensUseCase: ClearTokensUseCase
    
    // MARK: - Initialization
    init(
        checkLoginStateUseCase: CheckLoginStateUseCase,
        signOutUseCase: SignOutUseCase,
        clearTokensUseCase: ClearTokensUseCase
    ) {
        self.checkLoginStateUseCase = checkLoginStateUseCase
        self.signOutUseCase = signOutUseCase
        self.clearTokensUseCase = clearTokensUseCase
        
        updateLoginState()
    }
    
    // MARK: - Actions
    func updateLoginState() {
        isLoggedIn = checkLoginStateUseCase.execute()
    }
    
    func signOut() async {
        do {
            try await signOutUseCase.execute()
        } catch {
            print("AuthViewModel - 로그아웃 실패: \(error)")
        }
        
        // 로그아웃 성공/실패 관계없이 로컬 상태 업데이트
        isLoggedIn = false
        shouldNavigateToLogin = true
    }
    
    func handleTokenExpired() async {
        do {
            try await clearTokensUseCase.execute()
            isLoggedIn = false
            shouldNavigateToLogin = true
        } catch {
            print("AuthViewModel - 토큰 삭제 실패: \(error)")
            // 토큰 삭제 실패해도 로그아웃 처리
            isLoggedIn = false
            shouldNavigateToLogin = true
        }
    }
    
    func resetNavigationState() {
        shouldNavigateToLogin = false
    }
}
