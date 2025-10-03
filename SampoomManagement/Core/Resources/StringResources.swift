//
//  StringResources.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import Foundation

struct StringResources {
    
    // MARK: - App
    struct App {
        static let title = "SampoomManagement"
    }
    
    // MARK: - Tabs
    struct Tabs {
        static let parts = "부품"
        static let inventory = "인벤토리"
        static let profile = "프로필"
        static let settings = "설정"
    }
    
    // MARK: - Messages
    struct Messages {
        static let loading = "로딩 중..."
        static let errorTitle = "오류가 발생했습니다"
        static let retryButton = "다시 시도"
        static let emptyInventory = "인벤토리가 비어있습니다"
        static let emptyStateMessage = "데이터가 없습니다"
    }
    
    // MARK: - Navigation
    struct Navigation {
        static let back = "뒤로"
        static let close = "닫기"
        static let detail = "상세 보기"
    }
    
    // MARK: - Placeholders
    struct Placeholders {
        static let inventoryDescription = "인벤토리 관리 기능이 들어갈 예정입니다"
        static let profileDescription = "사용자 프로필 기능이 들어갈 예정입니다"
        static let settingsDescription = "앱 설정 기능이 들어갈 예정입니다"
        static let searchDescription = "검색 기능이 들어갈 예정입니다"
    }
    
    // MARK: - Search
    struct Search {
        static let title = "검색"
    }
    
    // MARK: - Detail
    struct Detail {
        static let title = "상세"
        static let screenTitle = "상세 화면"
        static let description = "이 화면은 탭바가 완전히 숨겨집니다!"
    }
    
    // MARK: - Common
    struct Common {
        static let ok = "확인"
        static let cancel = "취소"
        static let save = "저장"
        static let delete = "삭제"
        static let edit = "편집"
        static let done = "완료"
    }
}
