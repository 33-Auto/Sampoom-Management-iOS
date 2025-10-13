//
//  NetworkError.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case networkError(Error)
    case decodingError(Error)
    case invalidURL
    case noData
    case serverError(Int)
    
    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return "네트워크 오류: \(error.localizedDescription)"
        case .decodingError(let error):
            return "데이터 파싱 오류: \(error.localizedDescription)"
        case .invalidURL:
            return "잘못된 URL"
        case .noData:
            return "데이터가 없습니다"
        case .serverError(let code):
            return "서버 오류: \(code)"
        }
    }
}
