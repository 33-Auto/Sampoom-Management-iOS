//
//  OrderResultBottomSheet.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import SwiftUI
import Combine

struct OrderResultBottomSheet: View {
    let order: [Order]
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
                order: viewModel.uiState.orderDetail.isEmpty ? order : viewModel.uiState.orderDetail
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
                if let orderId = order.first?.orderId {
                    viewModel.setOrderId(orderId)
                    viewModel.onEvent(.cancelOrder)
                }
            }
            Button(StringResources.Common.cancel, role: .cancel) { }
        }
        .onAppear {
            if let orderId = order.first?.orderId {
                viewModel.setOrderId(orderId)
            }
        }
        .onChange(of: viewModel.uiState.isProcessingCancelSuccess) { _, newValue in
            if newValue {
                // Toast 대신 Alert 사용하거나 다른 방법으로 처리
                viewModel.clearSuccess()
                viewModel.onEvent(.loadOrder)
            }
        }
        .onChange(of: viewModel.uiState.isProcessingError) { _, newValue in
            if newValue != nil {
                // Toast 대신 Alert 사용하거나 다른 방법으로 처리
                viewModel.onEvent(.clearError)
            }
        }
    }
    
    private var isCancelEnabled: Bool {
        guard order.first?.orderId != nil else { return false }
        if viewModel.uiState.isProcessing { return false }
        let item = viewModel.uiState.orderDetail.first ?? order.first
        guard let status = item?.status else { return false }
        return status != .completed && status != .canceled
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
