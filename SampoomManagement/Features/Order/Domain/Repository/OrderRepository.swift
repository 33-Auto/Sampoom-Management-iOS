//
//  OrderRepository.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import Foundation

protocol OrderRepository {
    func getOrderList(page: Int, size: Int) async throws -> (items: [Order], hasMore: Bool)
    func createOrder(cartList: CartList) async throws -> Order
    func completeOrder(orderId: Int) async throws
    func receiveOrder(orderId: Int) async throws
    func getOrderDetail(orderId: Int) async throws -> Order
    func cancelOrder(orderId: Int) async throws
}
