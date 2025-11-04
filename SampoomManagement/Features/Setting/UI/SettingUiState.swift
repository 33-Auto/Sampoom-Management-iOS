//
//  SettingUiState.swift
//  SampoomManagement
//
//  Created by Generated.
//

import Foundation

struct SettingUiState {
    let loading: Bool
    let error: String?
    
    static let initial = SettingUiState(
        loading: false,
        error: nil
    )
    
    func copy(
        loading: Bool? = nil,
        error: String?? = nil
    ) -> SettingUiState {
        let resolvedError: String?
        if let error = error {
            resolvedError = error
        } else {
            resolvedError = self.error
        }
        
        return SettingUiState(
            loading: loading ?? self.loading,
            error: resolvedError
        )
    }
}

