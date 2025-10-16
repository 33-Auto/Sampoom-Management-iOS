//
//  AuthAPI.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/14/25.
//

import Foundation
import Alamofire

class AuthAPI {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    // 로그인
    func login(email: String, password: String) async throws -> APIResponse<LoginResponseDTO> {
        return try await withCheckedThrowingContinuation { continuation in
            let requestDTO = LoginRequestDTO(email: email, password: password)
            
            let parameters: [String: Any] = [
                "email": requestDTO.email,
                "password": requestDTO.password
            ]
            
            networkManager.request(
                endpoint: "auth/login",
                method: .post,
                parameters: parameters,
                responseType: LoginResponseDTO.self
            ) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // 회원가입
    func signup(
        email: String,
        password: String,
        workspace: String,
        branch: String,
        userName: String,
        position: String
    ) async throws -> APIResponse<SignupResponseDTO> {
        return try await withCheckedThrowingContinuation { continuation in
            let requestDTO = SignupRequestDTO(
                userName: userName,
                workspace: workspace,
                branch: branch,
                position: position,
                email: email,
                password: password
            )
            
            let parameters: [String: Any] = [
                "email": requestDTO.email,
                "password": requestDTO.password,
                "workspace": requestDTO.workspace,
                "branch": requestDTO.branch,
                "userName": requestDTO.userName,
                "position": requestDTO.position
            ]
            
            networkManager.request(
                endpoint: "auth/signup",
                method: .post,
                parameters: parameters,
                responseType: SignupResponseDTO.self
            ) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

