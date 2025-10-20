//
//  MatchCell.swift
//  Lion Lift
//
//  Created by Emile Billeh on 03/12/2024.
//

import SwiftUI
import Kingfisher

struct MatchCell: View {
    @ObservedObject var viewModel: MatchCellViewModel
   
    var body: some View {
        NavigationLink(destination: ChannelView(channel: viewModel.match)) {
            VStack {
                HStack {
                    
                    VStack (alignment: .leading, spacing: 4) {
                        Text(viewModel.channelName)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.black)
                        
                        Text(viewModel.lastMessage)
                            .font(.system(size: 15))
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                Divider()
            }
            .padding(.top)
        }
        .id(viewModel.match.id)
    }
}
