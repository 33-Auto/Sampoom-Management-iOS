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
            .onChange(of: viewModel.uiState.updateError) { _, newValue in
                handleUpdateError(newValue)
            }
            .alert(StringResources.PartDetail.confirmOutboundTitle, isPresented: $showOutboundDialog) {
                Button(StringResources.Common.ok) { addToOutbound() }
                Button(StringResources.Common.cancel, role: .cancel) { }
            } message: {
                Text(StringResources.PartDetail.confirmOutboundMessage)
            }
            .alert(StringResources.PartDetail.confirmCartTitle, isPresented: $showCartDialog) {
                Button(StringResources.Common.ok) { addToCart() }
                Button(StringResources.Common.cancel, role: .cancel) { }
            } message: {
                Text(StringResources.PartDetail.confirmCartMessage)
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
            .navigationTitle(StringResources.PartDetail.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(StringResources.Navigation.close) { viewModel.onEvent(.dismiss) }
                }
            }
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
            Toast.text(StringResources.PartDetail.outboundSuccess).show()
            showOutboundDialog = false
            viewModel.clearSuccess()
        }
    }
    
    private func handleCartSuccess(_ newValue: Bool) {
        if newValue {
            Toast.text(StringResources.PartDetail.cartSuccess).show()
            showCartDialog = false
            viewModel.clearSuccess()
        }
    }
    
    private func handleUpdateError(_ newValue: String?) {
        if let error = newValue {
            Toast.text("\(StringResources.PartDetail.errorOccurred): \(error)").show()
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
            CommonButton(StringResources.PartDetail.addToOutbound, customIcon: "outbound", backgroundColor: .red, textColor: .white) {
                addOutboundAction()
            }
            .disabled(isDisabled)

            CommonButton(StringResources.PartDetail.addToCart, customIcon: "cart", backgroundColor: .blue, textColor: .white) {
                addCartAction()
            }
            .disabled(isDisabled)
        }
    }
}
