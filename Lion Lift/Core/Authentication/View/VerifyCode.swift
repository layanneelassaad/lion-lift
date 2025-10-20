import SwiftUI
import FirebaseFirestore

struct VerifyCodeView: View {
    let email: String
    let verificationCode: String
    @State private var enteredCode: String = ""
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var isCodeValid: Bool = false

    var body: some View {
        ZStack {
            Color(red: 0.61, green: 0.80, blue: 0.92)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("Verify Code")
                    .font(.custom("Poppins", size: 24).weight(.semibold))
                    .foregroundColor(.white)
                    .padding(.top, 50)

                Text("Enter the 6-digit code sent to \(email)")
                    .font(.custom("Poppins", size: 16))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                TextField("Enter Code", text: $enteredCode)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
                    .foregroundColor(.black)
                    .font(.custom("Poppins", size: 16))
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .frame(maxWidth: .infinity, minHeight: 50)

                Button(action: {
                    verifyCode()
                }) {
                    Text("Verify")
                        .font(.custom("Poppins", size: 16).weight(.bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color(red: 0, green: 0.22, blue: 0.40))
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Code Verification"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }

                Spacer()
            }
            .padding(.horizontal, 20)
        }
    }

    private func verifyCode() {
        guard !enteredCode.isEmpty else {
            alertMessage = "Please enter the code."
            showAlert = true
            return
        }

        let db = Firestore.firestore()
        db.collection("password_reset_codes").document(email.lowercased()).getDocument { snapshot, error in
            if let error = error {
                alertMessage = "Error fetching code: \(error.localizedDescription)"
                showAlert = true
            } else if let data = snapshot?.data(),
                      let code = data["code"] as? String,
                      let expiresAt = data["expiresAt"] as? Timestamp,
                      expiresAt.dateValue() > Date() {
                if code == enteredCode {
                    alertMessage = "Code verified successfully!"
                    isCodeValid = true
                    // Proceed to password reset screen
                } else {
                    alertMessage = "Invalid code. Please try again."
                }
            } else {
                alertMessage = "Code expired or does not exist."
                showAlert = true
            }
        }
    }
}
