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
    
    private let authPreferences: AuthPreferences
    private let signOutUseCase: SignOutUseCase
    private let globalMessageHandler: GlobalMessageHandler
    
    init(
        authPreferences: AuthPreferences,
        signOutUseCase: SignOutUseCase,
        globalMessageHandler: GlobalMessageHandler
    ) {
        self.authPreferences = authPreferences
        self.signOutUseCase = signOutUseCase
        self.globalMessageHandler = globalMessageHandler
    }
    
    func onEvent(_ event: SettingUiEvent) {
        switch event {
        case .loadProfile:
            loadProfile()
        case .editProfile:
            // TODO: Implement edit profile
            break
        case .logout:
            // Deprecated in favor of explicit async logout() from the View
            break
        }
    }
    
    private func loadProfile() {
        do {
            user = try authPreferences.getStoredUser()
        } catch {
            uiState = uiState.copy(error: error.localizedDescription)
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

