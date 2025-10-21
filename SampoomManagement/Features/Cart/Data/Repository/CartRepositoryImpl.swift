//
//  CartRepositoryImpl.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import Foundation

class CartRepositoryImpl: CartRepository {
    private let api: CartAPI
    
    init(api: CartAPI) {
        self.api = api
    }
    
    func getCartList() async throws -> CartList {
        let data: [CartDto] = try await api.getCartList()
        let cartItems = data.map { $0.toModel() }
        return CartList(items: cartItems)
    }
    
    func addCart(partId: Int, quantity: Int) async throws {
        let request = AddCartRequestDto(partId: partId, quantity: quantity)
        try await api.addCart(request: request)
    }
    
    func deleteCart(cartItemId: Int) async throws {
        try await api.deleteCart(cartItemId: cartItemId)
    }
    
    func deleteAllCart() async throws {
        try await api.deleteAllCart()
    }
    
    func updateCartQuantity(cartItemId: Int, quantity: Int) async throws {
        let request = UpdateCartRequestDto(quantity: quantity)
        try await api.updateCart(cartItemId: cartItemId, request: request)
    }
}

