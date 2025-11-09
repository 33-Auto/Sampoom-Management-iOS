//
//  UpdateEmployeeStatusViewModel.swift
//  SampoomManagement
//
//  Created by Generated.
//

import Foundation
import Combine

@MainActor
class UpdateEmployeeStatusViewModel: ObservableObject {
    @Published var uiState = UpdateEmployeeStatusUiState()
    
    private let updateEmployeeStatusUseCase: UpdateEmployeeStatusUseCase
    private let messageHandler: GlobalMessageHandler
    
    init(
        updateEmployeeStatusUseCase: UpdateEmployeeStatusUseCase,
        messageHandler: GlobalMessageHandler
    ) {
        self.updateEmployeeStatusUseCase = updateEmployeeStatusUseCase
        self.messageHandler = messageHandler
    }
    
    private var errorLabel: String = ""
    private var editEmployeeLabel: String = ""
    
    func onEvent(_ event: UpdateEmployeeStatusUiEvent) {
        switch event {
        case .initialize(let employee):
            uiState = uiState.copy(
                employee: employee,
                isLoading: false,
                isSuccess: false
            )
        case .editEmployeeStatus(let status):
            updateEmployeeStatus(status: status)
        case .dismiss:
            uiState = uiState.copy(
                employee: nil,
                isLoading: false,
                error: nil
            )
        }
    }
    
    func bindLabel(error: String, editEmployee: String) {
        errorLabel = error
        editEmployeeLabel = editEmployee
    }
    
    private func updateEmployeeStatus(status: EmployeeStatus) {
        guard let currentEmployee = uiState.employee else {
            messageHandler.showMessage(errorLabel, isError: true)
            return
        }
        
        Task {
            uiState = uiState.copy(isLoading: true, error: nil)
            
            let updatedEmployee = Employee(
                id: currentEmployee.id,
                userId: currentEmployee.userId,
                email: currentEmployee.email,
                role: currentEmployee.role,
                userName: currentEmployee.userName,
                workspace: currentEmployee.workspace,
                organizationId: currentEmployee.organizationId,
                branch: currentEmployee.branch,
                position: currentEmployee.position,
                status: status,
                createdAt: currentEmployee.createdAt,
                startedAt: currentEmployee.startedAt,
                endedAt: currentEmployee.endedAt,
                deletedAt: currentEmployee.deletedAt
            )
            
            do {
                let result = try await updateEmployeeStatusUseCase.execute(employee: updatedEmployee, workspace: "AGENCY")
                uiState = uiState.copy(
                    employee: result,
                    isLoading: false,
                    error: nil,
                    isSuccess: true
                )
                messageHandler.showMessage(editEmployeeLabel, isError: false)
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


