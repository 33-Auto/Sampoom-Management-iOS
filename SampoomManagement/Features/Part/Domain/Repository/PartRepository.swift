//
//  PartRepository.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import Foundation

protocol PartRepository {
    func getPartList() async throws -> PartList
}
