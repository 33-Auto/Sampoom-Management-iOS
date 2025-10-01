//
//  PartMappers.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import Foundation

extension PartDTO {
    func toModel() -> Part {
        return Part(
            id: self.id,
            name: self.name,
            count: self.count
        )
    }
}
