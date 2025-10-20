//
//  ChannelView.swift
//  Lion Lift
//
//  Created by Emile Billeh on 03/12/2024.
//

import SwiftUI

struct ChannelView: View {
    @State private var messageText = ""
    @ObservedObject var viewModel: ChannelViewModel
    private let channel: Match
    
    init(channel: Match) {
        self.channel = channel
        self.viewModel = ChannelViewModel(channel: channel)
    }
    
    @State private var scrollViewID = UUID()

    var body: some View {
        VStack {
            GeometryReader { geometry in
                ScrollViewReader { scrollViewProxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(viewModel.messages) { message in
                                MessageView(viewModel: MessageViewModel(message: message))
                                    .id(message.id) // Add id to each message view
                            }
                        }
                        .rotationEffect(.degrees(180))
                        .frame(width: geometry.size.width)
                    }
                    .rotationEffect(.degrees(180))
                }
            }

            MessageInputView(text: $messageText, action: sendMessage)
        }
        .navigationTitle(channel.airport)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sendMessage() {
        if messageText == "" {
            return
        } else {
            viewModel.sendMessage(messageText)
            messageText = ""
        }
    }
}
