//
//  EmployeeListUiState.swift
//  SampoomManagement
//
//  Created by Generated.
//

import Foundation

struct EmployeeListUiState {
    let employeeList: [Employee]
    let employeeLoading: Bool
    let employeeError: String?
    let selectedEmployee: Employee?
    let bottomSheetType: EmployeeBottomSheetType?
    let currentPage: Int
    let hasNext: Bool
    
    init(
        employeeList: [Employee] = [],
        employeeLoading: Bool = false,
        employeeError: String? = nil,
        selectedEmployee: Employee? = nil,
        bottomSheetType: EmployeeBottomSheetType? = nil,
        currentPage: Int = 0,
        hasNext: Bool = true
    ) {
        self.employeeList = employeeList
        self.employeeLoading = employeeLoading
        self.employeeError = employeeError
        self.selectedEmployee = selectedEmployee
        self.bottomSheetType = bottomSheetType
        self.currentPage = currentPage
        self.hasNext = hasNext
    }
    
    func copy(
        employeeList: [Employee]? = nil,
        employeeLoading: Bool? = nil,
        employeeError: String?? = nil,
        selectedEmployee: Employee?? = nil,
        bottomSheetType: EmployeeBottomSheetType?? = nil,
        currentPage: Int? = nil,
        hasNext: Bool? = nil
    ) -> EmployeeListUiState {
        return EmployeeListUiState(
            employeeList: employeeList ?? self.employeeList,
            employeeLoading: employeeLoading ?? self.employeeLoading,
            employeeError: employeeError ?? self.employeeError,
            selectedEmployee: selectedEmployee ?? self.selectedEmployee,
            bottomSheetType: bottomSheetType ?? self.bottomSheetType,
            currentPage: currentPage ?? self.currentPage,
            hasNext: hasNext ?? self.hasNext
        )
    }
}

