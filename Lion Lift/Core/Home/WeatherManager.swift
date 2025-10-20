//
//  WeatherManager.swift
//  Lion Lift
//
//  Created by KyungHan Jo on 12/11/24.
//

import Foundation
import UserNotifications

struct Weather: Decodable {
    let temp_c: Double
    let condition: WeatherCondition
}

struct WeatherCondition: Decodable {
    let text: String
    let icon: String
}

struct WeatherResponse: Decodable {
    let current: Weather
}

class WeatherManager: ObservableObject {
    @Published var currentWeather: Weather?

    func fetchWeather(latitude: Double, longitude: Double) {
        let headers = [
            "x-rapidapi-key": "2ef9a382f3msh4a473987efda940p1b08c0jsnf65df83d9c56",
            "x-rapidapi-host": "weatherapi-com.p.rapidapi.com"
        ]

        let urlString = "https://weatherapi-com.p.rapidapi.com/current.json?q=\(latitude),\(longitude)"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                DispatchQueue.main.async {
                    self.currentWeather = weatherResponse.current
                    self.sendWeatherNotification()
                }
            } catch {
                print("Error decoding response: \(error)")
            }
        }.resume()
    }

    private func sendWeatherNotification() {
        guard let weather = currentWeather else { return }

        if weather.condition.text.contains("Rain") || weather.condition.text.contains("Snow") {
            let content = UNMutableNotificationContent()
            content.title = "Weather Alert"
            content.body = "It's \(weather.condition.text) with a temperature of \(weather.temp_c)°C. Stay prepared!"
            content.sound = .default

            let request = UNNotificationRequest(
                identifier: UUID().uuidString,
                content: content,
                trigger: nil
            )

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error adding notification: \(error.localizedDescription)")
                }
            }
        }
    }
}
