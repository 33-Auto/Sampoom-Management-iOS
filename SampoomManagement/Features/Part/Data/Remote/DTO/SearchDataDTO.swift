//
//  SearchDataDTO.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/17/25.
//

import Foundation

struct SearchDataDTO: Codable {
    let content: [SearchCategoryDTO]
    let totalElements: Int
    let totalPages: Int
    let currentPage: Int
}

struct SearchCategoryDTO: Codable {
    let categoryId: Int
    let categoryName: String
    let groups: [SearchGroupDTO]
}

struct SearchGroupDTO: Codable {
    let groupId: Int
    let groupName: String
    let parts: [PartDTO]
}