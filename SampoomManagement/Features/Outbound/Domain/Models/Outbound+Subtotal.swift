//
//  Outbound+Subtotal.swift
//  SampoomManagement
//

import Foundation

extension OutboundPart {
    var subtotal: Int { standardCost * quantity }
}


