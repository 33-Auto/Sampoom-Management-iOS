//
//  UpdateOutboundQuantityUseCase.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/17/25.
//

import Foundation

class UpdateOutboundQuantityUseCase {
    private let repository: OutboundRepository
    
    init(repository: OutboundRepository) {
        self.repository = repository
    }
    
    func execute(outboundId: Int, quantity: Int) async throws {
        return try await repository.updateOutboundQuantity(outboundId: outboundId, quantity: quantity)
    }
}
