//
//  CityRowView.swift
//  WeatherTestApp for LinaID
//
//  Created by Andrey Kaldyaev on 12.02.2026.
//

import SwiftUI

struct CityRowView: View {
    let city: City
    let temp: Float
    let weatherDescription: String
    let isRefreshing: Bool
    let onRefresh: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(city.name)
                    .font(.headline)
                Text(weatherDescription)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .foregroundStyle(rowBackground)
            
            Spacer()
            
            Text(String(format: "%.0f°", temp))
                .font(.title2.bold())
                .foregroundStyle(rowBackground)
            
            Button(action: onRefresh) {
                if isRefreshing {
                    ProgressView()
                        .scaleEffect(0.9)
                } else {
                    Image(systemName: "arrow.clockwise")
                }
            }
            .buttonStyle(.borderless)
            .disabled(isRefreshing)
        }
        .padding()
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var rowBackground: Color {
        if temp < 10 {
            return Color.blue.opacity(0.9)
        } else {
            return Color.black
        }
    }
}

#Preview() {
    VStack {
        CityRowView(city: City(id: "london", name: "Лондон", queryName: "London,GB"),
                    temp: 18.5,
                    weatherDescription: "переменная облачность",
                    isRefreshing: false,
                    onRefresh: {})
        .padding()
    
        CityRowView(city: City(id: "moscow", name: "Москва", queryName: "Moscow,RU"),
                    temp: 3,
                    weatherDescription: "снег с дождём",
                    isRefreshing: false,
                    onRefresh: {})
        .padding()
    }
}
