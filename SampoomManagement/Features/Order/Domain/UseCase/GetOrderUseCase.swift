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
    
    func execute(page: Int = 0, size: Int = 20) async throws -> (items: [Order], hasMore: Bool) {
        return try await repository.getOrderList(page: page, size: size)
    }
}
