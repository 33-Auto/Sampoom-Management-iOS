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
            name: self.userName,
            role: self.role,
            expiresIn: self.expiresIn
        )
    }
}
