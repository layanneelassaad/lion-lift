//
//  Lion_LiftApp.swift
//  Lion Lift
//
//  Created by Adam Sherif on 11/14/24.
//



import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct Lion_LiftApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @State private var isLoading = true // Manage loading state
    @StateObject var viewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            if isLoading {
                LoadingView() // Loading View
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isLoading = false
                        }
                    }
            } else {
                NavigationView {
                    ContentView()
                }
                .environmentObject(viewModel)
            }
        }
    }
}

