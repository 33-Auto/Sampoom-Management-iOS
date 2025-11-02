//
//  GlobalMessageHandler.swift
//  SampoomManagement
//
//  Created by 채상윤 on 11/1/25.
//

import Foundation
import SwiftUI
import Combine

/// 전역 에러 메시지 핸들러
class GlobalMessageHandler: ObservableObject {
    @Published var message: String?
    @Published var isError: Bool = false
    
    static let shared = GlobalMessageHandler()
    
    private init() {}
    
    func showMessage(_ message: String, isError: Bool = false) {
        DispatchQueue.main.async { [weak self] in
            self?.isError = isError
            self?.message = message
            // 메시지를 표시한 후 잠시 후 nil로 설정하여 같은 메시지도 다시 표시할 수 있도록 함
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self?.message = nil
            }
        }
    }
}

