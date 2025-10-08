//
//  PartUIState.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import Foundation

struct PartUIState: UIState {
    let loading: Bool
    let error: String?
    let success: Bool
    let partList: [Part]
    
    init(
        loading: Bool = false,
        error: String? = nil,
        success: Bool = false,
        partList: [Part] = []
    ) {
        self.loading = loading
        self.error = error
        self.success = success
        self.partList = partList
    }
    
    func copy(
        loading: Bool? = nil,
        error: String? = nil,
        success: Bool? = nil,
        partList: [Part]? = nil
    ) -> PartUIState {
        return PartUIState(
            loading: loading ?? self.loading,
            error: error ?? self.error,
            success: success ?? self.success,
            partList: partList ?? self.partList
        )
    }
}
