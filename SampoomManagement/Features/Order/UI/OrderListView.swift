//
//  OrderListView.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import SwiftUI
import Combine

struct OrderListView: View {
    @ObservedObject var viewModel: OrderListViewModel
    let onNavigateOrderDetail: (Int) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Content
            if viewModel.uiState.orderLoading {
                HStack {
                    Spacer()
                    ProgressView()
                        .scaleEffect(1.5)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.uiState.orderError {
                HStack {
                    Spacer()
                    ErrorView(
                        error: error,
                        onRetry: {
                            viewModel.onEvent(.retryOrderList)
                        }
                    )
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.uiState.orderList.isEmpty {
                HStack {
                    Spacer()
                    EmptyView(title: StringResources.Order.emptyList)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.uiState.orderList, id: \.orderId) { order in
                            OrderItemCard(
                                order: order,
                                onClick: {
                                    print("📱 OrderItemCard clicked: orderId = \(order.orderId)")
                                    onNavigateOrderDetail(order.orderId)
                                }
                            )
                        }
                        Spacer()
                            .frame(height: 100)
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
        .navigationTitle(StringResources.Order.title)
        .navigationBarTitleDisplayMode(.automatic)
        .background(Color.background)
        .onAppear {
            viewModel.onEvent(.loadOrderList)
        }
    }
    
}


struct OrderItemCard: View {
    let order: Order
    let onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(OrderFormatter.buildOrderTitle(order))
                        .font(.gmarketBody)
                        .foregroundColor(Color("Text"))
                        .lineLimit(1)
                    
                    Text(order.agencyName ?? "-")
                        .font(.gmarketCaption)
                        .foregroundColor(Color("TextSecondary"))
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 6) {
                    Text(order.createdAt.map { DateFormatter.formatDate($0) } ?? "-")
                        .font(.gmarketCaption)
                        .foregroundColor(Color("TextSecondary"))
                    
                    StatusChip(status: order.status.rawValue)
                }
            }
            .padding(16)
        }
        .buttonStyle(PlainButtonStyle())
        .background(Color("Background_Card"))
        .cornerRadius(12)
    }
}
