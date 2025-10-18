//
//  PartListView.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/17/25.
//

import SwiftUI

struct PartListView: View {
    @ObservedObject var viewModel: PartListViewModel
    
    init(
        viewModel: PartListViewModel
    ) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.uiState.partListLoading {
                // 로딩 상태
                Spacer()
                ProgressView()
                Spacer()
            } else if let error = viewModel.uiState.partListError {
                // 에러 상태
                Spacer()
                ErrorView(
                    error: error,
                    onRetry: { viewModel.onEvent(.retryPartList) }
                )
                .frame(height: 200)
                Spacer()
            } else if viewModel.uiState.partList.isEmpty {
                // 빈 상태
                Spacer()
                EmptyView(
                    icon: "tray",
                    title: "부품이 없습니다"
                )
                .frame(height: 200)
                Spacer()
            } else {
                // 부품 리스트
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.uiState.partList, id: \.id) { part in
                            PartListItemCard(part: part)
                        }
                    }
                    .padding(16)
                }
            }
        }
        .navigationTitle("부품")
        .navigationBarTitleDisplayMode(.automatic)
    }
}

struct PartListItemCard: View {
    let part: Part
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(part.name)
                    .font(.gmarketTitle2)
                    .foregroundColor(.primary)
                
                Text(part.code)
                    .font(.gmarketCaption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
                Text("\(part.quantity)")
                    .font(.gmarketTitle2)
                .foregroundColor(.primary)
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color("BackgroundCard"))
        )
    }
}


