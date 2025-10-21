//
//  CancelOrderUseCase.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import Foundation

class CancelOrderUseCase {
    private let repository: OrderRepository
    
    init(repository: OrderRepository) {
        self.repository = repository
    }
    
    func execute(orderId: Int) async throws {
        try await repository.cancelOrder(orderId: orderId)
    }
}
