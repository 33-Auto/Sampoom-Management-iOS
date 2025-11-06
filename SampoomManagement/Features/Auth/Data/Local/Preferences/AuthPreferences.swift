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
        static let userId = "auth.userId"
        static let userName = "auth.userName"
        static let userEmail = "auth.userEmail"
        static let userRole = "auth.userRole"
        static let expiresIn = "auth.expiresIn"
        static let position = "auth.position"
        static let workspace = "auth.workspace"
        static let branch = "auth.branch"
        static let agencyId = "auth.agencyId"
        static let startedAt = "auth.startedAt"
        static let endedAt = "auth.endedAt"
    }
    
    func saveUser(_ user: User) throws {
        do {
            try keychain.save(user.accessToken, for: Keys.accessToken)
            try keychain.save(user.refreshToken, for: Keys.refreshToken)
            try keychain.save(String(user.id), for: Keys.userId)
            try keychain.save(user.name, for: Keys.userName)
            try keychain.save(user.email, for: Keys.userEmail)
            try keychain.save(user.role.rawValue, for: Keys.userRole)
            try keychain.save(String(user.expiresIn), for: Keys.expiresIn)
            try keychain.save(user.position.rawValue, for: Keys.position)
            try keychain.save(user.workspace, for: Keys.workspace)
            try keychain.save(user.branch, for: Keys.branch)
            try keychain.save(String(user.agencyId), for: Keys.agencyId)
            try keychain.save(user.startedAt ?? "", for: Keys.startedAt)
            try keychain.save(user.endedAt ?? "", for: Keys.endedAt)
        } catch {
            // 부분 저장 실패 시 롤백
            try? keychain.delete(Keys.accessToken)
            try? keychain.delete(Keys.refreshToken)
            try? keychain.delete(Keys.userId)
            try? keychain.delete(Keys.userName)
            try? keychain.delete(Keys.userEmail)
            try? keychain.delete(Keys.userRole)
            try? keychain.delete(Keys.expiresIn)
            try? keychain.delete(Keys.position)
            try? keychain.delete(Keys.workspace)
            try? keychain.delete(Keys.branch)
            try? keychain.delete(Keys.agencyId)
            try? keychain.delete(Keys.startedAt)
            try? keychain.delete(Keys.endedAt)
            throw error
        }
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
    
    func getStoredUser() throws -> User? {
        do {
            // Require only core identifiers and tokens; allow missing new fields for migration
            guard let userIdString = try keychain.get(Keys.userId),
                  let userId = Int(userIdString),
                  let userName = try keychain.get(Keys.userName),
                  let userRole = try keychain.get(Keys.userRole),
                  let accessToken = try keychain.get(Keys.accessToken),
                  let refreshToken = try keychain.get(Keys.refreshToken),
                  let expiresInString = try keychain.get(Keys.expiresIn),
                  let expiresIn = Int(expiresInString) else {
                return nil
            }
            // Tolerate missing profile keys by defaulting to safe values
            let positionRaw = (try? keychain.get(Keys.position)) ?? ""
            let workspace = (try? keychain.get(Keys.workspace)) ?? ""
            let branch = (try? keychain.get(Keys.branch)) ?? ""
            let userEmail = (try? keychain.get(Keys.userEmail)) ?? ""
            let agencyId = Int((try? keychain.get(Keys.agencyId)) ?? "0") ?? 0
            let startedAt = try? keychain.get(Keys.startedAt)
            let endedAt = try? keychain.get(Keys.endedAt)
            
            return User(
                id: userId,
                name: userName,
                email: userEmail,
                role: UserRole(rawValue: userRole) ?? .user,
                accessToken: accessToken,
                refreshToken: refreshToken,
                expiresIn: expiresIn,
                position: UserPosition(rawValue: positionRaw) ?? .staff,
                workspace: workspace,
                branch: branch,
                agencyId: agencyId,
                startedAt: startedAt?.isEmpty == false ? startedAt : nil,
                endedAt: endedAt?.isEmpty == false ? endedAt : nil
            )
        } catch {
            print("AuthPreferences - 사용자 정보 조회 실패: \(error)")
            return nil
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
            try keychain.delete(Keys.userId)
            try keychain.delete(Keys.userName)
            try keychain.delete(Keys.userEmail)
            try keychain.delete(Keys.userRole)
            try keychain.delete(Keys.expiresIn)
            try keychain.delete(Keys.position)
            try keychain.delete(Keys.workspace)
            try keychain.delete(Keys.branch)
            try keychain.delete(Keys.agencyId)
            try keychain.delete(Keys.startedAt)
            try keychain.delete(Keys.endedAt)
        } catch {
            // 로그아웃 시에는 실패해도 에러를 던지지 않음 (이미 로그아웃 상태로 간주)
            print("AuthPreferences - 키체인 삭제 실패: \(error)")
        }
    }
}


