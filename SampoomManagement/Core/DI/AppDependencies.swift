//
//  AppDependencies.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/15/25.
//

import Foundation
import SwiftUI

/// SwiftUI Environment 기반 의존성 관리
class AppDependencies {
    // MARK: - Core
    let networkManager: NetworkManager
    
    // MARK: - Auth
    let authPreferences: AuthPreferences
    let authAPI: AuthAPI
    let authRepository: AuthRepository
    let loginUseCase: LoginUseCase
    let signUpUseCase: SignUpUseCase
    
    // MARK: - Part
    let partAPI: PartAPI
    let partRepository: PartRepository
    let getCategoryUseCase: GetCategoryUseCase
    let getGroupUseCase: GetGroupUseCase
    let getPartUseCase: GetPartUseCase
    
    init() {
        // Core
        networkManager = NetworkManager()
        
        // Auth
        authPreferences = AuthPreferences()
        authAPI = AuthAPI(networkManager: networkManager)
        authRepository = AuthRepositoryImpl(
            api: authAPI,
            preferences: authPreferences
        )
        loginUseCase = LoginUseCase(repository: authRepository)
        signUpUseCase = SignUpUseCase(repository: authRepository)
        
        // Part
        partAPI = PartAPI(networkManager: networkManager)
        partRepository = PartRepositoryImpl(api: partAPI)
        getCategoryUseCase = GetCategoryUseCase(repository: partRepository)
        getGroupUseCase = GetGroupUseCase(repository: partRepository)
        getPartUseCase = GetPartUseCase(repository: partRepository)
    }
    
    // MARK: - ViewModel Factories
    
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(loginUseCase: loginUseCase)
    }
    
    func makeSignUpViewModel() -> SignUpViewModel {
        return SignUpViewModel(signUpUseCase: signUpUseCase)
    }
    
    func makePartViewModel() -> PartViewModel {
        return PartViewModel(
            getCategoryUseCase: getCategoryUseCase,
            getGroupUseCase: getGroupUseCase
        )
    }
    
    func makePartListViewModel(groupId: Int) -> PartListViewModel {
        return PartListViewModel(
            getPartUseCase: getPartUseCase, groupId: groupId
        )
    }
}

