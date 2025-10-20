//
//  OutboundRepository.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/17/25.
//

import Foundation

protocol OutboundRepository {
    func getOutboundList() async throws -> OutboundList
    func processOutbound() async throws
    func addOutbound(partId: Int, quantity: Int) async throws
    func deleteOutbound(outboundId: Int) async throws
    func deleteAllOutbound() async throws
    func updateOutboundQuantity(outboundId: Int, quantity: Int) async throws
}
