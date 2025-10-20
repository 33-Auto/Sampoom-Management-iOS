//
//  OutboundListUiEvent.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/17/25.
//

import Foundation

enum OutboundListUiEvent {
    case loadOutboundList
    case retryOutboundList
    case processOutbound
    case updateQuantity(outboundId: Int, quantity: Int)
    case deleteOutbound(outboundId: Int)
    case deleteAllOutbound
    case clearUpdateError
    case clearDeleteError
}
