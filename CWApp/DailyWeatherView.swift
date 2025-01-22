//
//  DailyWeatherView.swift
//  CWApp
//
//  Created by Thuan Naheem Pakeer on 2024-12-29.
//

import MapKit
import SwiftUI

struct WeatherDTO: Codable {
    let current: CurrentWeather
    let hourly: [HourlyWeather]
    let daily: [DailyWeather]

    struct CurrentWeather: Codable {
        let temp: Double
        let humidity: Int
        let weather: [Weather]
    }

    struct HourlyWeather: Codable, Identifiable {
        var id: Int { dt }
        let dt: Int
        let temp: Double
        let weather: [Weather]
    }

    struct DailyWeather: Codable, Identifiable {
        var id: Int { dt }
        let dt: Int
        let temp: Temp
        let weather: [Weather]
        let humidity: Int

        struct Temp: Codable {
            let day: Double
            let min: Double
            let max: Double
        }
    }

    struct Weather: Codable {
        let main: String
        let description: String
        let icon: String
    }
}

struct DailyWeatherView: View {
    @Binding var searchedCity: City
    @State private var weatherData: WeatherDTO? = nil
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    let apiKey = ""

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.50, green: 0.55, blue: 0.75),
                    Color(red: 0.40, green: 0.45, blue: 0.65),
                    Color(red: 0.30, green: 0.35, blue: 0.55),
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                SearchView(searchedCity: $searchedCity)
                    .padding(.vertical)
                    .foregroundStyle(.black)

                if isLoading {
                    ProgressView("Loading...")
                } else {
                    if weatherData == nil {
                        Text("No weather data available")
                            .foregroundColor(.red)
                    }
                    VStack {
                        VStack {
                            HStack {
                                Image(systemName: "calendar")
                                Text("\(searchedCity.name) HOURLY FORECAST")
                                    .textCase(.uppercase)
                            }
                            .padding(.top)
                            .font(.headline)
                            .opacity(0.6)

                            Divider()
                                .background(Color.white.opacity(0.8))

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 23) {
                                    ForEach(
                                        weatherData?.hourly.prefix(24) ?? []
                                    ) { forecast in
                                        hourlyWeatherItem(forecast: forecast)
                                            .padding()
                                    }
                                }
                                .padding(.leading)
                                .padding(.bottom)
                            }
                        }
                        .background(
                            Color(red: 0.18, green: 0.22, blue: 0.48).opacity(
                                0.5)
                        )
                        .cornerRadius(12)

                        VStack {
                            HStack {
                                Image(systemName: "calendar")
                                Text("\(searchedCity.name) 5-DAY FORECAST")
                                    .textCase(.uppercase)
                            }
                            .padding(.top)
                            .font(.headline)
                            .opacity(0.6)

                            ForEach(weatherData?.daily.prefix(5) ?? []) {
                                forecast in
                                Divider()
                                    .background(Color.white.opacity(0.8))

                                dailyForecastRow(forecast: forecast)
                                    .padding(18)
                            }
                        }
                        .background(
                            Color(red: 0.18, green: 0.22, blue: 0.48).opacity(
                                0.5)
                        )
                        .cornerRadius(12)
                        .padding(.top, 4)
                    }
                    .padding()
                }

                Spacer()
            }
            .foregroundStyle(.white)
        }
        .task {
            await fetchWeatherData()
        }
        .onChange(of: searchedCity) {
            Task {
                await fetchWeatherData()
            }
        }
    }

    private func hourlyWeatherItem(forecast: WeatherDTO.HourlyWeather)
        -> some View
    {
        VStack(spacing: 10) {
            Text(formatHourFromTimestamp(forecast.dt))
                .fontWeight(.bold)

            Image(
                systemName: getWeatherIcon(
                    for: forecast.weather.first?.icon ?? "")
            )
            .frame(width: 30, height: 30)

            Text("\(Int(round(forecast.temp)))°")
                .fontWeight(.bold)
        }
    }

    private func dailyForecastRow(forecast: WeatherDTO.DailyWeather)
        -> some View
    {
        let maxTemp = forecast.temp.max
        let averageTemp = forecast.temp.day
        let progressValue = averageTemp / maxTemp

        return HStack(spacing: 40) {
            Text(formatDayFromTimestamp(forecast.dt))
                .fontWeight(.bold)
                .font(.body)

            Image(
                systemName: getWeatherIcon(
                    for: forecast.weather.first?.icon ?? "")
            )
            .frame(width: 30, height: 30)

            HStack {
                Text("\(Int(round(forecast.temp.min)))°")
                    .foregroundStyle(.white.opacity(0.4))
                    .fontWeight(.bold)
                    .font(.body)

                ProgressView(value: progressValue, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: .orange))
                    .frame(width: 40)

                Text("\(Int(round(forecast.temp.max)))°")
                    .fontWeight(.bold)
                    .font(.body)
            }
            .frame(maxWidth: 120)
        }
    }

    private func fetchWeatherData() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        let coordinate = searchedCity.coordinate

        guard
            let url = URL(
                string:
                    "https://api.openweathermap.org/data/3.0/onecall?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&units=metric&appid=\(apiKey)"
            )
        else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200
            else {
                errorMessage = "Failed to fetch weather data"
                isLoading = false
                return
            }

            guard httpResponse.statusCode == 200 else {
                errorMessage =
                    "Failed to fetch weather data: Status \(httpResponse.statusCode)"
                isLoading = false
                return
            }

            let decodedData = try JSONDecoder().decode(
                WeatherDTO.self, from: data)
            self.weatherData = decodedData
            isLoading = false

        } catch {
            errorMessage = "Error: \(error.localizedDescription)"
            isLoading = false
        }
    }

    private func formatHourFromTimestamp(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        return formatter.string(from: date)
    }

    private func formatDayFromTimestamp(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }

    private func formatDateForGrouping(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    private func getWeatherIcon(for iconCode: String) -> String {
        switch iconCode {
        case "01d", "01n": return "sun.max.fill"
        case "02d", "02n": return "cloud.sun.fill"
        case "03d", "03n": return "cloud.fill"
        case "04d", "04n": return "cloud.fill"
        case "09d", "09n": return "cloud.rain.fill"
        case "10d", "10n": return "cloud.heavyrain.fill"
        case "11d", "11n": return "cloud.bolt.fill"
        case "13d", "13n": return "snow"
        case "50d", "50n": return "cloud.fog.fill"
        default: return "cloud.fill"
        }
    }
}
