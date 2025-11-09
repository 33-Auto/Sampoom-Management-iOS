//
//  EmployeeStatusFormatter.swift
//  SampoomManagement
//
//  Created by Generated.
//

import Foundation

func employeeStatusToKorean(_ status: EmployeeStatus?) -> String {
    guard let status else { return StringResources.Common.slash }
    return status.displayNameKo
}


