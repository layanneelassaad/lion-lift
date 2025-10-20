import SwiftUI

struct ScheduledRideView: View {
    let flightInfo: FlightInfo
    let flightDate: Date?
    let flightTime: Date

    @State private var flightNumber: String = ""
    @State private var departureAirport: String = ""
    @State private var arrivalAirport: String = ""
    @State private var date: String = ""
    @State private var time: Date = Date()
    @State private var navigateToConfirmation = false

    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel = FlightConfirmationViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title
            Text("Is this your Flight?")
                .font(Font.custom("Roboto Flex", size: 24))
                .fontWeight(.bold)
                .padding(.bottom, 20)

            // Flight Number
            VStack(alignment: .leading, spacing: 4) {
                Text("Flight Number:")
                    .font(Font.custom("Roboto Flex", size: 16))
                Text(flightNumber)
                    .font(Font.custom("Roboto Flex", size: 16))
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .background(Color(red: 0.61, green: 0.79, blue: 0.92)) // Light blue
                    .cornerRadius(5)
            }

            // Departure Airport
            VStack(alignment: .leading, spacing: 4) {
                Text("Departure Airport:")
                    .font(Font.custom("Roboto Flex", size: 16))
                Text(departureAirport)
                    .font(Font.custom("Roboto Flex", size: 16))
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .background(Color(red: 0.61, green: 0.79, blue: 0.92)) // Light blue
                    .cornerRadius(5)
            }

            // Arrival Airport
            VStack(alignment: .leading, spacing: 4) {
                Text("Arrival Airport:")
                    .font(Font.custom("Roboto Flex", size: 16))
                Text(arrivalAirport)
                    .font(Font.custom("Roboto Flex", size: 16))
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .background(Color(red: 0.61, green: 0.79, blue: 0.92)) // Light blue
                    .cornerRadius(5)
            }

            // Date and Time
            VStack(alignment: .leading, spacing: 4) {
                Text("Date and Time at Airport:")
                    .font(Font.custom("Roboto Flex", size: 16))
                HStack {
                    Text(date) // Display user-entered date
                        .font(Font.custom("Roboto Flex", size: 16))
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                        .background(Color(red: 0.61, green: 0.79, blue: 0.92)) // Light blue
                        .cornerRadius(5)

                    DatePicker("", selection: $time, displayedComponents: [.hourAndMinute])
                        .labelsHidden()
                        .background(Color(red: 0.61, green: 0.79, blue: 0.92)) // Light blue
                        .cornerRadius(5)
                }
            }
            
            if let error = viewModel.error {
                Text("\(error)")
                    .foregroundStyle(.red)
            }

            Spacer()

          
            NavigationLink(
                destination: ConfirmationView().navigationBarBackButtonHidden(true),
                isActive: $navigateToConfirmation
            ) {
                EmptyView()
            }

       
            Button {
                viewModel.updateFlightInfo(departureAirport: departureAirport, arrivalAirport: arrivalAirport, date: date, time: time)
                if viewModel.error == nil {
                    navigateToConfirmation = true
                }
            } label: {
                Text("Save Changes")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.0, green: 0.22, blue: 0.39)) // Navy blue
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
        }
        .padding()
        
       
        .onAppear {
            print("ScheduledRideView: onAppear called")
            updateViewData()
        }
    }

    private func updateViewData() {
        print("Updating view data with flightInfo: \(flightInfo)")

        // Populate initial state values from `flightInfo`
        flightNumber = flightInfo.flnr.isEmpty ? "N/A" : flightInfo.flnr
        departureAirport = flightInfo.departureName ?? "Unknown"
        arrivalAirport = flightInfo.arrivalName ?? "Unknown"

        if let userFlightDate = flightDate {
            date = formatDate(userFlightDate)
        } else {
            date = "Unknown Date"
        }

        // Define NYC airports
        let nyAirports = ["John F. Kennedy International Airport", "JFK", "LaGuardia Airport", "LGA", "Newark Liberty International Airport", "EWR"]

        // Handle time based on NYC context
        if flightInfo.flnr != "N/A" {
            if let departureAirportName = flightInfo.departureName,
               nyAirports.contains(departureAirportName),
               let departureTimeString = flightInfo.scheduledDepartureLocal,
               let parsedDepartureTime = ISO8601DateFormatter().date(from: departureTimeString) {
                // Show departure time if departing from NYC
                time = parsedDepartureTime
                print("NYC departure detected. Using departure time: \(time)")
            } else if let arrivalAirportName = flightInfo.arrivalName,
                      nyAirports.contains(arrivalAirportName),
                      let arrivalTimeString = flightInfo.scheduledArrivalLocal,
                      let parsedArrivalTime = ISO8601DateFormatter().date(from: arrivalTimeString) {
                // Show arrival time if arriving in NYC
                time = parsedArrivalTime
                print("NYC arrival detected. Using arrival time: \(time)")
            } else {
                // Fallback to flightTime if neither departure nor arrival is in NYC
                time = flightTime
                print("No NYC airport detected. Using fallback time: \(time)")
            }
        } else {
            // Manual Entry: Use the user-entered time
            time = flightTime
            print("Manual entry detected. Using user-entered time: \(time)")
        }

        print("Initial Values - Flight Number: \(flightNumber), Departure Airport: \(departureAirport), Arrival Airport: \(arrivalAirport), Date: \(date), Time: \(time)")
    }


    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    private func combineDateAndTime(date: Date?, time: Date) -> Date {
        guard let userDate = date else { return time }
        let calendar = Calendar.current
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        var combinedDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: userDate)) ?? time
        combinedDate = calendar.date(byAdding: timeComponents, to: combinedDate) ?? time
        return combinedDate
    }
}
