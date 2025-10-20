import SwiftUI

struct FlightInfoEntryView: View {
    @State private var flightNumber: String = ""
    @State private var flightDate: Date = Date()
    @State private var isFetching = false
    @State private var fetchedFlightInfo: FlightInfo?
    @State private var fetchedTime: Date = Date()
    @State private var shouldNavigateToManualEntry = false
    @State private var shouldNavigateToScheduledRide = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                // Back Button
                HStack {
                    
                }
                .padding(.top)

                // Title Text
                Text("Flight Info")
                    .font(Font.custom("Roboto Flex", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.0, green: 0.22, blue: 0.39)) // Navy blue
                    .padding(.bottom, 24)

             
                HStack {
                    Text("Flight Number")
                        .font(Font.custom("Roboto Flex", size: 16))
                        .foregroundColor(.black)
                    Spacer()
                    TextField("", text: $flightNumber)
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                        .background(Color(red: 0.61, green: 0.79, blue: 0.92)) // Light blue
                        .cornerRadius(5)
                        .frame(width: 128, height: 45)
                        .padding(.trailing, 10)
                }
                Divider()

        
                HStack {
                    Text("Flight Date")
                        .font(Font.custom("Roboto Flex", size: 16))
                        .foregroundColor(.black)
                    Spacer()
                    DatePicker("", selection: $flightDate, displayedComponents: .date)
                        .labelsHidden()
                        .background(Color(red: 0.61, green: 0.79, blue: 0.92)) // Light blue
                        .cornerRadius(5)
                        .padding(.trailing, 10)
                }
                Divider()

                Spacer()

                NavigationLink(
                    destination: ManualFlightEntryView(),
                    isActive: $shouldNavigateToManualEntry
                ) {
                    EmptyView()
                }

                NavigationLink(
                    destination: ScheduledRideView(
                        flightInfo: fetchedFlightInfo ?? FlightInfo(
                            flnr: "N/A",
                            date: "",
                            scheduledDepartureLocal: "",
                            scheduledArrivalLocal: "",
                            departureName: "",
                            arrivalName: ""
                        ),
                        flightDate: flightDate,
                        flightTime: fetchedTime
                    ),
                    isActive: $shouldNavigateToScheduledRide
                ) {
                    EmptyView()
                }

                // Save Button
                Button(action: fetchFlightInfo) {
                    Text("Save this Flight")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.0, green: 0.22, blue: 0.39)) // Navy blue
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .disabled(isFetching || flightNumber.isEmpty)

                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    func fetchFlightInfo() {
        isFetching = true

        let urlString = "https://flightera-flight-data.p.rapidapi.com/flight/info?flnr=\(flightNumber)"
        guard let url = URL(string: urlString) else {
            isFetching = false
            shouldNavigateToManualEntry = true
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("ffbf139d03mshc8682734170b602p1ace0djsnacc15f6ca340", forHTTPHeaderField: "x-rapidapi-key")
        request.addValue("flightera-flight-data.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isFetching = false

                if let error = error {
                    print("Error fetching flight info: \(error.localizedDescription)")
                    self.shouldNavigateToManualEntry = true
                    return
                }

                guard let data = data else {
                    print("No data received from API")
                    self.shouldNavigateToManualEntry = true
                    return
                }

                do {
                    // Log raw JSON response for debugging
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Raw API Response: \(jsonString)")
                    }

                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let flightInfoArray = try decoder.decode([FlightInfo].self, from: data)

                    if let firstFlightInfo = flightInfoArray.first {
                        self.fetchedFlightInfo = firstFlightInfo
                        self.shouldNavigateToScheduledRide = true
                    } else {
                        print("No flight info found in response")
                        self.shouldNavigateToManualEntry = true
                    }
                } catch {
                    print("Error decoding response: \(error.localizedDescription)")
                    self.shouldNavigateToManualEntry = true
                }
            }
        }.resume()
    }

}
