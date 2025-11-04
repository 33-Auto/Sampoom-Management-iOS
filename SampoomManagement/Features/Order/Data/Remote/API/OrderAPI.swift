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
    func getOrderList(agencyName: String, page: Int = 0, size: Int = 20) async throws -> OrderListDto {
        let encodedAgencyName = agencyName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? agencyName
        let endpoint = "order/requested?from=\(encodedAgencyName)&page=\(page)&size=\(size)"
        
        let response: APIResponse<OrderListDto> = try await networkManager.request(
            endpoint: endpoint,
            method: .get,
            responseType: OrderListDto.self
        )
        guard response.success else { throw NetworkError.serverError(response.status, message: response.message) }
        
        return response.data ?? OrderListDto(content: [], totalElements: 0, totalPages: 0, number: 0, last: true, size: size, first: true)
    }
    
    /// 주문 생성
    func createOrder(orderRequestDto: OrderRequestDto) async throws -> OrderDto {
        let response: APIResponse<OrderDto> = try await networkManager.request(
            endpoint: "order/",
            method: .post,
            body: orderRequestDto,
            responseType: OrderDto.self
        )
        guard response.success else { throw NetworkError.serverError(response.status, message: response.message) }
        guard let data = response.data else {
            throw NetworkError.noData
        }
        return data
    }
    
    /// 주문 완료 처리
    func completeOrder(orderId: Int) async throws {
        let response: APIResponse<EmptyResponse> = try await networkManager.request(
            endpoint: "order/complete/\(orderId)",
            method: .patch,
            responseType: EmptyResponse.self
        )
        if !response.success { throw NetworkError.serverError(response.status, message: response.message) }
    }
    
    /// 주문 입고 처리 (대리점)
    func receiveOrder(agencyId: Int, orderId: Int) async throws {
        let response: APIResponse<EmptyResponse> = try await networkManager.request(
            endpoint: "agency/\(agencyId)/orders/\(orderId)/receive",
            method: .patch,
            responseType: EmptyResponse.self
        )
        if !response.success { throw NetworkError.serverError(response.status, message: response.message) }
    }
    
    /// 주문 상세 조회
    func getOrderDetail(orderId: Int) async throws -> OrderDto {
        let response: APIResponse<OrderDto> = try await networkManager.request(
            endpoint: "order/\(orderId)",
            method: .get,
            responseType: OrderDto.self
        )
        guard response.success else { throw NetworkError.serverError(response.status, message: response.message) }
        guard let data = response.data else {
            throw NetworkError.noData
        }
        return data
    }
    
    /// 주문 취소
    func cancelOrder(orderId: Int) async throws {
        let response: APIResponse<EmptyResponse> = try await networkManager.request(
            endpoint: "order/cancel/\(orderId)",
            method: .patch,
            responseType: EmptyResponse.self
        )
        if !response.success { throw NetworkError.serverError(response.status, message: response.message) }
    }
}
