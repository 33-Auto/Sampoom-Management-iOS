//
//  PartListUiEvent.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/17/25.
//

import Foundation

enum PartListUiEvent {
    case loadPartList
    case retryPartList
    case showBottomSheet(Part)
    case dismissBottomSheet
}
