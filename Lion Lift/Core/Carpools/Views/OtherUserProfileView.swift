//
//  OtherUserProfileView.swift
//  Lion Lift
//
//  Created by Chase Preston on 12/9/24.
//

import SwiftUI
import Kingfisher
import Firebase

struct OtherUserProfileView: View {
    let uid: String
    let userFullName: String
    let userProfileImageUrl: String?
    
    @Environment(\.dismiss) private var dismiss
    @State private var userDetails: UserDetails?
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    // Initializer for Match
    init(match: Match) {
        self.uid = match.uid
        self.userFullName = match.userFullName
        self.userProfileImageUrl = match.userProfileImageUrl
    }
    
    // Initializer for Request
    init(request: Request) {
        self.uid = request.uid // Assuming Request has a userId property
        self.userFullName = request.fullname
        self.userProfileImageUrl = request.profileImageUrl
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                // Header with Back Button and Profile Picture
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .imageScale(.large)
                    }
                    Spacer()
                }
                .padding()
                
                // Profile Picture
                if let profileImageUrl = userProfileImageUrl {
                    KFImage(URL(string: profileImageUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.blue, lineWidth: 4)
                        )
                } else {
                    ZStack {
                        Circle()
                            .foregroundColor(.gray)
                            .frame(width: 150, height: 150)
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 75, height: 75)
                            .foregroundColor(.white)
                    }
                }
                
                // User Name
                Text(userFullName)
                    .font(.title2)
                    .fontWeight(.bold)
                
                // User Details
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else if let userDetails = userDetails {
                    // Detailed User Information
                    VStack(alignment: .leading, spacing: 15) {
                        DetailRow(icon: "envelope", text: userDetails.email)
                        DetailRow(icon: "phone", text: userDetails.phoneNumber ?? "No phone number")
                        
                        Text("About")
                            .font(.headline)
                        
                        // Additional User Information
                        if let schoolAndYear = userDetails.schoolAndYear, !schoolAndYear.isEmpty {
                            DetailRow(icon: "graduationcap", text: schoolAndYear)
                        }
                        
                        if let venmo = userDetails.venmo, !venmo.isEmpty {
                            DetailRow(icon: "dollarsign.circle", text: "Venmo: \(venmo)")
                        }
                        if let bio = userDetails.bio, !bio.isEmpty {
                            Text(bio)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .frame(maxWidth: 350)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .multilineTextAlignment(.leading)
                }
                
                Spacer()
            }
        }
        .onAppear {
            fetchUserDetails()
        }
        .navigationBarHidden(true)
    }
    
    private func fetchUserDetails() {
        isLoading = true
        errorMessage = nil
        
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { (document, error) in
            isLoading = false
            
            if let error = error {
                errorMessage = "Failed to load user details: \(error.localizedDescription)"
                return
            }
            
            guard let document = document, document.exists,
                  let data = document.data() else {
                errorMessage = "User details not found"
                return
            }
            
            // parse user details from Firestore
            userDetails = UserDetails(
                email: data["email"] as? String ?? "",
                phoneNumber: data["phoneNumber"] as? String,
                bio: data["bio"] as? String,
                schoolAndYear: data["schoolAndYear"] as? String,
                venmo: data["venmo"] as? String
            )
        }
    }
    
    private func formatTimestamp(_ timestamp: Timestamp) -> String {
        let date = timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}

// struct for user details
struct UserDetails {
    let email: String
    let phoneNumber: String?
    let bio: String?
    let schoolAndYear: String?
    let venmo: String?
}

// detail row view
struct DetailRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 30)
            Text(text)
                .font(.subheadline)
        }
    }
}

#Preview {
    OtherUserProfileView(match: Match.dummyMatch)
}
