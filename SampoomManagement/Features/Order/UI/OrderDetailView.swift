//
//  OrderDetailView.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import SwiftUI

struct OrderDetailView: View {
    let orderId: Int
    @ObservedObject var viewModel: OrderDetailViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showCancelDialog = false
    @State private var showReceiveDialog = false

    // Extracted content to reduce type-checking complexity
    @ViewBuilder
    private var contentSection: some View {
        if viewModel.uiState.orderDetailLoading {
            HStack {
                Spacer()
                ProgressView()
                    .scaleEffect(1.5)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let order = viewModel.uiState.orderDetail {
            OrderDetailContent(
                order: order
            )
        } else {
            HStack {
                Spacer()
                EmptyView(title: StringResources.Order.emptyList)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    @ViewBuilder
    private var bottomButtons: some View {
        if hasOrderDetail {
            HStack(spacing: 16) {
                CommonButton(
                    StringResources.Order.detailOrderCancel,
                    isEnabled: !cannotPerformAction,
                    backgroundColor: Color(.failRed),
                    textColor: .white
                ) {
                    showCancelDialog = true
                }

                CommonButton(
                    StringResources.Order.detailOrderReceive,
                    isEnabled: !cannotPerformAction,
                    backgroundColor: .accent,
                    textColor: .white
                ) {
                    showReceiveDialog = true
                }
            }
            .padding(16)
        }
    }

    private var hasOrderDetail: Bool { viewModel.uiState.orderDetail != nil }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Content
            contentSection

            // Bottom Buttons
            bottomButtons
        }
        .navigationTitle(StringResources.Order.detailTitle)
        .navigationBarTitleDisplayMode(.automatic)
        .background(Color.background)
        .alert(StringResources.Order.detailDialogOrderCancel, isPresented: $showCancelDialog) {
            Button(StringResources.Common.ok) {
                viewModel.onEvent(.cancelOrder)
            }
            Button(StringResources.Common.cancel, role: .cancel) { }
        }
        .alert(StringResources.Order.detailDialogOrderReceive, isPresented: $showReceiveDialog) {
            Button(StringResources.Common.ok) {
                viewModel.onEvent(.receiveOrder)
            }
            Button(StringResources.Common.cancel, role: .cancel) { }
        }
        .onAppear {
            viewModel.onEvent(.loadOrder)
        }
        .onChange(of: viewModel.uiState.isProcessingCancelSuccess) { _, newValue in
            if newValue {
                viewModel.clearSuccess()
            }
        }
        .onChange(of: viewModel.uiState.isProcessingReceiveSuccess) { _, newValue in
            if newValue {
                viewModel.clearSuccess()
            }
        }
    }
    
    private var cannotPerformAction: Bool {
        guard let order = viewModel.uiState.orderDetail else { return true }
        return order.status == .completed || order.status == .canceled || viewModel.uiState.isProcessing
    }
}

