//
//  WelcomeView.swift
//  WeatherTestApp for LinaID
//
//  Created by Andrey Kaldyaev on 12.02.2026.
//

import SwiftUI

struct WelcomeView: View {
    @State private var apiKeyInput: String = ""
    var onSave: (String) -> Void

    var body: some View {
        VStack(spacing: 24) {
            Text("Введите ваш API Key для получения доступа к API One Call API 3.0 сервиса OpenWeatherMap")
                .font(.title3.bold())
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Text("У вас должен быть куплен тариф One Call API 3.0")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            TextField("API Key", text: $apiKeyInput)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding(.horizontal, 32)

            Button {
                let apiKey = apiKeyInput.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !apiKey.isEmpty else { return }
                onSave(apiKey)
            } label: {
                Text("Сохранить ключ")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 32)
            .disabled(apiKeyInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }
}

#Preview {
    WelcomeView(onSave: {_ in })
}
