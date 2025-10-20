//
//  OutboundListView.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/17/25.
//

import SwiftUI
import Toast

struct OutboundListView: View {
    @ObservedObject var viewModel: OutboundListViewModel
    @State private var showEmptyOutboundDialog = false
    @State private var showConfirmDialog = false
    
    init(viewModel: OutboundListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // 메인 콘텐츠
            mainContentSection
        }
        .navigationTitle(StringResources.Outbound.title)
        .navigationBarTitleDisplayMode(.automatic)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if !viewModel.uiState.outboundList.isEmpty && 
                   !viewModel.uiState.outboundLoading && 
                   viewModel.uiState.outboundError == nil {
                    Button(StringResources.Outbound.emptyAll) {
                        showEmptyOutboundDialog = true
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .background(Color.background)
        .onAppear {
            viewModel.clearSuccess()
            viewModel.onEvent(.loadOutboundList)
        }
        .onChange(of: viewModel.uiState.isOrderSuccess) { _, newValue in
            if newValue {
                Toast.text(StringResources.Outbound.orderSuccess).show()
                viewModel.clearSuccess()
            }
        }
        .onChange(of: viewModel.uiState.updateError) { _, newValue in
            if let error = newValue {
                Toast.text("\(StringResources.Outbound.updateQuantityError): \(error)").show()
                viewModel.onEvent(.clearUpdateError)
            }
        }
        .onChange(of: viewModel.uiState.deleteError) { _, newValue in
            if let error = newValue {
                Toast.text("\(StringResources.Outbound.deleteError): \(error)").show()
                viewModel.onEvent(.clearDeleteError)
            }
        }
        .alert(StringResources.Outbound.confirmEmptyTitle, isPresented: $showEmptyOutboundDialog) {
            Button(StringResources.Common.cancel, role: .cancel) { }
            Button(StringResources.Common.ok) {
                viewModel.onEvent(.deleteAllOutbound)
            }
        } message: {
            Text(StringResources.Outbound.confirmEmptyMessage)
        }
        .alert(StringResources.Outbound.confirmProcessTitle, isPresented: $showConfirmDialog) {
            Button(StringResources.Common.cancel, role: .cancel) { }
            Button(StringResources.Common.ok) {
                viewModel.onEvent(.processOutbound)
            }
        } message: {
            Text(StringResources.Outbound.confirmProcessMessage)
        }
    }
    
    @ViewBuilder
    private var mainContentSection: some View {
        if viewModel.uiState.outboundLoading {
            // 로딩 상태
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let error = viewModel.uiState.outboundError {
            // 에러 상태
            HStack {
                Spacer()
                ErrorView(
                    error: error,
                    onRetry: { viewModel.onEvent(.retryOutboundList) }
                )
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if viewModel.uiState.outboundList.isEmpty {
            // 빈 상태
            HStack {
                Spacer()
                EmptyView(
                    icon: "tray",
                    title: "출고 항목이 없습니다"
                )
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            // 출고 리스트
            ZStack {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.uiState.outboundList, id: \.categoryId) { category in
                            ForEach(category.groups, id: \.groupId) { group in
                                OutboundSection(
                                    categoryName: category.categoryName,
                                    groupName: group.groupName,
                                    parts: group.parts,
                                    isUpdating: viewModel.uiState.isUpdating,
                                    isDeleting: viewModel.uiState.isDeleting,
                                    onEvent: viewModel.onEvent
                                )
                            }
                        }
                        
                        Spacer()
                            .frame(height: 100)
                    }
                    .padding(.horizontal, 16)
                }
                
                // 출고 주문 버튼
                VStack {
                    Spacer()
                    CommonButton(StringResources.Outbound.processOrder, backgroundColor: .red, textColor: .white) {
                        showConfirmDialog = true
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
            }
        }
    }
}

struct OutboundSection: View {
    let categoryName: String
    let groupName: String
    let parts: [OutboundPart]
    let isUpdating: Bool
    let isDeleting: Bool
    let onEvent: (OutboundListUiEvent) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(categoryName) > \(groupName)")
                .font(.gmarketTitle3)
                .foregroundColor(.text)
            
            ForEach(parts, id: \.outboundId) { part in
                OutboundPartItem(
                    part: part,
                    isUpdating: isUpdating,
                    isDeleting: isDeleting,
                    onEvent: onEvent
                )
            }
        }
    }
}

struct OutboundPartItem: View {
    let part: OutboundPart
    let isUpdating: Bool
    let isDeleting: Bool
    let onEvent: (OutboundListUiEvent) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // 부품 정보
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
                
                CommonButton("", icon: "trash", backgroundColor: .clear, textColor: .red) {
                    onEvent(.deleteOutbound(outboundId: part.outboundId))
                }
                .frame(width: 44, height: 44)
                .disabled(isDeleting)
                .accessibilityLabel(StringResources.Common.delete)
                .accessibilityHint(StringResources.Outbound.deleteItemHint)
                .accessibilityIdentifier("outbound_item_delete_\(part.outboundId)")
            }
            .padding(16)
            
            // 수량 조절
            HStack {
                Text(StringResources.Part.quantity)
                    .font(.gmarketBody)
                    .foregroundColor(.text)
                
                Spacer()
                
                HStack(spacing: 8) {
                    CommonButton("-", backgroundColor: .disable, textColor: .text) {
                        if part.quantity > 1 {
                            onEvent(.updateQuantity(outboundId: part.outboundId, quantity: part.quantity - 1))
                        }
                    }
                    .frame(width: 50, height: 44)
                    .disabled(isUpdating || part.quantity <= 1)
                    
                    Text("\(part.quantity)")
                        .font(.gmarketTitle3)
                        .foregroundColor(.text)
                        .frame(width: 100)
                        .multilineTextAlignment(.center)
                    
                    CommonButton("+", backgroundColor: .disable, textColor: .text) {
                        onEvent(.updateQuantity(outboundId: part.outboundId, quantity: part.quantity + 1))
                    }
                    .frame(width: 50, height: 44)
                    .disabled(isUpdating)
                }
            }
            .padding(16)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.backgroundCard)
        )
    }
}

