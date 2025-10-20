//
//  MatchCellViewModel.swift
//  Lion Lift
//
//  Created by Emile Billeh on 03/12/2024.
//

import SwiftUI

class MatchCellViewModel: ObservableObject {
    @Published var match: Match

    init(_ channel: Match) {
        self.match = channel
    }

    var channelName: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short

        let date = match.dateAndTime.dateValue()

        let formattedDate = formatter.string(from: date)

        return "\(match.airport) \(formattedDate)"
    }

    var lastMessage: String {
        return match.lastMessage
    }
    
}
