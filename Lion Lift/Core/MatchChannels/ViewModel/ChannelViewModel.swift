//
//  ChannelViewModel.swift
//  Lion Lift
//
//  Created by Emile Billeh on 03/12/2024.
//

import Foundation
import Firebase

class ChannelViewModel: ObservableObject {
    @Published var messages = [Message]()
    let match: Match

    init(channel: Match) {
        self.match = channel
        fetchMessages()
    }

    func fetchMessages() {
        guard let matchId = match.id else { return }
        
        let query = COLLECTION_MATCHES
            .document(matchId)
            .collection("messages")
            .order(by: "timestamp", descending: false)

        query.addSnapshotListener { snapshot, _ in
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added }) else { return }

            var newMessages = changes.compactMap { try? $0.document.data(as: Message.self) }

            for message in newMessages where message.fromId != AuthViewModel.shared.userSession?.uid {
                self.fetchUser(for: message) { user in
                    if let user = user {
                        self.updateMessage(message, with: user)
                    }
                }
            }

            self.messages.append(contentsOf: newMessages)
        }
    }

    func sendMessage(_ messageText: String) {
        guard let currentUid = AuthViewModel.shared.userSession?.uid else { return }
//        guard let currentFullName = AuthViewModel.shared.currentUser?.fullname else { return }

        let data: [String: Any] = [
            "text": messageText,
            "fromId": currentUid,
            "matchId": match.id!,
            "read": false,
            "timestamp": Timestamp(date: Date())
        ]

        COLLECTION_MATCHES.document(match.id!)
            .collection("messages")
            .addDocument(data: data)

//        COLLECTION_MATCHES.document(match.id!)
//            .updateData(["lastMessage": messageText, "timestamp": Timestamp(date: Date())])  // Add later: currentFullName + ": " +
    }

    private func fetchUser(for message: Message, completion: @escaping (User?) -> Void) {
        COLLECTION_USERS.document(message.fromId).getDocument { snapshot, _ in
            guard let data = snapshot?.data(), let user = try? snapshot?.data(as: User.self) else {
                completion(nil)
                print("failed to get user for message")
                return
            }
            completion(user)
        }
    }

    private func updateMessage(_ message: Message, with user: User) {
        print("updating message with user")
        if let index = self.messages.firstIndex(where: { $0.id == message.id }) {
            self.messages[index].user = user
            self.objectWillChange.send()
        }
    }
}

