//
//  HomeView.swift
//  CWApp
//
//  Created by Thuan Naheem Pakeer on 2024-12-04.
//

import SwiftUI

struct HomeView: View {
    @AppStorage("isDark") var isLightMode: Bool = false
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search for city or airport", text: $searchText)
                }
                .padding(9)
                .background(
                    Color(uiColor: isLightMode ? .systemGray6 : .systemGray4)
                )
                .cornerRadius(10)
                Spacer()
            }
            .padding()
            .navigationBarTitle("Weather")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.title2)
                    }
                }
            }
        }
        .environment(\.colorScheme, isLightMode ? .light : .dark)
        .background(.blue)
    }
}

#Preview {
    HomeView()
}
