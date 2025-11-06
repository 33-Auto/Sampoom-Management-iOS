//
//  Order+Totals.swift
//  SampoomManagement
//
//  Adds per-item subtotal and order total cost computations.
//

import Foundation

extension OrderPart {
    var subtotal: Int { standardCost * quantity }
}

extension Order {
    var totalCost: Int {
        items.reduce(0) { acc, category in
            acc + category.groups.reduce(0) { acc2, group in
                acc2 + group.parts.reduce(0) { acc3, part in
                    acc3 + part.subtotal
                }
            }
        }
    }
}


