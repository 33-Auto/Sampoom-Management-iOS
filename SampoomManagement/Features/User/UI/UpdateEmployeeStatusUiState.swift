//
//  UpdateEmployeeStatusUiState.swift
//  SampoomManagement
//
//  Created by Generated.
//

import Foundation

struct UpdateEmployeeStatusUiState {
    let employee: Employee?
    let isLoading: Bool
    let error: String?
    let isSuccess: Bool
    
    init(
        employee: Employee? = nil,
        isLoading: Bool = false,
        error: String? = nil,
        isSuccess: Bool = false
    ) {
        self.employee = employee
        self.isLoading = isLoading
        self.error = error
        self.isSuccess = isSuccess
    }
    
    func copy(
        employee: Employee?? = nil,
        isLoading: Bool? = nil,
        error: String?? = nil,
        isSuccess: Bool? = nil
    ) -> UpdateEmployeeStatusUiState {
        return UpdateEmployeeStatusUiState(
            employee: employee ?? self.employee,
            isLoading: isLoading ?? self.isLoading,
            error: error ?? self.error,
            isSuccess: isSuccess ?? self.isSuccess
        )
    }
}


