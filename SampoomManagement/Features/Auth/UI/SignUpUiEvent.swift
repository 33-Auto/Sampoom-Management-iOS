//
//  SignUpUiEvent.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/14/25.
//

import Foundation

enum SignUpUiEvent {
    case nameChanged(String)
    case branchChanged(String)
    case positionChanged(String)
    case emailChanged(String)
    case passwordChanged(String)
    case passwordCheckChanged(String)
    case submit
}


