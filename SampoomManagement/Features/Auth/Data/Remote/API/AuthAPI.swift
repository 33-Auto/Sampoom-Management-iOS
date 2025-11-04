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
        let requestDTO = LoginRequestDTO(workspace: "AGENCY", email: email, password: password)
        
        let parameters: [String: Any] = [
            "workspace": requestDTO.workspace,
            "email": requestDTO.email,
            "password": requestDTO.password
        ]
        
        return try await networkManager.request(
            endpoint: "auth/login",
            method: .post,
            parameters: parameters,
            responseType: LoginResponseDTO.self
        )
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
        
        return try await networkManager.request(
            endpoint: "auth/signup",
            method: .post,
            parameters: parameters,
            responseType: SignupResponseDTO.self
        )
    }
    
    // 로그아웃
    func logout() async throws -> APIResponse<EmptyResponse> {
        return try await networkManager.request(
            endpoint: "auth/logout",
            method: .post,
            parameters: nil,
            responseType: EmptyResponse.self
        )
    }
    
    // 토큰 재발급
    func refresh(refreshToken: String) async throws -> APIResponse<RefreshResponseDTO> {
        let requestDTO = RefreshRequestDTO(refreshToken: refreshToken)
        
        let parameters: [String: Any] = [
            "refreshToken": requestDTO.refreshToken
        ]
        
        return try await networkManager.request(
            endpoint: "auth/refresh",
            method: .post,
            parameters: parameters,
            responseType: RefreshResponseDTO.self
        )
    }

    // 프로필 조회
    func getProfile(workspace: String = "AGENCY") async throws -> APIResponse<GetProfileResponseDTO> {
        return try await networkManager.request(
            endpoint: "user/profile?workspace=\(workspace)",
            method: .get,
            parameters: nil,
            responseType: GetProfileResponseDTO.self
        )
    }
}

