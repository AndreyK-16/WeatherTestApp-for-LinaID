//
//  City.swift
//  WeatherTestApp for LinaID
//
//  Created by Andrey Kaldyaev on 12.02.2026.
//

import Foundation

struct City: Identifiable, Hashable {
    let id: String
    let name: String
    let queryName: String

    static let capitals: [City] = [
        City(id: "london", name: "Лондон", queryName: "London,GB"),
        City(id: "paris", name: "Париж", queryName: "Paris,FR"),
        City(id: "newyork", name: "Нью-Йорк", queryName: "New York,US"),
        City(id: "rome", name: "Рим", queryName: "Rome,IT"),
        City(id: "moscow", name: "Москва", queryName: "Moscow,RU"),
    ]
}
