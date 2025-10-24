//
//  AuthRepository.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/14/25.
//

import Foundation

protocol AuthRepository {
    func signUp(
        userName: String,
        workspace: String,
        branch: String,
        position: String,
        email: String,
        password: String
    ) async throws -> User
    
    func signIn(email: String, password: String) async throws -> User
    func signOut() async throws
    func refreshToken() async throws -> User
    func clearTokens() async throws
    func isSignedIn() -> Bool
    
    // 토큰 조회 (API 요청 시 사용)
    func getAccessToken() throws -> String?
    func getRefreshToken() throws -> String?
}
