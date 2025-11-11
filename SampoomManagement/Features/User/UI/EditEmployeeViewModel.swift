//
//  EditEmployeeViewModel.swift
//  SampoomManagement
//
//  Created by Generated.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class EditEmployeeViewModel: ObservableObject {
    @Published var uiState = EditEmployeeUiState()
    
    private let editEmployeeUseCase: EditEmployeeUseCase
    private let messageHandler: GlobalMessageHandler
    
    init(
        editEmployeeUseCase: EditEmployeeUseCase,
        messageHandler: GlobalMessageHandler
    ) {
        self.editEmployeeUseCase = editEmployeeUseCase
        self.messageHandler = messageHandler
    }
    
    func onEvent(_ event: EditEmployeeUiEvent) {
        switch event {
        case .initialize(let employee):
            uiState = uiState.copy(
                employee: employee,
                isLoading: false,
                isSuccess: false
            )
        case .editEmployee(let position):
            editEmployee(position: position)
        case .dismiss:
            uiState = uiState.copy(
                employee: nil,
                isLoading: false,
                error: nil
            )
        }
    }
    
    private func editEmployee(position: UserPosition) {
        guard let currentEmployee = uiState.employee else {
            messageHandler.showMessage(StringResources.Employee.employeeNotFound, isError: true)
            return
        }
        
        Task {
            uiState = uiState.copy(isLoading: true, error: nil)
            
            let updatedEmployee = Employee(
                id: currentEmployee.userId,
                userId: currentEmployee.userId,
                email: currentEmployee.email,
                role: currentEmployee.role,
                userName: currentEmployee.userName,
                workspace: currentEmployee.workspace,
                organizationId: currentEmployee.organizationId,
                branch: currentEmployee.branch,
                position: position,
                status: currentEmployee.status,
                createdAt: currentEmployee.createdAt,
                startedAt: currentEmployee.startedAt,
                endedAt: currentEmployee.endedAt,
                deletedAt: currentEmployee.deletedAt
            )
            
            do {
                let result = try await editEmployeeUseCase.execute(employee: updatedEmployee, workspace: "AGENCY")
                uiState = uiState.copy(
                    employee: result,
                    isLoading: false,
                    error: nil,
                    isSuccess: true
                )
                messageHandler.showMessage(StringResources.Employee.editEdited, isError: false)
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

