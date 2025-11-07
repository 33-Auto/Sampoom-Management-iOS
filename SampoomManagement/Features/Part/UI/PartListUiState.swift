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
    let selectedPart: Part?
    
    init(
        partList: [Part] = [],
        partListLoading: Bool = false,
        partListError: String? = nil,
        selectedPart: Part? = nil
    ) {
        self.partList = partList
        self.partListLoading = partListLoading
        self.partListError = partListError
        self.selectedPart = selectedPart
    }
    
    func copy(
        partList: [Part]? = nil,
        partListLoading: Bool? = nil,
        partListError: String?? = nil,
        selectedPart: Part?? = nil
    ) -> PartListUiState {
        return PartListUiState(
            partList: partList ?? self.partList,
            partListLoading: partListLoading ?? self.partListLoading,
            partListError: partListError ?? self.partListError,
            selectedPart: selectedPart ?? self.selectedPart
        )
    }
}
