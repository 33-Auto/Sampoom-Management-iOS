//
//  CreateOrderUseCase.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import Foundation

class CreateOrderUseCase {
    private let repository: OrderRepository
    
    init(repository: OrderRepository) {
        self.repository = repository
    }
    
    func execute(cartList: CartList) async throws -> Order {
        return try await repository.createOrder(cartList: cartList)
    }
}
