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


// MARK: - Vendors

extension GetVendorsResponseDTO {
    func toModel() -> Vendor {
        return Vendor(
            id: id,
            vendorCode: vendorCode,
            name: name,
            businessNumber: businessNumber,
            ceoName: ceoName,
            address: address,
            status: status
        )
    }
}
