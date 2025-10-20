import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    @State private var email: String = ""
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var emailSent: Bool = false // Email sent status
    @State private var isNavigatingToLogin: Bool = false // Navigation state for login screen

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.61, green: 0.80, blue: 0.92)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    Text("Forgot Password")
                        .font(.custom("Poppins", size: 24).weight(.semibold))
                        .foregroundColor(.white)
                        .padding(.top, 50)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Email Address")
                            .font(.custom("Poppins", size: 16).weight(.semibold))
                            .foregroundColor(.white)

                        TextField("Enter your email", text: $email)
                            .onChange(of: email) { oldValue, newValue in
                                email = newValue.lowercased() // Automatically convert to lowercase
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(5)
                            .foregroundColor(.black)
                            .font(.custom("Poppins", size: 14))



                    }
                    .padding(.horizontal, 20)

                    if emailSent {
                        // Message after email is sent
                        Text("A password reset link has been sent to \(email). Please check your inbox.")
                            .foregroundColor(.white)
                            .padding(.top, 20)

                        HStack {
                            Button(action: {
                                isNavigatingToLogin = true
                            }) {
                                Text("Go to Login")
                                    .font(.custom("Poppins", size: 16).weight(.bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, minHeight: 50)
                                    .background(Color(red: 0, green: 0.22, blue: 0.40))
                                    .cornerRadius(10)
                            }

                            Button(action: {
                                sendResetEmail() // Resend email
                            }) {
                                Text("Resend")
                                    .font(.custom("Poppins", size: 16).weight(.bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, minHeight: 50)
                                    .background(Color(red: 0, green: 0.22, blue: 0.40))
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.top, 20)
                    } else {
                        // Send reset email button
                        Button(action: {
                            sendResetEmail()
                        }) {
                            Text("Send Reset Email")
                                .font(.custom("Poppins", size: 16).weight(.bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(Color(red: 0, green: 0.22, blue: 0.40))
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }

                    Spacer()
                }
            }
            .navigationDestination(isPresented: $isNavigatingToLogin) {
                LoginView() // Navigate to LoginView
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Reset Password"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func sendResetEmail() {
        guard !email.isEmpty else {
            alertMessage = "Please enter your email address."
            showAlert = true
            return
        }

        // Send password reset email using Firebase
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                alertMessage = "Failed to send reset email: \(error.localizedDescription)"
            } else {
                alertMessage = "A password reset link has been sent to \(email). Please check your inbox."
                emailSent = true // Update email sent status
            }
            showAlert = true
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
