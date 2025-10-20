import SwiftUI
import Toast

struct PartDetailBottomSheetView: View {
    @ObservedObject var viewModel: PartDetailViewModel
    @State private var showOutboundDialog = false
    @State private var showCartDialog = false
    @State private var quantityText: String = "1"
    
    private func decreaseQuantity() { viewModel.onEvent(.decreaseQuantity) }
    private func increaseQuantity() { viewModel.onEvent(.increaseQuantity) }
    private func addToOutbound() {
        let id = viewModel.uiState.part?.id ?? 0
        let qty = viewModel.uiState.quantity
        viewModel.onEvent(.addToOutbound(partId: id, quantity: qty))
    }
    private func addToCart() {
        let id = viewModel.uiState.part?.id ?? 0
        let qty = viewModel.uiState.quantity
        viewModel.onEvent(.addToCart(partId: id, quantity: qty))
    }

    private var partName: String { viewModel.uiState.part?.name ?? "N/A" }
    private var partCode: String { viewModel.uiState.part?.code ?? "N/A" }
    private var quantityLabelText: String { "현재 수량: \(viewModel.uiState.part?.quantity ?? 0)EA" }

    var body: some View {
        mainContent
            .onAppear {
                quantityText = String(viewModel.uiState.quantity)
                viewModel.clearSuccess()
            }
            .onChange(of: viewModel.uiState.quantity) { _, newValue in
                handleQuantityChange(newValue)
            }
            .onChange(of: quantityText) { _, newText in
                handleQuantityTextChange(newText)
            }
            .onChange(of: viewModel.uiState.isOutboundSuccess) { _, newValue in
                handleOutboundSuccess(newValue)
            }
            .onChange(of: viewModel.uiState.isCartSuccess) { _, newValue in
                handleCartSuccess(newValue)
            }
            .onChange(of: viewModel.uiState.updateError) { _, newValue in
                handleUpdateError(newValue)
            }
            .alert("출고 확인", isPresented: $showOutboundDialog) {
                Button("확인") { addToOutbound() }
                Button("취소", role: .cancel) { }
            } message: {
                Text("선택하신 부품을 출고 목록에 추가하시겠습니까?")
            }
            .alert("장바구니 확인", isPresented: $showCartDialog) {
                Button("확인") { addToCart() }
                Button("취소", role: .cancel) { }
            } message: {
                Text("선택하신 부품을 장바구니에 추가하시겠습니까?")
            }
    }
    
    private var mainContent: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                PartInfoHeaderView(
                    name: partName,
                    code: partCode,
                    quantityLabel: quantityLabelText
                )

                QuantityControlView(
                    quantityText: $quantityText,
                    decreaseAction: decreaseQuantity,
                    increaseAction: increaseQuantity,
                    isDecreaseDisabled: viewModel.uiState.quantity <= 1 || viewModel.uiState.isUpdating,
                    isIncreaseDisabled: viewModel.uiState.isUpdating
                )

                Spacer()

                ActionButtonsView(
                    addOutboundAction: { showOutboundDialog = true },
                    addCartAction: { showCartDialog = true },
                    isDisabled: viewModel.uiState.isUpdating
                )
            }
            .padding(24)
            .background(Color.background)
//            .navigationTitle("부품 상세")
            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button("닫기") { viewModel.onEvent(.dismiss) }
//                }
//            }
        }
    }
    
    private func handleQuantityChange(_ newValue: Int) {
        if quantityText != String(newValue) {
            quantityText = String(newValue)
        }
    }
    
    private func handleQuantityTextChange(_ newText: String) {
        if let q = Int(newText), q > 0 {
            viewModel.onEvent(.setQuantity(q))
        }
    }
    
    private func handleOutboundSuccess(_ newValue: Bool) {
        if newValue {
            Toast.text("출고 성공!").show()
            showOutboundDialog = false
            viewModel.clearSuccess()
        }
    }
    
    private func handleCartSuccess(_ newValue: Bool) {
        if newValue {
            Toast.text("장바구니 추가 성공!").show()
            showCartDialog = false
            viewModel.clearSuccess()
        }
    }
    
    private func handleUpdateError(_ newValue: String?) {
        if let error = newValue {
            Toast.text("에러 발생: \(error)").show()
            viewModel.onEvent(.clearError)
        }
    }
}

private struct PartInfoHeaderView: View {
    let name: String
    let code: String
    let quantityLabel: String

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name)
                    .font(.gmarketTitle2)
                    .foregroundColor(.text)
                Text(code)
                    .font(.gmarketCaption)
                    .foregroundColor(.textSecondary)
            }
            Spacer()
            Text(quantityLabel)
                .font(.gmarketBody)
                .foregroundColor(.textSecondary)
        }
    }
}

private struct QuantityControlView: View {
    @Binding var quantityText: String
    let decreaseAction: () -> Void
    let increaseAction: () -> Void
    let isDecreaseDisabled: Bool
    let isIncreaseDisabled: Bool

    var body: some View {
        HStack {
            Text("수량")
                .font(.gmarketBody)
                .foregroundColor(.text)
            Spacer()
            HStack {
                CommonButton("-", backgroundColor: .disable, textColor: .text) {
                    decreaseAction()
                }
                .frame(width: 50, height: 44)
                .disabled(isDecreaseDisabled)

                TextField("수량", text: $quantityText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 100)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)

                CommonButton("+", backgroundColor: .disable, textColor: .text) {
                    increaseAction()
                }
                .frame(width: 50, height: 44)
                .disabled(isIncreaseDisabled)
            }
        }
    }
}

private struct ActionButtonsView: View {
    let addOutboundAction: () -> Void
    let addCartAction: () -> Void
    let isDisabled: Bool

    var body: some View {
        HStack {
            CommonButton("출고 추가", customIcon: "outbound", backgroundColor: .red, textColor: .white) {
                addOutboundAction()
            }
            .disabled(isDisabled)

            CommonButton("장바구니 추가", customIcon: "cart", backgroundColor: .blue, textColor: .white) {
                addCartAction()
            }
            .disabled(isDisabled)
        }
    }
}
