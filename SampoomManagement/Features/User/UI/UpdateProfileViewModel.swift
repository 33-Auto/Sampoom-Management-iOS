//
//  UpdateProfileViewModel.swift
//  SampoomManagement
//
//  Created by Generated.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class UpdateProfileViewModel: ObservableObject {
    @Published var uiState = UpdateProfileUiState()
    
    private let updateProfileUseCase: UpdateProfileUseCase
    private let messageHandler: GlobalMessageHandler
    
    init(
        updateProfileUseCase: UpdateProfileUseCase,
        messageHandler: GlobalMessageHandler
    ) {
        self.updateProfileUseCase = updateProfileUseCase
        self.messageHandler = messageHandler
    }
    
    func onEvent(_ event: UpdateProfileUiEvent) {
        switch event {
        case .initialize(let user):
            uiState = uiState.copy(
                user: user,
                isLoading: false,
                isSuccess: false
            )
        case .updateProfile(let userName):
            updateProfile(userName: userName)
        case .dismiss:
            uiState = uiState.copy(
                user: nil,
                isLoading: false,
                error: nil
            )
        }
    }
    
    private func updateProfile(userName: String) {
        guard let currentUser = uiState.user else {
            messageHandler.showMessage(StringResources.Setting.userNotFound, isError: true)
            return
        }
        
        Task {
            uiState = uiState.copy(isLoading: true, error: nil)
            
            let updatedUser = User(
                id: currentUser.id,
                name: userName,
                email: currentUser.email,
                role: currentUser.role,
                accessToken: currentUser.accessToken,
                refreshToken: currentUser.refreshToken,
                expiresIn: currentUser.expiresIn,
                position: currentUser.position,
                branch: currentUser.branch,
                agencyId: currentUser.agencyId,
                startedAt: currentUser.startedAt,
                endedAt: currentUser.endedAt
            )
            
            do {
                let result = try await updateProfileUseCase.execute(user: updatedUser)
                uiState = uiState.copy(
                    user: result,
                    isLoading: false,
                    error: nil,
                    isSuccess: true
                )
                messageHandler.showMessage(StringResources.Setting.editProfileEdited, isError: false)
            } catch {
                let errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
                messageHandler.showMessage(errorMessage, isError: true)
                uiState = uiState.copy(
                    isLoading: false,
                    error: errorMessage
                )
            }
        }
    }
    
    func clearStatus() {
        uiState = uiState.copy(error: nil, isSuccess: false)
    }
}

