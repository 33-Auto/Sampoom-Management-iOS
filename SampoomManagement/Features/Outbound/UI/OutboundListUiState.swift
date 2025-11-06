//
//  OutboundListUiState.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/17/25.
//

import Foundation

struct OutboundListUiState {
    let outboundList: [Outbound]
    let outboundLoading: Bool
    let outboundError: String?
    let selectedOutbound: Outbound?
    let isUpdating: Bool
    let updateError: String?
    let isDeleting: Bool
    let deleteError: String?
    let isOrderSuccess: Bool
    
    init(
        outboundList: [Outbound] = [],
        outboundLoading: Bool = false,
        outboundError: String? = nil,
        selectedOutbound: Outbound? = nil,
        isUpdating: Bool = false,
        updateError: String? = nil,
        isDeleting: Bool = false,
        deleteError: String? = nil,
        isOrderSuccess: Bool = false
    ) {
        self.outboundList = outboundList
        self.outboundLoading = outboundLoading
        self.outboundError = outboundError
        self.selectedOutbound = selectedOutbound
        self.isUpdating = isUpdating
        self.updateError = updateError
        self.isDeleting = isDeleting
        self.deleteError = deleteError
        self.isOrderSuccess = isOrderSuccess
    }
    
    func copy(
        outboundList: [Outbound]? = nil,
        outboundLoading: Bool? = nil,
        outboundError: String?? = nil,
        selectedOutbound: Outbound? = nil,
        isUpdating: Bool? = nil,
        updateError: String?? = nil,
        isDeleting: Bool? = nil,
        deleteError: String?? = nil,
        isOrderSuccess: Bool? = nil
    ) -> OutboundListUiState {
        return OutboundListUiState(
            outboundList: outboundList ?? self.outboundList,
            outboundLoading: outboundLoading ?? self.outboundLoading,
            outboundError: outboundError ?? self.outboundError,
            selectedOutbound: selectedOutbound ?? self.selectedOutbound,
            isUpdating: isUpdating ?? self.isUpdating,
            updateError: updateError ?? self.updateError,
            isDeleting: isDeleting ?? self.isDeleting,
            deleteError: deleteError ?? self.deleteError,
            isOrderSuccess: isOrderSuccess ?? self.isOrderSuccess
        )
    }

    var totalCost: Int {
        outboundList.reduce(0) { acc, category in
            acc + category.groups.reduce(0) { acc2, group in
                acc2 + group.parts.reduce(0) { acc3, part in
                    acc3 + part.subtotal
                }
            }
        }
    }
}
