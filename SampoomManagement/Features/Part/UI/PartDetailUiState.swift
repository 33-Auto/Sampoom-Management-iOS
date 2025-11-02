//
//  PartDetailUiState.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/17/25.
//

import Foundation

struct PartDetailUiState {
    let part: Part?
    let quantity: Int
    let isUpdating: Bool
    let isOutboundSuccess: Bool
    let isCartSuccess: Bool
    
    init(
        part: Part? = nil,
        quantity: Int = 1,
        isUpdating: Bool = false,
        isOutboundSuccess: Bool = false,
        isCartSuccess: Bool = false
    ) {
        self.part = part
        self.quantity = quantity
        self.isUpdating = isUpdating
        self.isOutboundSuccess = isOutboundSuccess
        self.isCartSuccess = isCartSuccess
    }
    
    func copy(
        part: Part?? = nil,
        quantity: Int? = nil,
        isUpdating: Bool? = nil,
        isOutboundSuccess: Bool? = nil,
        isCartSuccess: Bool? = nil
    ) -> PartDetailUiState {
        return PartDetailUiState(
            part: part ?? self.part,
            quantity: quantity ?? self.quantity,
            isUpdating: isUpdating ?? self.isUpdating,
            isOutboundSuccess: isOutboundSuccess ?? self.isOutboundSuccess,
            isCartSuccess: isCartSuccess ?? self.isCartSuccess
        )
    }
}
