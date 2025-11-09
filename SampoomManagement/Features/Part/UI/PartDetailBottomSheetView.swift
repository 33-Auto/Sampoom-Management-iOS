import SwiftUI
import Toast

struct PartDetailBottomSheetView: View {
    @ObservedObject var viewModel: PartDetailViewModel
    @State private var showOutboundDialog = false
    @State private var showCartDialog = false
    @State private var quantityText: String = "1"
    @Environment(\.dismiss) private var dismiss
    
    private func decreaseQuantity() { viewModel.onEvent(.decreaseQuantity) }
    private func increaseQuantity() { viewModel.onEvent(.increaseQuantity) }
    private func addToOutbound() {
        guard let id = viewModel.uiState.part?.id else { return }
        let qty = viewModel.uiState.quantity
        viewModel.onEvent(.addToOutbound(partId: id, quantity: qty))
    }
    private func addToCart() {
        guard let id = viewModel.uiState.part?.id else { return }
        let qty = viewModel.uiState.quantity
        viewModel.onEvent(.addToCart(partId: id, quantity: qty))
    }

    private var partName: String { viewModel.uiState.part?.name ?? "N/A" }
    private var partCode: String { viewModel.uiState.part?.code ?? "N/A" }
    private var partPrice: String { formatWon(viewModel.uiState.part?.standardCost ?? 0) }
    private var quantityLabelText: String { "\(StringResources.PartDetail.currentQuantity): \(viewModel.uiState.part?.quantity ?? 0)EA" }

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
            .alert(StringResources.PartDetail.confirmOutboundTitle, isPresented: $showOutboundDialog) {
                Button(StringResources.Common.ok) { showOutboundDialog = false; addToOutbound() }
                Button(StringResources.Common.cancel, role: .cancel) { }
            } message: {
                Text(StringResources.PartDetail.confirmOutboundMessage)
            }
            .alert(StringResources.PartDetail.confirmCartTitle, isPresented: $showCartDialog) {
                Button(StringResources.Common.ok) { showCartDialog = false; addToCart() }
                Button(StringResources.Common.cancel, role: .cancel) { }
            } message: {
                Text(StringResources.PartDetail.confirmCartMessage)
            }
    }
    
    private var mainContent: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Spacer()
                
                PartInfoHeaderView(
                    name: partName,
                    code: partCode,
                    quantityLabel: quantityLabelText,
                    priceLabel: partPrice
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
            showOutboundDialog = false
            // 성공 상태는 유지하고 바텀시트만 닫음 (메시지는 onDisappear에서 표시)
            dismiss()
        }
    }
    
    private func handleCartSuccess(_ newValue: Bool) {
        if newValue {
            showCartDialog = false
            // 성공 상태는 유지하고 바텀시트만 닫음 (메시지는 onDisappear에서 표시)
            dismiss()
        }
    }
}

private struct PartInfoHeaderView: View {
    let name: String
    let code: String
    let quantityLabel: String
    let priceLabel: String

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
            VStack(alignment: .trailing, spacing: 4) {
                Text(priceLabel)
                    .font(.gmarketTitle3)
                    .foregroundColor(.text)
                Text(quantityLabel)
                    .font(.gmarketBody)
                    .foregroundColor(.textSecondary)
            }
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
            Text(StringResources.PartDetail.quantity)
                .font(.gmarketBody)
                .foregroundColor(.text)
            Spacer()
            HStack {
                CommonButton("-", backgroundColor: .disable, textColor: .text) {
                    decreaseAction()
                }
                .frame(width: 50, height: 44)
                .disabled(isDecreaseDisabled)

                TextField(StringResources.Part.quantity, text: $quantityText)
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
            CommonButton(StringResources.PartDetail.addToOutbound, type: .secondary, customIcon: "outbound") {
                addOutboundAction()
            }
            .disabled(isDisabled)
            
            CommonButton(StringResources.PartDetail.addToCart, type: .filled, customIcon: "cart") {
                addCartAction()
            }
            .disabled(isDisabled)
        }
    }
}
