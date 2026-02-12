//
//  WeatherListViewModel.swift
//  WeatherTestApp for LinaID
//
//  Created by Andrey Kaldyaev on 12.02.2026.
//

import Foundation

@MainActor
final class WeatherListViewModel: ObservableObject {
    @Published var cityWeather: [City: OneCallParsed] = [:]
    @Published var loadingCityId: String? = nil
    @Published var errorMessage: String? = nil

    private let service: WeatherService

    init(apiKey: String) {
        self.service = WeatherService(apiKey: apiKey)
    }

    func loadAll() async {
        for city in City.capitals {
            await load(city: city)
        }
    }

    func load(city: City) async {
        loadingCityId = city.id
        errorMessage = nil
        do {
            let parsed = try await service.fetchWeather(for: city)
            cityWeather[city] = parsed
        } catch {
            errorMessage = "\(city.name): \(error.localizedDescription)"
        }
        loadingCityId = nil
    }

    func weather(for city: City) -> OneCallParsed? {
        cityWeather[city]
    }

    func isRefreshing(_ city: City) -> Bool {
        loadingCityId == city.id
    }
}
