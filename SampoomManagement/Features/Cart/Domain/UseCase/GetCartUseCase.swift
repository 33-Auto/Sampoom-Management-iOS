//
//  GetCartUseCase.swift
//  SampoomManagement
//
//  Created by AI Assistant on 10/20/25.
//

import Foundation

class GetCartUseCase {
    private let repository: CartRepository
    
    init(repository: CartRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> CartList {
        return try await repository.getCartList()
    }
}

