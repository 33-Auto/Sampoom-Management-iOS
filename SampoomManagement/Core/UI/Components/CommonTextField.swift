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
    @FocusState private var isFocused: Bool
    @Binding var value: String
    
    let placeholder: String
    let type: TextFieldType
    let size: TextFieldSize
    let isError: Bool
    let errorMessage: String?
    let onTextChange: (String) -> Void
    let submitLabel: SubmitLabel
    let onSubmit: () -> Void
    
    init(
        value: Binding<String>,
        placeholder: String,
        type: TextFieldType = .text,
        size: TextFieldSize = .medium,
        isError: Bool = false,
        errorMessage: String? = nil,
        onTextChange: @escaping (String) -> Void = { _ in },
        submitLabel: SubmitLabel = .next,
        onSubmit: @escaping () -> Void = {}
    ) {
        self._value = value
        self.placeholder = placeholder
        self.type = type
        self.size = size
        self.isError = isError
        self.errorMessage = errorMessage
        self.onTextChange = onTextChange
        self.submitLabel = submitLabel
        self.onSubmit = onSubmit
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                // Text Field
                Group {
                    if type == .password && !isPasswordVisible {
                        SecureField(placeholder, text: $value)
                            .submitLabel(submitLabel)
                            .onSubmit { onSubmit() }
                            .textFieldStyle(PlainTextFieldStyle())
                            .focused($isFocused)
                    } else {
                        TextField(placeholder, text: $value)
                            .keyboardType(keyboardType)
                            .textInputAutocapitalization(autocapitalization)
                            .disableAutocorrection(disableAutocorrection)
                            .submitLabel(submitLabel)
                            .onSubmit { onSubmit() }
                            .textFieldStyle(PlainTextFieldStyle())
                            .focused($isFocused)
                    }
                }
                .font(.gmarketBody)
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
            .padding(4)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(effectiveBorderColor, lineWidth: isFocused ? 1.5 : 1)
            )
            
            // Error Message
            if isError, let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.gmarketBody)
                    .foregroundColor(.red)
                    .padding(.leading, 4)
            }
        }
        .onChange(of: value) { _, newValue in
            onTextChange(newValue)
        }
    }
    
    // MARK: - Computed Properties
    private var buttonTextColor: Color {
        // 다크모드 고려한 기본 색상
        switch colorScheme {
        case .dark:
            return value.isEmpty ? .gray : .white
        case .light:
            return value.isEmpty ? .gray : .black
        @unknown default:
            return value.isEmpty ? .gray : .primary
        }
    }
    
    private var buttonBackgroundColor: Color {
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
        // 다크모드 고려한 기본 테두리색
        switch colorScheme {
        case .dark:
            return .gray.opacity(0.4)
        case .light:
            return .gray.opacity(0.4)
        @unknown default:
            return .gray.opacity(0.4)
        }
    }
    
    private var effectiveBorderColor: Color {
        if isError {
            return .red
        }
        if isFocused {
            return .accentColor
        }
        return buttonBorderColor
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


