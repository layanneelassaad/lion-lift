//
//  CarpoolManagerViewModel.swift
//  Carpools
//
//  Created by Emile Billeh on 14/11/2024.
//

import Foundation

enum CarpoolManagerViewModel: Int, CaseIterable {
    case carpools
    case requests
    case matches
    
    
    var title: String {
        
        switch self {
        case.carpools: return "Carpools"
        case.requests: return "Requests"
        case.matches: return "Matches"
        }
    }
}
