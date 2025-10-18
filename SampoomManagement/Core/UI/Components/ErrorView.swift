//
//  ErrorView.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import SwiftUI

struct ErrorView: View {
    let error: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
//            Image(systemName: "exclamationmark.triangle")
//                .font(.system(size: 48))
//                .foregroundColor(.red)
            
            Text("오류가 발생했습니다")
                .font(.gmarketHeadline)
                .foregroundColor(.red)
            
//            Text(error)
//                .font(.caption)
//                .foregroundColor(.secondary)
//                .multilineTextAlignment(.center)
//                .padding(.horizontal, 32)
            
            Button {
                onRetry()
            } label: {
                Text("다시 시도")
                    .font(.gmarketCaption)
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
    }
}

#Preview {
    ErrorView(error: "네트워크 연결을 확인해주세요") {
        print("Retry tapped")
    }
}
