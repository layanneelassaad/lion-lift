import SwiftUI


struct ProfileSettingsView: View {
    @State private var username: String = "Liam Parker"
    @State private var email: String = "liamparker@gmail.com"
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section(header: Text("Personal Information")) {
                TextField("Username", text: $username)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
            }
        }
        .navigationTitle("Profile Settings")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    // save logic goes here
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    ProfileSettingsView()
}
