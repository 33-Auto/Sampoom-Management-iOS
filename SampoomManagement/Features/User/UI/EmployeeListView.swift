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
    let onNavigateBack: () -> Void
    @State private var showEditBottomSheet = false
    
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
        .sheet(isPresented: $showEditBottomSheet) {
            if let selectedEmployee = viewModel.uiState.selectedEmployee {
                EditEmployeeBottomSheet(
                    employee: selectedEmployee,
                    viewModel: editEmployeeViewModel,
                    onDismiss: {
                        showEditBottomSheet = false
                    },
                    onEmployeeUpdated: {
                        viewModel.onEvent(.loadEmployeeList)
                    }
                )
                .presentationDetents([.fraction(0.3)])
                .presentationDragIndicator(.visible)
                .onDisappear {
                    showEditBottomSheet = false
                    viewModel.onEvent(.dismissBottomSheet)
                }
            }
        }
        .onChange(of: viewModel.uiState.selectedEmployee) { _, newValue in
            showEditBottomSheet = newValue != nil
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
                    onEditClick: {
                        viewModel.onEvent(.showBottomSheet(employee))
                        showEditBottomSheet = true
                    },
                    onDeleteClick: {
                        // TODO: Implement delete
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
    let onEditClick: () -> Void
    let onDeleteClick: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(employee.userName)
                .font(.gmarketTitle3)
                .foregroundColor(.text)
            
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
            
            if let startedAt = employee.startedAt, !startedAt.isEmpty {
                HStack {
                    Text(StringResources.Employee.startedAt)
                        .font(.gmarketBody)
                        .foregroundColor(.textSecondary)
                    Spacer()
                    Text(DateFormatterUtil.formatDate(startedAt))
                        .font(.gmarketBody)
                        .foregroundColor(.textSecondary)
                }
            }
            
            HStack(spacing: 8) {
                CommonButton(
                    StringResources.Employee.delete,
                    type: .outlined,
                    backgroundColor: .failRed,
                    textColor: .white,
                    borderColor: .failRed,
                    action: onDeleteClick
                )
                
                CommonButton(
                    StringResources.Employee.edit,
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

