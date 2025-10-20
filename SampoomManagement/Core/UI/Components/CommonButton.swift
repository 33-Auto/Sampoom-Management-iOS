//
//  CommonButton.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import SwiftUI

// MARK: - Button Types
enum ButtonType {
    case filled            // 채워진 버튼
    case outlined          // 테두리만 있는 버튼
}

// MARK: - Button Sizes
enum ButtonSize {
    case small
    case medium
    case large
    
    var height: CGFloat {
        switch self {
        case .small: return 32
        case .medium: return 44
        case .large: return 52
        }
    }
    
    var font: Font {
        switch self {
        case .small: return .system(size: 14, weight: .medium)
        case .medium: return .system(size: 16, weight: .medium)
        case .large: return .system(size: 18, weight: .semibold)
        }
    }
}

// MARK: - CommonButton
struct CommonButton: View {
    let title: String
    let type: ButtonType
    let size: ButtonSize
    let icon: String?
    let customIcon: String?
    let iconPosition: IconPosition
    let isEnabled: Bool
    let backgroundColor: Color?
    let textColor: Color?
    let borderColor: Color?
    let action: () -> Void
    
    init(
        _ title: String,
        type: ButtonType = .filled,
        size: ButtonSize = .medium,
        icon: String? = nil,
        customIcon: String? = nil,
        iconPosition: IconPosition = .leading,
        isEnabled: Bool = true,
        backgroundColor: Color? = nil,
        textColor: Color? = nil,
        borderColor: Color? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.type = type
        self.size = size
        self.icon = icon
        self.customIcon = customIcon
        self.iconPosition = iconPosition
        self.isEnabled = isEnabled
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.borderColor = borderColor
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let customIcon = customIcon, iconPosition == .leading {
                    Image(customIcon)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: size.height * 0.5, height: size.height * 0.5)
                } else if let icon = icon, iconPosition == .leading {
                    Image(systemName: icon)
                        .font(size.font)
                }
                
                Text(title)
                    .font(.gmarketBody)
                
                if let customIcon = customIcon, iconPosition == .trailing {
                    Image(customIcon)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: size.height * 0.5, height: size.height * 0.5)
                } else if let icon = icon, iconPosition == .trailing {
                    Image(systemName: icon)
                        .font(size.font)
                }
            }
            .frame(height: size.height)
            .frame(maxWidth: .infinity)
            .padding(4)
            .foregroundColor(buttonTextColor)
            .background(buttonBackgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(buttonBorderColor, lineWidth: borderWidth)
            )
            .cornerRadius(16)
        }
        .disabled(!isEnabled)
        .animation(.easeInOut(duration: 0.2), value: isEnabled)
    }
    
    // MARK: - Button Styling
    private var buttonBackgroundColor: Color {
        if !isEnabled {
            return .disable
        }
        
        if let customColor = backgroundColor {
            return customColor
        }
        
        switch type {
        case .filled:
            return Color(.accent) // 기본 보라색
        case .outlined:
            return .clear
        }
    }
    
    private var buttonTextColor: Color {
        if !isEnabled {
            return .textSecondary
        }
        
        if let customColor = textColor {
            return customColor
        }
        
        switch type {
        case .filled:
            return .white
        case .outlined:
            return borderColor ?? .blue
        }
    }
    
    private var buttonBorderColor: Color {
        if !isEnabled {
            return .clear
        }
        
        if let customColor = borderColor {
            return customColor
        }
        
        switch type {
        case .filled:
            return .clear
        case .outlined:
            return .blue
        }
    }
    
    private var borderWidth: CGFloat {
        switch type {
        case .filled:
            return 0
        case .outlined:
            return 1
        }
    }
}

// MARK: - Icon Position
enum IconPosition {
    case leading
    case trailing
}

