//
//  PartViewModel.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class PartViewModel: ObservableObject {
    @Published var uiState = PartUIState()
    
    private let getPartUseCase: GetPartUseCase
    
    init(getPartUseCase: GetPartUseCase) {
        self.getPartUseCase = getPartUseCase
        loadPart()
    }
    
    private func loadPart() {
        Task {
            uiState = uiState.copy(loading: true, error: nil)
            
            do {
                let partList = try await getPartUseCase.execute()
                uiState = uiState.copy(
                    loading: false,
                    success: true,
                    partList: partList.items
                )
            } catch {
                uiState = uiState.copy(
                    loading: false,
                    error: error.localizedDescription
                )
            }
        }
    }
    
    func refreshPart() {
        loadPart()
    }
}

struct PartUIState {
    let loading: Bool
    let error: String?
    let success: Bool
    let partList: [Part]
    
    init(
        loading: Bool = false,
        error: String? = nil,
        success: Bool = false,
        partList: [Part] = []
    ) {
        self.loading = loading
        self.error = error
        self.success = success
        self.partList = partList
    }
    
    func copy(
        loading: Bool? = nil,
        error: String? = nil,
        success: Bool? = nil,
        partList: [Part]? = nil
    ) -> PartUIState {
        return PartUIState(
            loading: loading ?? self.loading,
            error: error ?? self.error,
            success: success ?? self.success,
            partList: partList ?? self.partList
        )
    }
}

