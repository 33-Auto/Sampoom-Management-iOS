//
//  CheckLoginStateUseCase.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/15/25.
//

import Foundation

class CheckLoginStateUseCase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func execute() -> Bool {
        return repository.isSignedIn()
    }
}
