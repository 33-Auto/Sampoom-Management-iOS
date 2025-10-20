//
//  CartListView.swift
//  SampoomManagement
//
//  Created by AI Assistant on 10/20/25.
//

import SwiftUI
import Toast

struct CartListView: View {
    @ObservedObject var viewModel: CartListViewModel
    @State private var showEmptyCartDialog = false
    @State private var showConfirmDialog = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Content
            if viewModel.uiState.cartLoading {
                Spacer()
                ProgressView()
                    .scaleEffect(1.5)
                Spacer()
            } else if let error = viewModel.uiState.cartError {
                HStack {
                    Spacer()
                    ErrorView(
                        error: error,
                        onRetry: {
                            viewModel.onEvent(.retryCartList)
                        }
                    )
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.uiState.cartList.isEmpty {
                HStack {
                    Spacer()
                    EmptyView(title: StringResources.Cart.emptyMessage)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ZStack(alignment: .bottom) {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.uiState.cartList.indices, id: \.self) { categoryIndex in
                                let category = viewModel.uiState.cartList[categoryIndex]
                                ForEach(category.groups.indices, id: \.self) { groupIndex in
                                    let group = category.groups[groupIndex]
                                    CartSection(
                                        categoryName: category.categoryName,
                                        groupName: group.groupName,
                                        parts: group.parts,
                                        isUpdating: viewModel.uiState.isUpdating,
                                        isDeleting: viewModel.uiState.isDeleting,
                                        onEvent: { event in
                                            viewModel.onEvent(event)
                                        }
                                    )
                                }
                            }
                            Spacer()
                                .frame(height: 100)
                        }
                        .padding(.horizontal, 16)
                    }
                    
                    // 주문하기 버튼
                    VStack {
                        Spacer()
                        CommonButton(StringResources.Cart.processOrder, backgroundColor: .accentColor, textColor: .white) {
                            showConfirmDialog = true
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                    }
                }
            }
        }
        .navigationTitle(StringResources.Cart.title)
        .navigationBarTitleDisplayMode(.automatic)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if !viewModel.uiState.cartLoading && viewModel.uiState.cartError == nil && !viewModel.uiState.cartList.isEmpty {
                    Button(StringResources.Cart.emptyAll) {
                        showEmptyCartDialog = true
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .background(Color.background)
        .alert(StringResources.Cart.confirmEmptyTitle, isPresented: $showEmptyCartDialog) {
            Button(StringResources.Common.ok) {
                viewModel.onEvent(.deleteAllCart)
            }
            Button(StringResources.Common.cancel, role: .cancel) { }
        } message: {
            Text(StringResources.Cart.confirmEmptyMessage)
        }
        .alert(StringResources.Cart.confirmProcessTitle, isPresented: $showConfirmDialog) {
            Button(StringResources.Common.ok) {
                viewModel.onEvent(.processOrder)
            }
            Button(StringResources.Common.cancel, role: .cancel) { }
        } message: {
            Text(StringResources.Cart.confirmProcessMessage)
        }
        .onAppear {
            viewModel.onEvent(.loadCartList)
        }
        .onChange(of: viewModel.uiState.isOrderSuccess) { oldValue, newValue in
            if newValue {
                Toast.text(StringResources.Cart.orderSuccess).show()
                viewModel.clearSuccess()
            }
        }
        .onChange(of: viewModel.uiState.updateError) { oldValue, newValue in
            if let error = newValue {
                Toast.text("\(StringResources.Cart.updateQuantityError): \(error)").show()
                viewModel.onEvent(.clearUpdateError)
            }
        }
        .onChange(of: viewModel.uiState.deleteError) { oldValue, newValue in
            if let error = newValue {
                Toast.text("\(StringResources.Cart.deleteError): \(error)").show()
                viewModel.onEvent(.clearDeleteError)
            }
        }
    }
}

struct CartSection: View {
    let categoryName: String
    let groupName: String
    let parts: [CartPart]
    let isUpdating: Bool
    let isDeleting: Bool
    let onEvent: (CartListUiEvent) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(categoryName) > \(groupName)")
                .font(.gmarketTitle3)
                .foregroundColor(.text)
            
            ForEach(parts, id: \.cartItemId) { part in
                CartPartItem(
                    part: part,
                    isUpdating: isUpdating,
                    isDeleting: isDeleting,
                    onEvent: onEvent
                )
            }
        }
    }
}

struct CartPartItem: View {
    let part: CartPart
    let isUpdating: Bool
    let isDeleting: Bool
    let onEvent: (CartListUiEvent) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
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
                    onEvent(.deleteCart(cartItemId: part.cartItemId))
                }
                .frame(width: 44, height: 44)
                .disabled(isDeleting)
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
                            onEvent(.updateQuantity(cartItemId: part.cartItemId, quantity: part.quantity - 1))
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
                        onEvent(.updateQuantity(cartItemId: part.cartItemId, quantity: part.quantity + 1))
                    }
                    .frame(width: 50, height: 44)
                    .disabled(isUpdating)
                }
            }
            .padding(16)
        }
        .background(Color.backgroundCard)
        .cornerRadius(12)
    }
}
}
