//
//  OrderResultBottomSheet.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import SwiftUI
import Combine

struct OrderResultBottomSheet: View {
    let order: Order
    let onDismiss: () -> Void
    @ObservedObject var viewModel: OrderDetailViewModel
    
    @State private var showCancelDialog = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 16)
            
            // Header
            OrderCompleteHeader()
            
            Spacer()
                .frame(height: 16)
            
            OrderDetailContent(
                order: viewModel.uiState.orderDetail ?? order
            )
            
            Spacer()
                .frame(height: 16)
            
            // Bottom Button
            CommonButton(
                StringResources.Order.detailOrderCancel,
                isEnabled: isCancelEnabled,
                backgroundColor: Color(.failRed),
                textColor: .white
            ) {
                showCancelDialog = true
            }
            .padding(.horizontal, 16)
            
            Spacer()
                .frame(height: 16)
        }
        .background(Color("Background"))
        .alert(StringResources.Order.detailDialogOrderCancel, isPresented: $showCancelDialog) {
            Button(StringResources.Common.ok) {
                viewModel.setOrderId(order.orderId)
                viewModel.onEvent(.cancelOrder)
            }
            Button(StringResources.Common.cancel, role: .cancel) { }
        }
        .onAppear {
            viewModel.setOrderId(order.orderId)
        }
        .onChange(of: viewModel.uiState.isProcessingCancelSuccess) { _, newValue in
            if newValue {
                viewModel.clearSuccess()
                viewModel.onEvent(.loadOrder)
                onDismiss()
            }
        }
    }
    
    private var isCancelEnabled: Bool {
        if viewModel.uiState.isProcessing { return false }
        let currentOrder = viewModel.uiState.orderDetail ?? order
        return currentOrder.status != .completed && currentOrder.status != .canceled
    }
}

struct OrderCompleteHeader: View {
    var body: some View {
        HStack {
            Spacer()
            
            HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.successGreen)
                        .font(.title2)
                
                Text(StringResources.Cart.orderSuccess)
                    .font(.gmarketTitle2)
                    .fontWeight(.bold)
                    .foregroundColor(Color("Text"))
            }
            
            Spacer()
        }
        .padding(.vertical, 16)
    }
}
