//
//  ContentView.swift
//  WeatherTestApp for LinaID
//

import SwiftUI

struct ContentView: View {
    @State private var apiKey: String? = KeychainStorage.loadOWMAPIKey()

    var body: some View {
        if let apiKey = apiKey, !apiKey.isEmpty {
            WeatherListView(apiKey: apiKey)
        } else {
            WelcomeView { savedKey in
                KeychainStorage.saveOWMAPIKey(savedKey)
                apiKey = savedKey
            }
        }
    }
}

#Preview {
    ContentView()
}
