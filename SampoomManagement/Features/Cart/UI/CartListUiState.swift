//
//  CartListUiState.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import Foundation

struct CartListUiState {
    let cartList: [Cart]
    let cartLoading: Bool
    let selectedCart: Cart?
    let isUpdating: Bool
    let isDeleting: Bool
    let isOrderSuccess: Bool
    let isProcessing: Bool
    let processedOrder: Order?
    
    init(
        cartList: [Cart] = [],
        cartLoading: Bool = false,
        selectedCart: Cart? = nil,
        isUpdating: Bool = false,
        isDeleting: Bool = false,
        isOrderSuccess: Bool = false,
        isProcessing: Bool = false,
        processedOrder: Order? = nil
    ) {
        self.cartList = cartList
        self.cartLoading = cartLoading
        self.selectedCart = selectedCart
        self.isUpdating = isUpdating
        self.isDeleting = isDeleting
        self.isOrderSuccess = isOrderSuccess
        self.isProcessing = isProcessing
        self.processedOrder = processedOrder
    }
    
    func copy(
        cartList: [Cart]? = nil,
        cartLoading: Bool? = nil,
        selectedCart: Cart? = nil,
        isUpdating: Bool? = nil,
        isDeleting: Bool? = nil,
        isOrderSuccess: Bool? = nil,
        isProcessing: Bool? = nil,
        processedOrder: Order? = nil
    ) -> CartListUiState {
        return CartListUiState(
            cartList: cartList ?? self.cartList,
            cartLoading: cartLoading ?? self.cartLoading,
            selectedCart: selectedCart ?? self.selectedCart,
            isUpdating: isUpdating ?? self.isUpdating,
            isDeleting: isDeleting ?? self.isDeleting,
            isOrderSuccess: isOrderSuccess ?? self.isOrderSuccess,
            isProcessing: isProcessing ?? self.isProcessing,
            processedOrder: processedOrder ?? self.processedOrder
        )
    }
}

