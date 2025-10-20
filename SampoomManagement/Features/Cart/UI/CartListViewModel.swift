//
//  CartListViewModel.swift
//  SampoomManagement
//
//  Created by AI Assistant on 10/20/25.
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
    // TODO: ProcessOrderUseCase 구현 후 주입
    
    private var errorLabel: String = ""
    
    init(
        getCartUseCase: GetCartUseCase,
        updateCartQuantityUseCase: UpdateCartQuantityUseCase,
        deleteCartUseCase: DeleteCartUseCase,
        deleteAllCartUseCase: DeleteAllCartUseCase
    ) {
        self.getCartUseCase = getCartUseCase
        self.updateCartQuantityUseCase = updateCartQuantityUseCase
        self.deleteCartUseCase = deleteCartUseCase
        self.deleteAllCartUseCase = deleteAllCartUseCase
    }
    
    func bindLabel(error: String) {
        errorLabel = error
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
        case .clearUpdateError:
            uiState = uiState.copy(updateError: nil)
        case .clearDeleteError:
            uiState = uiState.copy(deleteError: nil)
        }
    }
    
    private func loadCartList() {
        Task {
            uiState = uiState.copy(cartLoading: true, cartError: nil)
            
            do {
                let cartList = try await getCartUseCase.execute()
                
                uiState = uiState.copy(
                    cartList: cartList.items,
                    cartLoading: false,
                    cartError: nil
                )
            } catch {
                uiState = uiState.copy(
                    cartLoading: false,
                    cartError: error.localizedDescription
                )
            }
            print("CartListViewModel - loadCartList: \(uiState)")
        }
    }
    
    // TODO: 주문 생성 UseCase 구현 후 수정
    private func processOrder() {
        Task {
            // Placeholder implementation
            print("CartListViewModel - processOrder called")
            // TODO: ProcessOrderUseCase 구현 후 사용
        }
    }
    
    private func updateQuantity(cartItemId: Int, quantity: Int) {
        // 1. 로컬 상태 먼저 업데이트 (즉시 UI 반영)
        updateLocalQuantity(cartItemId: cartItemId, quantity: quantity)
        
        // 2. 백그라운드에서 서버 동기화
        Task {
            uiState = uiState.copy(isUpdating: true, updateError: nil)
            
            do {
                try await updateCartQuantityUseCase.execute(cartItemId: cartItemId, quantity: quantity)
                uiState = uiState.copy(isUpdating: false)
                print("CartListViewModel - updateQuantity success: \(uiState)")
            } catch {
                // 3. 실패 시 원래 상태로 롤백하고 에러 표시
                loadCartList() // 서버에서 최신 상태 가져와서 롤백
                uiState = uiState.copy(
                    isUpdating: false,
                    updateError: error.localizedDescription
                )
                print("CartListViewModel - updateQuantity error: \(error)")
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
                                    quantity: quantity
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
            uiState = uiState.copy(isDeleting: true, deleteError: nil)
            
            do {
                try await deleteCartUseCase.execute(cartItemId: cartItemId)
                uiState = uiState.copy(isDeleting: false)
                print("CartListViewModel - deleteCart success: \(uiState)")
            } catch {
                // 3. 실패 시 원래 상태로 롤백하고 에러 표시
                loadCartList() // 서버에서 최신 상태 가져와서 롤백
                uiState = uiState.copy(
                    isDeleting: false,
                    deleteError: error.localizedDescription
                )
                print("CartListViewModel - deleteCart error: \(error)")
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
            uiState = uiState.copy(isDeleting: true, deleteError: nil)
            
            do {
                try await deleteAllCartUseCase.execute()
                uiState = uiState.copy(isDeleting: false)
                print("CartListViewModel - deleteAllCart success: \(uiState)")
            } catch {
                // 3. 실패 시 원래 상태로 롤백하고 에러 표시
                loadCartList() // 서버에서 최신 상태 가져와서 롤백
                uiState = uiState.copy(
                    isDeleting: false,
                    deleteError: error.localizedDescription
                )
                print("CartListViewModel - deleteAllCart error: \(error)")
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

