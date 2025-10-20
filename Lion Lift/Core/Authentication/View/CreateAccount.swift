import SwiftUI

struct CreateAccountView: View {
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var password: String = ""
    @State private var showMessage: String? = nil
    @State private var navigateToLogin = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.61, green: 0.80, blue: 0.92)
                    .edgesIgnoringSafeArea(.all)

                ScrollView {
                    VStack(spacing: 20) {
                        Text("Create New Account")
                            .font(.custom("Gilroy ☞", size: 24).weight(.bold))
                            .foregroundColor(.white)

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Columbia Email")
                                .font(.custom("Poppins", size: 13))
                                .foregroundColor(.white)

                            TextField("Enter your Columbia email", text: $email)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(5)
                                .font(.custom("Poppins", size: 14))
                                .autocapitalization(.none)

                            Text("Phone Number")
                                .font(.custom("Poppins", size: 13))
                                .foregroundColor(.white)

                            TextField("Enter your phone number", text: $phoneNumber)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(5)
                                .font(.custom("Poppins", size: 14))
                                .keyboardType(.phonePad)

                            Text("Password")
                                .font(.custom("Poppins", size: 13))
                                .foregroundColor(.white)

                            SecureField("Enter your password", text: $password)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(5)
                                .font(.custom("Poppins", size: 14))
                        }
                        .padding(.horizontal, 20)

                        if let message = showMessage {
                            Text(message)
                                .font(.custom("Poppins", size: 14))
                                .foregroundColor(message.contains("successfully") ? .green : .red)
                                .multilineTextAlignment(.center)
                                .padding(.top, 10)
                        }

                        Button(action: handleCreateAccount) {
                            Text("Create Account")
                                .font(.custom("Roboto", size: 16).weight(.medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(Color(red: 0, green: 0.22, blue: 0.40))
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 20)

                        HStack {
                            Text("Already have an account?")
                                .font(.custom("Roboto", size: 13).weight(.medium))
                                .foregroundColor(Color(red: 0.28, green: 0.28, blue: 0.28))
                            NavigationLink(destination: LoginView()) {
                                Text("Login")
                                    .font(.custom("Roboto", size: 13).weight(.medium))
                                    .underline()
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
        }
    }

    func handleCreateAccount() {
        showMessage = nil

        guard email.hasSuffix("@columbia.edu") else {
            showMessage = "Please enter a valid Columbia email."
            return
        }
        guard !phoneNumber.isEmpty else {
            showMessage = "Phone number cannot be empty."
            return
        }
        guard !password.isEmpty else {
            showMessage = "Password cannot be empty."
            return
        }

        NetworkManager.shared.signUp(email: email, phoneNumber: phoneNumber, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Sign-up API succeeded")
                    showMessage = "Account created successfully!"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        navigateToLogin = true
                    }
                case .failure(let error):
                    print("Sign-up API failed: \(error.localizedDescription)")
                    showMessage = "Failed to create account: \(error.localizedDescription)"
                }
            }
        }
    }
}

// 미리보기 추가
struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
            .previewDevice("iPhone 15") // 여기서 원하는 디바이스를 선택할 수 있습니다.
    }
}
