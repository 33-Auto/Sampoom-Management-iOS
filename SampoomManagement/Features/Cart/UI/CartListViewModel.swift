//
//  CartListViewModel.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class CartListViewModel: ObservableObject {
    @Published var uiState = CartListUiState()
    
    private let getCartUseCase: GetCartUseCase
    private let updateCartQuantityUseCase: UpdateCartQuantityUseCase
    private let deleteCartUseCase: DeleteCartUseCase
    private let deleteAllCartUseCase: DeleteAllCartUseCase
    private let createOrderUseCase: CreateOrderUseCase
    private let globalMessageHandler: GlobalMessageHandler
    
    init(
        getCartUseCase: GetCartUseCase,
        updateCartQuantityUseCase: UpdateCartQuantityUseCase,
        deleteCartUseCase: DeleteCartUseCase,
        deleteAllCartUseCase: DeleteAllCartUseCase,
        createOrderUseCase: CreateOrderUseCase,
        globalMessageHandler: GlobalMessageHandler
    ) {
        self.getCartUseCase = getCartUseCase
        self.updateCartQuantityUseCase = updateCartQuantityUseCase
        self.deleteCartUseCase = deleteCartUseCase
        self.deleteAllCartUseCase = deleteAllCartUseCase
        self.createOrderUseCase = createOrderUseCase
        self.globalMessageHandler = globalMessageHandler
    }
    
    func onEvent(_ event: CartListUiEvent) {
        switch event {
        case .loadCartList:
            loadCartList()
        case .retryCartList:
            loadCartList()
        case .processOrder:
            processOrder()
        case .updateQuantity(let cartItemId, let quantity):
            updateQuantity(cartItemId: cartItemId, quantity: quantity)
        case .deleteCart(let cartItemId):
            deleteCart(cartItemId: cartItemId)
        case .deleteAllCart:
            deleteAllCart()
        case .dismissOrderResult:
            uiState = uiState.copy(isOrderSuccess: false, processedOrder: nil)
        }
    }
    
    private func loadCartList() {
        Task {
            await MainActor.run {
                uiState = uiState.copy(cartLoading: true)
            }
            
            do {
                let cartList = try await getCartUseCase.execute() 
                
                await MainActor.run {
                    uiState = uiState.copy(
                        cartList: cartList.items,
                        cartLoading: false
                    )
                }
            } catch {
                let errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
                globalMessageHandler.showMessage(errorMessage, isError: true)
                await MainActor.run {
                    uiState = uiState.copy(cartLoading: false)
                }
            }
        }
    }
    
    private func processOrder() {
        guard !uiState.isProcessing else { return }
        Task {
            await MainActor.run {
                uiState = uiState.copy(isProcessing: true)
            }
            do {
                let cartList = CartList(items: uiState.cartList)
                let order = try await createOrderUseCase.execute(cartList: cartList)
                await MainActor.run {
                    uiState = uiState.copy(
                        isOrderSuccess: true,
                        isProcessing: false,
                        processedOrder: order
                    )
                }
                globalMessageHandler.showMessage(StringResources.Cart.orderSuccess, isError: false)
                
                // 로컬 상태 먼저 업데이트 (즉시 UI 반영)
                await MainActor.run {
                    removeAllFromLocalList()
                }
                
                // 서버 삭제 완료 후 재조회
                do {
                    try await deleteAllCartUseCase.execute()
                    loadCartList() // 주문 후 장바구니 새로고침
                } catch {
                    let errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
                    globalMessageHandler.showMessage(errorMessage, isError: true)
                    loadCartList() // 에러 발생 시에도 재조회하여 롤백
                }
            } catch {
                let errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
                globalMessageHandler.showMessage(errorMessage, isError: true)
                await MainActor.run {
                    uiState = uiState.copy(isProcessing: false)
                }
            }
        }
    }
    
    private func updateQuantity(cartItemId: Int, quantity: Int) {
        // 1. 로컬 상태 먼저 업데이트 (즉시 UI 반영)
        updateLocalQuantity(cartItemId: cartItemId, quantity: quantity)
        
        // 2. 백그라운드에서 서버 동기화
        Task {
            await MainActor.run {
                uiState = uiState.copy(isUpdating: true)
            }
            
            do {
                try await updateCartQuantityUseCase.execute(cartItemId: cartItemId, quantity: quantity)
                await MainActor.run {
                    uiState = uiState.copy(isUpdating: false)
                }
            } catch {
                // 3. 실패 시 에러 표시 후 롤백
                let errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
                globalMessageHandler.showMessage(errorMessage, isError: true)
                await MainActor.run {
                    uiState = uiState.copy(isUpdating: false)
                }
                loadCartList() // 에러 표시 후 백그라운드에서 롤백
            }
        }
    }
    
    private func updateLocalQuantity(cartItemId: Int, quantity: Int) {
        let updatedList = uiState.cartList.map { category in
            Cart(
                categoryId: category.categoryId,
                categoryName: category.categoryName,
                groups: category.groups.map { group in
                    CartGroup(
                        groupId: group.groupId,
                        groupName: group.groupName,
                        parts: group.parts.map { part in
                            if part.cartItemId == cartItemId {
                                CartPart(
                                    cartItemId: part.cartItemId,
                                    partId: part.partId,
                                    code: part.code,
                                    name: part.name,
                                    quantity: quantity,
                                    standardCost: part.standardCost
                                )
                            } else {
                                part
                            }
                        }
                    )
                }
            )
        }
        uiState = uiState.copy(cartList: updatedList)
    }
    
    private func deleteCart(cartItemId: Int) {
        // 1. 로컬 상태 먼저 업데이트 (즉시 UI 반영)
        removeFromLocalList(cartItemId: cartItemId)
        
        // 2. 백그라운드에서 서버 동기화
        Task {
            await MainActor.run {
                uiState = uiState.copy(isDeleting: true)
            }
            
            do {
                try await deleteCartUseCase.execute(cartItemId: cartItemId)
                await MainActor.run {
                    uiState = uiState.copy(isDeleting: false)
                }
            } catch {
                // 3. 실패 시 에러 표시 후 롤백
                let errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
                globalMessageHandler.showMessage(errorMessage, isError: true)
                await MainActor.run {
                    uiState = uiState.copy(isDeleting: false)
                }
                loadCartList() // 에러 표시 후 백그라운드에서 롤백
            }
        }
    }
    
    private func removeFromLocalList(cartItemId: Int) {
        let updatedList = uiState.cartList.compactMap { category in
            let updatedGroups = category.groups.compactMap { group in
                let filteredParts = group.parts.filter { $0.cartItemId != cartItemId }
                return filteredParts.isEmpty ? nil : CartGroup(
                    groupId: group.groupId,
                    groupName: group.groupName,
                    parts: filteredParts
                )
            }
            return updatedGroups.isEmpty ? nil : Cart(
                categoryId: category.categoryId,
                categoryName: category.categoryName,
                groups: updatedGroups
            )
        }
        uiState = uiState.copy(cartList: updatedList)
    }
    
    private func deleteAllCart() {
        // 1. 로컬 상태 먼저 업데이트 (즉시 UI 반영)
        removeAllFromLocalList()
        
        // 2. 백그라운드에서 서버 동기화
        Task {
            await MainActor.run {
                uiState = uiState.copy(isDeleting: true)
            }
            
            do {
                try await deleteAllCartUseCase.execute()
                await MainActor.run {
                    uiState = uiState.copy(isDeleting: false)
                }
            } catch {
                // 3. 실패 시 에러 표시 후 롤백
                let errorMessage = (error as? NetworkError)?.errorDescription ?? error.localizedDescription
                globalMessageHandler.showMessage(errorMessage, isError: true)
                await MainActor.run {
                    uiState = uiState.copy(isDeleting: false)
                }
                loadCartList() // 에러 표시 후 백그라운드에서 롤백
            }
        }
    }
    
    private func removeAllFromLocalList() {
        uiState = uiState.copy(cartList: [])
    }
    
    func clearSuccess() {
        uiState = uiState.copy(isOrderSuccess: false)
    }
}

