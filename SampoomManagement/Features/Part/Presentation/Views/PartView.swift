//
//  PartView.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import SwiftUI

struct PartView: View {
    @EnvironmentObject var viewModel: PartViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                headerView
                contentView
            }
            .navigationBarHidden(true)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("인벤토리")
                .font(.title2)
                .fontWeight(.bold)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
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
        VStack {
            Spacer()
            ProgressView()
                .scaleEffect(1.2)
            Text("로딩 중...")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 8)
            Spacer()
        }
    }
    
    private func errorView(error: String) -> some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.red)
            
            Text("오류가 발생했습니다")
                .font(.headline)
                .foregroundColor(.red)
            
            Text(error)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button("다시 시도") {
                viewModel.refreshPart()
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
    }
    
    private var emptyView: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "tray")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("인벤토리가 비어있습니다")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
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
