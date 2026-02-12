//
//  WeatherData.swift
//  WeatherTestApp for LinaID
//
//  Created by Andrey Kaldyaev on 12.02.2026.
//

import Foundation

struct CurrentWeather {
    let temp: Double
    let pressure: Int?
    let humidity: Int?
    let visibility: Int?
    let clouds: Int?
    let description: String?

    init?(from dict: [String: Any]) {
        guard let t = dict["temp"] as? NSNumber else { return nil }
        temp = t.doubleValue
        pressure = (dict["pressure"] as? NSNumber).map { $0.intValue }
        humidity = (dict["humidity"] as? NSNumber).map { $0.intValue }
        visibility = (dict["visibility"] as? NSNumber).map { $0.intValue }
        clouds = (dict["clouds"] as? NSNumber).map { $0.intValue }
        description = dict["description"] as? String
    }
}

struct DayForecast: Identifiable {
    var id: TimeInterval { dt }
    let dt: TimeInterval
    let tempDay: Double?
    let pressure: Int?
    let humidity: Int?
    let visibility: Int?
    let clouds: Int?
    let description: String?

    init?(from dict: [String: Any]) {
        guard let d = dict["dt"] as? NSNumber else { return nil }
        dt = d.doubleValue
        tempDay = (dict["temp_day"] as? NSNumber)?.doubleValue
        pressure = (dict["pressure"] as? NSNumber).map { $0.intValue }
        humidity = (dict["humidity"] as? NSNumber).map { $0.intValue }
        visibility = (dict["visibility"] as? NSNumber).map { $0.intValue }
        clouds = (dict["clouds"] as? NSNumber).map { $0.intValue }
        description = dict["description"] as? String
    }

    var date: Date { Date(timeIntervalSince1970: dt) }
}

struct OneCallParsed {
    let current: CurrentWeather?
    let daily: [DayForecast]
    let timezone: String?

    init?(from dict: [String: Any]) {
        if let cur = dict["current"] as? [String: Any] {
            current = CurrentWeather(from: cur)
        } else {
            current = nil
        }
        let dailyDicts = dict["daily"] as? [[String: Any]] ?? []
        daily = dailyDicts.compactMap { DayForecast(from: $0) }
        timezone = dict["timezone"] as? String
    }
}
