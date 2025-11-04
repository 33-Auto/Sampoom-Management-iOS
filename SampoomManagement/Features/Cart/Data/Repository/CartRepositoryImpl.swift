//
//  CartRepositoryImpl.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import Foundation

class CartRepositoryImpl: CartRepository {
    private let api: CartAPI
    private let preferences: AuthPreferences
    
    init(api: CartAPI, preferences: AuthPreferences) {
        self.api = api
        self.preferences = preferences
    }
    
    func getCartList() async throws -> CartList {
        guard let user = try preferences.getStoredUser() else {
            throw NetworkError.unauthorized
        }
        let data: [CartDto] = try await api.getCartList(agencyId: user.agencyId)
        let cartItems = data.map { $0.toModel() }
        return CartList(items: cartItems)
    }
    
    func addCart(partId: Int, quantity: Int) async throws {
        guard let user = try preferences.getStoredUser() else {
            throw NetworkError.unauthorized
        }
        let request = AddCartRequestDto(partId: partId, quantity: quantity)
        try await api.addCart(agencyId: user.agencyId, request: request)
    }
    
    func deleteCart(cartItemId: Int) async throws {
        guard let user = try preferences.getStoredUser() else {
            throw NetworkError.unauthorized
        }
        try await api.deleteCart(agencyId: user.agencyId, cartItemId: cartItemId)
    }
    
    func deleteAllCart() async throws {
        guard let user = try preferences.getStoredUser() else {
            throw NetworkError.unauthorized
        }
        try await api.deleteAllCart(agencyId: user.agencyId)
    }
    
    func updateCartQuantity(cartItemId: Int, quantity: Int) async throws {
        guard let user = try preferences.getStoredUser() else {
            throw NetworkError.unauthorized
        }
        let request = UpdateCartRequestDto(quantity: quantity)
        try await api.updateCart(agencyId: user.agencyId, cartItemId: cartItemId, request: request)
    }
}

