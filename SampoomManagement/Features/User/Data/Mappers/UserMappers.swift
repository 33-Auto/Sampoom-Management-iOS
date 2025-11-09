//
//  UserMappers.swift
//  SampoomManagement
//
//  Created by Generated.
//

import Foundation

extension GetProfileResponseDTO {
    func toModel() -> User {
        return User(
            id: self.userId,
            name: self.userName,
            email: self.email,
            role: UserRole(rawValue: self.role) ?? .user,
            accessToken: "",
            refreshToken: "",
            expiresIn: 0,
            position: UserPosition(rawValue: self.position) ?? .staff,
            workspace: self.workspace,
            branch: self.branch,
            agencyId: self.organizationId,
            startedAt: self.startedAt.isEmpty ? nil : self.startedAt,
            endedAt: self.endedAt
        )
    }
}

extension UpdateProfileResponseDTO {
    func toModel() -> User {
        return User(
            id: self.userId,
            name: self.userName,
            email: "",
            role: .user,
            accessToken: "",
            refreshToken: "",
            expiresIn: 0,
            position: .staff,
            workspace: "",
            branch: "",
            agencyId: 0,
            startedAt: nil,
            endedAt: nil
        )
    }
}

extension EditEmployeeResponseDTO {
    func toModel() -> Employee {
        return Employee(
            id: self.userId,
            userId: self.userId,
            email: "",
            role: "",
            userName: self.userName,
            workspace: self.workspace,
            organizationId: 0,
            branch: "",
            position: UserPosition(rawValue: self.position) ?? .staff,
            status: .active,
            createdAt: nil,
            startedAt: nil,
            endedAt: nil,
            deletedAt: nil
        )
    }
}

extension EmployeeDTO {
    func toModel() -> Employee {
        return Employee(
            id: self.userId,
            userId: self.userId,
            email: self.email,
            role: self.role,
            userName: self.userName,
            workspace: self.workspace,
            organizationId: self.organizationId,
            branch: self.branch,
            position: self.position,
            status: self.status ?? .active,
            createdAt: self.createdAt,
            startedAt: self.startedAt,
            endedAt: self.endedAt,
            deletedAt: self.deletedAt
        )
    }
}

extension UpdateEmployeeStatusResponseDTO {
    func toModel(existingEmployee: Employee) -> Employee {
        return Employee(
            id: existingEmployee.id,
            userId: self.userId,
            email: existingEmployee.email,
            role: existingEmployee.role,
            userName: self.userName.isEmpty ? existingEmployee.userName : self.userName,
            workspace: self.workspace.isEmpty ? existingEmployee.workspace : self.workspace,
            organizationId: existingEmployee.organizationId,
            branch: existingEmployee.branch,
            position: existingEmployee.position,
            status: EmployeeStatus(rawValue: self.employeeStatus.uppercased()) ?? existingEmployee.status,
            createdAt: existingEmployee.createdAt,
            startedAt: existingEmployee.startedAt,
            endedAt: existingEmployee.endedAt,
            deletedAt: existingEmployee.deletedAt
        )
    }
}


