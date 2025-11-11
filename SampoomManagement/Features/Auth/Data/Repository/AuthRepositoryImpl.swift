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
        // 회원가입 직후 DB 반영 지연을 고려하여 잠시 대기 후 재시도하며 로그인
        // 0.5초 대기 후 최대 5회 재시도 (지수 백오프)
        try await Task.sleep(nanoseconds: 500_000_000)
        var currentDelayMs: UInt64 = 500
        for attempt in 1...5 {
            do {
                return try await signIn(email: email, password: password)
            } catch {
                if attempt == 5 { throw error }
                try await Task.sleep(nanoseconds: currentDelayMs * 1_000_000)
                currentDelayMs = min(currentDelayMs &* 2, 2_000)
            }
        }
        throw AuthError.invalidResponse
    }
    
    func signIn(email: String, password: String) async throws -> User {
        // 1) 로그인
        let loginResponse = try await api.login(email: email, password: password)
        guard let loginDto = loginResponse.data else {
            throw AuthError.invalidResponse
        }
        let loginUser = loginDto.toModel()
        // Store tokens immediately so that subsequent authorized calls carry Authorization header
        do {
            try preferences.saveUser(loginUser)
        } catch {
            print("AuthRepositoryImpl - 초기 토큰 저장 실패: \(error)")
            throw AuthError.tokenSaveFailed(error)
        }

        return loginUser
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
            email: existingUser.email,
            accessToken: dto.accessToken,
            refreshToken: dto.refreshToken,
            expiresIn: dto.expiresIn,
            position: existingUser.position,
            workspace: existingUser.workspace,
            branch: existingUser.branch,
            agencyId: existingUser.agencyId,
            startedAt: existingUser.startedAt,
            endedAt: existingUser.endedAt
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

    // MARK: - Vendors
    func getVendorList() async throws -> VendorList {
        let response = try await api.getVendors()
        if !response.success {
            throw NetworkError.serverError(response.status, message: response.message)
        }
        let items = (response.data ?? []).map { $0.toModel() }
        return VendorList(items: items)
    }
}

// MARK: - Retry Helper (Exponential Backoff)
private func retry<T>(
    times: Int = 5,
    initialDelayMs: UInt64 = 300,
    maxDelayMs: UInt64 = 1500,
    factor: Double = 1.8,
    _ block: @escaping () async throws -> T
) async throws -> T {
    precondition(times >= 1)
    var currentDelayMs = initialDelayMs
    for _ in 1..<(times) {
        do {
            return try await block()
        } catch {
            // Optional: filter retryable errors only
            let ns = currentDelayMs * 1_000_000 // ms -> ns
            try? await Task.sleep(nanoseconds: ns)
            let next = UInt64(Double(currentDelayMs) * factor)
            currentDelayMs = min(next, maxDelayMs)
        }
    }
    return try await block()
}
