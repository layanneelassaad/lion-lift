import SwiftUI

struct CustomerSupportView: View {
    @Environment(\.dismiss) var dismiss // NavigationStack back button
    enum ContactDestination: Hashable {
        case emailUs
        case reportUser
        case chatbot
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()

                VStack {
                    // Title Header
                    VStack {
                        Text("Customer Support")
                            .font(Font.custom("Montserrat", size: 24).weight(.semibold))
                            .foregroundColor(Color(red: 0, green: 0.22, blue: 0.40)) // Correct color initialization

                        // Helpful Guiding Text
                        Text("How can we assist you today?")
                            .font(Font.custom("Montserrat", size: 18))
                            .foregroundColor(Color.gray)
                            .padding(.top, 8)

                        // Chat and Contact Us Buttons
                        VStack(spacing: 30) {
                            
                            NavigationLink(value: ContactDestination.chatbot) { // Added NavigationLink for Chatbot
                                ContactButton(title: "Chat with Assistant", iconName: "message.fill") // Button for Chatbot
                            }
                            // E-mail us Button
                            NavigationLink(value: ContactDestination.emailUs) {
                                ContactButton(title: "E-mail us", iconName: "envelope.fill")
                            }
                            // Report the User Button
                            NavigationLink(value: ContactDestination.reportUser) {
                                ContactButton(title: "Report a User", iconName: "exclamationmark.triangle.fill")
                            }
                            

                            
                        }
                        .navigationDestination(for: ContactDestination.self) { destination in
                            switch destination {
                            case .emailUs:
                                EmailUsView()
                            case .reportUser:
                                ReportView()
                            case .chatbot: // Handle navigation to the ChatbotView
                                ChatbotView()
                            }
                        }
                        .padding(.top, 20)
                    }
                    

                    Divider()
                        .frame(width: 369, height: 2)
                        .background(Color(red: 0.85, green: 0.85, blue: 0.85)) // Correct color initialization
                        .padding(.top, 10)

                    Spacer()
                }
                .padding()
            }
            
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss() // Go back to previous screen
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}

struct ContactButton: View {
    let title: String
    let iconName: String

    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 353, height: 71)
                .foregroundColor(.clear)
                .background(Color(red: 0.61, green: 0.80, blue: 0.92)) // Correct color initialization
                .cornerRadius(21)
            HStack {
                Text(title)
                    .font(Font.custom("Montserrat", size: 16).weight(.semibold))
                    .foregroundColor(.black)
                    .padding(.leading, 20) // Add padding to the left of the text
                Spacer() // This ensures space between text and icon
                Image(systemName: iconName) // Icon on the right
                    .foregroundColor(.black)
                    .padding(.trailing, 20) // Add padding to the right of the icon
            }
            .frame(maxWidth: .infinity) // Ensures that the HStack expands to fill the button
        }
    }
}

struct CustomerSupportView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerSupportView()
    }
}
