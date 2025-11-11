//
//  TokenRefreshService.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/15/25.
//

import Foundation

class TokenRefreshService {
    private let authPreferences: AuthPreferences
    
    init(authPreferences: AuthPreferences) {
        self.authPreferences = authPreferences
    }
    
    func refreshToken() async throws -> User {
        guard let refreshToken = try authPreferences.getRefreshToken() else {
            throw AuthError.tokenRefreshFailed
        }
        
        // 새로운 URLSession 인스턴스 생성 (인터셉터 없이)
        let session = URLSession.shared
        let url = URL(string: "https://sampoom.store/api/auth/refresh")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = RefreshRequestDTO(refreshToken: refreshToken)
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw AuthError.tokenRefreshFailed
        }
        
        let apiResponse = try JSONDecoder().decode(APIResponse<RefreshResponseDTO>.self, from: data)
        guard let dto = apiResponse.data else {
            throw AuthError.invalidResponse
        }
        
        // 기존 사용자 정보 조회
        guard let existingUser = try authPreferences.getStoredUser() else {
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
        
        try authPreferences.saveUser(updatedUser)
        return updatedUser
    }
}
