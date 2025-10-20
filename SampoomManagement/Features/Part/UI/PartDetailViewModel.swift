//
//  PartDetailViewModel.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/17/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class PartDetailViewModel: ObservableObject {
    @Published var uiState = PartDetailUiState()
    
    private let addOutboundUseCase: AddOutboundUseCase
    private let addCartUseCase: AddCartUseCase
    
    init(addOutboundUseCase: AddOutboundUseCase, addCartUseCase: AddCartUseCase) {
        self.addOutboundUseCase = addOutboundUseCase
        self.addCartUseCase = addCartUseCase
    }
    
    func onEvent(_ event: PartDetailUiEvent) {
        switch event {
        case .initialize(let part):
            uiState = uiState.copy(
                part: part,
                quantity: 1,
                isUpdating: false,
                updateError: nil,
                isOutboundSuccess: false,
                isCartSuccess: false
            )
        case .increaseQuantity:
            let currentQuantity = uiState.quantity
            uiState = uiState.copy(quantity: currentQuantity + 1)
        case .decreaseQuantity:
            let currentQuantity = uiState.quantity
            uiState = uiState.copy(quantity: max(1, currentQuantity - 1))
        case .setQuantity(let quantity):
            if quantity > 0 {
                uiState = uiState.copy(quantity: quantity)
            }
        case .addToOutbound(let partId, let quantity):
            let part = uiState.part
            if part != nil {
                addToOutbound(partId: partId, quantity: quantity)
            }
        case .addToCart(let partId, let quantity):
            let part = uiState.part
            if part != nil {
                addToCart(partId: partId, quantity: quantity)
            }
        case .clearError:
            uiState = uiState.copy(updateError: .some(nil))
        case .dismiss:
            uiState = uiState.copy(
                part: .some(nil),
                quantity: 1,
                updateError: .some(nil)
            )
        }
    }
    
    private func addToOutbound(partId: Int, quantity: Int) {
        Task {
            await MainActor.run {
                uiState = uiState.copy(isUpdating: true, updateError: nil)
            }
            
            do {
                try await addOutboundUseCase.execute(partId: partId, quantity: quantity)
                
                await MainActor.run {
                    uiState = uiState.copy(isUpdating: false, isOutboundSuccess: true)
                }
                print("PartDetailViewModel - addToOutbound success: \(uiState)")
            } catch {
                await MainActor.run {
                    uiState = uiState.copy(
                        isUpdating: false,
                        updateError: error.localizedDescription
                    )
                }
                print("PartDetailViewModel - addToOutbound error: \(error)")
            }
        }
    }
    
    private func addToCart(partId: Int, quantity: Int) {
        Task {
            await MainActor.run {
                uiState = uiState.copy(isUpdating: true, updateError: nil)
            }
            
            do {
                try await addCartUseCase.execute(partId: partId, quantity: quantity)
                
                await MainActor.run {
                    uiState = uiState.copy(isUpdating: false, isCartSuccess: true)
                }
                print("PartDetailViewModel - addToCart success: \(uiState)")
            } catch {
                await MainActor.run {
                    uiState = uiState.copy(
                        isUpdating: false,
                        updateError: error.localizedDescription
                    )
                }
                print("PartDetailViewModel - addToCart error: \(error)")
            }
        }
    }
    
    func clearSuccess() {
        uiState = uiState.copy(isOutboundSuccess: false, isCartSuccess: false)
    }
}
