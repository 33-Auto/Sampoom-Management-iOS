//
//  SearchResultView.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/17/25.
//

import SwiftUI

struct SearchResultView: View {
    @ObservedObject var viewModel: SearchViewModel
    @ObservedObject var partDetailViewModel: PartDetailViewModel
    @State private var showBottomSheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.uiState.isSearching {
                loadingView
            } else if let error = viewModel.uiState.searchError {
                errorView(error: error)
            } else if viewModel.uiState.searchResults.isEmpty {
                emptyView
            } else {
                searchResultsList
            }
        }
        .sheet(isPresented: $showBottomSheet) {
            if let selectedPart = viewModel.uiState.selectedPart {
                PartDetailBottomSheetView(viewModel: partDetailViewModel)
                    .onAppear {
                        partDetailViewModel.onEvent(.initialize(selectedPart))
                    }
                    .onDisappear {
                        // 바텀시트가 닫힌 후 성공 메시지를 검색 결과 화면에서 표시
                        partDetailViewModel.showPendingSuccessMessage()
                        partDetailViewModel.clearSuccess()
                        showBottomSheet = false
                        viewModel.onEvent(.dismissBottomSheet)
                    }
                    .presentationDetents([.fraction(0.3)])
                    .presentationDragIndicator(.visible)
                    .presentationBackground(.clear)
            }
        }
        .onChange(of: viewModel.uiState.selectedPart) { _, newValue in
            showBottomSheet = newValue != nil
        }
    }
    
    private var loadingView: some View {
        HStack {
            Spacer()
            ProgressView()
                .scaleEffect(1.5)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func errorView(error: String) -> some View {
        HStack {
            Spacer()
            ErrorView(
                error: error,
                onRetry: {
                    // 검색 재시도는 상위에서 처리
                }
            )
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyView: some View {
        HStack {
            Spacer()
            EmptyView(title: StringResources.SearchParts.emptyMessage)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var searchResultsList: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(Array(viewModel.uiState.searchResults.enumerated()), id: \.element.part.id) { index, searchResult in
                    SearchResultItemCard(
                        searchResult: searchResult,
                        onClick: {
                            viewModel.onEvent(.showBottomSheet(searchResult.part))
                        }
                    )
                    .onAppear {
                        // 마지막에서 3번째 아이템이 보이면 다음 페이지 로드
                        if index >= viewModel.uiState.searchResults.count - 3 {
                            loadMoreIfNeeded()
                        }
                    }
                }
                
                // 무한 스크롤 로딩 인디케이터
                if viewModel.uiState.isLoadingMore {
                    HStack {
                        Spacer()
                        ProgressView()
                            .scaleEffect(0.8)
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    private func loadMoreIfNeeded() {
        // 스크롤이 마지막 아이템 근처에 도달했을 때 다음 페이지 로드
        if viewModel.uiState.hasMorePages && !viewModel.uiState.isLoadingMore {
            viewModel.onEvent(.loadMore)
        }
    }
}

struct SearchResultItemCard: View {
    let searchResult: SearchResult
    let onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(searchResult.categoryName) > \(searchResult.groupName)")
                        .font(.gmarketCaption)
                        .foregroundColor(.textSecondary)
                    
                    Text(searchResult.part.name)
                        .font(.gmarketTitle3)
                        .foregroundColor(.text)
                    
                    Text(searchResult.part.code)
                        .font(.gmarketCaption)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Text("\(searchResult.part.quantity)")
                    .font(.gmarketBody)
                    .foregroundColor(.text)
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.backgroundCard)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
