//
//  CWAppApp.swift
//  CWApp
//
//  Created by Thuan Naheem Pakeer on 2024-12-18.
//

import SwiftUI

@main
struct CWAppApp: App {
    @StateObject var viewModel = ViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
