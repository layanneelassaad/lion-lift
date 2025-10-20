// EmailUsView.swift
import SwiftUI
import Firebase
import FirebaseAuth // Added

struct EmailUsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var message: String = ""
    @State private var isSubmitted: Bool = false
    @State private var validationMessage: String? = nil

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack {
                // Top Header
                ZStack {
                    HStack {
                        Spacer()
                        Text("Email Us")
                            .font(Font.custom("Montserrat", size: 24).weight(.semibold))
                            .foregroundColor(Color(red: 0, green: 0.22, blue: 0.40))
                        Spacer()
                        Image(systemName: "chevron.left")
                            .foregroundColor(.clear) // Placeholder for spacing
                    }
                    .padding()
                }

                Divider()
                    .frame(height: 2)
                    .background(Color(red: 0.85, green: 0.85, blue: 0.85))

                // Message Input Form
                VStack(alignment: .leading, spacing: 20) {
                    Text("We'd love to hear from you! If you have any issues, suggestions, or feedback, please fill out the form below and we'll get back to you as soon as possible.")
                        .font(.callout)
                        .foregroundColor(.secondary)

                    TextEditor(text: $message)
                        .frame(height: 150)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(.bottom, 20)

                    Button(action: {
                        handleSubmit()
                    }) {
                        Text("Submit")
                            .font(Font.custom("Montserrat", size: 16).weight(.semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.61, green: 0.80, blue: 0.92))
                        
                            .cornerRadius(10)
                    }
                }
                .padding()

                Spacer()
            }
            .alert(isPresented: $isSubmitted) {
                if let validationMessage = validationMessage {
                    return Alert(
                        title: Text("Validation Failed"),
                        message: Text(validationMessage),
                        dismissButton: .default(Text("OK"))
                    )
                } else {
                    return Alert(
                        title: Text("Thank You!"),
                        message: Text("Your feedback has been successfully submitted."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
    }

    private func handleSubmit() {
        if message.isEmpty {
            validationMessage = "Please enter a message."
            isSubmitted = true
        } else {
            sendContactMessage()
        }
    }

    private func clearForm() {
        message = ""
    }

    private func sendContactMessage() {
        guard let email = Auth.auth().currentUser?.email else {
            validationMessage = "Unable to retrieve your email."
            isSubmitted = true
            return
        }

        ContactMessage.sendContactMessage(email: email, message: message) { result in
            switch result {
            case .success():
                validationMessage = nil
                clearForm()
            case .failure(let error):
                validationMessage = error.localizedDescription
            }
            isSubmitted = true
        }
    }
}

struct EmailUsView_Previews: PreviewProvider {
    static var previews: some View {
        EmailUsView()
    }
}
