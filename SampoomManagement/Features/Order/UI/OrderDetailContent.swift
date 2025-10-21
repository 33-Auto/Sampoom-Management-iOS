//
//  OrderDetailContent.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import SwiftUI
import Combine

struct OrderDetailContent: View {
    let order: [Order]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(order, id: \.orderId) { orderItem in
                    OrderInfoCard(
                        order: orderItem
                    )
                    
                    Text(StringResources.Order.detailOrderItemsTitle)
                        .font(.gmarketTitle2)
                        .fontWeight(.bold)
                        .foregroundColor(Color("Text"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ForEach(orderItem.items, id: \.categoryId) { category in
                        ForEach(category.groups, id: \.groupId) { group in
                            OrderSection(
                                categoryName: category.categoryName,
                                groupName: group.groupName,
                                parts: group.parts
                            )
                        }
                    }
                }
                Spacer()
                    .frame(height: 100)
            }
            .padding(.horizontal, 16)
        }
    }
}

struct OrderInfoCard: View {
    let order: Order
    
    var body: some View {
        VStack(spacing: 0) {
            OrderInfoRow(
                label: StringResources.Order.detailOrderNumber,
                value: order.orderNumber ?? "-"
            )
            
            Divider()
                .padding(.horizontal, 16)
            
            OrderInfoRow(
                label: StringResources.Order.detailOrderDate,
                value: order.createdAt.map { DateFormatter.formatDate($0) } ?? "-"
            )
            
            Divider()
                .padding(.horizontal, 16)
            
            OrderInfoRow(
                label: StringResources.Order.detailOrderAgency,
                value: order.agencyName ?? "-"
            )
            
            Divider()
                .padding(.horizontal, 16)
            
            HStack {
                Text(StringResources.Order.detailOrderStatus)
                    .font(.gmarketBody)
                    .foregroundColor(Color("TextSecondary"))
                
                Spacer()
                
                StatusChip(status: order.status.rawValue)
            }
            .padding(16)
        }
        .background(Color("Background_Card"))
        .cornerRadius(12)
    }
}

struct OrderInfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.gmarketBody)
                .foregroundColor(Color("TextSecondary"))
            
            Spacer()
            
            Text(value)
                .font(.gmarketBody)
                .foregroundColor(Color("Text"))
        }
        .padding(16)
    }
}

struct OrderSection: View {
    let categoryName: String
    let groupName: String
    let parts: [OrderPart]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(categoryName) > \(groupName)")
                .font(.gmarketTitle3)
                .foregroundColor(Color("Text"))
            
            ForEach(parts, id: \.partId) { part in
                OrderPartItem(part: part)
            }
        }
    }
}

struct OrderPartItem: View {
    let part: OrderPart
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(part.name)
                    .font(.gmarketTitle3)
                    .foregroundColor(Color("Text"))
                
                Text(part.code)
                    .font(.gmarketCaption)
                    .foregroundColor(Color("TextSecondary"))
            }
            
            Spacer()
            
            Text("\(part.quantity)")
                .font(.gmarketTitle3)
                .foregroundColor(Color("Text"))
        }
        .padding(16)
        .background(Color("Background_Card"))
        .cornerRadius(12)
    }
}
