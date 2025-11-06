//
//  GetVendorUseCase.swift
//  SampoomManagement
//
//  Mirrors Android GetVendorUseCase.
//

import Foundation

struct GetVendorUseCase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> VendorList {
        return try await repository.getVendorList()
    }
}


