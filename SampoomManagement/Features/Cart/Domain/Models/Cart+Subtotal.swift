//
//  Cart+Subtotal.swift
//  SampoomManagement
//
//  Adds per-item subtotal computation for cart.
//

import Foundation

extension CartPart {
    var subtotal: Int { standardCost * quantity }
}


