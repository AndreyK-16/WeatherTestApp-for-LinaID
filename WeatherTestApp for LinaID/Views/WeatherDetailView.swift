//
//  WeatherDetailView.swift
//  WeatherTestApp for LinaID
//
//  Created by Andrey Kaldyaev on 12.02.2026.
//

import SwiftUI

struct WeatherDetailView: View {
    let city: City
    let parsed: OneCallParsed?

    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "EEEE, d MMM"
        f.locale = Locale(identifier: "ru_RU")
        return f
    }()
    var body: some View {
        List {
            if let parsed = parsed, !parsed.daily.isEmpty {
                Section("Прогноз на неделю") {
                    ForEach(parsed.daily) { day in
                        DayRow(day: day, formatter: dateFormatter)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(city.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct LabeledRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
        }
    }
}

private struct DayRow: View {
    let day: DayForecast
    let formatter: DateFormatter

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(formatter.string(from: day.date))
                .font(.headline)
            Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 4) {
                if let t = day.tempDay { GridRow { Text("Температура"); Text(String(format: "%.0f °C", t)) } }
                if let p = day.pressure { GridRow { Text("Давление"); Text("\(p) hPa") } }
                if let h = day.humidity { GridRow { Text("Влажность"); Text("\(h) %") } }
                if let v = day.visibility { GridRow { Text("Видимость"); Text("\(v) м") } }
                if let c = day.clouds { GridRow { Text("Облачность"); Text("\(c) %") } }
                if let d = day.description { GridRow { Text("Описание"); Text(d) } }
            }
            .font(.subheadline)
        }
        .padding(.vertical, 4)
    }
}

#Preview("С данными") {
    NavigationStack {
        WeatherDetailView(
            city: City(id: "moscow", name: "Москва", queryName: "Moscow,RU"),
            parsed: OneCallParsed(from: [
                "current": [
                    "temp": 5.0,
                    "pressure": 1025,
                    "humidity": 78,
                    "visibility": 8000,
                    "clouds": 90,
                    "description": "пасмурно",
                ] as [String: Any],
                "daily": [
                    ["dt": 1739400000.0, "temp_day": 4.0, "pressure": 1025, "humidity": 80, "clouds": 95, "description": "облачно с прояснениями"],
                    ["dt": 1739486400.0, "temp_day": 2.0, "pressure": 1020, "humidity": 85, "clouds": 100, "description": "снег"],
                    ["dt": 1739572800.0, "temp_day": -1.0, "pressure": 1018, "humidity": 70, "clouds": 50, "description": "переменная облачность"],
                ] as [[String: Any]],
                "timezone": "Europe/Moscow",
            ] as [String: Any])
        )
    }
}

#Preview("Нет данных") {
    NavigationStack {
        WeatherDetailView(
            city: City(id: "london", name: "Лондон", queryName: "London,GB"),
            parsed: nil
        )
    }
}
