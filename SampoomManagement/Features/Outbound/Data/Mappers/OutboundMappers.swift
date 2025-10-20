//
//  OutboundMappers.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/17/25.
//

import Foundation

extension OutboundDto {
    func toModel() -> Outbound {
        return Outbound(
            categoryId: categoryId,
            categoryName: categoryName,
            groups: groups.map { $0.toModel() }
        )
    }
}

extension OutboundGroupDto {
    func toModel() -> OutboundGroup {
        return OutboundGroup(
            groupId: groupId,
            groupName: groupName,
            parts: parts.map { $0.toModel() }
        )
    }
}

extension OutboundPartDto {
    func toModel() -> OutboundPart {
        return OutboundPart(
            outboundId: outboundId,
            partId: partId,
            code: code,
            name: name,
            quantity: quantity
        )
    }
}
