//
//  UpdateProfileUiState.swift
//  SampoomManagement
//
//  Created by Generated.
//

import Foundation

struct UpdateProfileUiState {
    let user: User?
    let isLoading: Bool
    let error: String?
    let isSuccess: Bool
    
    init(
        user: User? = nil,
        isLoading: Bool = false,
        error: String? = nil,
        isSuccess: Bool = false
    ) {
        self.user = user
        self.isLoading = isLoading
        self.error = error
        self.isSuccess = isSuccess
    }
    
    func copy(
        user: User? = nil,
        isLoading: Bool? = nil,
        error: String? = nil,
        isSuccess: Bool? = nil
    ) -> UpdateProfileUiState {
        return UpdateProfileUiState(
            user: user ?? self.user,
            isLoading: isLoading ?? self.isLoading,
            error: error ?? self.error,
            isSuccess: isSuccess ?? self.isSuccess
        )
    }
}

