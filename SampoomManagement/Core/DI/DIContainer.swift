//
//  DIContainer.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import Foundation
import Swinject

final class DIContainer {
    static let shared = DIContainer()
    
    private let container: Container
    private let assembler: Assembler
    
    private init() {
        container = Container()
        assembler = Assembler([
            CoreDIModule(),     // Core 레벨 의존성
            PartDIModule()      // Part Feature 의존성
        ], container: container)
    }
    
    func resolve<T>(_ type: T.Type) -> T? {
        return container.resolve(type)
    }
    
    func resolve<T>(_ type: T.Type, name: String) -> T? {
        return container.resolve(type, name: name)
    }
}
