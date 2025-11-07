//
//  PartListView.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/17/25.
//

import SwiftUI

struct PartListView: View {
    @ObservedObject var viewModel: PartListViewModel
    @State private var showBottomSheet = false
    let dependencies: AppDependencies
    
    init(
        viewModel: PartListViewModel,
        dependencies: AppDependencies
    ) {
        self.viewModel = viewModel
        self.dependencies = dependencies
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.uiState.partListLoading {
                // 로딩 상태
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
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
                    title: StringResources.Part.emptyPart
                )
                .frame(height: 200)
                Spacer()
            } else {
                // 부품 리스트
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.uiState.partList, id: \.id) { part in
                            PartListItemCard(
                                part: part,
                                onClick: {
                                    viewModel.onEvent(.showBottomSheet(part))
                                    showBottomSheet = true
                                }
                            )
                        }
                    }
                    .padding(16)
                }
            }
        }
        .navigationTitle(StringResources.Tabs.parts)
        .navigationBarTitleDisplayMode(.automatic)
        .background(Color.background)
        .sheet(isPresented: $showBottomSheet) {
            if let selectedPart = viewModel.uiState.selectedPart {
                let detailViewModel = dependencies.makePartDetailViewModel()
                PartDetailBottomSheetView(viewModel: detailViewModel)
                    .onAppear {
                        detailViewModel.onEvent(.initialize(selectedPart))
                    }
                    .onDisappear {
                        // 바텀시트가 닫힌 후 성공 메시지를 부품 리스트 화면에서 표시
                        detailViewModel.showPendingSuccessMessage()
                        detailViewModel.clearSuccess()
                        showBottomSheet = false
                        viewModel.onEvent(.dismissBottomSheet)
                    }
                    .presentationDetents([.fraction(0.3)])
                    .presentationDragIndicator(.visible)
                    .presentationBackground(.clear)
            }
        }
    }
}

struct PartListItemCard: View {
    let part: Part
    let onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(part.name)
                        .font(.gmarketTitle3)
                        .foregroundColor(.text)
                    
                    Text(part.code)
                        .font(.gmarketCaption)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(formatWon(part.standardCost))
                        .font(.gmarketBody)
                        .foregroundColor(.text)
                    Text("\(part.quantity)")
                        .font(.gmarketCaption)
                        .foregroundColor(.textSecondary)
                }
                
                Image(systemName: "chevron.right")
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



