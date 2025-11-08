//
//  SettingViewModel.swift
//  SampoomManagement
//
//  Created by Generated.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class SettingViewModel: ObservableObject {
    @Published var uiState = SettingUiState.initial
    @Published var user: User?
    
    private let getStoredUserUseCase: GetStoredUserUseCase
    private let signOutUseCase: SignOutUseCase
    private let globalMessageHandler: GlobalMessageHandler
    
    init(
        getStoredUserUseCase: GetStoredUserUseCase,
        signOutUseCase: SignOutUseCase,
        globalMessageHandler: GlobalMessageHandler
    ) {
        self.getStoredUserUseCase = getStoredUserUseCase
        self.signOutUseCase = signOutUseCase
        self.globalMessageHandler = globalMessageHandler
    }
    
    func onEvent(_ event: SettingUiEvent) {
        switch event {
        case .loadProfile:
            refreshUser()
        }
    }
    
    func refreshUser() {
        Task {
            do {
                user = try getStoredUserUseCase.execute()
            } catch {
                uiState = uiState.copy(error: error.localizedDescription)
            }
        }
    }
    
    func logout() async -> Bool {
        do {
            try await signOutUseCase.execute()
            return true
        } catch {
            let errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
            globalMessageHandler.showMessage(errorMessage, isError: true)
            return false
        }
    }
}

