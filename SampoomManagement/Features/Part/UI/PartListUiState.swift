//
//  PartListUiState.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/17/25.
//

import Foundation

struct PartListUiState {
    let partList: [Part]
    let partListLoading: Bool
    let partListError: String?
    
    init(
        partList: [Part] = [],
        partListLoading: Bool = false,
        partListError: String? = nil
    ) {
        self.partList = partList
        self.partListLoading = partListLoading
        self.partListError = partListError
    }
    
    func copy(
        partList: [Part]? = nil,
        partListLoading: Bool? = nil,
        partListError: String? = nil
    ) -> PartListUiState {
        return PartListUiState(
            partList: partList ?? self.partList,
            partListLoading: partListLoading ?? self.partListLoading,
            partListError: partListError ?? self.partListError
        )
    }
}
