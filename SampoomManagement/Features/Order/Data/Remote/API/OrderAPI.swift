//
//  OrderAPI.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import Foundation
import Alamofire

class OrderAPI {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    /// 주문 목록 조회
    func getOrderList() async throws -> [OrderDto] {
        let response: APIResponse<[OrderDto]> = try await networkManager.request(
            endpoint: "/agency/1/orders",
            method: .get,
            responseType: [OrderDto].self
        )
        return response.data ?? []
    }
    
    /// 주문 생성
    func createOrder() async throws -> [OrderDto] {
        let response: APIResponse<[OrderDto]> = try await networkManager.request(
            endpoint: "/agency/1/orders",
            method: .post,
            responseType: [OrderDto].self
        )
        return response.data ?? []
    }
    
    /// 주문 입고 처리
    func receiveOrder(orderId: Int) async throws {
        let _: APIResponse<EmptyResponse> = try await networkManager.request(
            endpoint: "/agency/1/orders/\(orderId)/receive",
            method: .patch,
            responseType: EmptyResponse.self
        )
    }
    
    /// 주문 상세 조회
    func getOrderDetail(orderId: Int) async throws -> [OrderDto] {
        let response: APIResponse<[OrderDto]> = try await networkManager.request(
            endpoint: "/agency/1/orders/\(orderId)",
            method: .get,
            responseType: [OrderDto].self
        )
        return response.data ?? []
    }
    
    /// 주문 취소
    func cancelOrder(orderId: Int) async throws {
        let _: APIResponse<EmptyResponse> = try await networkManager.request(
            endpoint: "/agency/1/orders/\(orderId)",
            method: .delete,
            responseType: EmptyResponse.self
        )
    }
}
