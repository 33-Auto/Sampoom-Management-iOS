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
        // 1) 로그인
        let loginResponse = try await api.login(email: email, password: password)
        guard let loginDto = loginResponse.data else {
            throw AuthError.invalidResponse
        }
        let loginUser = loginDto.toModel()
        // Store tokens immediately so that subsequent authorized calls (e.g., getProfile) carry Authorization header
        do {
            try preferences.saveToken(accessToken: loginUser.accessToken, refreshToken: loginUser.refreshToken)
        } catch {
            print("AuthRepositoryImpl - 초기 토큰 저장 실패: \(error)")
            throw AuthError.tokenSaveFailed(error)
        }

        // 2) 프로필 조회
        let profileResponse = try await api.getProfile()
        guard let profileDto = profileResponse.data else {
            throw AuthError.invalidResponse
        }
        let profileUser = profileDto.toModel()

        // 3) 병합
        let mergedUser = loginUser.mergeWith(profile: profileUser)

        // 4) 저장
        do {
            try preferences.saveUser(mergedUser)
        } catch {
            print("AuthRepositoryImpl - 키체인 저장 실패: \(error)")
            throw AuthError.tokenSaveFailed(error)
        }

        return mergedUser
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
            expiresIn: dto.expiresIn,
            position: existingUser.position,
            workspace: existingUser.workspace,
            branch: existingUser.branch
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
