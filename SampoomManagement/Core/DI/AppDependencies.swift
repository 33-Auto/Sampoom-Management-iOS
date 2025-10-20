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
    
    // MARK: - Outbound
    let outboundAPI: OutboundAPI
    let outboundRepository: OutboundRepository
    let getOutboundUseCase: GetOutboundUseCase
    let addOutboundUseCase: AddOutboundUseCase
    let deleteOutboundUseCase: DeleteOutboundUseCase
    let deleteAllOutboundUseCase: DeleteAllOutboundUseCase
    let processOutboundUseCase: ProcessOutboundUseCase
    let updateOutboundQuantityUseCase: UpdateOutboundQuantityUseCase
    
    // MARK: - Cart
    let cartAPI: CartAPI
    let cartRepository: CartRepository
    let getCartUseCase: GetCartUseCase
    let addCartUseCase: AddCartUseCase
    let deleteCartUseCase: DeleteCartUseCase
    let deleteAllCartUseCase: DeleteAllCartUseCase
    let updateCartQuantityUseCase: UpdateCartQuantityUseCase
    
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
        
        // Outbound
        outboundAPI = OutboundAPI(networkManager: networkManager)
        outboundRepository = OutboundRepositoryImpl(api: outboundAPI)
        getOutboundUseCase = GetOutboundUseCase(repository: outboundRepository)
        addOutboundUseCase = AddOutboundUseCase(repository: outboundRepository)
        deleteOutboundUseCase = DeleteOutboundUseCase(repository: outboundRepository)
        deleteAllOutboundUseCase = DeleteAllOutboundUseCase(repository: outboundRepository)
        processOutboundUseCase = ProcessOutboundUseCase(repository: outboundRepository)
        updateOutboundQuantityUseCase = UpdateOutboundQuantityUseCase(repository: outboundRepository)
        
        // Cart
        cartAPI = CartAPI(networkManager: networkManager)
        cartRepository = CartRepositoryImpl(api: cartAPI)
        getCartUseCase = GetCartUseCase(repository: cartRepository)
        addCartUseCase = AddCartUseCase(repository: cartRepository)
        deleteCartUseCase = DeleteCartUseCase(repository: cartRepository)
        deleteAllCartUseCase = DeleteAllCartUseCase(repository: cartRepository)
        updateCartQuantityUseCase = UpdateCartQuantityUseCase(repository: cartRepository)
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
    
    func makePartDetailViewModel() -> PartDetailViewModel {
        return PartDetailViewModel(addOutboundUseCase: addOutboundUseCase, addCartUseCase: addCartUseCase)
    }
    
    func makeOutboundListViewModel() -> OutboundListViewModel {
        return OutboundListViewModel(
            getOutboundUseCase: getOutboundUseCase,
            processOutboundUseCase: processOutboundUseCase,
            updateOutboundQuantityUseCase: updateOutboundQuantityUseCase,
            deleteOutboundUseCase: deleteOutboundUseCase,
            deleteAllOutboundUseCase: deleteAllOutboundUseCase
        )
    }
    
    func makeCartListViewModel() -> CartListViewModel {
        return CartListViewModel(
            getCartUseCase: getCartUseCase,
            updateCartQuantityUseCase: updateCartQuantityUseCase,
            deleteCartUseCase: deleteCartUseCase,
            deleteAllCartUseCase: deleteAllCartUseCase
        )
    }
}

