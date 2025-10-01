//
//  ContentView.swift
//  SampoomManagement
//
//  Created by 채상윤 on 9/29/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var partViewModel = PartViewFactory.createViewModel()
    
    var body: some View {
        NavigationView {
            PartView()
                .environmentObject(partViewModel)
        }
    }
}
