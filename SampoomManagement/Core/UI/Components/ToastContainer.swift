//
//  ToastContainer.swift
//  SampoomManagement
//
//  Created by 채상윤 on 11/1/25.
//

import SwiftUI
import Toast
import UIKit

/// 앱 최상단에 Toast를 표시하기 위한 컨테이너 뷰
struct ToastContainer: View {
    @ObservedObject var globalMessageHandler: GlobalMessageHandler
    
    var body: some View {
        Color.clear
            .frame(width: 0, height: 0)
            .onChange(of: globalMessageHandler.message) { _, message in
                if let message = message, !message.isEmpty {
                    DispatchQueue.main.async {
                        showToastOnTopWindow(message)
                    }
                }
            }
    }
    
    private func showToastOnTopWindow(_ message: String) {
        // Toast 라이브러리는 기본적으로 앱의 최상단 window에 표시됩니다
        // RootView에서 호출되므로 자동으로 최상단에 표시됨
        Toast.text(message).show()
    }
}

