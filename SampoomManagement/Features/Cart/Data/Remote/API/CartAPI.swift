//
//  CartAPI.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import Foundation
import Alamofire

class CartAPI {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    // 장바구니 목록 조회
    func getCartList() async throws -> [CartDto] {
        let response = try await networkManager.request(
            endpoint: "agency/1/cart",
            method: .get,
            responseType: [CartDto].self
        )
        if !response.success {
            throw NetworkError.serverError(response.status, message: response.message)
        }
        return response.data ?? []
    }
    
    // 장바구니에 부품 추가
    func addCart(request: AddCartRequestDto) async throws {
        guard let params = request.toDictionary() else { throw NetworkError.invalidParameters }
        let response = try await networkManager.request(
            endpoint: "agency/1/cart",
            method: .post,
            parameters: params,
            responseType: EmptyResponse.self
        )
        if !response.success {
            throw NetworkError.serverError(response.status, message: response.message)
        }
    }
    
    // 장바구니 항목 삭제
    func deleteCart(cartItemId: Int) async throws {
        let response = try await networkManager.request(
            endpoint: "agency/1/cart/\(cartItemId)",
            method: .delete,
            responseType: EmptyResponse.self
        )
        if !response.success {
            throw NetworkError.serverError(response.status, message: response.message)
        }
    }
    
    // 장바구니 수량 변경
    func updateCart(cartItemId: Int, request: UpdateCartRequestDto) async throws {
        guard let params = request.toDictionary() else { throw NetworkError.invalidParameters }
        let response = try await networkManager.request(
            endpoint: "agency/1/cart/\(cartItemId)",
            method: .put,
            parameters: params,
            responseType: EmptyResponse.self
        )
        if !response.success {
            throw NetworkError.serverError(response.status, message: response.message)
        }
    }
    
    // 장바구니 전체 비우기
    func deleteAllCart() async throws {
        let response = try await networkManager.request(
            endpoint: "agency/1/cart/clear",
            method: .delete,
            responseType: EmptyResponse.self
        )
        if !response.success {
            throw NetworkError.serverError(response.status, message: response.message)
        }
    }
}

