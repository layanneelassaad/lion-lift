//
//  Message.swift
//  Lion Lift
//
//  Created by Emile Billeh on 03/12/2024.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Message: Identifiable, Decodable {
    @DocumentID var id: String?
    let matchId: String
    let fromId: String
    let read: Bool
    let text: String
    let timestamp: Timestamp
    
    var user: User?
    var match: Match?
}
