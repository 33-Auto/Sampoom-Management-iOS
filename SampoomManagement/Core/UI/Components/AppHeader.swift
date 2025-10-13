//
//  AppHeader.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import SwiftUI

struct AppHeader: View {
    let title: String
    let showBackButton: Bool
    let onBackPressed: (() -> Void)?
    
    init(
        title: String,
        showBackButton: Bool = false,
        onBackPressed: (() -> Void)? = nil
    ) {
        self.title = title
        self.showBackButton = showBackButton
        self.onBackPressed = onBackPressed
    }
    
    var body: some View {
        HStack {
            if showBackButton {
                Button(action: {
                    onBackPressed?()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
            }
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
    }
}

#Preview {
    VStack {
        AppHeader(title: "인벤토리")
        AppHeader(title: "상세보기", showBackButton: true) {
            print("Back pressed")
        }
        Spacer()
    }
}
