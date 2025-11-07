//
//  ReceiveOrderUseCase.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import Foundation

class ReceiveOrderUseCase {
    private let repository: OrderRepository
    
    init(repository: OrderRepository) {
        self.repository = repository
    }
    
    func execute(items: [(Int, Int)]) async throws {
        try await repository.receiveOrder(items: items)
    }
}
