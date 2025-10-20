//
//  DeleteOutboundUseCase.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/17/25.
//

import Foundation

class DeleteOutboundUseCase {
    private let repository: OutboundRepository
    
    init(repository: OutboundRepository) {
        self.repository = repository
    }
    
    func execute(outboundId: Int) async throws {
        return try await repository.deleteOutbound(outboundId: outboundId)
    }
}
