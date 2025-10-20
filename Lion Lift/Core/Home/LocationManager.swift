//
//  LocationManager.swift
//  Lion Lift
//
//  Created by KyungHan Jo on 12/11/24.
//

import Foundation
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()

    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @Published var weatherAnnotations: [WeatherAnnotation] = []
    @Published var currentWeather: Weather?

    private var hasCenteredOnUser = false

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func focusOnUser() {
        if let location = locationManager.location {
            updateRegion(to: location.coordinate)
            fetchWeather(for: location.coordinate)
        }
    }

    private func updateRegion(to coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    }

    func fetchWeather(for coordinate: CLLocationCoordinate2D) {
        let headers = [
            "x-rapidapi-key": "2ef9a382f3msh4a473987efda940p1b08c0jsnf65df83d9c56",
            "x-rapidapi-host": "weatherapi-com.p.rapidapi.com"
        ]

        let urlString = "https://weatherapi-com.p.rapidapi.com/current.json?q=\(coordinate.latitude),\(coordinate.longitude)"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching weather: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                DispatchQueue.main.async {
                    let annotation = WeatherAnnotation(
                        coordinate: coordinate,
                        temp: weatherResponse.current.temp_c,
                        condition: weatherResponse.current.condition.text
                    )
                    self.weatherAnnotations = [annotation]
                    self.currentWeather = weatherResponse.current
                }
            } catch {
                print("Error decoding weather data: \(error)")
            }
        }.resume()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        // Center on user location only the first time
        if !hasCenteredOnUser {
            updateRegion(to: location.coordinate)
            fetchWeather(for: location.coordinate)
            hasCenteredOnUser = true
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else if status == .denied {
            print("Location access denied. Please enable it in settings.")
        }
    }
}

struct WeatherAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let temp: Double
    let condition: String
}
