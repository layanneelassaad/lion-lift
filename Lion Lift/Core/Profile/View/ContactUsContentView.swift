//import SwiftUI
//import Firebase
//import FirebaseFirestore
//import FirebaseAuth
//
//struct ReportView: View {
//    @State private var users: [User] = []
//    @State private var selectedUser: User?
//    @State private var selectedReason: String = "" // Report reason
//    @State private var additionalNotes: String = "" // Additional notes
//    @State private var isSubmitted: Bool = false
//    @State private var errorMessage: String?
//
//    // List of report reasons
//    let reportReasons = [
//        "Please Select Reason", // First item as default placeholder (non-selectable)
//        "Unresponsive",
//        "Rude Behavior",
//        "Fraudulent Activity",
//        "Illegal Activities",
//        "Providing False Information",
//        "Spam or Unwanted Promotions",
//        "Abusive Language",
//        "Account Hacking or Unauthorized Access",
//        "Inappropriate Content Sharing",
//        "Other"
//    ]
//    
//    var body: some View {
//        VStack {
//            // Report the User title
//            Text("Report the User")
//                .font(.title)
//                .fontWeight(.bold)
//                .padding(.top, 20)
//
//            // Short description
//            Text("Please report users who are violating the platform rules. Select the user, reason, and provide additional notes if necessary.")
//                .font(.body)
//                .foregroundColor(.gray)
//                .padding([.top, .bottom], 10)
//                .padding(.horizontal, 20)
//
//            // User selection Picker
//            VStack {
//                Text("Select User")
//                    .font(.title3)
//                    .fontWeight(.bold)
//                    .padding(.leading, 20)
//                    .padding(.bottom, 5)
//
//                // Custom user picker as cards
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 15) {
//                        ForEach(users) { user in
//                            Button(action: {
//                                selectedUser = user
//                            }) {
//                                HStack(spacing: 10) {
//                                    if let profileImageUrl = user.profileImageUrl {
//                                        AsyncImage(url: URL(string: profileImageUrl)) { image in
//                                            image
//                                                .resizable()
//                                                .scaledToFit()
//                                                .frame(width: 40, height: 40)
//                                                .clipShape(Circle())
//                                        } placeholder: {
//                                            Image(systemName: "person.circle.fill")
//                                                .resizable()
//                                                .scaledToFit()
//                                                .frame(width: 40, height: 40)
//                                                .clipShape(Circle())
//                                        }
//                                    }
//                                    
//                                    Text(user.fullname)
//                                        .font(.subheadline)
//                                        .bold()
//                                        .foregroundColor(selectedUser == user ? .white : .black)
//                                        .padding(10)
//                                        .background(selectedUser == user ? Color.blue : Color.gray.opacity(0.2))
//                                        .cornerRadius(15)
//                                }
//                            }
//                        }
//                    }
//                }
//                .padding(.horizontal, 20)
//            }
//
//            Divider()
//
//            // Report reason Picker
//            VStack {
//                Text("Select a Report Reason")
//                    .font(.title3)
//                    .fontWeight(.bold)
//                    .padding(.leading, 20)
//                    .padding(.bottom, 5)
//
//                Picker("Select a report reason", selection: $selectedReason) {
//                    ForEach(reportReasons, id: \.self) { reason in
//                        Text(reason)
//                    }
//                }
//                .pickerStyle(WheelPickerStyle())
//                .frame(height: 100)
//                .padding(.horizontal, 20)
//            }
//
//            Divider()
//
//            // Additional notes (optional)
//            VStack {
//                Text("Additional Notes (Optional)")
//                    .font(.title3)
//                    .fontWeight(.bold)
//                    .padding(.leading, 20)
//                    .padding(.bottom, 5)
//
//                TextField("Enter additional notes here...", text: $additionalNotes)
//                    .padding()
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(12)
//                    .padding(.horizontal, 20)
//                    .frame(height: 150)
//            }
//
//            Divider()
//
//            // Report button
//            Button("Report User") {
//                submitReport()
//            }
//            .disabled(selectedUser == nil || selectedReason == "Please Select Reason")
//            .foregroundColor(.white)
//            .frame(maxWidth: .infinity)
//            .padding()
//            .background(selectedUser != nil && selectedReason != "Please Select Reason" ? Color.blue : Color.gray)
//            .cornerRadius(10)
//            .padding(.horizontal, 20)
//            .alert(isPresented: $isSubmitted) {
//                if let errorMessage = errorMessage {
//                    return Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
//                } else {
//                    return Alert(title: Text("Success"), message: Text("User reported successfully!"), dismissButton: .default(Text("OK")))
//                }
//            }
//
//            Spacer()
//        }
//        .onAppear {
//            fetchUsers()
//        }
//        .padding(.top, 20)
//    }
//
//    // Submit the report
//    func submitReport() {
//        guard let user = selectedUser else { return }
//        Report.submitReport(reportedUserId: user.uid, reason: selectedReason, additionalNotes: additionalNotes) { result in
//            switch result {
//            case .success():
//                errorMessage = nil
//                isSubmitted = true
//            case .failure(let error):
//                errorMessage = error.localizedDescription
//                isSubmitted = true
//            }
//        }
//    }
//
//    // Fetch users related to matches, requests, and messages
//    func fetchUsers() {
//        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
//        let db = Firestore.firestore()
//        var relatedUserIds: Set<String> = []
//
//        // 1. Fetch matches
//        db.collection("matches")
//            .whereField("uids", arrayContains: currentUserId)
//            .getDocuments { snapshot, error in
//                if let error = error {
//                    print("Error fetching matches: \(error.localizedDescription)")
//                } else {
//                    for document in snapshot?.documents ?? [] {
//                        if let uid = document.data()["uid"] as? String {
//                            relatedUserIds.insert(uid)
//                        }
//                    }
//
//                    // 2. Fetch requests
//                    db.collection("requests")
//                        .whereField("uid", isEqualTo: currentUserId)
//                        .getDocuments { snapshot, error in
//                            if let error = error {
//                                print("Error fetching requests: \(error.localizedDescription)")
//                            } else {
//                                for document in snapshot?.documents ?? [] {
//                                    if let matchId = document.data()["matchId"] as? String {
//                                        relatedUserIds.insert(matchId)
//                                    }
//                                }
//
//                                // 3. Fetch messages
//                                db.collection("messages")
//                                    .whereField("fromId", isEqualTo: currentUserId)
//                                    .getDocuments { snapshot, error in
//                                        if let error = error {
//                                            print("Error fetching messages: \(error.localizedDescription)")
//                                        } else {
//                                            for document in snapshot?.documents ?? [] {
//                                                if let fromId = document.data()["fromId"] as? String {
//                                                    relatedUserIds.insert(fromId)
//                                                }
//                                            }
//
//                                            // Fetch users by IDs
//                                            fetchUsersByIds(userIds: Array(relatedUserIds))
//                                        }
//                                    }
//                            }
//                        }
//                }
//            }
//    }
//
//    func fetchUsersByIds(userIds: [String]) {
//        Firestore.firestore()
//            .collection("users")
//            .whereField("uid", in: userIds)
//            .getDocuments { snapshot, error in
//                if let error = error {
//                    print("Error fetching users: \(error.localizedDescription)")
//                } else {
//                    self.users = snapshot?.documents.compactMap { document -> User? in
//                        try? document.data(as: User.self)
//                    } ?? []
//                }
//            }
//    }
//}
//
//struct ReportView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReportView()
//    }
//}
