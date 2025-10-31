//
//  OrderRepositoryImpl.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import Foundation

class OrderRepositoryImpl: OrderRepository {
    private let api: OrderAPI
    private let preferences: AuthPreferences
    
    init(api: OrderAPI, preferences: AuthPreferences) {
        self.api = api
        self.preferences = preferences
    }
    
    func getOrderList() async throws -> OrderList {
        let dtos = try await api.getOrderList()
        let orders = dtos.map { $0.toModel() }
        return OrderList(items: orders)
    }
    
    func createOrder(cartList: CartList) async throws -> OrderList {
        guard let user = try preferences.getStoredUser() else {
            throw NetworkError.unauthorized
        }
        let items: [OrderItems] = cartList.items
            .flatMap { $0.groups }
            .flatMap { $0.parts }
            .map { part in
                return OrderItems(code: part.code, quantity: Int64(part.quantity))
            }
        let request = OrderRequestDto(
            requester: "대리점",
            branch: user.branch,
            items: items
        )
        let dtos = try await api.createOrder(orderRequestDto: request)
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
