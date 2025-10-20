//
//  MatchRowView.swift
//  Carpools
//
//  Created by Emile Billeh on 14/11/2024.
//

import SwiftUI
import Kingfisher
import Firebase

struct MatchRowView: View {
    let match: Match
    @State private var showRequestSheet = false
    @State private var isProfileViewPresented = false
    
    var body: some View {
        HStack {
            if let profileImageUrl = match.userProfileImageUrl {
                KFImage(URL(string: profileImageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 65, height: 65)
                    .clipShape(Circle())
                    .onTapGesture {
                        isProfileViewPresented = true
                    }
            } else {
                ZStack {
                    Circle()
                        .foregroundColor(.gray)
                        .frame(width: 65, height: 65)
                    Image(systemName: "person")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundColor(.white)
                }
                .onTapGesture {
                    isProfileViewPresented = true
                }
            }
                
            VStack (alignment: .leading, spacing: 4) {
                Text(match.userFullName)
                    .font(.footnote).bold()
                    .foregroundColor(.black)
                Text(match.airport)
                    .font(.footnote)
                    .foregroundColor(.gray)
                Text(formatTimestamp(match.dateAndTime))
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            Spacer()
            
            Button {
                showRequestSheet.toggle()
            } label: {
                Text("Request")
                    .padding(10)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .font(.caption)
                    .cornerRadius(5)
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            }
            .sheet(isPresented: $showRequestSheet) {
                RequestSheetView(match: match)
                    .ignoresSafeArea()
                    .presentationDetents([.fraction(0.5), .fraction(0.6)])
            }
        }
        .padding(.horizontal)
        .sheet(isPresented: $isProfileViewPresented) {
            OtherUserProfileView(match: match)
        }
    }
    
    private func formatTimestamp(_ timestamp: Timestamp) -> String {
        let date = timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}

#Preview {
    MatchRowView(match: Match.dummyMatch)
}
