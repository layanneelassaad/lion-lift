//
//  RequestRowViewModel.swift
//  Lion Lift
//
//  Created by Emile Billeh on 05/12/2024.
//

import Foundation
import Firebase

class RequestRowViewModel {
    let request: Request
    
    init(request: Request) {
        self.request = request
    }

    func acceptRequest() {
        guard let currentUid = AuthViewModel.shared.userSession?.uid else { return }
        guard let requestId = request.id else { return }

        COLLECTION_MATCHES.document(request.matchId).updateData(["uids": FieldValue.arrayUnion([request.uid])]) { error in
            if let error = error {
                print("Error updating match: \(error.localizedDescription)")
            }
        }
        
        COLLECTION_USERS.document(currentUid).collection("requests").document(requestId).delete()
    }
    
    func ignoreRequest() {
        guard let currentUid = AuthViewModel.shared.userSession?.uid else { return }
        guard let requestId = request.id else { return }
        
        COLLECTION_USERS.document(currentUid).collection("requests").document(requestId).delete()
    }
}
