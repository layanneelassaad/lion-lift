//
//  NewRequestViewModel.swift
//  Lion Lift
//
//  Created by Emile Billeh on 05/12/2024.
//

import Foundation
import Firebase
import SwiftUI


class NewRequestViewModel {

    func sendRequest(messageText: String, match: Match) {
        guard let currentUser = AuthViewModel.shared.currentUser else { return }
        guard let matchId = match.id else { return }
        
        var data: [String: Any] = ["uid": currentUser.uid,
                                   "fullname": currentUser.fullname,
                                   "airport": currentUser.nextFlightAirport,
                                   "flightDateAndTime": currentUser.nextFlightDateAndTime,
                                   "departing": currentUser.departing,
                                   "message": messageText,
                                   "matchId": matchId,
                                   "timestamp": Timestamp(date: Date()) ]
        
        if let userProfileImageUrl = currentUser.profileImageUrl {
            data["profileImageUrl"] = userProfileImageUrl
        }
        
        Firestore.firestore().collection("users").document(match.uid).collection("requests").addDocument(data: data) { error in
            if let error = error {
                print("error uploading request \(error.localizedDescription)")
            }
        }
        
        
    }
}

