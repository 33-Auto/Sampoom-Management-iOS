//
//  UpdateCartQuantityUseCase.swift
//  SampoomManagement
//
//  Created by AI Assistant on 10/20/25.
//

import Foundation

class UpdateCartQuantityUseCase {
    private let repository: CartRepository
    
    init(repository: CartRepository) {
        self.repository = repository
    }
    
    func execute(cartItemId: Int, quantity: Int) async throws {
        try await repository.updateCartQuantity(cartItemId: cartItemId, quantity: quantity)
    }
}

