//
//  SampoomManagementApp.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import SwiftUI

@main
struct SampoomManagementApp: App {
    // SwiftUI Environment 기반 DI
    private let dependencies = AppDependencies()
    
    init() {
        // 앱 전체 폰트 설정
        setupGlobalFont()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(dependencies: dependencies)
        }
    }
    
    // MARK: - Setup
    
    private func setupGlobalFont() {
        // UIKit 컴포넌트에 대한 기본 폰트 설정
        if let font = UIFont.gmarketSans(size: 16, weight: .medium) {
            UILabel.appearance().font = font
            UITextField.appearance().font = font
            UITextView.appearance().font = font
        }
    }
}
