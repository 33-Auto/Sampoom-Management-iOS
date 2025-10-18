//
//  PartUIState.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import Foundation

struct PartUIState {
    // Part
    let groupList: [PartsGroup]
    let groupLoading: Bool
    let groupError: String?
    
    let selectedCategory: Category?
    
    // Category
    let categoryList: [Category]
    let categoryLoading: Bool
    let categoryError: String?
    
    init(
        groupList: [PartsGroup] = [],
        groupLoading: Bool = false,
        groupError: String? = nil,
        selectedCategory: Category? = nil,
        categoryList: [Category] = [],
        categoryLoading: Bool = false,
        categoryError: String? = nil
    ) {
        self.groupList = groupList
        self.groupLoading = groupLoading
        self.groupError = groupError
        
        self.selectedCategory = selectedCategory
        
        self.categoryList = categoryList
        self.categoryLoading = categoryLoading
        self.categoryError = categoryError
    }
    
    func copy(
        groupList: [PartsGroup]? = nil,
        groupLoading: Bool? = nil,
        groupError: String?? = nil,
        selectedCategory: Category?? = nil,
        categoryList: [Category]? = nil,
        categoryLoading: Bool? = nil,
        categoryError: String?? = nil
    ) -> PartUIState {
        return PartUIState(
            groupList: groupList ?? self.groupList,
            groupLoading: groupLoading ?? self.groupLoading,
            groupError: groupError ?? self.groupError,
            selectedCategory: selectedCategory ?? self.selectedCategory,
            categoryList: categoryList ?? self.categoryList,
            categoryLoading: categoryLoading ?? self.categoryLoading,
            categoryError: categoryError ?? self.categoryError
        )
    }
}

