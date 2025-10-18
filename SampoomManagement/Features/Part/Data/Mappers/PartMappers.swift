//
//  PartMappers.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import Foundation

extension CategoryDTO {
    func toModel() -> Category {
        return Category(
            id: self.id,
            code: self.code,
            name: self.name
        )
    }
}

extension GroupDTO {
    func toModel() -> PartsGroup {
        return PartsGroup(
            id: self.id,
            code: self.code,
            name: self.name,
            categoryId: self.categoryId
        )
    }
}

extension PartDTO {
    func toModel() -> Part {
        return Part(
            id: self.partId,
            code: self.code,
            name: self.name,
            quantity: self.quantity
        )
    }
}
