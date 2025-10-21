//
//  OrderRepositoryImpl.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import Foundation

class OrderRepositoryImpl: OrderRepository {
    private let api: OrderAPI
    
    init(api: OrderAPI) {
        self.api = api
    }
    
    func getOrderList() async throws -> OrderList {
        let dtos = try await api.getOrderList()
        let orders = dtos.map { $0.toModel() }
        return OrderList(items: orders)
    }
    
    func createOrder() async throws -> OrderList {
        let dtos = try await api.createOrder()
        let orders = dtos.map { $0.toModel() }
        return OrderList(items: orders)
    }
    
    func receiveOrder(orderId: Int) async throws {
        try await api.receiveOrder(orderId: orderId)
    }
    
    func getOrderDetail(orderId: Int) async throws -> OrderList {
        let dtos = try await api.getOrderDetail(orderId: orderId)
        let orders = dtos.map { $0.toModel() }
        return OrderList(items: orders)
    }
    
    func cancelOrder(orderId: Int) async throws {
        try await api.cancelOrder(orderId: orderId)
    }
}
