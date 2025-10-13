//
//  CommonTextField.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import SwiftUI

// MARK: - TextField Types
enum TextFieldType {
    case email
    case password
    case text
    case number
}

// MARK: - TextField Sizes
enum TextFieldSize {
    case small
    case medium
    case large
    
    var height: CGFloat {
        switch self {
        case .small: return 36
        case .medium: return 44
        case .large: return 52
        }
    }
    
    var font: Font {
        switch self {
        case .small: return .system(size: 14, weight: .regular)
        case .medium: return .system(size: 16, weight: .regular)
        case .large: return .system(size: 18, weight: .regular)
        }
    }
    
    var padding: EdgeInsets {
        switch self {
        case .small: return EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        case .medium: return EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        case .large: return EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20)
        }
    }
}

// MARK: - CommonTextField
struct CommonTextField: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var isPasswordVisible = false
    @State private var text = ""
    
    let placeholder: String
    let type: TextFieldType
    let size: TextFieldSize
    let textColor: Color?
    let backgroundColor: Color?
    let borderColor: Color?
    let onTextChange: (String) -> Void
    
    init(
        placeholder: String,
        type: TextFieldType = .text,
        size: TextFieldSize = .medium,
        textColor: Color? = nil,
        backgroundColor: Color? = nil,
        borderColor: Color? = nil,
        onTextChange: @escaping (String) -> Void = { _ in }
    ) {
        self.placeholder = placeholder
        self.type = type
        self.size = size
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.onTextChange = onTextChange
    }
    
    var body: some View {
        HStack {
            // Text Field
            Group {
                if type == .password && !isPasswordVisible {
                    SecureField(placeholder, text: $text)
                        .textFieldStyle(PlainTextFieldStyle())
                } else {
                    TextField(placeholder, text: $text)
                        .keyboardType(keyboardType)
                        .textInputAutocapitalization(autocapitalization)
                        .disableAutocorrection(disableAutocorrection)
                        .textFieldStyle(PlainTextFieldStyle())
                }
            }
            .font(size.font)
            .foregroundColor(buttonTextColor)
            
            // Password Toggle Button (inside TextField)
            if type == .password {
                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundColor(iconColor)
                        .font(.system(size: 16, weight: .medium))
                }
                .padding(.trailing, 8)
            }
        }
        .padding(size.padding)
        .background(buttonBackgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(buttonBorderColor, lineWidth: 1)
        )
        .onChange(of: text) { oldValue, newValue in
            onTextChange(newValue)
        }
    }
    
    // MARK: - Computed Properties
    private var buttonTextColor: Color {
        if let textColor = textColor {
            return textColor
        }
        
        // 다크모드 고려한 기본 색상
        switch colorScheme {
        case .dark:
            return text.isEmpty ? .gray : .white
        case .light:
            return text.isEmpty ? .gray : .black
        @unknown default:
            return text.isEmpty ? .gray : .primary
        }
    }
    
    private var buttonBackgroundColor: Color {
        if let backgroundColor = backgroundColor {
            return backgroundColor
        }
        
        // 다크모드 고려한 기본 배경색
        switch colorScheme {
        case .dark:
            return Color(red: 0.1, green: 0.1, blue: 0.1) // 매우 어두운 회색
        case .light:
            return .white
        @unknown default:
            return Color(.systemBackground)
        }
    }
    
    private var buttonBorderColor: Color {
        if let borderColor = borderColor {
            return borderColor
        }
        
        // 다크모드 고려한 기본 테두리색
        switch colorScheme {
        case .dark:
            return .gray.opacity(0.3)
        case .light:
            return .gray.opacity(0.3)
        @unknown default:
            return .gray.opacity(0.3)
        }
    }
    
    private var iconColor: Color {
        switch colorScheme {
        case .dark:
            return .gray
        case .light:
            return .gray
        @unknown default:
            return .gray
        }
    }
    
    private var keyboardType: UIKeyboardType {
        switch type {
        case .email:
            return .emailAddress
        case .number:
            return .numberPad
        case .password, .text:
            return .default
        }
    }
    
    private var autocapitalization: TextInputAutocapitalization {
        switch type {
        case .email:
            return .never
        case .password:
            return .never
        case .text:
            return .sentences
        case .number:
            return .never
        }
    }
    
    private var disableAutocorrection: Bool {
        switch type {
        case .email, .password, .number:
            return true
        case .text:
            return false
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        // Email Input (Placeholder)
        CommonTextField(
            placeholder: "이메일 입력",
            type: .email
        ) { text in
            print("Email: \(text)")
        }
        
        // Email Input (Filled)
        CommonTextField(
            placeholder: "이메일 입력",
            type: .email
        ) { text in
            print("Email: \(text)")
        }
        
        // Password Input (Placeholder)
        CommonTextField(
            placeholder: "비밀번호 입력",
            type: .password
        ) { text in
            print("Password: \(text)")
        }
        
        // Password Input (Filled)
        CommonTextField(
            placeholder: "비밀번호 입력",
            type: .password
        ) { text in
            print("Password: \(text)")
        }
        
        // Custom Colors
        CommonTextField(
            placeholder: "커스텀 색상",
            type: .text,
            textColor: .blue,
            backgroundColor: .yellow.opacity(0.1),
            borderColor: .blue
        ) { text in
            print("Custom: \(text)")
        }
    }
    .padding()
    .background(Color(.systemBackground))
}

