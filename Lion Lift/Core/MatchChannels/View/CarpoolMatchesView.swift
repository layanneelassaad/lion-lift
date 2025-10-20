//
//  MatchesView.swift
//  Lion Lift
//
//  Created by Emile Billeh on 03/12/2024.
//

import SwiftUI

struct CarpoolMatchesView: View {
    @State private var showChatView = false
    @State var selectedChannel: Match?
    @ObservedObject var viewModel = MatchesViewModel()

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            if let channel = selectedChannel {
                NavigationLink(
                    destination: ChannelView(channel: channel),
                    isActive: $showChatView,
                    label: { })
            }
            
            ScrollView {
                VStack(alignment: .leading) {
                    if !viewModel.matches.isEmpty {
                        ForEach(viewModel.matches) { channel in
                            if channel.uids.count > 1 {
                                MatchCell(viewModel: MatchCellViewModel(channel))
                            }
                        }
                        HStack { Spacer() }
                    } else {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("You have no carpools yet")
                                .foregroundStyle(.gray)
                            Spacer()
                        }
                        Spacer()
                    }
                }
            }
        }
    }
    
}


struct ChannelsView_Previews: PreviewProvider {
    static var previews: some View {
        CarpoolMatchesView()
    }
}
