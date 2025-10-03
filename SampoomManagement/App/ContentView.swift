//
//  ContentView.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var partViewModel: PartViewModel
    
    init() {
        // DI Container에서 ViewModel 주입
        guard let viewModel = DIContainer.shared.resolve(PartViewModel.self) else {
            fatalError("PartViewModel을 DIContainer에서 찾을 수 없습니다.")
        }
        _partViewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            PartView()
                .environmentObject(partViewModel)
        }
    }
}
