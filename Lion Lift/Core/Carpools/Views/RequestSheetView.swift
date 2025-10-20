//
//  RequestSheetView.swift
//  Carpools
//
//  Created by Emile Billeh on 14/11/2024.
//

import SwiftUI

struct RequestSheetView: View {
    @State private var requestMessage = ""
    var match: Match
    var viewModel = NewRequestViewModel()
    @Environment(\.presentationMode) var mode
    var body: some View {
        VStack {
            Text("Request")
                .font(.headline)
                .padding()
            TextField("Message...", text: $requestMessage, axis: .vertical)
                .padding()
                .frame(minHeight: 30)
                .modifier(Modifierr())
                .padding()
            
            HStack {
                Spacer()
                Button {
                    viewModel.sendRequest(messageText: requestMessage, match: match)
                    mode.wrappedValue.dismiss()
                } label: {
                    Text("Send")
                        .font(.caption)
                        .foregroundStyle(.white)
                        .padding(10)
                        .background(.blue)
                        .cornerRadius(5)
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                }
                .padding(.trailing)
            }
            
            Spacer()
        }
    }
}

struct Modifierr: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .background(Color(.systemGray6))
            .cornerRadius(10)
    }
}
