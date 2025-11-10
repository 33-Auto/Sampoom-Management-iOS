//
//  UserAPI.swift
//  SampoomManagement
//
//  Created by Generated.
//

import Foundation
import Alamofire

class UserAPI {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    // 프로필 조회
    func getProfile(role: String = "AGENCY") async throws -> APIResponse<GetProfileResponseDTO> {
        return try await networkManager.request(
            endpoint: "user/profile?role=\(role)",
            method: .get,
            parameters: nil,
            responseType: GetProfileResponseDTO.self
        )
    }
    
    // 프로필 수정
    func updateProfile(userName: String) async throws -> APIResponse<UpdateProfileResponseDTO> {
        let requestDTO = UpdateProfileRequestDTO(userName: userName)
        
        let parameters: [String: Any] = [
            "userName": requestDTO.userName
        ]
        
        return try await networkManager.request(
            endpoint: "user/profile",
            method: .patch,
            parameters: parameters,
            responseType: UpdateProfileResponseDTO.self
        )
    }
    
    // 직원 목록 조회
    func getEmployeeList(role: String, organizationId: Int, page: Int = 0, size: Int = 20) async throws -> APIResponse<EmployeeListDTO> {
        return try await networkManager.request(
            endpoint: "user/info?role=\(role)&organizationId=\(organizationId)&page=\(page)&size=\(size)",
            method: .get,
            parameters: nil,
            responseType: EmployeeListDTO.self
        )
    }
    
    // 직원 수정
    func editEmployee(userId: Int, role: String, position: String) async throws -> APIResponse<EditEmployeeResponseDTO> {
        let requestDTO = EditEmployeeRequestDTO(position: position)
        
        let parameters: [String: Any] = [
            "position": requestDTO.position
        ]
        
        return try await networkManager.request(
            endpoint: "user/profile/\(userId)?role=\(role)",
            method: .patch,
            parameters: parameters,
            responseType: EditEmployeeResponseDTO.self
        )
    }
    
    // 직원 상태 수정
    func updateEmployeeStatus(userId: Int, role: String, employeeStatus: String) async throws -> APIResponse<UpdateEmployeeStatusResponseDTO> {
        let requestDTO = UpdateEmployeeStatusRequestDTO(employeeStatus: employeeStatus)
        
        let parameters: [String: Any] = [
            "employeeStatus": requestDTO.employeeStatus
        ]
        
        return try await networkManager.request(
            endpoint: "user/status/\(userId)?role=\(role)",
            method: .patch,
            parameters: parameters,
            responseType: UpdateEmployeeStatusResponseDTO.self
        )
    }
}

