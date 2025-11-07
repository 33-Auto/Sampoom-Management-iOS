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
    let globalMessageHandler: GlobalMessageHandler
    
    // MARK: - Auth
    let authPreferences: AuthPreferences
    let authAPI: AuthAPI
    let authRepository: AuthRepository
    let loginUseCase: LoginUseCase
    let signUpUseCase: SignUpUseCase
    let checkLoginStateUseCase: CheckLoginStateUseCase
    let signOutUseCase: SignOutUseCase
    let clearTokensUseCase: ClearTokensUseCase
    let getVendorUseCase: GetVendorUseCase
    let authViewModel: AuthViewModel
    
    // MARK: - Network Auth
    private let tokenRefreshService: TokenRefreshService
    private let authRequestInterceptor: AuthRequestInterceptor
    
    // MARK: - Part
    let partAPI: PartAPI
    let partRepository: PartRepository
    let getCategoryUseCase: GetCategoryUseCase
    let getGroupUseCase: GetGroupUseCase
    let getPartUseCase: GetPartUseCase
    let searchPartsUseCase: SearchPartsUseCase
    
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
    
    // MARK: - Order
    let orderAPI: OrderAPI
    let orderRepository: OrderRepository
    let getOrderUseCase: GetOrderUseCase
    let createOrderUseCase: CreateOrderUseCase
    let getOrderDetailUseCase: GetOrderDetailUseCase
    let completeOrderUseCase: CompleteOrderUseCase
    let receiveOrderUseCase: ReceiveOrderUseCase
    let cancelOrderUseCase: CancelOrderUseCase
    
    // MARK: - Dashboard
    let dashboardAPI: DashboardAPI
    let dashboardRepository: DashboardRepository
    let getDashboardUseCase: GetDashboardUseCase
    let getWeeklySummaryUseCase: GetWeeklySummaryUseCase
    
    // MARK: - User
    let userAPI: UserAPI
    let userRepository: UserRepository
    let getProfileUseCase: GetProfileUseCase
    let getStoredUserUseCase: GetStoredUserUseCase
    let updateProfileUseCase: UpdateProfileUseCase
    let getEmployeeUseCase: GetEmployeeUseCase
    let editEmployeeUseCase: EditEmployeeUseCase
    
    init() {
        // Global Message Handler
        globalMessageHandler = GlobalMessageHandler.shared
        
        // Auth Preferences
        authPreferences = AuthPreferences()
        
        // Network Auth Services
        tokenRefreshService = TokenRefreshService(authPreferences: authPreferences)
        authRequestInterceptor = AuthRequestInterceptor(
            authPreferences: authPreferences,
            tokenRefreshService: tokenRefreshService
        )
        
        // Core Network
        networkManager = NetworkManager(authRequestInterceptor: authRequestInterceptor)
        
        // Auth
        authAPI = AuthAPI(networkManager: networkManager)
        authRepository = AuthRepositoryImpl(
            api: authAPI,
            preferences: authPreferences
        )
        loginUseCase = LoginUseCase(repository: authRepository)
        signUpUseCase = SignUpUseCase(repository: authRepository)
        checkLoginStateUseCase = CheckLoginStateUseCase(repository: authRepository)
        signOutUseCase = SignOutUseCase(repository: authRepository)
        clearTokensUseCase = ClearTokensUseCase(repository: authRepository)
        getVendorUseCase = GetVendorUseCase(repository: authRepository)
        
        // Auth ViewModel
        authViewModel = AuthViewModel(
            checkLoginStateUseCase: checkLoginStateUseCase,
            signOutUseCase: signOutUseCase,
            clearTokensUseCase: clearTokensUseCase
        )
        
        // Part
        partAPI = PartAPI(networkManager: networkManager)
        partRepository = PartRepositoryImpl(api: partAPI, preferences: authPreferences)
        getCategoryUseCase = GetCategoryUseCase(repository: partRepository)
        getGroupUseCase = GetGroupUseCase(repository: partRepository)
        getPartUseCase = GetPartUseCase(repository: partRepository)
        searchPartsUseCase = SearchPartsUseCase(repository: partRepository)
        
        // Outbound
        outboundAPI = OutboundAPI(networkManager: networkManager)
        outboundRepository = OutboundRepositoryImpl(api: outboundAPI, preferences: authPreferences)
        getOutboundUseCase = GetOutboundUseCase(repository: outboundRepository)
        addOutboundUseCase = AddOutboundUseCase(repository: outboundRepository)
        deleteOutboundUseCase = DeleteOutboundUseCase(repository: outboundRepository)
        deleteAllOutboundUseCase = DeleteAllOutboundUseCase(repository: outboundRepository)
        processOutboundUseCase = ProcessOutboundUseCase(repository: outboundRepository)
        updateOutboundQuantityUseCase = UpdateOutboundQuantityUseCase(repository: outboundRepository)
        
        // Cart
        cartAPI = CartAPI(networkManager: networkManager)
        cartRepository = CartRepositoryImpl(api: cartAPI, preferences: authPreferences)
        getCartUseCase = GetCartUseCase(repository: cartRepository)
        addCartUseCase = AddCartUseCase(repository: cartRepository)
        deleteCartUseCase = DeleteCartUseCase(repository: cartRepository)
        deleteAllCartUseCase = DeleteAllCartUseCase(repository: cartRepository)
        updateCartQuantityUseCase = UpdateCartQuantityUseCase(repository: cartRepository)
        
        // Order
        orderAPI = OrderAPI(networkManager: networkManager)
        orderRepository = OrderRepositoryImpl(api: orderAPI, preferences: authPreferences)
        getOrderUseCase = GetOrderUseCase(repository: orderRepository)
        createOrderUseCase = CreateOrderUseCase(repository: orderRepository)
        getOrderDetailUseCase = GetOrderDetailUseCase(repository: orderRepository)
        completeOrderUseCase = CompleteOrderUseCase(repository: orderRepository)
        receiveOrderUseCase = ReceiveOrderUseCase(repository: orderRepository)
        cancelOrderUseCase = CancelOrderUseCase(repository: orderRepository)
        
        // Dashboard
        dashboardAPI = DashboardAPI(networkManager: networkManager)
        dashboardRepository = DashboardRepositoryImpl(api: dashboardAPI, authPreferences: authPreferences)
        getDashboardUseCase = GetDashboardUseCase(repository: dashboardRepository)
        getWeeklySummaryUseCase = GetWeeklySummaryUseCase(repository: dashboardRepository)
        
        // User
        userAPI = UserAPI(networkManager: networkManager)
        userRepository = UserRepositoryImpl(api: userAPI, preferences: authPreferences)
        getProfileUseCase = GetProfileUseCase(repository: userRepository)
        getStoredUserUseCase = GetStoredUserUseCase(repository: userRepository)
        updateProfileUseCase = UpdateProfileUseCase(repository: userRepository)
        getEmployeeUseCase = GetEmployeeUseCase(repository: userRepository)
        editEmployeeUseCase = EditEmployeeUseCase(repository: userRepository)
    }
    
    // MARK: - ViewModel Factories
    
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(loginUseCase: loginUseCase, getProfileUseCase: getProfileUseCase)
    }
    
    func makeSignUpViewModel() -> SignUpViewModel {
        return SignUpViewModel(signUpUseCase: signUpUseCase, getVendorUseCase: getVendorUseCase, getProfileUseCase: getProfileUseCase)
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
        return PartDetailViewModel(
            addOutboundUseCase: addOutboundUseCase,
            addCartUseCase: addCartUseCase,
            globalMessageHandler: globalMessageHandler
        )
    }
    
    func makeSearchViewModel() -> SearchViewModel {
        let partDetailViewModel = makePartDetailViewModel()
        return SearchViewModel(searchPartsUseCase: searchPartsUseCase, partDetailViewModel: partDetailViewModel)
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
            deleteAllCartUseCase: deleteAllCartUseCase,
            createOrderUseCase: createOrderUseCase,
            globalMessageHandler: globalMessageHandler
        )
    }
    
    func makeOrderListViewModel() -> OrderListViewModel {
        return OrderListViewModel(
            getOrderUseCase: getOrderUseCase,
            globalMessageHandler: globalMessageHandler
        )
    }
    
    func makeOrderDetailViewModel(orderId: Int) -> OrderDetailViewModel {
        return OrderDetailViewModel(
            getOrderDetailUseCase: getOrderDetailUseCase,
            cancelOrderUseCase: cancelOrderUseCase,
            completeOrderUseCase: completeOrderUseCase,
            receiveOrderUseCase: receiveOrderUseCase,
            globalMessageHandler: globalMessageHandler,
            orderId: orderId
        )
    }
    
    func makeDashboardViewModel() -> DashboardViewModel {
        return DashboardViewModel(
            getOrderUseCase: getOrderUseCase,
            getDashboardUseCase: getDashboardUseCase,
            getWeeklySummaryUseCase: getWeeklySummaryUseCase,
            getStoredUserUseCase: getStoredUserUseCase,
            messageHandler: globalMessageHandler
        )
    }
    
    func makeSettingViewModel() -> SettingViewModel {
        return SettingViewModel(
            getStoredUserUseCase: getStoredUserUseCase,
            signOutUseCase: signOutUseCase,
            globalMessageHandler: globalMessageHandler
        )
    }
    
    func makeEmployeeListViewModel() -> EmployeeListViewModel {
        return EmployeeListViewModel(
            getEmployeeUseCase: getEmployeeUseCase,
            messageHandler: globalMessageHandler,
            authPreferences: authPreferences
        )
    }
    
    func makeEditEmployeeViewModel() -> EditEmployeeViewModel {
        return EditEmployeeViewModel(
            editEmployeeUseCase: editEmployeeUseCase,
            messageHandler: globalMessageHandler
        )
    }
    
    func makeUpdateProfileViewModel() -> UpdateProfileViewModel {
        return UpdateProfileViewModel(
            updateProfileUseCase: updateProfileUseCase,
            messageHandler: globalMessageHandler
        )
    }
}

