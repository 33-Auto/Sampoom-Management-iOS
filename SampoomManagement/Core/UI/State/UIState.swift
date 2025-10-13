//
//  UIState.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import Foundation

protocol UIState {
    var loading: Bool { get }
    var error: String? { get }
    var success: Bool { get }
}

struct BaseUIState: UIState {
    let loading: Bool
    let error: String?
    let success: Bool
    
    init(
        loading: Bool = false,
        error: String? = nil,
        success: Bool = false
    ) {
        self.loading = loading
        self.error = error
        self.success = success
    }
    
    func copy(
        loading: Bool? = nil,
        error: String? = nil,
        success: Bool? = nil
    ) -> BaseUIState {
        return BaseUIState(
            loading: loading ?? self.loading,
            error: error ?? self.error,
            success: success ?? self.success
        )
    }
}
