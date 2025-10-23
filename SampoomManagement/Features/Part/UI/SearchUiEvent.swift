//
//  SearchUiEvent.swift
//  SampoomManagement
//
//  Created by 채상윤 on 10/17/25.
//

import Foundation

enum SearchUiEvent {
    case search(String)
    case loadMore
    case clearSearch
    case showBottomSheet(Part)
    case dismissBottomSheet
}
