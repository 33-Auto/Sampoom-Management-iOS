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
    let cartError: String?
    let selectedCart: Cart?
    let isUpdating: Bool
    let updateError: String?
    let isDeleting: Bool
    let deleteError: String?
    let isOrderSuccess: Bool
    let isProcessing: Bool
    let processError: String?
    let processedOrder: [Order]?
    
    init(
        cartList: [Cart] = [],
        cartLoading: Bool = false,
        cartError: String? = nil,
        selectedCart: Cart? = nil,
        isUpdating: Bool = false,
        updateError: String? = nil,
        isDeleting: Bool = false,
        deleteError: String? = nil,
        isOrderSuccess: Bool = false,
        isProcessing: Bool = false,
        processError: String? = nil,
        processedOrder: [Order]? = nil
    ) {
        self.cartList = cartList
        self.cartLoading = cartLoading
        self.cartError = cartError
        self.selectedCart = selectedCart
        self.isUpdating = isUpdating
        self.updateError = updateError
        self.isDeleting = isDeleting
        self.deleteError = deleteError
        self.isOrderSuccess = isOrderSuccess
        self.isProcessing = isProcessing
        self.processError = processError
        self.processedOrder = processedOrder
    }
    
    func copy(
        cartList: [Cart]? = nil,
        cartLoading: Bool? = nil,
        cartError: String?? = nil,
        selectedCart: Cart? = nil,
        isUpdating: Bool? = nil,
        updateError: String?? = nil,
        isDeleting: Bool? = nil,
        deleteError: String?? = nil,
        isOrderSuccess: Bool? = nil,
        isProcessing: Bool? = nil,
        processError: String?? = nil,
        processedOrder: [Order]?? = nil
    ) -> CartListUiState {
        return CartListUiState(
            cartList: cartList ?? self.cartList,
            cartLoading: cartLoading ?? self.cartLoading,
            cartError: cartError ?? self.cartError,
            selectedCart: selectedCart ?? self.selectedCart,
            isUpdating: isUpdating ?? self.isUpdating,
            updateError: updateError ?? self.updateError,
            isDeleting: isDeleting ?? self.isDeleting,
            deleteError: deleteError ?? self.deleteError,
            isOrderSuccess: isOrderSuccess ?? self.isOrderSuccess,
            isProcessing: isProcessing ?? self.isProcessing,
            processError: processError ?? self.processError,
            processedOrder: processedOrder ?? self.processedOrder
        )
    }
}

