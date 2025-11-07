//
//  SearchViewModel.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/17/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class SearchViewModel: ObservableObject {
    @Published var uiState = SearchUiState()
    
    private let searchPartsUseCase: SearchPartsUseCase
    let partDetailViewModel: PartDetailViewModel
    private var searchTask: Task<Void, Never>?
    private var currentKeyword: String = ""
    
    init(searchPartsUseCase: SearchPartsUseCase, partDetailViewModel: PartDetailViewModel) {
        self.searchPartsUseCase = searchPartsUseCase
        self.partDetailViewModel = partDetailViewModel
    }
    
    func onEvent(_ event: SearchUiEvent) {
        switch event {
        case .search(let keyword):
            searchParts(keyword: keyword)
        case .loadMore:
            loadMoreResults()
        case .clearSearch:
            clearSearch()
        case .showBottomSheet(let part):
            showBottomSheet(part: part)
        case .dismissBottomSheet:
            dismissBottomSheet()
        }
    }
    
    private func searchParts(keyword: String) {
        // 이전 검색 작업 취소
        searchTask?.cancel()
        
        guard !keyword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            uiState = uiState.copy(
                searchResults: [],
                isSearching: false,
                searchError: nil,
                currentPage: 0,
                hasMorePages: true
            )
            return
        }
        
        currentKeyword = keyword
        uiState = uiState.copy(
            isSearching: true,
            searchError: .some(nil),
            currentPage: 0,
            hasMorePages: true
        )
        
        searchTask = Task {
            // 0.3초 debounce
            try? await Task.sleep(nanoseconds: 300_000_000)
            
            guard !Task.isCancelled else { return }
            
            do {
                let (results, hasMore) = try await searchPartsUseCase.execute(keyword: keyword, page: 0)
                
                await MainActor.run {
                    uiState = uiState.copy(
                        searchResults: results,
                        isSearching: false,
                        searchError: nil,
                        currentPage: 0,
                        hasMorePages: hasMore
                    )
                }
            } catch {
                await MainActor.run {
                    uiState = uiState.copy(
                        searchResults: [],
                        isSearching: false,
                        searchError: error.localizedDescription,
                        currentPage: 0,
                        hasMorePages: false
                    )
                }
            }
        }
    }
    
    private func loadMoreResults() {
        guard !currentKeyword.isEmpty,
              uiState.hasMorePages,
              !uiState.isLoadingMore else { return }
        
        uiState = uiState.copy(isLoadingMore: true)
        
        Task {
            do {
                let nextPage = uiState.currentPage + 1
                let (newResults, hasMore) = try await searchPartsUseCase.execute(keyword: currentKeyword, page: nextPage)
                
                await MainActor.run {
                    let combinedResults = uiState.searchResults + newResults
                    uiState = uiState.copy(
                        searchResults: combinedResults,
                        currentPage: nextPage,
                        hasMorePages: hasMore,
                        isLoadingMore: false
                    )
                }
            } catch {
                await MainActor.run {
                    uiState = uiState.copy(
                        searchError: error.localizedDescription,
                        isLoadingMore: false
                    )
                }
            }
        }
    }
    
    private func clearSearch() {
        searchTask?.cancel()
        currentKeyword = ""
        uiState = uiState.copy(
            searchResults: [],
            isSearching: false,
            searchError: .some(nil),
            currentPage: 0,
            hasMorePages: true
        )
    }
    
    private func showBottomSheet(part: Part) {
        uiState = uiState.copy(selectedPart: part)
        partDetailViewModel.onEvent(.initialize(part))
    }
    
    private func dismissBottomSheet() {
        uiState = uiState.copy(selectedPart: nil)
        partDetailViewModel.onEvent(.dismiss)
    }
}
