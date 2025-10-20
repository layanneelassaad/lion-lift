import SwiftUI

struct CreateNewPasswordView: View {
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var showMessage: String? = nil

    var body: some View {
        ZStack {
            // Background Color
            Color(red: 0.61, green: 0.80, blue: 0.92)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                // Header Text
                Text("Create New Password")
                    .font(.custom("Poppins", size: 24).weight(.semibold))
                    .foregroundColor(.white)
                    .padding(.top, 50)

                // Input Fields
                VStack(alignment: .leading, spacing: 10) {
                    Text("New Password")
                        .font(.custom("Poppins", size: 16).weight(.semibold))
                        .foregroundColor(.white)

                    SecureField("Enter new password", text: $newPassword)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5)
                        .font(.custom("Poppins", size: 14))

                    Text("Confirm Password")
                        .font(.custom("Poppins", size: 16).weight(.semibold))
                        .foregroundColor(.white)

                    SecureField("Confirm new password", text: $confirmPassword)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5)
                        .font(.custom("Poppins", size: 14))
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)

                // Validation Message
                if let message = showMessage {
                    Text(message)
                        .font(.custom("Poppins", size: 14))
                        .foregroundColor(message == "Password changed successfully!" ? .green : .red)
                        .padding(.top, 10)
                }

                // Submit Button
                Button(action: {
                    handlePasswordChange()
                }) {
                    Text("Submit")
                        .font(.custom("Poppins", size: 16).weight(.bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color(red: 0, green: 0.22, blue: 0.40))
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                Spacer() 
            }
            .frame(maxWidth: .infinity, alignment: .top)
        }
    }

    func handlePasswordChange() {
        if newPassword.isEmpty || confirmPassword.isEmpty {
            showMessage = "All fields are required."
        } else if newPassword != confirmPassword {
            showMessage = "Passwords do not match."
        } else {
            showMessage = "Password changed successfully!"
        }
    }
}

struct CreateNewPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewPasswordView()
            .previewDevice("iPhone 15 Pro")
    }
}
