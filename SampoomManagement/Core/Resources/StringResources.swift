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
    
    // MARK: - Dashboard
    struct Dashboard {
        static let greetingPrefix = "안녕하세요, "
        static let greetingSuffix = " 님"
        static let intro = "오늘도 효율적인 재고 관리를 시작해보세요."
        static let employee = "직원 관리"
        static let partsOnHand = "보유 부품"
        static let partsInProgress = "진행중 부품"
        static let shortageOfParts = "부족 부품"
        static let orderAmount = "주문 금액"
        static let recentOrdersTitle = "최근 주문"
        static let weeklySummaryTitle = "이번 주 요약"
        static let weeklySummaryInStock = "입고 부품"
        static let weeklySummaryOutStock = "출고 부품"
    }

    // MARK: - Tabs
    struct Tabs {
        static let dashboard = "대시보드"
        static let outbound = "출고목록"
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
        static let confirm = "확인"
        static let cancel = "취소"
        static let save = "저장"
        static let delete = "삭제"
        static let edit = "편집"
        static let done = "완료"
        static let error = "오류"
        static let retry = "다시 시도"
        static let loadMore = "더 보기"
        static let close = "닫기"
        static let detail = "상세 보기"
        static let EA = "EA"
        static let slash = "-"
    }
    
    // MARK: - Search
    struct SearchParts {
        static let title = "검색"
        static let placeholder = "부품 검색"
        static let emptyMessage = "검색 결과가 없습니다"
        static let loadingMessage = "검색 중..."
    }
    
    // MARK: - Outbound
    struct Outbound {
        static let title = "출고목록"
        static let emptyAll = "비우기"
        static let processOrder = "부품 출고처리"
        static let orderSuccess = "출고 주문 성공"
        static let updateQuantityError = "수량 업데이트 에러"
        static let deleteError = "삭제 에러"
        static let confirmProcessTitle = "출고 확인"
        static let confirmProcessMessage = "선택하신 부품들을 출고 처리하시겠습니까?"
        static let confirmEmptyTitle = "전체 삭제"
        static let confirmEmptyMessage = "출고 목록을 모두 삭제하시겠습니까?"
        static let deleteItemHint = "이 항목을 출고 목록에서 삭제합니다"
    }
    
    // MARK: - Cart
    struct Cart {
        static let title = "장바구니"
        static let emptyAll = "비우기"
        static let processOrder = "부품 주문"
        static let orderSuccess = "주문이 완료되었습니다"
        static let updateQuantityError = "수량 업데이트 에러"
        static let deleteError = "삭제 에러"
        static let confirmProcessTitle = "주문 확인"
        static let confirmProcessMessage = "선택하신 부품을 주문하시겠습니까?"
        static let confirmEmptyTitle = "장바구니 비우기"
        static let confirmEmptyMessage = "장바구니를 비우시겠습니까?"
        static let emptyMessage = "장바구니가 비어있습니다"
        static let deleteItemHint = "이 항목을 장바구니에서 삭제합니다"
    }
    
    // MARK: - PartDetail
    struct PartDetail {
        static let title = "부품 상세"
        static let currentQuantity = "현재 수량"
        static let quantity = "수량"
        static let addToOutbound = "출고 추가"
        static let addToCart = "장바구니 추가"
        static let outboundSuccess = "출고 목록에 추가되었습니다"
        static let cartSuccess = "장바구니 목록에 추가되었습니다"
        static let errorOccurred = "에러 발생"
        static let confirmOutboundTitle = "출고 확인"
        static let confirmOutboundMessage = "출고 목록에 추가하시겠습니까?"
        static let confirmCartTitle = "장바구니 확인"
        static let confirmCartMessage = "장바구니 목록에 추가하시겠습니까?"
    }
    
    // MARK: - Part
    struct Part {
        static let quantity = "수량"
        static let selectCategory = "카테고리 선택"
        static let selectCategoryPrompt = "카테고리를 선택해주세요"
        static let selectGroup = "그룹 선택"
        static let emptyPart = "부품 목록이 없습니다."
    }
    
    // MARK: - Order
    struct Order {
        static let title = "주문관리"
        static let emptyList = "주문관리 목록이 없습니다."
        static let detailTitle = "주문정보"
        static let detailOrderNumber = "주문번호"
        static let detailOrderDate = "주문일자"
        static let detailOrderAgency = "대리점"
        static let detailOrderStatus = "주문상태"
        static let detailOrderItemsTitle = "주문상품"
        static let detailOrderCancel = "주문취소"
        static let detailDialogOrderCancel = "주문 취소처리하시겠습니까?"
        static let detailToastOrderCancel = "주문 취소처리되었습니다"
        static let detailOrderReceive = "입고처리"
        static let detailDialogOrderReceive = "입고 처리하시겠습니까?"
        static let detailToastOrderReceive = "입고 처리되었습니다"
        static let detailTotalAmount = "총 가격"
        
        // Order Status
        static let statusPending = "대기중"
        static let statusConfirmed = "주문확인"
        static let statusShipping = "배송중"
        static let statusDelayed = "배송지연"
        static let statusProducing = "생산중"
        static let statusArrived = "배송완료"
        static let statusCompleted = "입고완료"
        static let statusCanceled = "주문취소"
    }
    
    // MARK: - Setting
    struct Setting {
        static let title = "설정"
        static let editProfile = "프로필 수정"
        static let editProfilePlaceholderUsername = "이름 입력"
        static let editProfileEdited = "프로필 수정이 완료되었습니다."
        static let logout = "로그아웃"
        static let logoutTitle = "로그아웃"
        static let dialogLogout = "로그아웃 하시겠습니까?"
        static let userNotFound = "사용자 정보를 찾을 수 없습니다"
    }
    
    // MARK: - Employee
    struct Employee {
        static let title = "직원관리"
        static let emptyEmployee = "직원이 없습니다."
        static let email = "이메일"
        static let startedAt = "가입일"
        static let delete = "삭제"
        static let edit = "수정"
        static let editTitle = "직원 수정"
        static let positionLabel = "직급"
        static let editEdited = "직원 수정이 완료되었습니다."
        static let editDeleted = "직원 삭제가 완료되었습니다."
        static let statusLabel = "재직상태"
        static let statusEdit = "재직상태 변경"
        static let positionEdit = "직급 변경"
        static let editStatusEdited = "직원 상태 수정이 완료되었습니다."
        static let statusActive = "재직"
        static let statusLeave = "휴직"
        static let statusRetired = "퇴직"
        static let employeeNotFound = "직원 정보를 찾을 수 없습니다"
        static let userNotFound = "사용자 정보를 찾을 수 없습니다"
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
        static let logoutButton = "로그아웃"
        
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
            return "\(field)을(를) 입력해주세요"
        }
        static let emailRequired = "이메일을 입력해주세요"
        static let emailInvalid = "올바른 이메일 형식이 아닙니다"
        static let passwordRequired = "비밀번호를 입력해주세요"
        static let passwordTooShort = "비밀번호는 최소 8자 이상이어야 합니다"
        static let passwordMaxLength = "비밀번호는 최대 30자까지 가능합니다"
        static let passwordComplexity = "영문, 숫자, 특수문자를 각각 1개 이상 포함해야 합니다"
        static let passwordInvalid = "비밀번호는 영문과 숫자를 포함해야 합니다."
        static let passwordCheckRequired = "비밀번호 확인을 입력해주세요"
        static let passwordCheckMismatch = "비밀번호가 일치하지 않습니다"
    }
}
