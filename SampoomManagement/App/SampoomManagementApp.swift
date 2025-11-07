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
        // 앱 전체 백그라운드 설정
        setupGlobalBackground()
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
    
    private func setupGlobalBackground() {
        // UIKit 컴포넌트에 대한 기본 백그라운드 설정
        UITableView.appearance().backgroundColor = UIColor.clear
        UICollectionView.appearance().backgroundColor = UIColor.clear
        UINavigationBar.appearance().backgroundColor = UIColor.clear
        UITabBar.appearance().backgroundColor = UIColor.clear
        
        // 시스템 배경색 설정
        if let backgroundColor = UIColor(named: "Background") {
            UINavigationBar.appearance().barTintColor = backgroundColor
            UITabBar.appearance().barTintColor = backgroundColor
        }
    }
}
