import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct ReportView: View {
    @State private var users: [User] = []
    @State private var filteredUsers: [User] = []
    @State private var selectedUser: User?
    @State private var selectedReason: String = ""
    @State private var additionalNotes: String = ""
    @State private var isSubmitted: Bool = false
    @State private var errorMessage: String?
    @State private var searchText: String = ""
    @Environment(\.dismiss) private var dismiss

   
    let reportReasons = [
        "Please Select Reason", //  placeholder
        "Unresponsive",
        "Rude Behavior",
        "Fraudulent Activity",
        "Illegal Activities",
        "Providing False Information",
        "Spam or Unwanted Promotions",
        "Abusive Language",
        "Account Hacking or Unauthorized Access",
        "Inappropriate Content Sharing",
        "Other"
    ]
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Report the User title
                    Text("Report a User")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0/255, green: 56/255, blue: 101/255))
                        .padding(.top, 20)

                    // Short description
                    Text("Select the user, reason, and provide additional notes if necessary.")
                        .font(.body)
                        .foregroundColor(Color.white)
                        .padding([.top, .bottom], 10)
                        .padding(.horizontal, 20)

                    // Search bar to filter users
                    VStack {
                        Text("Search for a User")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.leading, 20)
                            .padding(.bottom, 5)
                            .foregroundColor(Color(red: 0/255, green: 56/255, blue: 101/255))

                        TextField("Search users by name or ID...", text: $searchText)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(.horizontal, 20)
                        
                            .onChange(of: searchText) { oldState, newState in
                                filterUsers()
                            }
                    }

                    Divider()

                    // select the user
                    VStack {
                        Text("Select User")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.leading, 20)
                            .padding(.bottom, 5)
                            .foregroundColor(Color(red: 0/255, green: 56/255, blue: 101/255))

                        // Search result ( horizontal dragging)
                        if filteredUsers.isEmpty {
                            Text("No users available. Please search for a user.")
                                .font(.body)
                                .foregroundColor(Color.white)
                                .padding()
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(filteredUsers) { user in
                                        Button(action: {
                                            selectedUser = user
                                        }) {
                                            VStack {
                                                if let profileImageUrl = user.profileImageUrl {
                                                    AsyncImage(url: URL(string: profileImageUrl)) { image in
                                                        image
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 60, height: 60)
                                                            .clipShape(Circle())
                                                    } placeholder: {
                                                        Image(systemName: "person.circle.fill")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 60, height: 60)
                                                            .clipShape(Circle())
                                                    }
                                                }

                                                Text(user.fullname)
                                                    .font(.subheadline)
                                                    .bold()
                                                    .foregroundColor(selectedUser == user ? .white : .black)
                                                    .padding(10)
                                                    .background(selectedUser == user ? (Color(red: 0/255, green: 56/255, blue: 101/255))  : Color.white)  //
                                                    .cornerRadius(15)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }

                    Divider()

             
                    VStack {
                        Text("Select a Report Reason")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.leading, 20)
                            .padding(.bottom, 5)
                            .foregroundColor(Color(red: 0/255, green: 56/255, blue: 101/255))

                        Picker("Select a report reason", selection: $selectedReason) {
                            ForEach(reportReasons, id: \.self) { reason in
                                Text(reason)
                                    .foregroundColor(Color.white)

                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(height: 100)
                        .padding(.horizontal, 20)
                    }

                    Divider()

               
                    VStack {
                        Text("Additional Notes (Optional)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.leading, 20)
                            .padding(.bottom, 2)
                            .foregroundColor(Color(red: 0/255, green: 56/255, blue: 101/255))

                        TextField("Enter additional notes here...", text: $additionalNotes)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(.horizontal, 10)
                            .frame(height: 120)
                    }

                    Divider()
                }
            }

            //Report user button place the bottom ( decerete)
            Button("Report User") {
                submitReport()
            }
            .disabled(selectedUser == nil || selectedReason == "Please Select Reason")
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(red: 0/255, green: 56/255, blue: 101/255))
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .alert(isPresented: $isSubmitted) {
                if let errorMessage = errorMessage {
                    return Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                } else {
                    return Alert(title: Text("Success"), message: Text("User reported successfully!"), dismissButton: .default(Text("OK")) {
                        dismiss()  //Back to Customer support :)
                    })
                }
            }
            .padding(.bottom, 20)
        }
        .background(Color(hex: "#9BCBEB")) // Entire Background
        .onAppear {
            fetchUsers()
        }
        .padding(.top, 20)
    }

    // report submit
    func submitReport() {
        guard let user = selectedUser else {
            errorMessage = "Please select a user."
            isSubmitted = true
            return
        }

        guard selectedReason != "Please Select Reason" else {
            errorMessage = "Please select a report reason."
            isSubmitted = true
            return
        }

        // Report submit function
        Report.submitReport(reportedUserId: user.uid, reason: selectedReason, additionalNotes: additionalNotes) { result in
            switch result {
            case .success():
                errorMessage = nil
                isSubmitted = true
            case .failure(let error):
                errorMessage = error.localizedDescription
                isSubmitted = true
            }
        }
    }

    // user name search filtering
    func filterUsers() {
        if searchText.isEmpty {
            filteredUsers = []
        } else {
            filteredUsers = users.filter { user in
                user.fullname.lowercased().hasPrefix(searchText.lowercased())
            }
        }
    }

 
    func fetchUsers() {
        Firestore.firestore()
            .collection("users")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching users: \(error.localizedDescription)")
                } else {
                    self.users = snapshot?.documents.compactMap { document -> User? in
                        try? document.data(as: User.self)
                    } ?? []
                    // filteredUsers
                    self.filteredUsers = []
                }
            }
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
    }
}
