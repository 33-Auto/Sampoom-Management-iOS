//
//  PartRepository.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import Foundation

protocol PartRepository {
    func getCategoryList() async throws -> CategoryList
    func getGroupList(categoryId: Int) async throws -> PartsGroupList
    func getPartList(groupId: Int) async throws -> PartList
}
