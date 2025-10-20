//
//  ConfirmationView.swift
//  Lion Lift
//
//
//

import SwiftUI

struct ConfirmationView: View {
    var body: some View {
        VStack {
            Image(systemName: "checkmark.seal")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.green)
                .padding(.bottom, 20)

            Text("Thank you! Your flight was saved.")
                .font(Font.custom("Roboto Flex", size: 24))
                .fontWeight(.bold)
                .foregroundColor(.black)
        }
        .padding()
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }
}
