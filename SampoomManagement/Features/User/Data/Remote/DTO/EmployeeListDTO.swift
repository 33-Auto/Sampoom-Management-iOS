//
//  EmployeeListDTO.swift
//  SampoomManagement
//
//  Created by Generated.
//

import Foundation

struct EmployeeListDTO: Codable {
    let users: [EmployeeDTO]
    let meta: EmployeeMetaDTO
}

struct EmployeeMetaDTO: Codable {
    let currentPage: Int
    let totalPages: Int
    let totalElements: Int
    let size: Int
    let hasNext: Bool
    let hasPrevious: Bool
}

