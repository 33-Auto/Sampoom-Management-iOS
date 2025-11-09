//
//  SignUpViewModel.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/14/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class SignUpViewModel: ObservableObject {
    @Published var uiState = SignUpUiState()
    
    private let signUpUseCase: SignUpUseCase
    private let getVendorUseCase: GetVendorUseCase
    private let getProfileUseCase: GetProfileUseCase
    
    init(signUpUseCase: SignUpUseCase, getVendorUseCase: GetVendorUseCase, getProfileUseCase: GetProfileUseCase) {
        self.signUpUseCase = signUpUseCase
        self.getVendorUseCase = getVendorUseCase
        self.getProfileUseCase = getProfileUseCase
        Task { await loadVendors() }
    }
    
    // 이름 업데이트
    func updateName(_ name: String) {
        uiState = uiState.copy(name: name)
        validateName()
    }
    
    // 지점 업데이트
    func updateBranch(_ branch: String) {
        uiState = uiState.copy(branch: branch)
        validateBranch()
    }
    
    // Vendor 선택 시 브랜치 채우기
    func selectVendor(_ vendor: Vendor) {
        uiState = uiState.copy(branch: vendor.name, selectedVendor: vendor)
        validateBranch()
    }
    
    // 직급 업데이트
    func updatePosition(_ position: String) {
        uiState = uiState.copy(position: position)
        validatePosition()
    }
    
    // 이메일 업데이트
    func updateEmail(_ email: String) {
        uiState = uiState.copy(email: email)
        validateEmail()
    }
    
    // 비밀번호 업데이트
    func updatePassword(_ password: String) {
        uiState = uiState.copy(password: password)
        validatePassword()
        if !uiState.passwordCheck.isEmpty {
            validatePasswordCheck()
        }
    }
    
    // 비밀번호 확인 업데이트
    func updatePasswordCheck(_ passwordCheck: String) {
        uiState = uiState.copy(passwordCheck: passwordCheck)
        validatePasswordCheck()
    }
    
    // 회원가입 제출
    func submit() {
        Task {
            validateName()
            validateBranch()
            validatePosition()
            validateEmail()
            validatePassword()
            validatePasswordCheck()
            
            guard uiState.isValid else { return }
            
            let name = uiState.name
            let workspace = uiState.workspace
            let branch = uiState.branch
            let position = uiState.position
            let email = uiState.email
            let password = uiState.password
            
            uiState = uiState.copy(loading: true, error: nil)
            
            do {
                _ = try await signUpUseCase.execute(
                    userName: name,
                    workspace: workspace,
                    branch: branch,
                    position: position,
                    email: email,
                    password: password
                )
                // 회원가입 성공 후 프로필 조회
                _ = try await getProfileUseCase.execute(workspace: "AGENCY")
                uiState = uiState.copy(loading: false, success: true)
            } catch {
                uiState = uiState.copy(loading: false)
                showError(error.localizedDescription)
            }
        }
    }
    
    // 에러 소비 (Toast 표시 후 에러 상태 제거)
    func consumeError() {
        uiState = uiState.copy(error: nil)
    }
    
    // 에러 표시를 위한 강제 상태 변경
    private func showError(_ message: String) {
        // 타임스탬프를 추가하여 항상 다른 값으로 만들어 onChange 트리거 보장
        uiState = uiState.copy(error: "\(message)_\(Date().timeIntervalSince1970)")
    }
    
    // MARK: - Private Methods
    
    private func validateName() {
        let result = AuthValidator.validateNotEmpty(
            uiState.name,
            StringResources.Auth.nameLabel
        )
        uiState = uiState.copy(nameError: result.errorMessage)
    }
    
    private func validateBranch() {
        let result = AuthValidator.validateNotEmpty(
            uiState.branch,
            StringResources.Auth.branchLabel
        )
        uiState = uiState.copy(branchError: result.errorMessage)
    }

    private func loadVendors() async {
        uiState = uiState.copy(vendorsLoading: true)
        do {
            let list = try await getVendorUseCase.execute()
            uiState = uiState.copy(vendors: list.items, vendorsLoading: false)
        } catch {
            // 실패 시에도 로딩 해제만
            uiState = uiState.copy(vendorsLoading: false)
        }
    }
    
    private func validatePosition() {
        let result = AuthValidator.validateNotEmpty(
            uiState.position,
            StringResources.Auth.positionLabel
        )
        uiState = uiState.copy(positionError: result.errorMessage)
    }
    
    private func validateEmail() {
        let result = AuthValidator.validateEmail(uiState.email)
        uiState = uiState.copy(emailError: result.errorMessage)
    }
    
    private func validatePassword() {
        let result = AuthValidator.validatePassword(uiState.password)
        uiState = uiState.copy(passwordError: result.errorMessage)
    }
    
    private func validatePasswordCheck() {
        let result = AuthValidator.validatePasswordCheck(
            uiState.password,
            uiState.passwordCheck
        )
        uiState = uiState.copy(passwordCheckError: result.errorMessage)
    }
}
