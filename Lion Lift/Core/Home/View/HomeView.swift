import SwiftUI
import MapKit

struct HomeView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var isShowFlight = false

    var body: some View {
        ZStack {
            Map(
                coordinateRegion: $locationManager.region,
                showsUserLocation: true
            )
            .edgesIgnoringSafeArea(.top)

            if let weather = locationManager.currentWeather {
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Image(systemName: "thermometer")
                            .foregroundColor(.orange)
                        Text("\(weather.temp_c, specifier: "%.1f")°C")
                            .font(.footnote)
                            .bold()
                    }
                    .padding(6)
                    .background(LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.white.opacity(0.7)]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .cornerRadius(8)
                    .shadow(radius: 3)

                    HStack {
                        Image(systemName: weatherIcon(for: weather.condition.text))
                            .foregroundColor(.blue)
                        Text(weather.condition.text.capitalized)
                            .font(.caption)
                    }
                    .padding(6)
                    .background(LinearGradient(
                        gradient: Gradient(colors: [Color.green.opacity(0.5), Color.white.opacity(0.7)]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .cornerRadius(8)
                    .shadow(radius: 3)

                    HStack {
                        Image(systemName: "car")
                            .foregroundColor(.red)
                        Text(trafficAdvisory(for: weather.condition.text))
                            .font(.caption2)
                            .foregroundColor(.red)
                    }
                    .padding(6)
                    .background(LinearGradient(
                        gradient: Gradient(colors: [Color.red.opacity(0.5), Color.white.opacity(0.7)]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .cornerRadius(8)
                    .shadow(radius: 3)
                }
                .padding(.leading, 15)
                .padding(.top, 360)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }

            VStack {
                Button {
                    isShowFlight.toggle()
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 45, height: 45)
                            .foregroundColor(.white)
                            .shadow(radius: 9.0)
                        Image(systemName: "airplane.departure")
                            .font(.system(size: 25))
                            .foregroundColor(.black)
                    }
                }
                .padding(.top, -307)
                .padding(.trailing, 10)
                Button {
                    locationManager.focusOnUser()
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 45, height: 45)
                            .foregroundColor(.white)
                            .shadow(radius: 9.0)
                        Image(systemName: "location.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                    }
                }
                .padding(.top, -253)
                .padding(.trailing, 10)
            }
            .frame(maxWidth: .infinity, alignment: .topTrailing)
        }
        .sheet(isPresented: $isShowFlight) {
            FlightInfoEntryView()
        }
    }

    private func weatherIcon(for condition: String) -> String {
        switch condition.lowercased() {
        case let cond where cond.contains("rain"):
            return "cloud.rain"
        case let cond where cond.contains("sun") || cond.contains("clear"):
            return "sun.max"
        case let cond where cond.contains("snow"):
            return "cloud.snow"
        default:
            return "cloud"
        }
    }

    private func trafficAdvisory(for condition: String) -> String {
        switch condition.lowercased() {
        case let cond where cond.contains("rain"):
            return "Wet roads may cause slower traffic."
        case let cond where cond.contains("snow"):
            return "Expect delays due to snow."
        case let cond where cond.contains("fog"):
            return "Low visibility may affect traffic."
        default:
            return "Traffic conditions are normal."
        }
    }
}
