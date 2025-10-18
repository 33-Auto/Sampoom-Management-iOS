//
//  PartViewModel.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class PartViewModel: ObservableObject {
    @Published var uiState = PartUIState()

    private let getCategoryUseCase: GetCategoryUseCase
    private let getGroupUseCase: GetGroupUseCase
    
    init(
        getCategoryUseCase: GetCategoryUseCase,
        getGroupUseCase: GetGroupUseCase
    ) {
        self.getCategoryUseCase = getCategoryUseCase
        self.getGroupUseCase = getGroupUseCase
        loadCategory()
    }
    
    func onEvent(_ event: PartUiEvent) {
        switch event {
        case .loadCategories:
            loadCategory()
        case .categorySelected(let category):
            selectCategory(category)
        case .retryCategories:
            loadCategory()
        case .retryGroups:
            loadGroup()
        }
    }
    
    private func loadCategory() {
        Task {
            uiState = uiState.copy(categoryLoading: true, categoryError: nil)
            
            do {
                let categoryList = try await getCategoryUseCase.execute()
                uiState = uiState.copy(
                    categoryList: categoryList.items,
                    categoryLoading: false,
                    categoryError: nil
                )
            } catch {
                uiState = uiState.copy(
                    categoryLoading: false,
                    categoryError: error.localizedDescription
                )
            }
            print("PartViewModel - loadCategory: \(uiState)")
        }
    }
    
    private func selectCategory(_ category: Category) {
        Task {
            uiState = uiState.copy(selectedCategory: category)
            await loadGroup(categoryId: category.id)
        }
    }
    
    private func loadGroup(categoryId: Int) async {
        Task {
            uiState = uiState.copy(groupLoading: true, groupError: nil)
            
            do {
                let groupList = try await getGroupUseCase.execute(categoryId: categoryId)
                uiState = uiState.copy(
                    groupList: groupList.items,
                    groupLoading: false,
                    groupError: nil
                )
            } catch {
                uiState = uiState.copy(
                    groupLoading: false,
                    groupError: error.localizedDescription
                )
            }
            print("PartViewModel - loadGroup: \(uiState)")
        }
    }
    
    private func loadGroup() {
        guard let selectedCategory = uiState.selectedCategory else { return }
        Task {
            await loadGroup(categoryId: selectedCategory.id)
        }
    }
}

