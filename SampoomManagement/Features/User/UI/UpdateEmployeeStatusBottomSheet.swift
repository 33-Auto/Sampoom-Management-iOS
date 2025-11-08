//
//  UpdateEmployeeStatusBottomSheet.swift
//  SampoomManagement
//
//  Created by Generated.
//

import SwiftUI

struct UpdateEmployeeStatusBottomSheet: View {
    let employee: Employee
    @ObservedObject var viewModel: UpdateEmployeeStatusViewModel
    let onDismiss: () -> Void
    let onStatusUpdated: (Employee) -> Void
    @State private var selectedStatus: EmployeeStatus
    
    init(
        employee: Employee,
        viewModel: UpdateEmployeeStatusViewModel,
        onDismiss: @escaping () -> Void,
        onStatusUpdated: @escaping (Employee) -> Void = { _ in }
    ) {
        self.employee = employee
        self.viewModel = viewModel
        self.onDismiss = onDismiss
        self.onStatusUpdated = onStatusUpdated
        _selectedStatus = State(initialValue: employee.employeeStatus)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Spacer()
                Text(StringResources.Employee.statusLabel)
                    .font(.gmarketBody)
                    .foregroundColor(Color("Text"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                
                Menu {
                    ForEach(EmployeeStatus.allCases, id: \.self) { status in
                        Button(action: {
                            selectedStatus = status
                        }) {
                            Text(status.displayNameKo)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 6)
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedStatus.displayNameKo)
                            .font(.gmarketBody)
                            .foregroundColor(Color("Text"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
                    .contentShape(Rectangle())
                }
                .padding(.horizontal, 16)
                
                Spacer()
                
                CommonButton(
                    StringResources.Common.confirm,
                    type: .filled,
                    isEnabled: !viewModel.uiState.isLoading && selectedStatus != employee.employeeStatus,
                    action: {
                        viewModel.onEvent(.editEmployeeStatus(selectedStatus))
                    }
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
        }
        .onAppear {
            viewModel.bindLabel(
                error: StringResources.Common.error,
                editEmployee: StringResources.Employee.editStatusEdited
            )
            viewModel.onEvent(.initialize(employee))
            selectedStatus = employee.employeeStatus
        }
        .onChange(of: viewModel.uiState.isSuccess) { _, isSuccess in
            if isSuccess, let updatedEmployee = viewModel.uiState.employee {
                viewModel.clearStatus()
                onStatusUpdated(updatedEmployee)
                onDismiss()
            }
        }
    }
}


