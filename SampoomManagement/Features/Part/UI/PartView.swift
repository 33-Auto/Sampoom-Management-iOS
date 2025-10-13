//
//  PartView.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import SwiftUI

struct PartView: View {
    @EnvironmentObject var viewModel: PartViewModel
    @State var searchString = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                contentView
            }
            .navigationBarTitle(Text("부품"))
            .searchable(text: $searchString)
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.uiState.loading {
            loadingView
        } else if let error = viewModel.uiState.error {
            errorView(error: error)
        } else if viewModel.uiState.partList.isEmpty {
            emptyView
        } else {
            listView
        }
    }
    
    private var loadingView: some View {
        LoadingView()
    }
    
    private func errorView(error: String) -> some View {
        ErrorView(error: error) {
            viewModel.refreshPart()
        }
    }
    
    private var emptyView: some View {
        EmptyStateView(
            icon: "tray",
            title: "인벤토리가 비어있습니다"
        )
    }
    
    private var listView: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(viewModel.uiState.partList) { part in
                    PartItemView(part: part)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
}
