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
    let status: String // 임시로 String 사용
    
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
        switch status.lowercased() {
        case "pending":
            return ("승인대기", Color(.waitYellow))
        case "completed":
            return ("입고완료", Color(.successGreen))
        case "canceled":
            return ("주문취소", Color(.failRed))
        default:
            return ("승인대기", Color(.waitYellow))
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        StatusChip(status: "pending")
        StatusChip(status: "completed")
        StatusChip(status: "canceled")
    }
    .padding()
}
