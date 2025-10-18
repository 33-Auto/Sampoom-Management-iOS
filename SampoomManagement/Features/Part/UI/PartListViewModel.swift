//
//  PartListViewModel.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/17/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class PartListViewModel: ObservableObject {
    @Published var uiState = PartListUiState()
    
    private let getPartUseCase: GetPartUseCase
    private let groupId: Int
    
    init(
        getPartUseCase: GetPartUseCase,
        groupId: Int
    ) {
        self.getPartUseCase = getPartUseCase
        self.groupId = groupId
        
        loadPartList(groupId: groupId)
    }
    
    func onEvent(_ event: PartListUiEvent) {
        switch event {
        case .loadPartList:
            loadPartList(groupId: groupId)
        case .retryPartList:
            loadPartList(groupId: groupId)
        }
    }
    
    private func loadPartList(groupId: Int) {
        Task {
            uiState = uiState.copy(partListLoading: true, partListError: nil)
            
            do {
                let partList = try await getPartUseCase.execute(groupId: groupId)
                uiState = uiState.copy(
                    partList: partList.items,
                    partListLoading: false,
                    partListError: nil
                )
            } catch {
                uiState = uiState.copy(
                    partListLoading: false,
                    partListError: error.localizedDescription
                )
            }
            print("PartListViewModel - loadPartList: \(uiState)")
        }
    }
}
