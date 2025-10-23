//
//  SearchUiState.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/17/25.
//

import Foundation

struct SearchUiState {
    let searchResults: [SearchResult]
    let isSearching: Bool
    let searchError: String?
    let selectedPart: Part?
    let currentPage: Int
    let hasMorePages: Bool
    let isLoadingMore: Bool
    
    init(
        searchResults: [SearchResult] = [],
        isSearching: Bool = false,
        searchError: String? = nil,
        selectedPart: Part? = nil,
        currentPage: Int = 0,
        hasMorePages: Bool = true,
        isLoadingMore: Bool = false
    ) {
        self.searchResults = searchResults
        self.isSearching = isSearching
        self.searchError = searchError
        self.selectedPart = selectedPart
        self.currentPage = currentPage
        self.hasMorePages = hasMorePages
        self.isLoadingMore = isLoadingMore
    }
    
    func copy(
        searchResults: [SearchResult]? = nil,
        isSearching: Bool? = nil,
        searchError: String?? = nil,
        selectedPart: Part?? = nil,
        currentPage: Int? = nil,
        hasMorePages: Bool? = nil,
        isLoadingMore: Bool? = nil
    ) -> SearchUiState {
        return SearchUiState(
            searchResults: searchResults ?? self.searchResults,
            isSearching: isSearching ?? self.isSearching,
            searchError: searchError.flatMap { $0 } ?? self.searchError,
            selectedPart: selectedPart.flatMap { $0 } ?? self.selectedPart,
            currentPage: currentPage ?? self.currentPage,
            hasMorePages: hasMorePages ?? self.hasMorePages,
            isLoadingMore: isLoadingMore ?? self.isLoadingMore
        )
    }
}
