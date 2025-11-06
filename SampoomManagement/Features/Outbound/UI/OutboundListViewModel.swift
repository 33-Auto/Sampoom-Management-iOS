//
//  OutboundListViewModel.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/17/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class OutboundListViewModel: ObservableObject {
    @Published var uiState = OutboundListUiState()
    
    private let getOutboundUseCase: GetOutboundUseCase
    private let processOutboundUseCase: ProcessOutboundUseCase
    private let updateOutboundQuantityUseCase: UpdateOutboundQuantityUseCase
    private let deleteOutboundUseCase: DeleteOutboundUseCase
    private let deleteAllOutboundUseCase: DeleteAllOutboundUseCase
    
    init(
        getOutboundUseCase: GetOutboundUseCase,
        processOutboundUseCase: ProcessOutboundUseCase,
        updateOutboundQuantityUseCase: UpdateOutboundQuantityUseCase,
        deleteOutboundUseCase: DeleteOutboundUseCase,
        deleteAllOutboundUseCase: DeleteAllOutboundUseCase
    ) {
        self.getOutboundUseCase = getOutboundUseCase
        self.processOutboundUseCase = processOutboundUseCase
        self.updateOutboundQuantityUseCase = updateOutboundQuantityUseCase
        self.deleteOutboundUseCase = deleteOutboundUseCase
        self.deleteAllOutboundUseCase = deleteAllOutboundUseCase
    }
    
    func onEvent(_ event: OutboundListUiEvent) {
        switch event {
        case .loadOutboundList:
            loadOutboundList()
        case .retryOutboundList:
            loadOutboundList()
        case .processOutbound:
            processOutbound()
        case .updateQuantity(let outboundId, let quantity):
            updateQuantity(outboundId: outboundId, quantity: quantity)
        case .deleteOutbound(let outboundId):
            deleteOutbound(outboundId: outboundId)
        case .deleteAllOutbound:
            deleteAllOutbound()
        case .clearUpdateError:
            uiState = uiState.copy(updateError: .some(nil))
        case .clearDeleteError:
            uiState = uiState.copy(deleteError: .some(nil))
        }
    }
    
    private func loadOutboundList() {
        Task {
            await MainActor.run {
                uiState = uiState.copy(outboundLoading: true, outboundError: nil)
            }
            
            do {
                let outboundList = try await getOutboundUseCase.execute()
                await MainActor.run {
                    uiState = uiState.copy(
                        outboundList: outboundList.items,
                        outboundLoading: false,
                        outboundError: nil
                    )
                }
            } catch {
                await MainActor.run {
                    uiState = uiState.copy(
                        outboundLoading: false,
                        outboundError: error.localizedDescription
                    )
                }
            }
            print("OutboundListViewModel - loadOutboundList: \(uiState)")
        }
    }
    
    private func processOutbound() {
        Task {
            await MainActor.run {
                uiState = uiState.copy(outboundLoading: true, outboundError: nil)
            }
            
            do {
                try await processOutboundUseCase.execute()
                await MainActor.run {
                    uiState = uiState.copy(outboundLoading: false, isOrderSuccess: true)
                }
                loadOutboundList() // 성공 후 리스트 새로고침
            } catch {
                await MainActor.run {
                    uiState = uiState.copy(
                        outboundLoading: false,
                        outboundError: error.localizedDescription
                    )
                }
            }
            print("OutboundListViewModel - processOutbound: \(uiState)")
        }
    }
    
    private func updateQuantity(outboundId: Int, quantity: Int) {
        // 1. 로컬 상태 먼저 업데이트 (즉시 UI 반영)
        updateLocalQuantity(outboundId: outboundId, quantity: quantity)
        
        // 2. 백그라운드에서 서버 동기화
        Task {
            await MainActor.run {
                uiState = uiState.copy(isUpdating: true, updateError: nil)
            }
            
            do {
                try await updateOutboundQuantityUseCase.execute(outboundId: outboundId, quantity: quantity)
                await MainActor.run {
                    uiState = uiState.copy(isUpdating: false)
                }
                print("OutboundListViewModel - updateQuantity success: \(uiState)")
            } catch {
                // 3. 실패 시 에러 표시 후 롤백
                await MainActor.run {
                    uiState = uiState.copy(
                        isUpdating: false,
                        updateError: error.localizedDescription
                    )
                }
                loadOutboundList() // 에러 표시 후 백그라운드에서 롤백
                print("OutboundListViewModel - updateQuantity error: \(error)")
            }
        }
    }
    
    private func updateLocalQuantity(outboundId: Int, quantity: Int) {
        let updatedList = uiState.outboundList.map { category in
            Outbound(
                categoryId: category.categoryId,
                categoryName: category.categoryName,
                groups: category.groups.map { group in
                    OutboundGroup(
                        groupId: group.groupId,
                        groupName: group.groupName,
                        parts: group.parts.map { part in
                            if part.outboundId == outboundId {
                                OutboundPart(
                                    outboundId: part.outboundId,
                                    partId: part.partId,
                                    code: part.code,
                                    name: part.name,
                                    quantity: quantity,
                                    standardCost: part.standardCost
                                )
                            } else {
                                part
                            }
                        }
                    )
                }
            )
        }
        uiState = uiState.copy(outboundList: updatedList)
    }
    
    private func deleteOutbound(outboundId: Int) {
        // 1. 로컬 상태 먼저 업데이트 (즉시 UI 반영)
        removeFromLocalList(outboundId: outboundId)
        
        // 2. 백그라운드에서 서버 동기화
        Task {
            await MainActor.run {
                uiState = uiState.copy(isDeleting: true, deleteError: nil)
            }
            
            do {
                try await deleteOutboundUseCase.execute(outboundId: outboundId)
                await MainActor.run {
                    uiState = uiState.copy(isDeleting: false)
                }
                print("OutboundListViewModel - deleteOutbound success: \(uiState)")
            } catch {
                // 3. 실패 시 에러 표시 후 롤백
                await MainActor.run {
                    uiState = uiState.copy(
                        isDeleting: false,
                        deleteError: error.localizedDescription
                    )
                }
                loadOutboundList() // 에러 표시 후 백그라운드에서 롤백
                print("OutboundListViewModel - deleteOutbound error: \(error)")
            }
        }
    }
    
    private func removeFromLocalList(outboundId: Int) {
        let updatedList = uiState.outboundList.compactMap { category in
            let updatedGroups = category.groups.compactMap { group in
                let filteredParts = group.parts.filter { $0.outboundId != outboundId }
                return filteredParts.isEmpty ? nil : OutboundGroup(
                    groupId: group.groupId,
                    groupName: group.groupName,
                    parts: filteredParts
                )
            }
            return updatedGroups.isEmpty ? nil : Outbound(
                categoryId: category.categoryId,
                categoryName: category.categoryName,
                groups: updatedGroups
            )
        }
        uiState = uiState.copy(outboundList: updatedList)
    }
    
    private func deleteAllOutbound() {
        // 1. 로컬 상태 먼저 업데이트 (즉시 UI 반영)
        removeAllFromLocalList()
        
        // 2. 백그라운드에서 서버 동기화
        Task {
            await MainActor.run {
                uiState = uiState.copy(isDeleting: true, deleteError: nil)
            }
            
            do {
                try await deleteAllOutboundUseCase.execute()
                await MainActor.run {
                    uiState = uiState.copy(isDeleting: false)
                }
                print("OutboundListViewModel - deleteAllOutbound success: \(uiState)")
            } catch {
                // 3. 실패 시 에러 표시 후 롤백
                await MainActor.run {
                    uiState = uiState.copy(
                        isDeleting: false,
                        deleteError: error.localizedDescription
                    )
                }
                loadOutboundList() // 에러 표시 후 백그라운드에서 롤백
                print("OutboundListViewModel - deleteAllOutbound error: \(error)")
            }
        }
    }
    
    private func removeAllFromLocalList() {
        uiState = uiState.copy(outboundList: [])
    }
    
    func clearSuccess() {
        uiState = uiState.copy(isOrderSuccess: false)
    }
}
