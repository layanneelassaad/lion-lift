import SwiftUI

struct ChangePasswordView: View {
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section(header: Text("Change Password")) {
                SecureField("Current Password", text: $currentPassword)
                SecureField("New Password", text: $newPassword)
                SecureField("Confirm New Password", text: $confirmPassword)
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
            }
        }
        .navigationTitle("Change Password")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    handleChangePassword()
                }
            }
        }
    }
    
    private func handleChangePassword() {
        if newPassword != confirmPassword {
            errorMessage = "Passwords do not match."
        } else if newPassword.isEmpty || currentPassword.isEmpty {
            errorMessage = "Please fill in all fields."
        } else {
            // password update logic goes heere
            dismiss()
        }
    }
}

#Preview {
    ChangePasswordView()
}
