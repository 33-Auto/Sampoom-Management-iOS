//
//  OutboundRepositoryImpl.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/17/25.
//

import Foundation

class OutboundRepositoryImpl: OutboundRepository {
    private let api: OutboundAPI
    
    init(api: OutboundAPI) {
        self.api = api
    }
    
    func getOutboundList() async throws -> OutboundList {
        let data: [OutboundDto] = try await api.getOutboundList()
        let outboundItems = data.map { $0.toModel() }
        return OutboundList(items: outboundItems)
    }
    
    func processOutbound() async throws {
        try await api.processOutbound()
    }
    
    func addOutbound(partId: Int, quantity: Int) async throws {
        let request = AddOutboundRequestDto(partId: partId, quantity: quantity)
        try await api.addOutbound(request: request)
    }
    
    func deleteOutbound(outboundId: Int) async throws {
        try await api.deleteOutbound(outboundId: outboundId)
    }
    
    func deleteAllOutbound() async throws {
        try await api.deleteAllOutbound()
    }
    
    func updateOutboundQuantity(outboundId: Int, quantity: Int) async throws {
        let request = UpdateOutboundRequestDto(quantity: quantity)
        try await api.updateOutbound(outboundId: outboundId, request: request)
    }
}