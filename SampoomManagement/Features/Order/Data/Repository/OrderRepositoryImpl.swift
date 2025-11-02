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
    
    func getOrderList(page: Int, size: Int) async throws -> (items: [Order], hasMore: Bool) {
        guard let user = try preferences.getStoredUser() else {
            throw NetworkError.unauthorized
        }
        let dto = try await api.getOrderList(agencyName: user.branch, page: page, size: size)
        let orders = dto.content.map { $0.toModel() }
        // last가 false면 더 많은 페이지가 있음
        let hasMore = !dto.last
        return (items: orders, hasMore: hasMore)
    }
    
    func createOrder(cartList: CartList) async throws -> Order {
        guard let user = try preferences.getStoredUser() else {
            throw NetworkError.unauthorized
        }
        let items = cartList.items.map { cart in
            OrderCategoryDto(
                categoryId: cart.categoryId,
                categoryName: cart.categoryName,
                groups: cart.groups.map { group in
                    OrderGroupDto(
                        groupId: group.groupId,
                        groupName: group.groupName,
                        parts: group.parts.map { part in
                            OrderPartDto(
                                partId: part.partId,
                                code: part.code,
                                name: part.name,
                                quantity: part.quantity
                            )
                        }
                    )
                }
            )
        }
        let request = OrderRequestDto(
            agencyName: user.branch,
            items: items
        )
        let dto = try await api.createOrder(orderRequestDto: request)
        return dto.toModel()
    }
    
    func receiveOrder(orderId: Int) async throws {
        try await api.receiveOrder(orderId: orderId)
    }
    
    func getOrderDetail(orderId: Int) async throws -> Order {
        let dto = try await api.getOrderDetail(orderId: orderId)
        return dto.toModel()
    }
    
    func cancelOrder(orderId: Int) async throws {
        try await api.cancelOrder(orderId: orderId)
    }
}
