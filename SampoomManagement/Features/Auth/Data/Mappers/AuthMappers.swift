//
//  AuthMappers.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/15/25.
//

import Foundation

extension LoginResponseDTO {
    func toModel() -> User {
        return User(
            id: self.userId,
            name: "",
            email: "",
            role: .user,
            accessToken: self.accessToken,
            refreshToken: self.refreshToken,
            expiresIn: self.expiresIn,
            position: .staff,
            workspace: "",
            branch: "",
            agencyId: 0,
            startedAt: nil,
            endedAt: nil
        )
    }
}

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

extension User {
    func mergeWith(profile: User) -> User {
        return User(
            id: self.id,
            name: profile.name,
            email: profile.email,
            role: profile.role,
            accessToken: self.accessToken,
            refreshToken: self.refreshToken,
            expiresIn: self.expiresIn,
            position: profile.position,
            workspace: profile.workspace,
            branch: profile.branch,
            agencyId: profile.agencyId,
            startedAt: profile.startedAt,
            endedAt: profile.endedAt
        )
    }
}
