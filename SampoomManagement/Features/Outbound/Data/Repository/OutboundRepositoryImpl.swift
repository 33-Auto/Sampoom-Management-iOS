//
//  OutboundRepositoryImpl.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/17/25.
//

import Foundation

class OutboundRepositoryImpl: OutboundRepository {
    private let api: OutboundAPI
    private let preferences: AuthPreferences
    
    init(api: OutboundAPI, preferences: AuthPreferences) {
        self.api = api
        self.preferences = preferences
    }
    
    func getOutboundList() async throws -> OutboundList {
        guard let user = try preferences.getStoredUser() else {
            throw NetworkError.unauthorized
        }
        let data: [OutboundDto] = try await api.getOutboundList(agencyId: user.agencyId)
        let outboundItems = data.map { $0.toModel() }
        return OutboundList(items: outboundItems)
    }
    
    func processOutbound() async throws {
        guard let user = try preferences.getStoredUser() else {
            throw NetworkError.unauthorized
        }
        try await api.processOutbound(agencyId: user.agencyId)
    }
    
    func addOutbound(partId: Int, quantity: Int) async throws {
        guard let user = try preferences.getStoredUser() else {
            throw NetworkError.unauthorized
        }
        let request = AddOutboundRequestDto(partId: partId, quantity: quantity)
        try await api.addOutbound(agencyId: user.agencyId, request: request)
    }
    
    func deleteOutbound(outboundId: Int) async throws {
        guard let user = try preferences.getStoredUser() else {
            throw NetworkError.unauthorized
        }
        try await api.deleteOutbound(agencyId: user.agencyId, outboundId: outboundId)
    }
    
    func deleteAllOutbound() async throws {
        guard let user = try preferences.getStoredUser() else {
            throw NetworkError.unauthorized
        }
        try await api.deleteAllOutbound(agencyId: user.agencyId)
    }
    
    func updateOutboundQuantity(outboundId: Int, quantity: Int) async throws {
        guard let user = try preferences.getStoredUser() else {
            throw NetworkError.unauthorized
        }
        let request = UpdateOutboundRequestDto(quantity: quantity)
        try await api.updateOutbound(agencyId: user.agencyId, outboundId: outboundId, request: request)
    }
}