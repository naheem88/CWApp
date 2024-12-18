//
//  ContentView.swift
//  CWApp
//
//  Created by Thuan Naheem Pakeer on 2024-12-04.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.63, green: 0.80, blue: 0.96), // Light sky blue
                    Color(red: 0.36, green: 0.64, blue: 0.90), // Deeper sky blue
                    Color(red: 0.13, green: 0.46, blue: 0.86)  // Intense blue
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView (.vertical) {
                VStack {
                    Text("My Location")
                        .textCase(.uppercase)
                    Text("Colombo")
                        .font(.largeTitle)
                    Text("29°")
                        .font(.system(size: 80, weight: .light))
                        .padding(.leading)
                    Text("Cloudy")
                    HStack {
                        Text("H:31")
                        Text("L:24")
                    }
                }
                .padding(.bottom)
                
                VStack {
                    Text("Cloudy conditions expected around 17:30. Wind gusts are up to 14km/h.")
                        .padding(.top, 10)
                    
                    Divider()
                    
                    ScrollView (.horizontal) {
                        HStack (spacing: 23) {
                            ForEach(0..<8, id: \.self) { _ in
                                hourlyWeatherItem
                            }
                        }
                        .padding()
                    }
                }
                .background(.blue.opacity(0.6))
                .cornerRadius(10)
                
                VStack {
                    HStack {
                        Image(systemName: "calendar")
                        Text("10-Day Forecast")
                    }
                    .padding(.top)
                    .padding(.trailing, 160)
                    .textCase(.uppercase)
                    .font(.system(size: 16, weight: .bold))
                    .opacity(0.6)
                    
                    Divider()
                    
                    ForEach(0..<10, id: \.self) { _ in
                        dailyForecastRow
                        Divider()
                    }
                }
                .background(.blue.opacity(0.6))
                .cornerRadius(10)
                .padding(.top, 4)
            }
            .padding()
            .foregroundStyle(.white)
            .font(.system(size: 18))
        }
    }
    
    private var hourlyWeatherItem: some View {
        VStack(spacing: 10) {
            Text("Now")
                .fontWeight(.bold)
            
            Image(systemName: "cloud.fill")
            
            Text("27°")
                .fontWeight(.bold)
        }
    }
    
    private var dailyForecastRow: some View {
        HStack(spacing: 60) {
            Text("Today")
                .fontWeight(.bold)
            
            Image(systemName: "cloud.fill")
            
            HStack {
                Text("24°")
                    .foregroundStyle(.white.opacity(0.4))
                    .fontWeight(.bold)
                
                ProgressView(value: 0.5)
                    .progressViewStyle(LinearProgressViewStyle(tint: .orange))
                
                Text("31°")
                    .fontWeight(.bold)
            }
            .frame(maxWidth: 120)
        }
    }
}
