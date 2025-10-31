//
//  OrderRepository.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import Foundation

protocol OrderRepository {
    func getOrderList() async throws -> OrderList
    func createOrder(cartList: CartList) async throws -> OrderList
    func receiveOrder(orderId: Int) async throws
    func getOrderDetail(orderId: Int) async throws -> OrderList
    func cancelOrder(orderId: Int) async throws
}
