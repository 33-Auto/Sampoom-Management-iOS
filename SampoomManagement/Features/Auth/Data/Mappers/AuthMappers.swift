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
            name: self.userName ?? "",
            role: self.role,
            accessToken: self.accessToken,
            refreshToken: self.refreshToken,
            expiresIn: self.expiresIn,
            position: "",
            workspace: "",
            branch: ""
        )
    }
}

extension GetProfileResponseDTO {
    func toModel() -> User {
        return User(
            id: self.userId,
            name: self.userName ?? "",
            role: "",
            accessToken: "",
            refreshToken: "",
            expiresIn: 0,
            position: self.position ?? "",
            workspace: self.workspace ?? "",
            branch: self.branch ?? ""
        )
    }
}

extension User {
    func mergeWith(profile: User) -> User {
        return User(
            id: self.id,
            name: profile.name,
            role: self.role,
            accessToken: self.accessToken,
            refreshToken: self.refreshToken,
            expiresIn: self.expiresIn,
            position: profile.position,
            workspace: profile.workspace,
            branch: profile.branch
        )
    }
}
