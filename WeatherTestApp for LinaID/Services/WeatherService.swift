//
//  WeatherService.swift
//  WeatherTestApp for LinaID
//
//  Created by Andrey Kaldyaev on 12.02.2026.
//

import Foundation

enum WeatherError: Error, LocalizedError {
    case invalidURL
    case noData
    case geocodingFailed(String)
    case parseError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Некорректный URL"
        case .noData: return "Пустой ответ сервера"
        case .geocodingFailed(let city): return "Не удалось определить координаты для \(city)"
        case .parseError(let err): return err.localizedDescription
        }
    }
}

final class WeatherService {
    private let oneCallBase = "https://api.openweathermap.org/data/3.0/onecall"
    private let geocodingBase = "https://api.openweathermap.org/geo/1.0/direct"
    private let apiKey: String
    private let session: URLSession

    init(apiKey: String, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }
    
    func fetchWeather(for city: City) async throws -> OneCallParsed {
        let location = try await fetchCoordinates(query: city.queryName)
        return try await fetchWeather(lat: location.lat, lon: location.lon)
    }

    func fetchCoordinates(query: String) async throws -> GeoLocation {
        var components = URLComponents(string: geocodingBase)!
        components.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "limit", value: "1"),
            URLQueryItem(name: "appid", value: apiKey),
        ]
        guard let url = components.url else { throw WeatherError.invalidURL }

        let (data, _) = try await session.data(from: url)
        guard let jsonString = String(data: data, encoding: .utf8),
              !jsonString.isEmpty else {
            throw WeatherError.geocodingFailed(query)
        }

        guard let array = try JSONSerialization.jsonObject(with: data) as? [[String: Any]],
              let first = array.first,
              let lat = first["lat"] as? Double,
              let lon = first["lon"] as? Double else {
            throw WeatherError.geocodingFailed(query)
        }
        return GeoLocation(lat: lat, lon: lon)
    }

    func fetchWeather(lat: Double, lon: Double) async throws -> OneCallParsed {
        var components = URLComponents(string: oneCallBase)!
        components.queryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: apiKey),
        ]
        guard let url = components.url else { throw WeatherError.invalidURL }

        let (data, _) = try await session.data(from: url)
        guard let jsonString = String(data: data, encoding: .utf8) else { throw WeatherError.noData }

        let dict: [String: Any]?
        do {
            dict = try WeatherJSONParser.parseOneCallResponse(withJSONString: jsonString) as? [String: Any]
        } catch {
            throw WeatherError.parseError(error)
        }
        guard let dict = dict, let parsed = OneCallParsed(from: dict) else {
            throw WeatherError.parseError(
                NSError(domain: "WeatherService", code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Parse failed"])
            )
        }
        return parsed
    }
}
