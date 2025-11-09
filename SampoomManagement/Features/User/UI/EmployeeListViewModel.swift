//
//  EmployeeListViewModel.swift
//  SampoomManagement
//
//  Created by Generated.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class EmployeeListViewModel: ObservableObject {
    @Published var uiState = EmployeeListUiState()
    
    private let getEmployeeUseCase: GetEmployeeUseCase
    private let messageHandler: GlobalMessageHandler
    private let authPreferences: AuthPreferences
    
    init(
        getEmployeeUseCase: GetEmployeeUseCase,
        messageHandler: GlobalMessageHandler,
        authPreferences: AuthPreferences
    ) {
        self.getEmployeeUseCase = getEmployeeUseCase
        self.messageHandler = messageHandler
        self.authPreferences = authPreferences
        loadEmployeeList()
    }
    
    func onEvent(_ event: EmployeeListUiEvent) {
        switch event {
        case .loadEmployeeList:
            loadEmployeeList()
        case .retryEmployeeList:
            loadEmployeeList()
        case .showEditBottomSheet(let employee):
            presentBottomSheet(for: employee, type: .edit)
        case .showStatusBottomSheet(let employee):
            presentBottomSheet(for: employee, type: .status)
        case .dismissBottomSheet:
            uiState = uiState.copy(selectedEmployee: .some(nil), bottomSheetType: .some(nil))
        case .loadMore:
            loadMoreEmployees()
        }
    }
    
    private func presentBottomSheet(for employee: Employee, type: EmployeeBottomSheetType) {
        if uiState.selectedEmployee?.userId == employee.userId && uiState.bottomSheetType == type {
            // toggle to allow re-selection of identical employee & sheet
            uiState = uiState.copy(selectedEmployee: .some(nil), bottomSheetType: .some(nil))
            Task { @MainActor in
                self.uiState = self.uiState.copy(selectedEmployee: .some(employee), bottomSheetType: .some(type))
            }
        } else {
            uiState = uiState.copy(selectedEmployee: .some(employee), bottomSheetType: .some(type))
        }
    }
    
    private func loadEmployeeList() {
        Task {
            uiState = uiState.copy(
                employeeList: [],
                employeeLoading: true,
                employeeError: nil,
                selectedEmployee: .some(nil),
                bottomSheetType: .some(nil),
                currentPage: 0
            )
            await loadEmployees(page: 0)
        }
    }
    
    private func loadMoreEmployees() {
        guard !uiState.employeeLoading && uiState.hasNext else { return }
        Task {
            await loadEmployees(page: uiState.currentPage + 1)
        }
    }
    
    private func loadEmployees(page: Int) async {
        guard let user = try? authPreferences.getStoredUser() else {
            await MainActor.run {
                uiState = uiState.copy(employeeLoading: false, employeeError: StringResources.Employee.userNotFound)
            }
            return
        }
        
        do {
            let result = try await getEmployeeUseCase.execute(
                workspace: "AGENCY",
                organizationId: user.agencyId,
                page: page,
                size: 20
            )
            
            await MainActor.run {
                if page == 0 {
                    uiState = uiState.copy(
                        employeeList: result.employees,
                        employeeLoading: false,
                        employeeError: nil,
                        currentPage: page,
                        hasNext: result.hasNext
                    )
                } else {
                    uiState = uiState.copy(
                        employeeList: uiState.employeeList + result.employees,
                        employeeLoading: false,
                        employeeError: nil,
                        currentPage: page,
                        hasNext: result.hasNext
                    )
                }
            }
        } catch {
            let errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
            messageHandler.showMessage(errorMessage, isError: true)
            await MainActor.run {
                uiState = uiState.copy(
                    employeeLoading: false,
                    employeeError: errorMessage
                )
            }
        }
    }
}

