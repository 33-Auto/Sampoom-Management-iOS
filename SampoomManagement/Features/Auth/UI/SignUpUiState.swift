//
//  SignUpUiState.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/14/25.
//

import Foundation

struct SignUpUiState: UIState {
    let name: String
    let role: String
    let branch: String
    let position: String
    let email: String
    let password: String
    let passwordCheck: String
    
    // Vendor
    let vendors: [Vendor]
    let selectedVendor: Vendor?
    let vendorsLoading: Bool
    
    // Error message
    let nameError: String?
    let branchError: String?
    let positionError: String?
    let emailError: String?
    let passwordError: String?
    let passwordCheckError: String?
    
    let loading: Bool
    let error: String?
    let success: Bool
    
    init(
        name: String = "",
        role: String = "AGENCY",
        branch: String = "",
        position: String = "",
        email: String = "",
        password: String = "",
        passwordCheck: String = "",
        vendors: [Vendor] = [],
        selectedVendor: Vendor? = nil,
        vendorsLoading: Bool = false,
        nameError: String? = nil,
        branchError: String? = nil,
        positionError: String? = nil,
        emailError: String? = nil,
        passwordError: String? = nil,
        passwordCheckError: String? = nil,
        loading: Bool = false,
        error: String? = nil,
        success: Bool = false
    ) {
        self.name = name
        self.role = role
        self.branch = branch
        self.position = position
        self.email = email
        self.password = password
        self.passwordCheck = passwordCheck
        self.vendors = vendors
        self.selectedVendor = selectedVendor
        self.vendorsLoading = vendorsLoading
        self.nameError = nameError
        self.branchError = branchError
        self.positionError = positionError
        self.emailError = emailError
        self.passwordError = passwordError
        self.passwordCheckError = passwordCheckError
        self.loading = loading
        self.error = error
        self.success = success
    }
    
    var isValid: Bool {
        return !name.isEmpty &&
               !branch.isEmpty &&
               !position.isEmpty &&
               !email.isEmpty &&
               !password.isEmpty &&
               !passwordCheck.isEmpty &&
               nameError == nil &&
               branchError == nil &&
               positionError == nil &&
               emailError == nil &&
               passwordError == nil &&
               passwordCheckError == nil
    }
    
    func copy(
        name: String? = nil,
        role: String? = nil,
        branch: String? = nil,
        position: String? = nil,
        email: String? = nil,
        password: String? = nil,
        passwordCheck: String? = nil,
        vendors: [Vendor]? = nil,
        selectedVendor: Vendor?? = nil,
        vendorsLoading: Bool? = nil,
        nameError: String?? = nil,
        branchError: String?? = nil,
        positionError: String?? = nil,
        emailError: String?? = nil,
        passwordError: String?? = nil,
        passwordCheckError: String?? = nil,
        loading: Bool? = nil,
        error: String?? = nil,
        success: Bool? = nil
    ) -> SignUpUiState {
        return SignUpUiState(
            name: name ?? self.name,
            role: role ?? self.role,
            branch: branch ?? self.branch,
            position: position ?? self.position,
            email: email ?? self.email,
            password: password ?? self.password,
            passwordCheck: passwordCheck ?? self.passwordCheck,
            vendors: vendors ?? self.vendors,
            selectedVendor: selectedVendor ?? self.selectedVendor,
            vendorsLoading: vendorsLoading ?? self.vendorsLoading,
            nameError: nameError ?? self.nameError,
            branchError: branchError ?? self.branchError,
            positionError: positionError ?? self.positionError,
            emailError: emailError ?? self.emailError,
            passwordError: passwordError ?? self.passwordError,
            passwordCheckError: passwordCheckError ?? self.passwordCheckError,
            loading: loading ?? self.loading,
            error: error ?? self.error,
            success: success ?? self.success
        )
    }
}


