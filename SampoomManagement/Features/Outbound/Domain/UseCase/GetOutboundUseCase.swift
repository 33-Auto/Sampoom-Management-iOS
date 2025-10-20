//
//  GetOutboundUseCase.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/17/25.
//

import Foundation

class GetOutboundUseCase {
    private let repository: OutboundRepository
    
    init(repository: OutboundRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> OutboundList {
        return try await repository.getOutboundList()
    }
}
