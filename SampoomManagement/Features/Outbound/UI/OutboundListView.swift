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
        .navigationTitle("출고")
        .navigationBarTitleDisplayMode(.automatic)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if !viewModel.uiState.outboundList.isEmpty && 
                   !viewModel.uiState.outboundLoading && 
                   viewModel.uiState.outboundError == nil {
                    Button("출고목록 비우기") {
                        showEmptyOutboundDialog = true
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .background(Color.background)
        .onAppear {
            viewModel.clearSuccess()
            viewModel.bindLabel(error: "오류가 발생했습니다")
            viewModel.onEvent(.loadOutboundList)
        }
        .onChange(of: viewModel.uiState.isOrderSuccess) { oldValue, newValue in
            if newValue {
                Toast.text("출고 주문 성공").show()
                viewModel.clearSuccess()
            }
        }
        .onChange(of: viewModel.uiState.updateError) { oldValue, newValue in
            if let error = newValue {
                Toast.text("수량 업데이트 에러: \(error)").show()
                viewModel.onEvent(.clearUpdateError)
            }
        }
        .onChange(of: viewModel.uiState.deleteError) { oldValue, newValue in
            if let error = newValue {
                Toast.text("삭제 에러: \(error)").show()
                viewModel.onEvent(.clearDeleteError)
            }
        }
        .alert("전체 삭제", isPresented: $showEmptyOutboundDialog) {
            Button("취소", role: .cancel) { }
            Button("확인") {
                viewModel.onEvent(.deleteAllOutbound)
            }
        } message: {
            Text("모든 출고 항목을 삭제하시겠습니까?")
        }
        .alert("출고 주문", isPresented: $showConfirmDialog) {
            Button("취소", role: .cancel) { }
            Button("확인") {
                viewModel.onEvent(.processOutbound)
            }
        } message: {
            Text("선택한 항목들을 출고 주문하시겠습니까?")
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
                    CommonButton("부품 출고처리", backgroundColor: .red, textColor: .white) {
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
            }
            .padding(16)
            
            // 수량 조절
            HStack {
                Text("수량")
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

#Preview {
    OutboundListView(viewModel: OutboundListViewModel(
        getOutboundUseCase: GetOutboundUseCase(repository: MockOutboundRepository()),
        processOutboundUseCase: ProcessOutboundUseCase(repository: MockOutboundRepository()),
        updateOutboundQuantityUseCase: UpdateOutboundQuantityUseCase(repository: MockOutboundRepository()),
        deleteOutboundUseCase: DeleteOutboundUseCase(repository: MockOutboundRepository()),
        deleteAllOutboundUseCase: DeleteAllOutboundUseCase(repository: MockOutboundRepository())
    ))
}

// Preview용 Mock Repository
class MockOutboundRepository: OutboundRepository {
    func getOutboundList() async throws -> OutboundList {
        return OutboundList.empty()
    }
    
    func processOutbound() async throws {}
    func addOutbound(partId: Int, quantity: Int) async throws {}
    func deleteOutbound(outboundId: Int) async throws {}
    func deleteAllOutbound() async throws {}
    func updateOutboundQuantity(outboundId: Int, quantity: Int) async throws {}
}
