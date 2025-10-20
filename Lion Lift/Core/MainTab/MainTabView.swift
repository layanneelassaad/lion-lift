//
//  MainTabView.swift
//  Lion Lift
//
//  Created by Adam Sherif on 11/14/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        
        TabView {
            HomeView() .tabItem {
                Label("Home", systemImage: "house")
            }
            
            CarpoolsView() .tabItem {
                Label("Carpools", systemImage: "car")
            }
            
            ProfileView() .tabItem {
                Label("Profile", systemImage: "person")
            }
        }
    }
}

#Preview {
    MainTabView()
}
