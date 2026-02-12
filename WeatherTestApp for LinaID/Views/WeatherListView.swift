//
//  WeatherListView.swift
//  WeatherTestApp for LinaID
//
//  Created by Andrey Kaldyaev on 12.02.2026.
//

import SwiftUI

struct WeatherListView: View {
    @StateObject private var viewModel: WeatherListViewModel

    init(apiKey: String) {
        _viewModel = StateObject(wrappedValue: WeatherListViewModel(apiKey: apiKey))
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(City.capitals) { city in
                    NavigationLink {
                        WeatherDetailView(city: city, parsed: viewModel.weather(for: city))
                    } label: {
                        let current = viewModel.weather(for: city)?.current
                        CityRowView(
                            city: city,
                            temp: Float(current?.temp ?? 0),
                            weatherDescription: current?.description ?? "—",
                            isRefreshing: viewModel.isRefreshing(city),
                            onRefresh: { Task { await viewModel.load(city: city) } }
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Погода в столицах")
            .navigationBarTitleDisplayMode(.large)
            .task { await viewModel.loadAll() }
            .refreshable { await viewModel.loadAll() }
        }
    }
}

#Preview {
    WeatherListView(apiKey: "fa037578bc9bf3e58f06f7a062a7f4ca")
}
