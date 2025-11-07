//
//  ValidationResult.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/14/25.
//

import Foundation

enum ValidationResult {
    case success
    case error(String)
    
    var isSuccess: Bool {
        if case .success = self {
            return true
        }
        return false
    }
    
    var errorMessage: String? {
        if case .error(let message) = self {
            return message
        }
        return nil
    }
}


