//
//  EmployeeListView.swift
//  SampoomManagement
//
//  Created by Generated.
//

import SwiftUI

struct EmployeeListView: View {
    @ObservedObject var viewModel: EmployeeListViewModel
    @ObservedObject var editEmployeeViewModel: EditEmployeeViewModel
    @ObservedObject var updateEmployeeStatusViewModel: UpdateEmployeeStatusViewModel
    let onNavigateBack: () -> Void
    @State private var showBottomSheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    if viewModel.uiState.employeeLoading && viewModel.uiState.employeeList.isEmpty {
                        loadingView
                    } else if let error = viewModel.uiState.employeeError, viewModel.uiState.employeeList.isEmpty {
                        errorView(error: error)
                    } else if viewModel.uiState.employeeList.isEmpty {
                        emptyView
                    } else {
                        employeeListView
                    }
                }
                .padding(16)
            }
        }
        .navigationTitle(StringResources.Employee.title)
        .navigationBarTitleDisplayMode(.large)
        .background(Color.background)
        .refreshable {
            viewModel.onEvent(.loadEmployeeList)
        }
        .sheet(isPresented: $showBottomSheet) {
            if let selectedEmployee = viewModel.uiState.selectedEmployee,
               let bottomSheetType = viewModel.uiState.bottomSheetType {
                switch bottomSheetType {
                case .edit:
                    EditEmployeeBottomSheet(
                        employee: selectedEmployee,
                        viewModel: editEmployeeViewModel,
                        onDismiss: {
                            showBottomSheet = false
                            viewModel.onEvent(.dismissBottomSheet)
                        },
                        onEmployeeUpdated: {
                            viewModel.onEvent(.loadEmployeeList)
                        }
                    )
                    .presentationDetents([.fraction(0.3)])
                    .presentationDragIndicator(.visible)
                case .status:
                    UpdateEmployeeStatusBottomSheet(
                        employee: selectedEmployee,
                        viewModel: updateEmployeeStatusViewModel,
                        onDismiss: {
                            showBottomSheet = false
                            viewModel.onEvent(.dismissBottomSheet)
                        },
                        onStatusUpdated: { _ in
                            viewModel.onEvent(.loadEmployeeList)
                        }
                    )
                    .presentationDetents([.fraction(0.3)])
                    .presentationDragIndicator(.visible)
                }
            }
        }
        .onChange(of: viewModel.uiState.selectedEmployee) { _, newValue in
            showBottomSheet = newValue != nil
        }
        .onChange(of: viewModel.uiState.bottomSheetType) { _, newValue in
            showBottomSheet = newValue != nil
        }
    }
    
    private var loadingView: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
        }
        .frame(maxWidth: .infinity, minHeight: 200)
    }
    
    private func errorView(error: String) -> some View {
        VStack(spacing: 16) {
            Text(error)
                .font(.gmarketBody)
                .foregroundColor(.red)
            Button(StringResources.Common.retry) {
                viewModel.onEvent(.retryEmployeeList)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 200)
    }
    
    private var emptyView: some View {
        VStack {
            EmptyView(title: StringResources.Employee.emptyEmployee)
        }
        .frame(maxWidth: .infinity, minHeight: 200)
    }
    
    private var employeeListView: some View {
        LazyVStack(spacing: 16) {
            ForEach(viewModel.uiState.employeeList, id: \.userId) { employee in
                EmployeeListItemCard(
                    employee: employee,
                    onStatusClick: {
                        viewModel.onEvent(.showStatusBottomSheet(employee))
                        showBottomSheet = true
                    },
                    onEditClick: {
                        viewModel.onEvent(.showEditBottomSheet(employee))
                        showBottomSheet = true
                    }
                )
            }
            
            if viewModel.uiState.hasNext && !viewModel.uiState.employeeLoading {
                Button(StringResources.Common.loadMore) {
                    viewModel.onEvent(.loadMore)
                }
                .padding()
            }
            
            if viewModel.uiState.employeeLoading {
                ProgressView()
                    .padding()
            }
        }
    }
}

struct EmployeeListItemCard: View {
    let employee: Employee
    let onStatusClick: () -> Void
    let onEditClick: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(employee.userName)
                    .font(.gmarketTitle3)
                    .foregroundColor(.text)
                Spacer()
                Text(employeeStatusToKorean(employee.status))
                    .font(.gmarketBody)
                    .foregroundColor(.text)
            }
            
            Text(employee.position.displayNameKo)
                .font(.gmarketBody)
                .foregroundColor(.textSecondary)
            
            HStack {
                Text(StringResources.Employee.email)
                    .font(.gmarketBody)
                    .foregroundColor(.textSecondary)
                Spacer()
                Text(employee.email)
                    .font(.gmarketBody)
                    .foregroundColor(.textSecondary)
            }
            
            HStack {
                Text(StringResources.Employee.createdAt)
                    .font(.gmarketBody)
                    .foregroundColor(.textSecondary)
                Spacer()
                Text(createdAtText)
                    .font(.gmarketBody)
                    .foregroundColor(.textSecondary)
            }
            
            HStack {
                Text(StringResources.Employee.startedAt)
                    .font(.gmarketBody)
                    .foregroundColor(.textSecondary)
                Spacer()
                Text(startedAtText)
                    .font(.gmarketBody)
                    .foregroundColor(.textSecondary)
            }
            
            HStack {
                Text(StringResources.Employee.endedAt)
                    .font(.gmarketBody)
                    .foregroundColor(.textSecondary)
                Spacer()
                Text(endedAtText)
                    .font(.gmarketBody)
                    .foregroundColor(.textSecondary)
            }
            
            HStack {
                Text(StringResources.Employee.deletedAt)
                    .font(.gmarketBody)
                    .foregroundColor(.textSecondary)
                Spacer()
                Text(deletedAtText)
                    .font(.gmarketBody)
                    .foregroundColor(.textSecondary)
            }
            
            HStack(spacing: 8) {
                CommonButton(
                    StringResources.Employee.statusEdit,
                    type: .outlined,
                    action: onStatusClick
                )
                
                CommonButton(
                    StringResources.Employee.positionEdit,
                    type: .filled,
                    action: onEditClick
                )
            }
        }
        .padding(16)
        .background(Color.backgroundCard)
        .cornerRadius(12)
    }
}

private extension EmployeeListItemCard {
    var createdAtText: String {
        guard let createdAt = employee.createdAt, !createdAt.isEmpty else {
            return StringResources.Common.slash
        }
        return DateFormatterUtil.formatDate(createdAt)
    }
    
    var startedAtText: String {
        guard let startedAt = employee.startedAt, !startedAt.isEmpty else {
            return StringResources.Common.slash
        }
        return DateFormatterUtil.formatDate(startedAt)
    }
    
    var endedAtText: String {
        guard let endedAt = employee.endedAt, !endedAt.isEmpty else {
            return StringResources.Common.slash
        }
        return DateFormatterUtil.formatDate(endedAt)
    }
    
    var deletedAtText: String {
        guard let deletedAt = employee.deletedAt, !deletedAt.isEmpty else {
            return StringResources.Common.slash
        }
        return DateFormatterUtil.formatDate(deletedAt)
    }
}

