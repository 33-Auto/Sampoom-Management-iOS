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

enum AuthError: Error, LocalizedError {
    case tokenSaveFailed(Error)
    case invalidCredentials
    case networkError(Error)
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
        case .tokenSaveFailed(let error):
            return "토큰 저장 실패: \(error.localizedDescription)"
        case .invalidCredentials:
            return "잘못된 인증 정보입니다"
        case .networkError(let error):
            return "네트워크 오류: \(error.localizedDescription)"
        case .invalidResponse:
            return "잘못된 응답입니다"
        }
    }
}
