//
//  AuthPreferences.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/14/25.
//

import Foundation

class AuthPreferences {
    private let keychain = KeychainManager()
    
    private enum Keys {
        static let accessToken = "auth.accessToken"
        static let refreshToken = "auth.refreshToken"
    }
    
    func saveToken(accessToken: String, refreshToken: String) {
        try? keychain.save(accessToken, for: Keys.accessToken)
        try? keychain.save(refreshToken, for: Keys.refreshToken)
    }
    
    func getAccessToken() -> String? {
        return try? keychain.get(Keys.accessToken)
    }
    
    func getRefreshToken() -> String? {
        return try? keychain.get(Keys.refreshToken)
    }
    
    func hasToken() -> Bool {
        return getAccessToken() != nil && getRefreshToken() != nil
    }
    
    func clear() {
        try? keychain.delete(Keys.accessToken)
        try? keychain.delete(Keys.refreshToken)
    }
}


