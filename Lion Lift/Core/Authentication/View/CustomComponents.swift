//
//  CustomComponents.swift
//  Flights
//
//  Created by Chloe Lee on 11/14/24.
//

import SwiftUI

// Reusable Input Field
struct CustomInputField: View {
    var placeholder: String
    var isSecure: Bool = false
    @Binding var text: String

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .frame(height: 50)
                .cornerRadius(5)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .padding(.horizontal, 15)
                    .foregroundColor(.black)
                    .font(.custom("Poppins", size: 13))
            } else {
                TextField(placeholder, text: $text)
                    .padding(.horizontal, 15)
                    .foregroundColor(.black)
                    .font(.custom("Poppins", size: 13))
            }
        }
    }
}


struct CustomButton: View {
    var title: String
    var backgroundColor: Color
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Roboto", size: 14).weight(.bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(backgroundColor)
                .cornerRadius(5)
        }
    }
}
