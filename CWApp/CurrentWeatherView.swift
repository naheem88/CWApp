//
//  CurrentWeatherView.swift
//  CWApp
//
//  Created by Thuan Naheem Pakeer on 2024-12-23.
//

import SwiftUI

struct CurrentWeatherDTO: Codable {
    let current: Current
    let daily: [Daily]
    let timezone_offset: Int

    struct Current: Codable {
        let dt: Int
        let temp: Double
        let humidity: Int
        let pressure: Int
        let windSpeed: Double
        let weather: [Weather]
        let rain: Rain?

        enum CodingKeys: String, CodingKey {
            case dt, temp, humidity, pressure, weather, rain
            case windSpeed = "wind_speed"
        }
    }

    struct Daily: Codable {
        let dt: Int
        let temp: Temperature
        let weather: [Weather]

        struct Temperature: Codable {
            let min: Double
            let max: Double
        }
    }

    struct Weather: Codable {
        let main: String
        let description: String
        let icon: String
    }

    struct Rain: Codable {
        let oneHour: Double?

        enum CodingKeys: String, CodingKey {
            case oneHour = "1h"
        }
    }
}

struct AirPollutionDTO: Codable {
    struct Components: Codable {
        let co: Double
        let no: Double
        let no2: Double
        let o3: Double
        let so2: Double
        let nh3: Double
    }

    let list: [PollutionData]

    struct PollutionData: Codable {
        let dt: Int
        let main: Main
        let components: Components

        struct Main: Codable {
            let aqi: Int
        }
    }
}

struct CurrentWeatherView: View {
    @Binding var searchedCity: City
    @State private var weatherData: CurrentWeatherDTO? = nil
    @State private var airPollutionData: AirPollutionDTO? = nil
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    let apiKey = ""
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()

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
                    .foregroundColor(.black)

                if isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else if let weatherData = weatherData {
                    VStack {
                        Text(searchedCity.name)
                            .font(.largeTitle)

                        Text("\(Int(weatherData.current.temp))°")
                            .font(.system(size: 80, weight: .light))
                            .padding(.leading, 24)
                        Text(
                            weatherData.current.weather.first?.main ?? "Unknown"
                        )
                        .padding(.trailing, 1)
                        .padding(.bottom, 1)
                        HStack {
                            if let firstForecast = weatherData.daily.first {
                                HStack {
                                    Text("H: \(Int(firstForecast.temp.max))°")
                                    Text("L: \(Int(firstForecast.temp.min))°")
                                }
                            }
                        }

                        HStack(spacing: 4) {
                            Text(dateFormatter.string(from: getCityTime()))
                            Text(timeFormatter.string(from: getCityTime()))
                        }
                        .font(.body)
                        .fontWeight(.medium)

                    }
                    .padding(.bottom)

                    HStack {
                        additionalCard(
                            title: "WIND SPEED",
                            imgName: "wind",
                            value: "\(Int(weatherData.current.windSpeed)) km/h"
                        )
                        additionalCard(
                            title: "HUMIDITY",
                            imgName: "humidity",
                            value: "\(weatherData.current.humidity)%"
                        )
                    }
                    .padding(.top, 4)

                    HStack {
                        additionalCard(
                            title: "PRESSURE",
                            imgName: "gauge",
                            value: "\(weatherData.current.pressure) hPa"
                        )
                        additionalCard(
                            title: "PRECIPITATION",
                            imgName: "cloud.rain",
                            value: weatherData.current.rain?.oneHour != nil
                                ? "\(weatherData.current.rain!.oneHour!) mm"
                                : "0 mm"
                        )
                    }
                    .padding(.top, 2)

                    Spacer()

                    if let pollutionData = airPollutionData?.list.first {
                        VStack(alignment: .center) {
                            Text("Air Quality in \(searchedCity.name)")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.vertical)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    additionalCard(
                                        title: "CO",
                                        imgName: "aqi.low",
                                        value:
                                            "\(pollutionData.components.co) µg/m³"
                                    )
                                    additionalCard(
                                        title: "NO",
                                        imgName: "aqi.medium",
                                        value:
                                            "\(pollutionData.components.no) µg/m³"
                                    )
                                    additionalCard(
                                        title: "NO₂",
                                        imgName: "aqi.medium",
                                        value:
                                            "\(pollutionData.components.no2) µg/m³"
                                    )
                                    additionalCard(
                                        title: "O₃",
                                        imgName: "aqi.medium",
                                        value:
                                            "\(pollutionData.components.o3) µg/m³"
                                    )
                                    additionalCard(
                                        title: "SO₂",
                                        imgName: "aqi.low",
                                        value:
                                            "\(pollutionData.components.so2) µg/m³"
                                    )
                                    additionalCard(
                                        title: "NH₃",
                                        imgName: "aqi.medium",
                                        value:
                                            "\(pollutionData.components.nh3) µg/m³"
                                    )
                                }
                            }
                        }
                        .padding(.top, 10)
                        .padding(.horizontal)
                    }
                }
            }
        }
        .foregroundStyle(.white)
        .font(.body)
        .onAppear {
            Task {
                await fetchWeatherData()
                await fetchAirPollutionData()
            }
        }
        .onChange(of: searchedCity) {
            Task {
                await fetchWeatherData()
                await fetchAirPollutionData()
            }
        }
    }

    private func additionalCard(title: String, imgName: String, value: String)
        -> some View
    {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: imgName)
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .opacity(0.6)
            }
            .padding(.top, 8)

            Text(value)
                .font(.system(size: 24, weight: .bold))
                .lineLimit(1)

            Spacer()
        }
        .frame(width: 180, height: 100)
        .background(Color(red: 0.18, green: 0.22, blue: 0.48).opacity(0.5))
        .cornerRadius(12)
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

            let decodedData = try JSONDecoder().decode(
                CurrentWeatherDTO.self, from: data)
            weatherData = decodedData
            isLoading = false
        } catch {
            errorMessage = "Error: \(error.localizedDescription)"
            isLoading = false
        }
    }

    private func fetchAirPollutionData() async {
        guard !isLoading else { return }

        let coordinate = searchedCity.coordinate

        guard
            let url = URL(
                string:
                    "https://api.openweathermap.org/data/2.5/air_pollution?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appid=\(apiKey)"
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
                errorMessage = "Failed to fetch air pollution data"
                isLoading = false
                return
            }

            let decodedData = try JSONDecoder().decode(
                AirPollutionDTO.self, from: data)
            airPollutionData = decodedData
        } catch {
            errorMessage = "Error: \(error.localizedDescription)"
            isLoading = false
        }
    }

    private func getCityTime() -> Date {
        guard let weatherData = weatherData else { return Date() }

        let offsetFromUTC = TimeInterval(weatherData.timezone_offset)
        let localUTCOffset = TimeInterval(TimeZone.current.secondsFromGMT())

        return Date().addingTimeInterval(offsetFromUTC - localUTCOffset)
    }
}
