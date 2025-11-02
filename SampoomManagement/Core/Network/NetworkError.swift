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
    case serverError(Int, message: String?)
    case invalidParameters
    case unauthorized
    
    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return "네트워크 오류: \(error.localizedDescription)"
        case .decodingError(let error):
            // 디코딩 에러의 실제 메시지 추출 시도
            if let decodingError = error as? DecodingError {
                return decodingErrorMessage(decodingError)
            }
            return "데이터 파싱 오류: \(error.localizedDescription)"
        case .invalidURL:
            return "잘못된 URL"
        case .noData:
            return "데이터가 없습니다"
        case .serverError(let code, let message):
            if let message = message, !message.isEmpty {
                return message
            }
            return "서버 오류: \(code)"
        case .invalidParameters:
            return "잘못된 매개변수입니다"
        case .unauthorized:
            return "인증이 필요합니다"
        }
    }
    
    private func decodingErrorMessage(_ error: DecodingError) -> String {
        switch error {
        case .dataCorrupted(let context):
            return "데이터 형식 오류: \(context.debugDescription)"
        case .keyNotFound(let key, _):
            return "필수 데이터 누락: \(key.stringValue)"
        case .typeMismatch(let type, _):
            return "데이터 형식 불일치: \(type)"
        case .valueNotFound(let type, _):
            return "필수 값 누락: \(type)"
        @unknown default:
            return "데이터 파싱 오류"
        }
    }
}

enum AuthError: Error, LocalizedError {
    case tokenSaveFailed(Error)
    case invalidCredentials
    case networkError(Error)
    case invalidResponse
    case tokenRefreshFailed
    case unauthorized
    
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
        case .tokenRefreshFailed:
            return "토큰 재발급에 실패했습니다"
        case .unauthorized:
            return "인증이 필요합니다"
        }
    }
}
