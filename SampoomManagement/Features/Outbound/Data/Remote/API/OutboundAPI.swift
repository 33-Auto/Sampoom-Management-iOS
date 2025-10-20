//
//  OutboundAPI.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/17/25.
//

import Foundation
import Alamofire

class OutboundAPI {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    // 출고 목록 조회
    func getOutboundList() async throws -> [OutboundDto] {
        let response = try await networkManager.request(
            endpoint: "agency/1/outbound",
            method: .get,
            responseType: [OutboundDto].self
        )
        print("OutboundAPI - getOutboundList response: \(response)")
        return response.data ?? []
    }
    
    // 출고 목록에 부품 추가
    func addOutbound(request: AddOutboundRequestDto) async throws -> Void {
        let response = try await networkManager.request(
            endpoint: "agency/1/outbound",
            method: .post,
            parameters: request.toDictionary(),
            responseType: APIResponse<EmptyResponse>.self
        )
        if !response.success {
            throw NetworkError.serverError(response.status)
        }
    }
    
    // 출고 처리
    func processOutbound() async throws -> Void {
        let response = try await networkManager.request(
            endpoint: "agency/1/outbound/process",
            method: .post,
            responseType: APIResponse<EmptyResponse>.self
        )
        if !response.success {
            throw NetworkError.serverError(response.status)
        }
    }
    
    // 출고 항목 삭제
    func deleteOutbound(outboundId: Int) async throws -> Void {
        let response = try await networkManager.request(
            endpoint: "agency/1/outbound/\(outboundId)",
            method: .delete,
            responseType: APIResponse<EmptyResponse>.self
        )
        if !response.success {
            throw NetworkError.serverError(response.status)
        }
    }
    
    // 출고 수량 변경
    func updateOutbound(outboundId: Int, request: UpdateOutboundRequestDto) async throws -> Void {
        let response = try await networkManager.request(
            endpoint: "agency/1/outbound/\(outboundId)",
            method: .patch,
            parameters: request.toDictionary(),
            responseType: APIResponse<EmptyResponse>.self
        )
        if !response.success {
            throw NetworkError.serverError(response.status)
        }
    }
    
    // 출고 목록 전체 비우기
    func deleteAllOutbound() async throws -> Void {
        let response = try await networkManager.request(
            endpoint: "agency/1/outbound/clear",
            method: .delete,
            responseType: APIResponse<EmptyResponse>.self
        )
        if !response.success {
            throw NetworkError.serverError(response.status)
        }
    }
}

// Helper extension to convert DTOs to dictionary
extension Encodable {
    func toDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    }
}
