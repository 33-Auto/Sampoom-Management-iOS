//
//  AuthRequestInterceptor.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/15/25.
//

import Foundation
import Alamofire

extension Notification.Name {
    static let didRequestLogout = Notification.Name("didRequestLogout")
}

// 비동기-세이프 토큰 갱신 조정자
actor RefreshCoordinator {
    private var inFlight: Task<User, Error>?
    
    func refresh(using service: TokenRefreshService) async throws -> User {
        if let t = inFlight { 
            return try await t.value 
        }
        let t = Task { 
            try await service.refreshToken() 
        }
        inFlight = t
        defer { inFlight = nil }
        return try await t.value
    }
}

final class AuthRequestInterceptor: RequestInterceptor, @unchecked Sendable {
    private let authPreferences: AuthPreferences
    private let tokenRefreshService: TokenRefreshService
    private let refreshCoordinator = RefreshCoordinator()
    
    init(authPreferences: AuthPreferences, tokenRefreshService: TokenRefreshService) {
        self.authPreferences = authPreferences
        self.tokenRefreshService = tokenRefreshService
    }
    
    // 요청에 Authorization 헤더 추가
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var adaptedRequest = urlRequest
        
        if let urlString = adaptedRequest.url?.absoluteString,
           urlString.contains("/auth/refresh") {
            adaptedRequest.setValue(nil, forHTTPHeaderField: "Authorization")
            completion(.success(adaptedRequest))
            return
        }
        
        do {
            if let accessToken = try authPreferences.getAccessToken() {
                adaptedRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            } else {
                adaptedRequest.setValue(nil, forHTTPHeaderField: "Authorization")
            }
        } catch {
            print("AuthRequestInterceptor - 토큰 조회 실패: \(error)")
        }
        
        completion(.success(adaptedRequest))
    }
    
    // 401 응답 시 토큰 재발급 및 재시도
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401 else {
            completion(.doNotRetry)
            return
        }
        
        Task {
            do {
                _ = try await refreshCoordinator.refresh(using: tokenRefreshService)
                
                if request.retryCount >= 1 {
                    await authPreferences.clear()
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: .didRequestLogout, object: nil)
                    }
                    completion(.doNotRetry)
                    return
                }
                
                completion(.retryWithDelay(0.1))
            } catch {
                print("AuthRequestInterceptor - 토큰 재발급 실패: \(error)")
                // 토큰 재발급 실패 시 로그아웃 처리
                await authPreferences.clear()
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .didRequestLogout, object: nil)
                }
                completion(.doNotRetry)
            }
        }
    }
}
