//
//  AddCartUseCase.swift
//  SampoomManagement
//
//  Created by AI Assistant on 10/20/25.
//

import Foundation

class AddCartUseCase {
    private let repository: CartRepository
    
    init(repository: CartRepository) {
        self.repository = repository
    }
    
    func execute(partId: Int, quantity: Int) async throws {
        try await repository.addCart(partId: partId, quantity: quantity)
    }
}

