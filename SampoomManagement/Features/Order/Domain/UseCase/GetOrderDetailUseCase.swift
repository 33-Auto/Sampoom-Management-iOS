//
//  GetOrderDetailUseCase.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import Foundation

class GetOrderDetailUseCase {
    private let repository: OrderRepository

    init(repository: OrderRepository) {
        self.repository = repository
    }

    func execute(orderId: Int) async throws -> OrderList {
        return try await repository.getOrderDetail(orderId: orderId)
    }
}
