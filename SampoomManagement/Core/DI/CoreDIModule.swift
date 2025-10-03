//
//  CoreDIModule.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import Foundation
import Swinject

final class CoreDIModule: Assembly {
    func assemble(container: Container) {
        // MARK: - Core Layer Dependencies
        
        // NetworkManager 등록
        container.register(NetworkManager.self) { _ in
            NetworkManager()
        }.inObjectScope(.container)
    }
}
