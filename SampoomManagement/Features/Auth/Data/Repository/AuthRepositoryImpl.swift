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
        let dto = response.data
        
        preferences.saveToken(
            accessToken: dto.accessToken,
            refreshToken: dto.refreshToken
        )
        
        return dto.toModel()
    }
    
    func signOut() async throws {
        preferences.clear()
    }
    
    func isSignedIn() -> Bool {
        return preferences.hasToken()
    }
}
