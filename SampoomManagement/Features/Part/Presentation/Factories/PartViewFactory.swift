//
//  PartViewFactory.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import Foundation

class PartViewFactory {
    static func createViewModel() -> PartViewModel {
        let api = PartAPI()
        let repository = PartRepositoryImpl(api: api)
        let useCase = GetPartUseCase(repository: repository)
        return PartViewModel(getPartUseCase: useCase)
    }
}
