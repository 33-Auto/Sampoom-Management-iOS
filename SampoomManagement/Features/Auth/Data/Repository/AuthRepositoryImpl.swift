//
//  AuthRepositoryImpl.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/14/25.
//

import Foundation

class AuthRepositoryImpl: AuthRepository {
    private let api: AuthAPI
    private let preferences: AuthPreferences
    
    init(api: AuthAPI, preferences: AuthPreferences) {
        self.api = api
        self.preferences = preferences
    }
    
    // 회원가입
    func signUp(
        userName: String,
        workspace: String,
        branch: String,
        position: String,
        email: String,
        password: String
    ) async throws -> User {
        _ = try await api.signup(
            email: email,
            password: password,
            workspace: workspace,
            branch: branch,
            userName: userName,
            position: position
        )
        
        // 회원가입 후 자동 로그인
        return try await signIn(email: email, password: password)
    }
    
    func signIn(email: String, password: String) async throws -> User {
        let response = try await api.login(email: email, password: password)
        guard let dto = response.data else {
            throw AuthError.invalidResponse
        }
        
        do {
            try preferences.saveToken(
                accessToken: dto.accessToken,
                refreshToken: dto.refreshToken
            )
        } catch {
            // 키체인 저장 실패 시 로깅 및 에러 전파
            print("AuthRepositoryImpl - 키체인 저장 실패: \(error)")
            throw AuthError.tokenSaveFailed(error)
        }
        
        return dto.toModel()
    }
    
    func signOut() async throws {
        preferences.clear()
    }
    
    func isSignedIn() -> Bool {
        return preferences.hasToken()
    }
    
    // 토큰 조회 (API 요청 시 사용)
    func getAccessToken() throws -> String? {
        return try preferences.getAccessToken()
    }
    
    func getRefreshToken() throws -> String? {
        return try preferences.getRefreshToken()
    }
}
