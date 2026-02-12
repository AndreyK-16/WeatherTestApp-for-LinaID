//
//  WeatherDataTests.swift
//  WeatherTestApp for LinaIDTests
//

import XCTest
@testable import WeatherTestApp_for_LinaID

final class WeatherDataTests: XCTestCase {

    func testCurrentWeatherFromDict() {
        let dict: [String: Any] = [
            "temp": 15.5,
            "pressure": 1013,
            "humidity": 70,
            "visibility": 10000,
            "clouds": 20,
            "description": "clear sky",
        ]
        let current = CurrentWeather(from: dict)
        XCTAssertNotNil(current)
        XCTAssertEqual(current?.temp, 15.5)
        XCTAssertEqual(current?.pressure, 1013)
        XCTAssertEqual(current?.humidity, 70)
        XCTAssertEqual(current?.visibility, 10000)
        XCTAssertEqual(current?.clouds, 20)
        XCTAssertEqual(current?.description, "clear sky")
    }

    func testCurrentWeatherRequiresTemp() {
        XCTAssertNil(CurrentWeather(from: ["pressure": 1013]))
        XCTAssertNotNil(CurrentWeather(from: ["temp": 0]))
    }

    func testDayForecastFromDict() {
        let dict: [String: Any] = [
            "dt": 1640000000.0,
            "temp_day": 12.0,
            "pressure": 1020,
            "humidity": 65,
            "clouds": 30,
            "description": "few clouds",
        ]
        let day = DayForecast(from: dict)
        XCTAssertNotNil(day)
        XCTAssertEqual(day?.dt, 1640000000.0)
        XCTAssertEqual(day?.tempDay, 12.0)
        XCTAssertEqual(day?.pressure, 1020)
        XCTAssertEqual(day?.humidity, 65)
        XCTAssertEqual(day?.clouds, 30)
        XCTAssertEqual(day?.description, "few clouds")
    }

    func testDayForecastRequiresDt() {
        XCTAssertNil(DayForecast(from: ["temp_day": 10]))
    }

    func testOneCallParsedFromDict() {
        let dict: [String: Any] = [
            "current": ["temp": 10.0],
            "daily": [
                ["dt": 1640000000.0, "temp_day": 11.0],
            ],
            "timezone": "Europe/Moscow",
        ]
        let parsed = OneCallParsed(from: dict)
        XCTAssertNotNil(parsed)
        XCTAssertEqual(parsed?.current?.temp, 10.0)
        XCTAssertEqual(parsed?.daily.count, 1)
        XCTAssertEqual(parsed?.daily.first?.tempDay, 11.0)
        XCTAssertEqual(parsed?.timezone, "Europe/Moscow")
    }

    func testCityCapitalsCount() {
        XCTAssertEqual(City.capitals.count, 5)
    }

    func testCityIdsUnique() {
        let ids = Set(City.capitals.map(\.id))
        XCTAssertEqual(ids.count, 5)
    }
}
