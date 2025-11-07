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
    func getCartList(agencyId: Int) async throws -> [CartDto] {
        let response = try await networkManager.request(
            endpoint: "agency/\(agencyId)/cart",
            method: .get,
            responseType: [CartDto].self
        )
        if !response.success {
            throw NetworkError.serverError(response.status, message: response.message)
        }
        return response.data ?? []
    }
    
    // 장바구니에 부품 추가
    func addCart(agencyId: Int, request: AddCartRequestDto) async throws {
        guard let params = request.toDictionary() else { throw NetworkError.invalidParameters }
        let response = try await networkManager.request(
            endpoint: "agency/\(agencyId)/cart",
            method: .post,
            parameters: params,
            responseType: EmptyResponse.self
        )
        if !response.success {
            throw NetworkError.serverError(response.status, message: response.message)
        }
    }
    
    // 장바구니 항목 삭제
    func deleteCart(agencyId: Int, cartItemId: Int) async throws {
        let response = try await networkManager.request(
            endpoint: "agency/\(agencyId)/cart/\(cartItemId)",
            method: .delete,
            responseType: EmptyResponse.self
        )
        if !response.success {
            throw NetworkError.serverError(response.status, message: response.message)
        }
    }
    
    // 장바구니 수량 변경
    func updateCart(agencyId: Int, cartItemId: Int, request: UpdateCartRequestDto) async throws {
        guard let params = request.toDictionary() else { throw NetworkError.invalidParameters }
        let response = try await networkManager.request(
            endpoint: "agency/\(agencyId)/cart/\(cartItemId)",
            method: .put,
            parameters: params,
            responseType: EmptyResponse.self
        )
        if !response.success {
            throw NetworkError.serverError(response.status, message: response.message)
        }
    }
    
    // 장바구니 전체 비우기
    func deleteAllCart(agencyId: Int) async throws {
        let response = try await networkManager.request(
            endpoint: "agency/\(agencyId)/cart/clear",
            method: .delete,
            responseType: EmptyResponse.self
        )
        if !response.success {
            throw NetworkError.serverError(response.status, message: response.message)
        }
    }
}

