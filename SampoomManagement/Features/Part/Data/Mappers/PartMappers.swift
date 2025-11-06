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
            quantity: self.quantity,
            standardCost: self.standardCost
        )
    }
}

extension SearchCategoryDTO {
    func toModel() -> [SearchResult] {
        return groups.flatMap { group in
            group.parts.map { part in
                SearchResult(
                    part: part.toModel(),
                    categoryName: categoryName,
                    groupName: group.groupName
                )
            }
        }
    }
}

extension SearchDataDTO {
    func toModel() -> [SearchResult] {
        return content.flatMap { category in
            category.toModel()
        }
    }
}
