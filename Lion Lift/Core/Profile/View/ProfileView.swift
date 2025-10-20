import SwiftUI
import Kingfisher
import Firebase

struct ProfileView: View {
    
    @State private var logoutHit = false
    @State private var editProfileSheet = false
    @State private var customerSupport = false
    @EnvironmentObject var viewModel: AuthViewModel
    private let accentColor = Color.blue.opacity(0.8)
    private let buttonBackgroundColor = Color(hex: "#9BCBEB")
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    headerSection
                    userDetailsCard
                    upcomingFlightsSection
                    
                    actionButtons
                    
                    Spacer()
                }
                .padding()
            }
            .toolbar {
                toolbarContent
            }
        }
        .onAppear() {
            viewModel.fetchUser()
        }
    }
    
    // header with welcome  [name] and profile picture
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Welcome")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                if let user = viewModel.currentUser {
                    Text(user.fullname)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
            }
            
            Spacer()
            
            if let user = viewModel.currentUser,
               let profileImageUrl = user.profileImageUrl {
                KFImage(URL(string: profileImageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(accentColor, lineWidth: 3)
                    )
            }
        }
        .padding()
    }
    
    // user info card
    private var userDetailsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Profile Details")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button {
                    editProfileSheet.toggle()
                } label: {
                    Image(systemName: "pencil.circle.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(accentColor)
                }
            }
            
            if let user = viewModel.currentUser {
                detailRow(icon: "envelope", title: "Email", value: user.email)
                detailRow(icon: "phone", title: "Phone", value: user.phoneNumber)
                
                if let schoolAndYear = user.schoolAndYear {
                    detailRow(icon: "graduationcap", title: "School", value: schoolAndYear)
                }
                
                if let bio = user.bio {
                    detailRow(icon: "text.quote", title: "Bio", value: bio)
                }
                
                if let venmo = user.venmo {
                    detailRow(icon: "dollarsign.circle", title: "Venmo", value: venmo)
                }
            }
        }
        .padding()
        .background(accentColor.opacity(0.1))
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
        .fullScreenCover(isPresented: $editProfileSheet) {
            EditProfileSheet()
        }
    }
    
    // upcoming flights section
    private var upcomingFlightsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Upcoming Flights")
                .font(.headline)
                .foregroundColor(.secondary)
            
            if let user = viewModel.currentUser {
                if user.nextFlightAirport.isEmpty {
                    Text("No upcoming flights")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(user.nextFlightAirport)
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        Text("Departure: \(formatFirebaseTimestamp(user.nextFlightDateAndTime))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: .gray.opacity(0.3), radius: 3)
                }
            }
        }
    }
    
    private var actionButtons: some View {
        HStack(spacing: 16) {
            Button {
                customerSupport.toggle()
            } label: {
                HStack {
                    Image(systemName: "phone.bubble.fill")
                        .foregroundColor(.white)
                    Text("Customer Support")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .padding()
                .background(buttonBackgroundColor)
                .cornerRadius(10)
                .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
            }
            .fullScreenCover(isPresented: $customerSupport) {
                CustomerSupportView()
            }
            
            Button {
                logoutHit.toggle()
            } label: {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                        .foregroundColor(.white)
                    Text("Log Out")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.red)
                .cornerRadius(10)
                .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
            }
            .alert("Log Out", isPresented: $logoutHit) {
                Button("Log Out", role: .destructive) {
                    viewModel.signOut()
                }
                Button("Cancel", role: .cancel) {}
            }
        }
        .padding(.top, 20)
    }
    
    // toolbar
    private var toolbarContent: some ToolbarContent {
        Group {
            ToolbarItem(placement: .topBarLeading) {
            }
            
            ToolbarItem(placement: .topBarTrailing) {
            }
        }
    }
    
    // helper function for detail rows
    private func detailRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(accentColor)
                .frame(width: 30)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.subheadline)
            }
        }
        .padding(.vertical, 4)
    }
    
    func formatFirebaseTimestamp(_ timestamp: Timestamp?) -> String {
        guard let timestamp = timestamp else { return "N/A" }
        let date = timestamp.dateValue()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hex)
        var hexInt: UInt64 = 0
        scanner.scanHexInt64(&hexInt)
        
        self.init(
            .sRGB,
            red: Double((hexInt & 0xFF0000) >> 16) / 255.0,
            green: Double((hexInt & 0x00FF00) >> 8) / 255.0,
            blue: Double(hexInt & 0x0000FF) / 255.0,
            opacity: 1.0
        )
    }
}

#Preview {
    ProfileView()
}
