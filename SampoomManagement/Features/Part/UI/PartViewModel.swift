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

