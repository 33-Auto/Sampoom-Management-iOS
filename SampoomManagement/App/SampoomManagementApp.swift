//
//  SampoomManagementApp.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import SwiftUI

@main
struct SampoomManagementApp: App {
    
    init() {
        // DI Container 초기화
        _ = DIContainer.shared
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
