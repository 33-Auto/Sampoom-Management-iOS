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
        static let dashboard = "대시보드"
        static let delivery = "출고목록"
        static let cart = "장바구니"
        static let orders = "주문관리"
        static let parts = "부품조회"
        static let employee = "직원관리"
        static let setting = "설정"
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
    
    // MARK: - Auth
    struct Auth {
        // Login
        static let emailLabel = "이메일"
        static let passwordLabel = "비밀번호"
        static let emailPlaceholder = "이메일 입력"
        static let passwordPlaceholder = "비밀번호 입력"
        static let loginButton = "로그인"
        static let loginButtonLoading = "로그인 중..."
        static let needAccount = "계정이 없으신가요?"
        static let signUpLink = "회원가입"
        static let signUpDo = "하기"
        
        // SignUp
        static let nameLabel = "이름"
        static let branchLabel = "지점"
        static let positionLabel = "직급"
        static let passwordCheckLabel = "비밀번호 확인"
        static let namePlaceholder = "이름 입력"
        static let branchPlaceholder = "지점 입력"
        static let positionPlaceholder = "직급 입력"
        static let passwordCheckPlaceholder = "비밀번호 확인 입력"
        static let signUpButton = "회원가입"
        static let signUpButtonLoading = "회원가입 중..."
        static let back = "뒤로"
        
        // Validation Messages
        static func fieldRequired(_ field: String) -> String {
            return "\(field)을(를) 입력해주세요."
        }
        static let emailRequired = "이메일을 입력해주세요."
        static let emailInvalid = "올바른 이메일 형식이 아닙니다."
        static let passwordRequired = "비밀번호를 입력해주세요."
        static let passwordTooShort = "비밀번호는 8자 이상이어야 합니다."
        static let passwordInvalid = "비밀번호는 영문과 숫자를 포함해야 합니다."
        static let passwordCheckRequired = "비밀번호 확인을 입력해주세요."
        static let passwordCheckMismatch = "비밀번호가 일치하지 않습니다."
    }
}
