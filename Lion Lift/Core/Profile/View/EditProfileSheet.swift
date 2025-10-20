//
//  EditProfileSheet.swift
//  Lion Lift
//
//  Created by Adam Sherif on 12/5/24.
//

import SwiftUI
import Kingfisher
import Firebase
import FirebaseFirestore

struct EditProfileSheet: View {
    
    @State private var fullname: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: String?
    @State private var emailErrorMessage: String?
    @State private var bio: String = ""
    @State private var schoolAndYear: String = ""
    @State private var venmo: String = ""
    
    @State private var showAlert = false
    
    @State private var selectedImage: UIImage?
    @State private var image: UIImage?
    
    @State private var showImagePicker = false
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        
        VStack {
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "multiply")
                    .imageScale(.large)
                    .foregroundColor(.black)
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            if let user = viewModel.currentUser {
                Button {
                    showImagePicker.toggle()
                } label: {
                    ZStack(alignment: .bottomTrailing) {
                        if let image = image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 120, height: 120)
                            
                        } else if let profileImageUrl = user.profileImageUrl {
                            KFImage(URL(string: profileImageUrl))
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 120, height: 120)
                        } else {
                            ZStack {
                                Circle()
                                    .frame(width: 120, height: 120)
                                    .foregroundColor(.white)
                                
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .foregroundColor(Color(red: 0.63, green: 0.82, blue: 0.96))
                                    .scaledToFill()
                                    .frame(width: 180, height: 180)
                            }
                        }
                        
                        Image(systemName: "pencil")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                            .padding(10)
                            .background(.white)
                            .clipShape(Circle())
                            .offset(x: -8, y: -8)
                        
                    }
                }
                .fullScreenCover(isPresented: $showImagePicker) {
                    ImagePicker(selectedImage: $image)
                }
            }
            
            if let user = viewModel.currentUser {
                Form {
                    Section(header: Text("Personal Information")) {
                        TextField("Full Name", text: $fullname)
                            .onAppear() {
                                fullname = user.fullname
                            }
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .onAppear() {
                                email = user.email
                            }
                        TextField("Phone Number", text: $phoneNumber)
                            .keyboardType(.emailAddress)
                            .onAppear() {
                                phoneNumber = user.phoneNumber
                            }
                        TextField("Bio", text: $bio)
                            .onAppear() {
                                bio = user.bio ?? ""
                            }
                            
                        TextField("School and Year", text: $schoolAndYear)
                            .onAppear() {
                                schoolAndYear = user.schoolAndYear ?? ""
                            }
                            
                        TextField("Venmo", text: $venmo)
                            .onAppear() {
                                venmo = user.venmo ?? ""
                            }
                    }
                }
                .cornerRadius(20)
                .frame(height: 200)
                .padding()
                
                if let errorMessage = emailErrorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
                
                Form {
                    Section(header: Text("Change Password")) {
                        SecureField("Current Password", text: $currentPassword)
                        SecureField("New Password", text: $newPassword)
                        SecureField("Confirm New Password", text: $confirmPassword)
                    }
                }
                .cornerRadius(20)
                .frame(height: 200)
                .padding([.horizontal, .top])
                
                if !currentPassword.isEmpty {
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }
                }
                
                
                Button {
                    handleChangePassword()
                    
                    if user.email == email {
                        
                        viewModel.updateUserProfile(email: email, fullname: fullname, phoneNumber: phoneNumber, image: image, bio: bio, schoolAndYear: schoolAndYear, venmo: venmo) {
                            showAlert = true
                            print("Save button hit...")
                        }
                        
                    } else {
                        if validateEmail(email) {
                            viewModel.updateUserProfile(email: email, fullname: fullname, phoneNumber: phoneNumber, image: image, bio: bio, schoolAndYear: schoolAndYear, venmo: venmo) {
                                showAlert = true
                                print("Save Button hit...")
                            }
                        } else {
                            emailErrorMessage = "Please check the email address you have provided"
                        }
                    }
                    
                    print("User email is \(user.email)")
                    print("Edit profile email is \(email)")
                    print("new bio: \(bio)")
                    print("new schoolandyear: \(schoolAndYear)")
                    print("new venmo: \(venmo)")
                    
                } label: {
                    Text("Save")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 360, height: 44)
                        .background(Color(red: 0/255, green: 56/255, blue: 101/255))
                        .cornerRadius(8)
                        .padding(.vertical)
                }
                .alert("Done", isPresented: $showAlert) {
                    Button("OK") {
                        dismiss()
                    }
                } message: {
                    Text("Your information was successfully updated.")
                }
            }
            
            Spacer()
        }
    }
    
    private func handleChangePassword() {
        if newPassword != confirmPassword {
            errorMessage = "Passwords do not match."
            return
        } else if newPassword.isEmpty || currentPassword.isEmpty {
            errorMessage = "Please fill in all fields."
            return
        }

        AuthViewModel.shared.changePassword(currentPassword: currentPassword, newPassword: newPassword) { success, error in
            if success {
                showAlert = true
            } else {
                errorMessage = error
            }
        }
    }
    
    private func validateEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@columbia\.edu$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
}

#Preview {
    EditProfileSheet()
}

extension AuthViewModel {
    func updateUserProfile(email: String, fullname: String, phoneNumber: String, image: UIImage?, bio: String?, schoolAndYear: String?, venmo: String?, completion: @escaping () -> Void) {
        if (currentUser?.fullname == fullname) && (currentUser?.email == email) && (currentUser?.phoneNumber == phoneNumber) && (image == nil && (currentUser?.bio == bio) && (currentUser?.schoolAndYear == schoolAndYear) && (currentUser?.venmo == venmo)) {
            return
        } else {
            guard let uid = userSession?.uid else { return }
            
            var data = ["email": email,
                        "fullname": fullname,
                        "phoneNumber": phoneNumber,
                        "bio": bio,
                        "schoolAndYear": schoolAndYear,
                        "venmo": venmo]
            
            if let image = image {
                ImageUploader.uploadImage(image: image) { profileImageUrl in
                    data["profileImageUrl"] = profileImageUrl

                    Firestore.firestore().collection("users")
                        .document(uid)
                        .updateData(data) { error in
                            if let error = error {
                                print("DEBUG: Failed to update user data with error \(error.localizedDescription)")
                                return
                            }
                            self.fetchUser()
                            completion()
                        }
                }
            } else {
                Firestore.firestore().collection("users")
                    .document(uid)
                    .updateData(data) { error in
                        if let error = error {
                            print("DEBUG: Failed to update user data with error \(error.localizedDescription)")
                            return
                        }
                        self.fetchUser()
                        completion()
                    }
            }
        }
    }
}
