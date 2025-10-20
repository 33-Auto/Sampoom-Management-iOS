//
//  AddOutboundUseCase.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/17/25.
//

import Foundation

class AddOutboundUseCase {
    private let repository: OutboundRepository
    
    init(repository: OutboundRepository) {
        self.repository = repository
    }
    
    func execute(partId: Int, quantity: Int) async throws {
        return try await repository.addOutbound(partId: partId, quantity: quantity)
    }
}
