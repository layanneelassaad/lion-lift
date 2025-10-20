//
//  FlightConfirmationViewModel.swift
//  Lion Lift
//
//  Created by Emile Billeh on 03/12/2024.
//

import Foundation
import Firebase
import SwiftUI


class FlightConfirmationViewModel: ObservableObject {
    @Published var error: String?

    func updateFlightInfo(departureAirport: String, arrivalAirport: String, date: String, time: Date) {
        // Step 1: Define New York airports and their abbreviations
        let nyAirports: [String: String] = [
            "John F. Kennedy International Airport": "JFK",
            "JFK": "JFK",
            "LaGuardia Airport": "LGA",
            "LGA": "LGA",
            "Newark Liberty International Airport": "EWR",
            "EWR": "EWR"
        ]

        // Step 2: Merge date and time
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Set locale to ensure consistent formatting

        // Try parsing both date formats
        let dateFormats = ["MMM dd, yyyy", "dd MMM yyyy"]

        var parsedDate: Date? = nil
        for format in dateFormats {
            dateFormatter.dateFormat = format
            parsedDate = dateFormatter.date(from: date)
            
            if parsedDate != nil {
                break
            }
        }

        guard let validDate = parsedDate else {
            error = "Invalid date format."
            return
        }

        let calendar = Calendar.current
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)

        guard let combinedDate = calendar.date(bySettingHour: timeComponents.hour ?? 0,
                                               minute: timeComponents.minute ?? 0,
                                               second: 0,
                                               of: validDate) else {
            error = "Unable to combine date and time."
            return
        }

        // Convert combinedDate to Firebase Timestamp
        let timestamp = Timestamp(date: combinedDate)


        // Step 3: Check if either airport is a New York airport
        var departing: Bool?

        // Convert full airport name to abbreviation if applicable
        let departureAbbreviation = nyAirports[departureAirport] ?? departureAirport
        let arrivalAbbreviation = nyAirports[arrivalAirport] ?? arrivalAirport

        if nyAirports.keys.contains(departureAirport) {
            departing = true
        } else if nyAirports.keys.contains(arrivalAirport) {
            departing = false
        } else {
            error = "Neither airport is a New York City airport."
            return
        }

        // Step 4: Prepare data to update
        let nextFlightAirport = departing == true ? departureAbbreviation : arrivalAbbreviation

        let data: [String: Any] = [
            "nextFlightDateAndTime": timestamp,
            "nextFlightAirport": nextFlightAirport,
            "departing": departing ?? false
        ]

        // Step 5: Update user flight info in Firestore
        guard let currentUserId = AuthViewModel.shared.userSession?.uid else { return }
        guard let currentUser = AuthViewModel.shared.currentUser else { return }

        COLLECTION_USERS.document(currentUserId).updateData(data) { error in
            if let error = error {
                print("Error updating user flight, \(error.localizedDescription)")
            }
        }
        
        var matchData: [String: Any] = [
            "uids": [currentUserId],
            "airport": nextFlightAirport,
            "dateAndTime": timestamp,
            "departing": departing ?? false,
            "lastMessage": "New match! Plan your carpool here",
            "timestamp": Timestamp(date: Date()),
            "uid": currentUserId,
            "userFullName": currentUser.fullname
        ]
        
        if let profileImageUrl = currentUser.profileImageUrl {
            matchData["userProfileImageUrl"] = profileImageUrl
        }
        
        COLLECTION_MATCHES.addDocument(data: matchData) { error in
            if let error = error {
                print("Error creating match, \(error.localizedDescription)")
            }
        }
        
        
    }
}




