//
//  AuthPreferences.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/14/25.
//

import Foundation

class AuthPreferences {
    private let keychain = KeychainManager()
    
    private enum Keys {
        static let accessToken = "auth.accessToken"
        static let refreshToken = "auth.refreshToken"
    }
    
    func saveToken(accessToken: String, refreshToken: String) throws {
        do {
            try keychain.save(accessToken, for: Keys.accessToken)
            try keychain.save(refreshToken, for: Keys.refreshToken)
        } catch {
            // 부분 저장 실패 시 롤백
            try? keychain.delete(Keys.accessToken)
            try? keychain.delete(Keys.refreshToken)
            throw error
        }
    }
    
    func getAccessToken() throws -> String? {
        return try keychain.get(Keys.accessToken)
    }
    
    func getRefreshToken() throws -> String? {
        return try keychain.get(Keys.refreshToken)
    }
    
    func hasToken() -> Bool {
        do {
            let accessToken = try getAccessToken()
            let refreshToken = try getRefreshToken()
            return accessToken != nil && refreshToken != nil
        } catch {
            // 키체인 접근 오류 발생 시 로깅하고 false 반환
            print("AuthPreferences - 키체인 접근 오류: \(error)")
            return false
        }
    }
    
    // 에러를 전파하는 버전 (필요한 경우 사용)
    func hasTokenSafely() throws -> Bool {
        let accessToken = try getAccessToken()
        let refreshToken = try getRefreshToken()
        return accessToken != nil && refreshToken != nil
    }
    
    func clear() {
        do {
            try keychain.delete(Keys.accessToken)
            try keychain.delete(Keys.refreshToken)
        } catch {
            // 로그아웃 시에는 실패해도 에러를 던지지 않음 (이미 로그아웃 상태로 간주)
            print("AuthPreferences - 키체인 삭제 실패: \(error)")
        }
    }
}


