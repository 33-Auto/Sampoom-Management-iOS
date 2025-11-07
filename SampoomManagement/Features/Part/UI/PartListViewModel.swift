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
    private var loadTask: Task<Void, Never>?
    
    init(
        getPartUseCase: GetPartUseCase,
        groupId: Int
    ) {
        self.getPartUseCase = getPartUseCase
        self.groupId = groupId
        
        loadPartList()
    }
    
    func onEvent(_ event: PartListUiEvent) {
        switch event {
        case .loadPartList:
            loadPartList()
        case .retryPartList:
            loadPartList()
        case .showBottomSheet(let part):
            uiState = uiState.copy(selectedPart: part)
        case .dismissBottomSheet:
            uiState = uiState.copy(selectedPart: .some(nil))
        }
    }
    
    private func loadPartList() {
        // 이전 작업 취소
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            guard let self else { return }
            // 로딩 상태 진입은 메인에서
            await MainActor.run {
                self.uiState = self.uiState.copy(partListLoading: true, partListError: .some(nil))
            }
            do {
                let partList = try await self.getPartUseCase.execute(groupId: self.groupId)
                try Task.checkCancellation()
                await MainActor.run {
                    self.uiState = self.uiState.copy(
                        partList: partList.items,
                        partListLoading: false,
                        partListError: .some(nil)
                    )
                }
            } catch is CancellationError {
                // 취소는 무시
            } catch {
                await MainActor.run {
                    self.uiState = self.uiState.copy(
                        partListLoading: false,
                        partListError: error.localizedDescription
                    )
                }
            }
            print("PartListViewModel - loadPartList: \(self.uiState)")
        }
    }
}
