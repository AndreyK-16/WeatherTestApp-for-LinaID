# Погода в столицах мира

iOS‑приложение (SwiftUI, iOS 16+) для просмотра текущей погоды и недельного прогноза в пяти столицах: Лондон, Париж, Нью‑Йорк, Рим, Москва.

## Технологии

- **API:** [OpenWeatherMap One Call API 3.0](https://openweathermap.org/api/one-call-3)
- **Парсинг JSON:** [taocpp/json](https://github.com/taocpp/json) (C++) через Objective-C++ мост
- **Стек:** SwiftUI, async/await, URLSession, без сторонних Swift-зависимостей

## Настройка

### 1. Подмодули

Инициализируйте подмодуль PEGTL (зависимость taocpp/json):

```bash
cd "WeatherTestApp for LinaID/ThirdParty/taocpp-json"
git submodule update --init --recursive
```

### 2. API-ключ OpenWeatherMap

1. Зарегистрируйтесь на [OpenWeatherMap](https://home.openweathermap.org/users/sign_up) и получите API key.
2. Подпишитесь на [One Call by Call](https://openweathermap.org/price#onecall) (есть бесплатный лимит).
3. Укажите ключ в **Info.plist** в корне проекта (рядом с `.xcodeproj`): ключ `OWM_API_KEY`, значение — ваш API key.

## Сборка и запуск

Откройте `WeatherTestApp for LinaID.xcodeproj` в Xcode, выберите симулятор или устройство и запустите (⌘R).

## Функции

- **Главный экран:** список столиц с текущей температурой и кратким описанием; кнопка обновления по каждой столице; pull-to-refresh по всему списку.
- **Цвет при t &lt; 10 °C:** строка города подсвечивается голубым.
- **Экран детали:** по тапу на город — прогноз на неделю: температура (день/мин/макс), давление, влажность, видимость, облачность, описание.

## Структура

- **ThirdParty/taocpp-json** (в корне проекта) — библиотека taocpp/json и PEGTL для парсинга JSON.
- `WeatherJSONParser.h` / `.mm` — парсинг ответа One Call с помощью **taocpp/json** (C++), результат в `NSDictionary` для Swift.
- `Models/` — `City`, `CurrentWeather`, `DayForecast`, `OneCallParsed`.
- `Services/WeatherService.swift` — загрузка данных по API (async/await) и вызов парсера.
- `ViewModels/WeatherListViewModel.swift` — состояние списка и загрузка по городам.
- `Views/` — `WeatherListView`, `CityRowView`, `WeatherDetailView`.

## Тесты

В папке `WeatherTestApp for LinaIDTests/` лежат юнит-тесты моделей (`WeatherDataTests.swift`). Чтобы запустить тесты: в Xcode добавьте target **Unit Tests** (File → New → Target → Unit Testing Bundle), укажите папку с тестами как источник и добавьте зависимость от основного таргета приложения. Затем ⌘U.
