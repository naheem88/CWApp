//
//  SelectedCountryView.swift
//  CWApp
//
//  Created by Thuan Naheem Pakeer on 2024-12-23.
//

import SwiftUI

struct SelectedCountryView: View {
    @Binding var selectedCity: City?

    var body: some View {
            
            ScrollView (showsIndicators: false) {
                VStack {
                    Text("Colombo")
                        .font(.largeTitle)
                    Text("29°")
                        .font(.system(size: 80, weight: .light))
                        .padding(.leading, 24)
                    Text("Cloudy")
                        .padding(.trailing, 1)
                        .padding(.bottom, 1)
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
                        .background(Color.white.opacity(0.8))
                        .padding()
                    
                    ScrollView (.horizontal, showsIndicators: false) {
                        HStack (spacing: 23) {
                            ForEach(0..<24, id: \.self) { _ in
                                hourlyWeatherItem
                            }
                        }
                        .padding(.leading)
                        .padding(.bottom)
                    }
                }
                .background(Color(red: 0.18, green: 0.22, blue: 0.48).opacity(0.5))
                .cornerRadius(10)
                
                VStack {
                    HStack {
                        Image(systemName: "calendar")
                        Text("10-DAY FORECAST")
                    }
                    .padding(.top)
                    .padding(.trailing, 160)
                    .font(.system(size: 16, weight: .bold))
                    .opacity(0.6)
                    
                    Divider()
                        .background(Color.white.opacity(0.8))
                        .padding(.horizontal)
                    
                    ForEach(0..<10, id: \.self) { _ in
                        dailyForecastRow
                            .padding(2)
                        Divider()
                            .background(Color.white.opacity(0.8))
                            .padding(.horizontal)
                    }
                }
                .background(Color(red: 0.18, green: 0.22, blue: 0.48).opacity(0.5))
                .cornerRadius(10)
                .padding(.top, 4)
                
                HStack {
                    additionalCard(title: "WIND SPEED",
                                   imgName: "wind",
                                   value: "75%")
                    additionalCard(title: "HUMIDITY",
                                   imgName: "humidity",
                                   value: "75%")
                }
                .padding(.top, 4)
                
            }
            .padding()
            .foregroundStyle(.white)
            .font(.system(size: 18))
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
    
    private func additionalCard(title: String, imgName: String, value: String) -> some View {
        VStack {
            HStack {
                Image(systemName: imgName)
                Text("\(title)")
            }
            .padding(.vertical, 8)
            .padding(.trailing, 24)
            .font(.system(size: 16, weight: .bold))
            .opacity(0.6)
                    
            
            Text("\(value)")
                .font(.system(size: 24, weight: .bold))
                .padding(.trailing, 88)
            
            Spacer()
        }
        .frame(width: 180, height: 140)
        .background(Color(red: 0.18, green: 0.22, blue: 0.48).opacity(0.5))
        .cornerRadius(10)
    }
}


#Preview {
    SelectedCountryView(selectedCity: .constant(City.bristol))
}
