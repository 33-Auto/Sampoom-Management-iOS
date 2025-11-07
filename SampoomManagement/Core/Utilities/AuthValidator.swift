//
//  AuthValidator.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/14/25.
//

import Foundation

class AuthValidator {
    // 빈 값 검증
    static func validateNotEmpty(_ value: String, _ label: String) -> ValidationResult {
        if value.trimmingCharacters(in: .whitespaces).isEmpty {
            return .error(StringResources.Auth.fieldRequired(label))
        }
        return .success
    }
    
    // 이메일 형식 검증
    static func validateEmail(_ email: String) -> ValidationResult {
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
        
        if trimmedEmail.isEmpty {
            return .error(StringResources.Auth.emailRequired)
        }
        
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        if !emailPredicate.evaluate(with: trimmedEmail) {
            return .error(StringResources.Auth.emailInvalid)
        }
        
        return .success
    }
    
    // 비밀번호 검증
    static func validatePassword(_ password: String) -> ValidationResult {
        if password.isEmpty {
            return .error(StringResources.Auth.passwordRequired)
        }
        
        if password.count < 8 {
            return .error(StringResources.Auth.passwordTooShort)
        }
        
        // 영문, 숫자 포함 여부 확인
        let hasLetter = password.rangeOfCharacter(from: .letters) != nil
        let hasNumber = password.rangeOfCharacter(from: .decimalDigits) != nil
        
        if !hasLetter || !hasNumber {
            return .error(StringResources.Auth.passwordInvalid)
        }
        
        return .success
    }
    
    // 비밀번호 확인 검증
    static func validatePasswordCheck(_ password: String, _ passwordCheck: String) -> ValidationResult {
        if passwordCheck.isEmpty {
            return .error(StringResources.Auth.passwordCheckRequired)
        }
        
        if password != passwordCheck {
            return .error(StringResources.Auth.passwordCheckMismatch)
        }
        
        return .success
    }
}

