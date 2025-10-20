//
//  Match.swift
//  Carpools
//
//  Created by Emile Billeh on 14/11/2024.
//

import FirebaseFirestore
import Firebase
import MapKit

struct Match: Identifiable, Decodable {
    @DocumentID var id: String?
    let uids: [String]
    let airport: String
    let dateAndTime: Timestamp
    let departing: Bool
    let timestamp: Timestamp
    let lastMessage: String
    let uid: String // uid of person you matched with
    let userFullName: String
    let userProfileImageUrl: String?
    
    
    static var dummyMatch: Match {
        return Match(
            uids: [],
            airport: "John F. Kennedy",
            dateAndTime: Timestamp(date: Date()),
            departing: false,
            timestamp: Timestamp(date: Date()),
            lastMessage: "",
            uid: "",
            userFullName: "",
            userProfileImageUrl: nil
            )
    }
}
