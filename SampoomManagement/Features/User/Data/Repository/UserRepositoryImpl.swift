//
//  UserRepositoryImpl.swift
//  SampoomManagement
//
//  Created by Generated.
//

import Foundation

class UserRepositoryImpl: UserRepository {
    private let api: UserAPI
    private let preferences: AuthPreferences
    
    init(api: UserAPI, preferences: AuthPreferences) {
        self.api = api
        self.preferences = preferences
    }
    
    func getStoredUser() throws -> User? {
        return try preferences.getStoredUser()
    }
    
    func getProfile(workspace: String) async throws -> User {
        // 프로필 조회 (서버 반영 지연 고려하여 재시도)
        let profileUser = try await retry(times: 5, initialDelayMs: 300, maxDelayMs: 1500, factor: 1.8) {
            let profileResponse = try await self.api.getProfile(workspace: workspace)
            guard let profileDto = profileResponse.data else {
                throw NetworkError.serverError(profileResponse.status, message: profileResponse.message)
            }
            return profileDto.toModel()
        }
        
        // 저장된 사용자 정보 조회
        guard let loginUser = try preferences.getStoredUser() else {
            throw NetworkError.serverError(401, message: "No stored user")
        }
        
        // 토큰 정보와 프로필 정보 병합
        let completeUser = User(
            id: profileUser.id,
            name: profileUser.name,
            email: profileUser.email,
            role: profileUser.role,
            accessToken: loginUser.accessToken,
            refreshToken: loginUser.refreshToken,
            expiresIn: loginUser.expiresIn,
            position: profileUser.position,
            workspace: profileUser.workspace,
            branch: profileUser.branch,
            agencyId: profileUser.agencyId,
            startedAt: profileUser.startedAt,
            endedAt: profileUser.endedAt
        )
        
        // 저장
        try preferences.saveUser(completeUser)
        
        return completeUser
    }
    
    func updateProfile(user: User) async throws -> User {
        let response = try await api.updateProfile(userName: user.name)
        guard let dto = response.data else {
            throw NetworkError.serverError(response.status, message: response.message)
        }
        
        let updatedProfile = dto.toModel()
        
        // 저장된 사용자 정보 조회
        guard let storedUser = try preferences.getStoredUser() else {
            throw NetworkError.serverError(401, message: "No stored user")
        }
        
        // 업데이트된 프로필 정보와 기존 토큰 정보 병합
        let completeUser = User(
            id: updatedProfile.id,
            name: updatedProfile.name,
            email: user.email,
            role: user.role,
            accessToken: storedUser.accessToken,
            refreshToken: storedUser.refreshToken,
            expiresIn: storedUser.expiresIn,
            position: user.position,
            workspace: user.workspace,
            branch: user.branch,
            agencyId: user.agencyId,
            startedAt: user.startedAt,
            endedAt: user.endedAt
        )
        
        // 저장
        try preferences.saveUser(completeUser)
        
        return completeUser
    }
    
    func getEmployeeList(workspace: String, organizationId: Int, page: Int, size: Int) async throws -> (employees: [Employee], hasNext: Bool) {
        let response = try await api.getEmployeeList(workspace: workspace, organizationId: organizationId, page: page, size: size)
        guard let dto = response.data else {
            throw NetworkError.serverError(response.status, message: response.message)
        }
        
        let employees = dto.users.map { $0.toModel() }
        return (employees: employees, hasNext: dto.meta.hasNext)
    }
    
    func editEmployee(employee: Employee, workspace: String) async throws -> Employee {
        let response = try await api.editEmployee(userId: employee.userId, workspace: workspace, position: employee.position.rawValue)
        guard let dto = response.data else {
            throw NetworkError.serverError(response.status, message: response.message)
        }
        
        let updatedEmployee = dto.toModel()
        
        // 기존 직원 정보와 업데이트된 정보 병합
        let completeEmployee = Employee(
            id: updatedEmployee.userId,
            userId: updatedEmployee.userId,
            email: employee.email,
            role: employee.role,
            userName: updatedEmployee.userName.isEmpty ? employee.userName : updatedEmployee.userName,
            workspace: updatedEmployee.workspace.isEmpty ? employee.workspace : updatedEmployee.workspace,
            organizationId: employee.organizationId,
            branch: employee.branch,
            position: updatedEmployee.position,
            startedAt: employee.startedAt,
            endedAt: employee.endedAt
        )
        
        return completeEmployee
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

