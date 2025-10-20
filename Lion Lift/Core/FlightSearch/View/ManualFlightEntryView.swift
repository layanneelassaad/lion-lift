import SwiftUI

struct ManualFlightEntryView: View {
    @State private var selectedAirport: String = "John F. Kennedy International Airport" // Default airport
    @State private var enteredOtherAirport: String = "" // For manual input
    @State private var flightDateTime: Date = Date()
    @State private var shouldNavigateToScheduledRide = false
    @State private var isDeparting = false

    let nycAirports = [
        "John F. Kennedy International Airport",
        "LaGuardia Airport",
        "Newark Liberty International Airport"
    ]

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
         
                HStack {
                    
                    Spacer()
                }
                .padding(.top)

       
                Text("Sorry, we couldn’t match your flight")
                    .font(Font.custom("Roboto Flex", size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .padding(.top)

       
                Text("Enter Flight Details Manually")
                    .font(Font.custom("Roboto Flex", size: 18))
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(.bottom, 10)

                VStack(alignment: .leading, spacing: 16) {
                   
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Departing or arriving to NYC?")
                            .font(Font.custom("Roboto Flex", size: 16))
                            .foregroundColor(.black)
                        Menu {
                            Button(action: {
                                isDeparting = true
                            }) {
                                Text("Departing NYC")
                            }
                            Button(action: {
                                isDeparting = false
                            }) {
                                Text("Arriving to NYC")
                            }
                        } label: {
                            HStack {
                                Text(isDeparting ? "Departing NYC" : "Arriving to NYC")
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal)
                            .background(Color(red: 0.61, green: 0.79, blue: 0.92))
                            .cornerRadius(5)
                        }
                        Divider()
                    }

                   
                    if isDeparting {
                      
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Departure Airport")
                                .font(Font.custom("Roboto Flex", size: 16))
                                .foregroundColor(.black)
                            Menu {
                                ForEach(nycAirports, id: \.self) { airport in
                                    Button(action: {
                                        selectedAirport = airport
                                    }) {
                                        Text(airport)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedAirport)
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal)
                                .background(Color(red: 0.61, green: 0.79, blue: 0.92))
                                .cornerRadius(5)
                            }
                            Divider()
                        }

                    
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Arrival Airport")
                                .font(Font.custom("Roboto Flex", size: 16))
                                .foregroundColor(.black)
                            TextField("Enter arrival airport", text: $enteredOtherAirport)
                                .padding(.vertical, 8)
                                .padding(.horizontal)
                                .background(Color(red: 0.61, green: 0.79, blue: 0.92))
                                .cornerRadius(5)
                            Divider()
                        }
                    } else {
                       
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Departure Airport")
                                .font(Font.custom("Roboto Flex", size: 16))
                                .foregroundColor(.black)
                            TextField("Enter departure airport", text: $enteredOtherAirport)
                                .padding(.vertical, 8)
                                .padding(.horizontal)
                                .background(Color(red: 0.61, green: 0.79, blue: 0.92))
                                .cornerRadius(5)
                            Divider()
                        }

                  
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Arrival Airport")
                                .font(Font.custom("Roboto Flex", size: 16))
                                .foregroundColor(.black)
                            Menu {
                                ForEach(nycAirports, id: \.self) { airport in
                                    Button(action: {
                                        selectedAirport = airport
                                    }) {
                                        Text(airport)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedAirport)
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal)
                                .background(Color(red: 0.61, green: 0.79, blue: 0.92))
                                .cornerRadius(5)
                            }
                            Divider()
                        }
                    }

                  
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Date and Time At Airport:")
                            .font(Font.custom("Roboto Flex", size: 16))
                            .foregroundColor(.black)
                        DatePicker("", selection: $flightDateTime, displayedComponents: [.hourAndMinute, .date])
                            .labelsHidden()
                            .background(Color(red: 0.61, green: 0.79, blue: 0.92))
                            .cornerRadius(5)
                        Divider()
                    }
                }

                Spacer()

                NavigationLink(
                    destination: ScheduledRideView(
                        flightInfo: FlightInfo(
                            flnr: "N/A",
                            date: selectedAirport,
                            scheduledDepartureLocal: isDeparting ? selectedAirport : enteredOtherAirport,
                            scheduledArrivalLocal: isDeparting ? enteredOtherAirport : selectedAirport,
                            departureName: isDeparting ? selectedAirport : enteredOtherAirport,
                            arrivalName: isDeparting ? enteredOtherAirport : selectedAirport
                        ),
                        flightDate: flightDateTime,
                        flightTime: flightDateTime
                    ).navigationBarBackButtonHidden(true),
                    isActive: $shouldNavigateToScheduledRide
                ) {
                    EmptyView()
                }

           
                Button(action: {
                    shouldNavigateToScheduledRide = true
                }) {
                    Text("Next")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.0, green: 0.22, blue: 0.39))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding(.horizontal)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
    }
}
