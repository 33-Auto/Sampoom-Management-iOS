//
//  Font+Extension.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/15/25.
//

import SwiftUI

extension Font {
    // MARK: - GmarketSans Font
    
    enum GmarketSansWeight {
        case light
        case medium
        case bold
        
        var name: String {
            switch self {
            case .light: return "GmarketSansLight"
            case .medium: return "GmarketSansMedium"
            case .bold: return "GmarketSansBold"
            }
        }
    }
    
    /// GmarketSans 커스텀 폰트
    static func gmarketSans(size: CGFloat, weight: GmarketSansWeight = .medium) -> Font {
        return .custom(weight.name, size: size)
    }
    
    // MARK: - GmarketSans Semantic Fonts
    
    /// 큰 타이틀 (40pt, Medium) - 매우 큰 제목
    static var gmarketLargeTitle: Font {
        return .gmarketSans(size: 40, weight: .medium)
    }
    
    /// 타이틀 (32pt, Medium) - 화면 제목
    static var gmarketTitle: Font {
        return .gmarketSans(size: 32, weight: .medium)
    }
    
    /// 타이틀 2 (24pt, Medium) - 섹션 제목
    static var gmarketTitle2: Font {
        return .gmarketSans(size: 24, weight: .medium)
    }
    
    /// 타이틀 3 (20pt, Medium) - 작은 제목
    static var gmarketTitle3: Font {
        return .gmarketSans(size: 20, weight: .medium)
    }
    
    /// 헤드라인 (18pt, Medium) - 강조 텍스트
    static var gmarketHeadline: Font {
        return .gmarketSans(size: 18, weight: .medium)
    }
    
    /// 본문 (16pt, Medium) - 기본 본문
    static var gmarketBody: Font {
        return .gmarketSans(size: 16, weight: .medium)
    }
    
    /// 서브헤드 (14pt, Medium) - 작은 본문
    static var gmarketSubheadline: Font {
        return .gmarketSans(size: 14, weight: .medium)
    }
    
    /// 캡션 (13pt, Medium) - 설명 텍스트
    static var gmarketCaption: Font {
        return .gmarketSans(size: 13, weight: .medium)
    }
    
    /// 작은 캡션 (12pt, Medium) - 매우 작은 텍스트
    static var gmarketCaption2: Font {
        return .gmarketSans(size: 12, weight: .medium)
    }
    
    // MARK: - Bold Variants (필요시 사용)
    
    /// 타이틀 Bold (32pt, Bold)
    static var gmarketTitleBold: Font {
        return .gmarketSans(size: 32, weight: .bold)
    }
    
    /// 헤드라인 Bold (18pt, Bold)
    static var gmarketHeadlineBold: Font {
        return .gmarketSans(size: 18, weight: .bold)
    }
}

// MARK: - UIFont Extension (UIKit 사용 시)
extension UIFont {
    static func gmarketSans(size: CGFloat, weight: Font.GmarketSansWeight) -> UIFont? {
        return UIFont(name: weight.name, size: size)
    }
}

