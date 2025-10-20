//
//  AuthViewModel.swift
//  Lion Lift
//
//  Created by Adam Sherif on 12/2/24.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var errorMessage: String = ""
    @Published var didAuthenticateUser = false
    
    private var tempUserSession: FirebaseAuth.User?
    
    static var shared = AuthViewModel()
    
    init() {
        self.userSession = Auth.auth().currentUser
        fetchUser()
    }
    
    func login(withEmail email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            
            if let error = error {
                print("DEBUG: Failed to login with error: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
                return
            }
            
            guard let user = result?.user else { return }
            self.userSession = user
            
            
            print("DEBUG: Did log user in")
            
        }
    }
    
    func updateAdditionalProfileInfo(schoolAndYear: String? = nil, bio: String? = nil, venmo: String? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var updateData: [String: Any] = ["schoolAndYear": schoolAndYear as Any]

        if let bio = bio {
            updateData["bio"] = bio
        }
        
        if let venmo = venmo {
            updateData["venmo"] = venmo
        }
        
        Firestore.firestore().collection("users").document(uid).updateData(updateData) { error in
            if let error = error {
                print("DEBUG: Failed to update profile info \(error.localizedDescription)")
            } else {
                print("DEBUG: Successfully updated profile info")
            }
            self.userSession = self.tempUserSession
        }
    }
    
    func register(withEmail email: String, password: String, phoneNumebr: String, fullname: String, profileImageUrl: UIImage?, nextFlightDateAndTime: String, nextFlightAirport: String, departing: Bool, bio: String = "", schoolAndYear: String = "", venmo: String = "") {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            
            if let error = error {
                print("DEBUG: Failed to register with error: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
                return
                
            }
            
            guard let user = result?.user else { return }
            self.tempUserSession = user
            
            print("DEBUG: Registered user sucessfully")
            
            let data = ["email": email,
                        "phoneNumber": phoneNumebr,
                        "fullname": fullname,
                        "uid": user.uid,
                        "nextFlightDateAndTime": Timestamp(date: Date()),
                        "nextFlightAirport": nextFlightAirport,
                        "departing": departing,
                        "bio": bio.isEmpty ? "" : bio,
                        "schoolAndYear": schoolAndYear.isEmpty ? "" : schoolAndYear,
                        "venmo": venmo.isEmpty ? "" : venmo
                        ]
            
            
            
            Firestore.firestore().collection("users")
                .document(user.uid)
                .setData(data) { _ in
                    self.didAuthenticateUser = true
                }
        }
    }
    
    func signOut() {
        userSession = nil
        try? Auth.auth().signOut()
    }
    
    func uploadProfileImage(_ image: UIImage) {
        guard let uid = tempUserSession?.uid else { return }
        
        ImageUploader.uploadImage(image: image) { profileImageUrl in
            Firestore.firestore().collection("users")
                .document(uid)
                .updateData(["profileImageUrl": profileImageUrl]) { _ in
                    self.tempUserSession = self.tempUserSession
                }
        }
    }
    
    func serviceFetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        Firestore.firestore().collection("users")
            .document(uid)
            .getDocument { snapshot, _ in
                guard let snapshot = snapshot else { return }
                
                guard let user = try? snapshot.data(as: User.self) else { return }
                
                
                
                completion(user)
            }
    }
    
    func fetchUser() {
        guard let uid = self.userSession?.uid else { return }
        
        serviceFetchUser(withUid: uid) { user in
            self.currentUser = user
        }
    }
    
    func changePassword(currentPassword: String, newPassword: String, completion: @escaping (Bool, String?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(false, "No user is logged in.")
            return
        }

        guard let email = user.email else {
            completion(false, "User email is unavailable.")
            return
        }

        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        user.reauthenticate(with: credential) { _, error in
            if let error = error {
                completion(false, "Reauthentication failed: \(error.localizedDescription)")
                return
            }
            
            user.updatePassword(to: newPassword) { error in
                if let error = error {
                    completion(false, "Failed to update password: \(error.localizedDescription)")
                } else {
                    completion(true, nil)
                }
            }
        }
    }
}

