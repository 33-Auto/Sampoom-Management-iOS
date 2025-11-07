//
//  CartRepository.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import Foundation

protocol CartRepository {
    func getCartList() async throws -> CartList
    func addCart(partId: Int, quantity: Int) async throws -> Void
    func deleteCart(cartItemId: Int) async throws -> Void
    func deleteAllCart() async throws -> Void
    func updateCartQuantity(cartItemId: Int, quantity: Int) async throws -> Void
}

