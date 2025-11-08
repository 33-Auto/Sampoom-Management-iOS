//
//  EditEmployeeBottomSheet.swift
//  SampoomManagement
//
//  Created by Generated.
//

import SwiftUI

struct EditEmployeeBottomSheet: View {
    let employee: Employee
    @ObservedObject var viewModel: EditEmployeeViewModel
    let onDismiss: () -> Void
    let onEmployeeUpdated: () -> Void
    @State private var selectedPosition: UserPosition
    
    init(
        employee: Employee,
        viewModel: EditEmployeeViewModel,
        onDismiss: @escaping () -> Void,
        onEmployeeUpdated: @escaping () -> Void = {}
    ) {
        self.employee = employee
        self.viewModel = viewModel
        self.onDismiss = onDismiss
        self.onEmployeeUpdated = onEmployeeUpdated
        _selectedPosition = State(initialValue: employee.position)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Spacer()
                // 직급 선택
                Text(StringResources.Employee.positionLabel)
                    .font(.gmarketBody)
                    .foregroundColor(Color("Text"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                
                Menu {
                    ForEach(UserPosition.allCases, id: \.self) { position in
                        Button(action: {
                            selectedPosition = position
                        }) {
                            Text(position.displayNameKo)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 6)
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedPosition.displayNameKo)
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
                    isEnabled: !viewModel.uiState.isLoading && selectedPosition != employee.position,
                    action: {
                        viewModel.onEvent(.editEmployee(selectedPosition))
                    }
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
        }
        .onAppear {
            viewModel.onEvent(.initialize(employee))
            selectedPosition = employee.position
        }
        .onChange(of: viewModel.uiState.isSuccess) { _, isSuccess in
            if isSuccess {
                viewModel.clearStatus()
                onEmployeeUpdated()
                onDismiss()
            }
        }
    }
}

