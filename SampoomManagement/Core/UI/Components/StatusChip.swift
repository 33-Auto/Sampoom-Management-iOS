//
//  StatusChip.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import SwiftUI
import Foundation

/// 주문 상태를 표시하는 칩 컴포넌트
struct StatusChip: View {
    let status: OrderStatus
    
    var body: some View {
        let (text, color) = statusDisplayInfo
        
        Text(text)
            .font(.caption)
            .foregroundColor(color)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color.opacity(0.2))
            .cornerRadius(16)
    }
    
    private var statusDisplayInfo: (text: String, color: Color) {
        switch status {
        case .pending:
            return (StringResources.Order.statusPending, Color(.waitYellow))
        case .confirmed:
            return (StringResources.Order.statusConfirmed, Color(.waitYellow))
        case .shipping:
            return (StringResources.Order.statusShipping, Color(.waitYellow))
        case .delayed:
            return (StringResources.Order.statusDelayed, Color(.waitYellow))
        case .producing:
            return (StringResources.Order.statusProducing, Color(.waitYellow))
        case .arrived:
            return (StringResources.Order.statusArrived, Color(.waitYellow))
        case .completed:
            return (StringResources.Order.statusCompleted, Color(.successGreen))
        case .canceled:
            return (StringResources.Order.statusCanceled, Color(.failRed))
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        StatusChip(status: .pending)
        StatusChip(status: .confirmed)
        StatusChip(status: .shipping)
        StatusChip(status: .arrived)
        StatusChip(status: .completed)
        StatusChip(status: .canceled)
    }
    .padding()
}
