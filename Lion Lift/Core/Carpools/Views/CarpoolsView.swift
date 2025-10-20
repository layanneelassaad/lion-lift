//
//  ContentView.swift
//  Carpools
//
//  Created by Emile Billeh on 14/11/2024.
//

import SwiftUI

struct CarpoolsView: View {
    @State private var selectedFilter: CarpoolManagerViewModel = .carpools
    @Namespace var animation
    
    @ObservedObject var viewModel = CarpoolsViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    ForEach(CarpoolManagerViewModel.allCases, id: \.rawValue) { item in
                        VStack {
                            Text(item.title)
                            //.fontWeight(selectedFilter == item ? .semibold : .regular)
                                .foregroundColor(selectedFilter == item ? .black : .gray)
                            
                            if selectedFilter == item {
                                Capsule()
                                    .frame(height: 3)
                                    .foregroundColor(.blue)
                                    .matchedGeometryEffect(id: "filter", in: animation)
                            } else {
                                Capsule()
                                    .frame(height: 3)
                                    .foregroundColor(.clear )
                            }
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                self.selectedFilter = item
                            }
                        }
                    }
                }
                .padding(.top)
                
                TabView(selection: $selectedFilter) {
                    CarpoolMatchesView().tag(CarpoolManagerViewModel.carpools)
                    requests.tag(CarpoolManagerViewModel.requests)
                    matches.tag(CarpoolManagerViewModel.matches)
                }
            }
            .navigationTitle("Carpools")
        }
    }
}

extension CarpoolsView {
    var carpools: some View {
        VStack {
            VStack {
                Text("You have no carpools yet")
                Text("Request to join carpools from your matches")
                Text("Or check your requests")
            }
            .foregroundStyle(.gray)
        }
    }
    
    var requests: some View {
        VStack {
            if !viewModel.requests.isEmpty {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.requests) { request in
                            RequestRowView(request: request)
                                .padding(.vertical)
                        }
                        Spacer()
                    }
                }
            } else {
                Spacer()
                Text("You have no new requests")
                    .foregroundStyle(.gray)
                Spacer()
            }
        }
    }
    
    var matches: some View {
        VStack {
            if let currentuid = AuthViewModel.shared.userSession?.uid {
                if !viewModel.uniqueMatches.filter({ $0.uid != currentuid }).isEmpty {
                    ForEach(viewModel.uniqueMatches) { match in
                        
                        if currentuid != match.uid {
                            MatchRowView(match: match)
                        }
                        
                    }
                    Spacer()
                } else {
                    Spacer()
                    Text("You have no new matches")
                        .foregroundStyle(.gray)
                    Spacer()
                }
            }
        }
        .onAppear {
            viewModel.fetchMatches()
        }
    }
}

#Preview {
    CarpoolsView()
}
