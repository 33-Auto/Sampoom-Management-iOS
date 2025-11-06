//
//  OrderItem.swift
//  SampoomManagement
//
//  Created by Generated.
//

import SwiftUI

struct OrderItem: View {
    let order: Order
    let onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            HStack(alignment: .center, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(OrderFormatter.buildOrderTitle(order))
                        .font(.gmarketBody)
                        .lineLimit(1)
                        .foregroundColor(.text)
                    Text(order.agencyName ?? "-")
                        .font(.gmarketCaption)
                        .foregroundColor(.textSecondary)
                }
                Spacer(minLength: 12)
                VStack(alignment: .trailing, spacing: 6) {
                    Text(order.createdAt.map { DateFormatterUtil.formatDate($0) } ?? "-")
                        .font(.gmarketCaption)
                        .foregroundColor(.textSecondary)
                    StatusChip(status: order.status)
                    Text(formatWon(order.totalCost))
                        .font(.gmarketBody)
                        .foregroundColor(.text)
                }
            }
            .padding(16)
            .background(Color.backgroundCard)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}


