import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage = ""
    @State private var isLoading: Bool = false

    @State private var navigateToSignup = false
    @State private var navigateToForgotPassword = false
    @State private var navigateToMainTab = false
    
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.61, green: 0.80, blue: 0.92)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    Text("Login")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.white)
                    
                    if !viewModel.errorMessage.isEmpty {
                        Text("Incorrect username or password, please try again")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                        .modifier(TextFieldModifier())
                    
                    SecureField("Password", text: $password)
                        .modifier(TextFieldModifier())
                    
                    Button {
                        navigateToForgotPassword = true // Forgot password 버튼을 눌렀을 때 상태를 변경
                    } label: {
                        Text("Forgot password?")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .padding(.trailing, 24)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .navigationDestination(isPresented: $navigateToForgotPassword) {
                        ForgotPasswordView()
                            .environmentObject(viewModel)
                    }

                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Button {
                            viewModel.login(withEmail: email, password: password)
                        } label: {
                            Text("Log In")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 360, height: 44)
                                .background(Color(red: 0/255, green: 56/255, blue: 101/255)) // #003865
                                .cornerRadius(8)
                                .padding(.vertical)
                        }
                    }

                    HStack {
                        Text("Don't have an account? ")
                            .font(.caption)
                            .foregroundColor(.black)
                        
                        NavigationLink {
                            SignUpView()
                        } label: {
                            Text("Sign Up")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.bottom, 16)
                    
                    Spacer()
                }
                .padding(.top, 32)
            }
            .onAppear() {
                viewModel.errorMessage = ""
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
            .environmentObject(AuthViewModel())
    }
}
