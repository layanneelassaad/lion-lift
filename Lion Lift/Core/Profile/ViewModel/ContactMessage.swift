// ContactMessage.swift
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct ContactMessage: Identifiable, Codable {
    @DocumentID var id: String?
    let fromId: String
    let email: String
    let message: String
    let timestamp: Timestamp

    static func sendContactMessage(email: String, message: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let fromId = Auth.auth().currentUser?.uid ?? "unknown"
        let data: [String: Any] = [
            "fromId": fromId,
            "email": email,
            "message": message,
            "timestamp": Timestamp(date: Date())
        ]

        Firestore.firestore().collection("contact_messages").addDocument(data: data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
