//
//  DateFormatterUtil.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/20/25.
//

import Foundation

/// 날짜 포맷팅 유틸리티
struct DateFormatterUtil {
    
    /// ISO 8601 날짜 문자열을 로컬 날짜 형식으로 변환
    /// - Parameter dateString: ISO 8601 형식의 날짜 문자열
    /// - Returns: 변환된 날짜 문자열 (yyyy-MM-dd) 또는 원본 문자열 (실패 시)
    static func formatDate(_ dateString: String) -> String {
        // ISO 8601 형식 파싱
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]
        
        // 로컬 날짜 형식
        let outputFormatter = Foundation.DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        outputFormatter.locale = Locale(identifier: "ko_KR")
        
        guard let date = isoFormatter.date(from: dateString) else {
            // ISO 8601 파싱 실패 시 다른 형식 시도
            let alternativeFormatters = [
                "yyyy-MM-dd'T'HH:mm:ss",
                "yyyy-MM-dd'T'HH:mm:ss.SSS",
                "yyyy-MM-dd'T'HH:mm:ss'Z'",
                "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            ]
            
            for format in alternativeFormatters {
                let formatter = Foundation.DateFormatter()
                formatter.dateFormat = format
                formatter.locale = Locale(identifier: "ko_KR")
                
                if let date = formatter.date(from: dateString) {
                    return outputFormatter.string(from: date)
                }
            }
            
            // 모든 파싱 실패 시 원본 반환
            return dateString
        }
        
        return outputFormatter.string(from: date)
    }
}
