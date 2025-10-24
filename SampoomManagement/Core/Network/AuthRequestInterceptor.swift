//
//  AuthRequestInterceptor.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/15/25.
//

import Foundation
import Alamofire

class AuthRequestInterceptor: RequestInterceptor {
    private let authPreferences: AuthPreferences
    private let tokenRefreshService: TokenRefreshService
    private let refreshMutex = NSLock()
    
    init(authPreferences: AuthPreferences, tokenRefreshService: TokenRefreshService) {
        self.authPreferences = authPreferences
        self.tokenRefreshService = tokenRefreshService
    }
    
    // 요청에 Authorization 헤더 추가
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var adaptedRequest = urlRequest
        
        // 이미 Authorization 헤더가 있으면 그대로 사용
        if adaptedRequest.value(forHTTPHeaderField: "Authorization") == nil {
            do {
                if let accessToken = try authPreferences.getAccessToken() {
                    adaptedRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
                }
            } catch {
                print("AuthRequestInterceptor - 토큰 조회 실패: \(error)")
            }
        }
        
        completion(.success(adaptedRequest))
    }
    
    // 401 응답 시 토큰 재발급 및 재시도
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        // 이미 재시도된 요청인지 확인
        if request.request?.value(forHTTPHeaderField: "X-Retry-Count") != nil {
            completion(.doNotRetry)
            return
        }
        
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401 else {
            completion(.doNotRetry)
            return
        }
        
        refreshMutex.lock()
        defer { refreshMutex.unlock() }
        
        Task {
            do {
                _ = try await tokenRefreshService.refreshToken()
                
                // 새로운 토큰으로 요청 재시도
                var retryRequest = request.request
                retryRequest?.setValue("1", forHTTPHeaderField: "X-Retry-Count")
                
                do {
                    if let accessToken = try await authPreferences.getAccessToken() {
                        retryRequest?.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
                    }
                } catch {
                    print("AuthRequestInterceptor - 재시도 시 토큰 조회 실패: \(error)")
                }
                
                completion(.retryWithDelay(0.1))
            } catch {
                print("AuthRequestInterceptor - 토큰 재발급 실패: \(error)")
                // 토큰 재발급 실패 시 로그아웃 처리
                await authPreferences.clear()
                completion(.doNotRetry)
            }
        }
    }
}
