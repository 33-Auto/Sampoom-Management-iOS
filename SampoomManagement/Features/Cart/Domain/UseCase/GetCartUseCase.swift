//
//  GetCartUseCase.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
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

