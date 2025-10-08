//
//  PartDIModule.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import Foundation
import Swinject

final class PartDIModule: Assembly {
    func assemble(container: Container) {
        // MARK: - Part Feature Dependencies
        
        // PartAPI 등록
        container.register(PartAPI.self) { resolver in
            PartAPI(networkManager: resolver.resolve(NetworkManager.self)!)
        }.inObjectScope(.container)
        
        // PartRepository 등록 (Interface -> Implementation)
        container.register(PartRepository.self) { resolver in
            PartRepositoryImpl(api: resolver.resolve(PartAPI.self)!)
        }.inObjectScope(.container)
        
        // GetPartUseCase 등록
        container.register(GetPartUseCase.self) { resolver in
            GetPartUseCase(repository: resolver.resolve(PartRepository.self)!)
        }.inObjectScope(.container)
        
        // PartViewModel 등록
        container.register(PartViewModel.self) { resolver in
            PartViewModel(getPartUseCase: resolver.resolve(GetPartUseCase.self)!)
        }.inObjectScope(.container)
    }
}
