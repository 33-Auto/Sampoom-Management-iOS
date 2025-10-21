//
//  DeleteCartUseCase.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import Foundation

class DeleteCartUseCase {
    private let repository: CartRepository
    
    init(repository: CartRepository) {
        self.repository = repository
    }
    
    func execute(cartItemId: Int) async throws {
        try await repository.deleteCart(cartItemId: cartItemId)
    }
}

