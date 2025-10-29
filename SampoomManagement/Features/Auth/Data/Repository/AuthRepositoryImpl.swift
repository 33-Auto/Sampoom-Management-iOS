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
        
        let user = dto.toModel()
        do {
            try preferences.saveUser(user)
        } catch {
            // 키체인 저장 실패 시 로깅 및 에러 전파
            print("AuthRepositoryImpl - 키체인 저장 실패: \(error)")
            throw AuthError.tokenSaveFailed(error)
        }
        
        return user
    }
    
    func signOut() async throws {
        // API 호출 실패해도 토큰은 삭제 (이미 로그아웃 상태로 간주)
        do {
            _ = try await api.logout()
        } catch {
            print("AuthRepositoryImpl - 로그아웃 API 호출 실패: \(error)")
            // API 실패해도 토큰은 삭제
        }
        
        preferences.clear()
    }
    
    func refreshToken() async throws -> User {
        guard let refreshToken = try preferences.getRefreshToken() else {
            throw AuthError.tokenRefreshFailed
        }
        
        let response = try await api.refresh(refreshToken: refreshToken)
        guard let dto = response.data else {
            throw AuthError.invalidResponse
        }
        
        // 기존 사용자 정보 조회
        guard let existingUser = try preferences.getStoredUser() else {
            throw AuthError.tokenRefreshFailed
        }
        
        // 새로운 토큰 정보로 사용자 정보 업데이트
        let updatedUser = User(
            id: existingUser.id,
            name: existingUser.name,
            role: existingUser.role,
            accessToken: dto.accessToken,
            refreshToken: dto.refreshToken,
            expiresIn: dto.expiresIn
        )
        
        do {
            try preferences.saveUser(updatedUser)
        } catch {
            print("AuthRepositoryImpl - 토큰 갱신 후 키체인 저장 실패: \(error)")
            throw AuthError.tokenSaveFailed(error)
        }
        
        return updatedUser
    }
    
    func clearTokens() async throws {
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
