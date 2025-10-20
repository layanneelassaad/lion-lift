import SwiftUI

struct AdditionalProfileInfoView: View {
    @State private var schoolAndYear: String = ""
    @State private var bio: String = ""
    @State private var venmo: String = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                // gradient background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.61, green: 0.80, blue: 0.92),
                        Color(red: 0.40, green: 0.70, blue: 0.85)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    // main title
                    VStack(spacing: 8) {
                        Text("Complete Your Profile")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Help us get to know you better")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top, 20)
                    
                    // fields
                    VStack(spacing: 20) {
                        CustomTextField(
                            icon: "graduationcap",
                            placeholder: "School and Year (e.g. CC '25)",
                            text: $schoolAndYear,
                            placeholderColor: .gray.opacity(0.5)
                        )
                        
                        VStack(alignment: .leading) {
                            Text("My Bio")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                                    .padding(.horizontal, 20)
                                
                                ZStack(alignment: .topLeading) {
                                    if bio.isEmpty {
                                        Text("Tell us a bit about yourself")
                                            .foregroundColor(.gray.opacity(0.5))
                                            .font(.subheadline)
                                            .padding(.horizontal, 30)
                                            .padding(.vertical, 14)
                                    }
                                    
                                    TextEditor(text: $bio)
                                        .frame(height: 120)
                                        .background(Color.white)
                                        .foregroundColor(.black)
                                        .cornerRadius(12)
                                        .padding(.horizontal)
                                }
                        }
                        
                        CustomTextField(
                            icon: "dollarsign.circle",
                            placeholder: "Venmo Username (optional)",
                            text: $venmo,
                            placeholderColor: .gray.opacity(0.5)
                        )
                    }
                    .padding(.horizontal)
                    
                    // Continue Button
                    Button(action: updateProfileInfo) {
                        Text("Continue")
                            .font(.headline)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func updateProfileInfo() {
        viewModel.updateAdditionalProfileInfo(
            schoolAndYear: schoolAndYear.isEmpty ? nil : schoolAndYear,
            bio: bio.isEmpty ? nil : bio,
            venmo: venmo.isEmpty ? nil : venmo
        )
        dismiss()
    }
}

// Custom TextField View
struct CustomTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var placeholderColor: Color = .gray.opacity(0.5)
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.black.opacity(0.6))
                .frame(width: 30)
            
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(placeholderColor)
                        .font(.subheadline)
                }
                
                TextField("", text: $text)
                    .foregroundColor(.black)
                    .font(.subheadline)
                    .accentColor(.black)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

#Preview {
    AdditionalProfileInfoView()
        .environmentObject(AuthViewModel())
}
