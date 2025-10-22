//
//  GetOrderUseCase.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import Foundation

class GetOrderUseCase {
    private let repository: OrderRepository
    
    init(repository: OrderRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> OrderList {
        return try await repository.getOrderList()
    }
}
