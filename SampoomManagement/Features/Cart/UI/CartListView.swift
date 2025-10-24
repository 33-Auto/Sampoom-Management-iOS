//
//  CartListView.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import SwiftUI
import Combine

struct CartListView: View {
    @ObservedObject var viewModel: CartListViewModel
    @State private var showEmptyCartDialog = false
    @State private var showConfirmDialog = false
    
    var body: some View {
        // Precompute simple bindings to reduce type-checking load
        let isOrderSuccess = Binding<Bool>(
            get: { viewModel.uiState.isOrderSuccess },
            set: { _ in }
        )
        let updateError = Binding<Bool>(
            get: { viewModel.uiState.updateError != nil },
            set: { _ in }
        )
        let deleteError = Binding<Bool>(
            get: { viewModel.uiState.deleteError != nil },
            set: { _ in }
        )

        MainNavigationContent(
            shouldShowEmptyButton: shouldShowEmptyButton,
            showEmptyCartDialog: $showEmptyCartDialog,
            showConfirmDialog: $showConfirmDialog,
            isOrderSuccessBinding: isOrderSuccess,
            hasUpdateError: updateError,
            hasDeleteError: deleteError,
            onEmptyAll: { viewModel.onEvent(.deleteAllCart) },
            onProcessOrder: { viewModel.onEvent(.processOrder) },
            onAppear: { viewModel.onEvent(.loadCartList) },
            onClearUpdateError: { viewModel.onEvent(.clearUpdateError) },
            onClearDeleteError: { viewModel.onEvent(.clearDeleteError) },
            cartContent: { AnyView(cartContent) },
            orderResultSheet: { 
                AnyView(
                    Group {
                        if let processedOrder = viewModel.uiState.processedOrder {
                            OrderResultBottomSheet(
                                order: processedOrder,
                                onDismiss: {
                                    viewModel.onEvent(.dismissOrderResult)
                                },
                                viewModel: OrderDetailViewModel(
                                    getOrderDetailUseCase: GetOrderDetailUseCase(repository: OrderRepositoryImpl(api: OrderAPI(networkManager: NetworkManager(authRequestInterceptor: AuthRequestInterceptor(authPreferences: AuthPreferences(), tokenRefreshService: TokenRefreshService(authPreferences: AuthPreferences())))))),
                                    cancelOrderUseCase: CancelOrderUseCase(repository: OrderRepositoryImpl(api: OrderAPI(networkManager: NetworkManager(authRequestInterceptor: AuthRequestInterceptor(authPreferences: AuthPreferences(), tokenRefreshService: TokenRefreshService(authPreferences: AuthPreferences())))))),
                                    receiveOrderUseCase: ReceiveOrderUseCase(repository: OrderRepositoryImpl(api: OrderAPI(networkManager: NetworkManager(authRequestInterceptor: AuthRequestInterceptor(authPreferences: AuthPreferences(), tokenRefreshService: TokenRefreshService(authPreferences: AuthPreferences()))))))
                                )
                            )
                        } else {
                            EmptyView()
                        }
                    }
                )
            },
            viewModel: viewModel
        )
    }
    
    @ViewBuilder
    private var cartContent: some View {
        if viewModel.uiState.cartLoading {
            loadingView
        } else if let error = viewModel.uiState.cartError {
            errorView(error: error)
        } else if viewModel.uiState.cartList.isEmpty {
            emptyView
        } else {
            cartListView
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
                    viewModel.onEvent(.retryCartList)
                }
            )
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyView: some View {
        HStack {
            Spacer()
            EmptyView(title: StringResources.Cart.emptyMessage)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var cartListView: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                LazyVStack(spacing: 16) {
                    CartListContent(
                        categories: viewModel.uiState.cartList,
                        isUpdating: viewModel.uiState.isUpdating,
                        isDeleting: viewModel.uiState.isDeleting,
                        onEvent: { event in
                            viewModel.onEvent(event)
                        }
                    )
                    Spacer()
                        .frame(height: 100)
                }
                .padding(.horizontal, 16)
            }

            orderButton
        }
    }
    
    private var orderButton: some View {
        VStack {
            Spacer()
            CommonButton(StringResources.Cart.processOrder, backgroundColor: .accent, textColor: .white) {
                showConfirmDialog = true
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
    }
    
    private var shouldShowEmptyButton: Bool {
        !viewModel.uiState.cartLoading && 
        viewModel.uiState.cartError == nil && 
        !viewModel.uiState.cartList.isEmpty
    }
    
}

private struct MainNavigationContent: View {
    let shouldShowEmptyButton: Bool
    @Binding var showEmptyCartDialog: Bool
    @Binding var showConfirmDialog: Bool
    let isOrderSuccessBinding: Binding<Bool>
    let hasUpdateError: Binding<Bool>
    let hasDeleteError: Binding<Bool>
    let onEmptyAll: () -> Void
    let onProcessOrder: () -> Void
    let onAppear: () -> Void
    let onClearUpdateError: () -> Void
    let onClearDeleteError: () -> Void
    let cartContent: () -> AnyView
    let orderResultSheet: () -> AnyView
    @ObservedObject var viewModel: CartListViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                cartContent()
            }
            .navigationTitle(StringResources.Cart.title)
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if shouldShowEmptyButton {
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
                    onEmptyAll()
                }
                Button(StringResources.Common.cancel, role: .cancel) { }
            } message: {
                Text(StringResources.Cart.confirmEmptyMessage)
            }
            .alert(StringResources.Cart.confirmProcessTitle, isPresented: $showConfirmDialog) {
                Button(StringResources.Common.ok) {
                    onProcessOrder()
                }
                Button(StringResources.Common.cancel, role: .cancel) { }
            } message: {
                Text(StringResources.Cart.confirmProcessMessage)
            }
            .onAppear {
                onAppear()
            }
            .onChange(of: isOrderSuccessBinding.wrappedValue) { _, newValue in
                if newValue {
                    // handled by parent
                }
            }
            .onChange(of: hasUpdateError.wrappedValue) { _, newValue in
                if newValue {
                    onClearUpdateError()
                }
            }
            .onChange(of: hasDeleteError.wrappedValue) { _, newValue in
                if newValue {
                    onClearDeleteError()
                }
            }
            .sheet(isPresented: Binding<Bool>(
                get: { viewModel.uiState.processedOrder != nil && viewModel.uiState.isOrderSuccess },
                set: { _ in }
            ), onDismiss: {
                viewModel.onEvent(.dismissOrderResult)
            }) {
                orderResultSheet()
            }
        }
    }
}

private struct CartListContent: View {
    let categories: [Cart]
    let isUpdating: Bool
    let isDeleting: Bool
    let onEvent: (CartListUiEvent) -> Void

    var body: some View {
        ForEach(categories, id: \.categoryId) { category in
            ForEach(category.groups, id: \.groupId) { group in
                CartSection(
                    categoryName: category.categoryName,
                    groupName: group.groupName,
                    parts: group.parts,
                    isUpdating: isUpdating,
                    isDeleting: isDeleting,
                    onEvent: onEvent
                )
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
                .accessibilityLabel(StringResources.Common.delete)
                .accessibilityHint(StringResources.Cart.deleteItemHint)
                .accessibilityIdentifier("cart_item_delete_\(part.cartItemId)")
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
