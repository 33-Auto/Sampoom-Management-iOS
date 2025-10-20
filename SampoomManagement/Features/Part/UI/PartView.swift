//
//  PartView.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import SwiftUI

struct PartView: View {
    @ObservedObject var viewModel: PartViewModel
    @State private var searchQuery = ""
    
    let onNavigatePartList: (PartsGroup) -> Void
    
    init(
        onNavigatePartList: @escaping (PartsGroup) -> Void,
        viewModel: PartViewModel
    ) {
        self.onNavigatePartList = onNavigatePartList
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Category 선택 제목
                Text("카테고리 선택")
                    .font(.gmarketTitle2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 16)
                 
                // Category 섹션
                categorySection
                
                Spacer()
                    .frame(height: 24)
                
                // 그룹 리스트 섹션
                groupSection
            }
            .padding(.vertical, 16)
        }
        .navigationTitle("부품조회")
        .navigationBarTitleDisplayMode(.automatic)
        .searchable(text: $searchQuery, prompt: "search")
        .background(Color.background)
    }
    
    @ViewBuilder
    private var categorySection: some View {
        if viewModel.uiState.categoryLoading {
            // 로딩 상태
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
            .frame(height: 200)
        } else if let error = viewModel.uiState.categoryError {
            // 에러 상태
            HStack {
                Spacer()
                ErrorView(
                    error: error,
                    onRetry: { viewModel.onEvent(.retryCategories) }
                )
                Spacer()
            }
            .frame(height: 200)
        } else if viewModel.uiState.categoryList.isEmpty {
            // 빈 상태
            HStack {
                Spacer()
                EmptyView(
                    icon: "tray",
                    title: "카테고리가 없습니다"
                )
                Spacer()
            }
            .frame(height: 200)
        } else {
            // 카테고리 그리드
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                ForEach(viewModel.uiState.categoryList, id: \.id) { category in
                    CategoryItem(
                        category: category,
                        isSelected: category.id == viewModel.uiState.selectedCategory?.id,
                        onClick: {
                            viewModel.onEvent(.categorySelected(category))
                        }
                    )
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    @ViewBuilder
    private var groupSection: some View {
        if viewModel.uiState.selectedCategory == nil {
            // 초기 상태: 카테고리 선택 안내
            VStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 32))
                    .foregroundColor(.gray)
                
                Text("카테고리를 선택해주세요")
                    .font(.gmarketBody)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
        } else {
            // 그룹 선택 제목
            Text("그룹 선택")
                .font(.gmarketTitle2)
                .fontWeight(.bold)
                .padding(.horizontal, 16)
            
            // 그룹 리스트
            if viewModel.uiState.groupLoading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .frame(height: 200)
            } else if let error = viewModel.uiState.groupError {
                ErrorView(
                    error: error,
                    onRetry: { viewModel.onEvent(.retryGroups) }
                )
                .frame(height: 200)
            } else if viewModel.uiState.groupList.isEmpty {
                HStack {
                    Spacer()
                    EmptyView(
                        icon: "tray",
                        title: "그룹이 없습니다"
                    )
                    Spacer()
                }
                .frame(height: 200)
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(viewModel.uiState.groupList, id: \.id) { group in
                        PartItemCard(
                            group: group,
                            onClick: { onNavigatePartList(group) }
                        )
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}


// Category 아이템
struct CategoryItem: View {
    let category: Category
    let isSelected: Bool
    let onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            VStack(spacing: 4) {
                Image(categoryIcon(for: category.code))
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(isSelected ? .white : .text)
                
                Text(category.name)
                    .font(.gmarketCaption)
                    .foregroundColor(isSelected ? .white : .text)
            }
            .frame(height: 100)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? .accent : .backgroundCard)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func categoryIcon(for code: String) -> String {
        switch code {
        case "ENG": return "engine"
        case "TRN": return "transmission"
        case "CHS": return "chassis"
        case "BDY": return "body"
        case "TRM": return "trim"
        case "ELE": return "electric"
        default: return "parts"
        }
    }
}

// Part 아이템 카드
struct PartItemCard: View {
    let group: PartsGroup
    let onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            HStack {
                Text(group.name)
                    .font(.gmarketBody)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.backgroundCard))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
