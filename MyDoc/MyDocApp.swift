//
//  Login.swift
//  MyDoc
//
//  Created by Derek Kim on 2022/11/05.
//

import SwiftUI

import Firebase
import FirebaseAuth
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Initializing Firebase
        FirebaseApp.configure()
        return true
    }
    
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
    -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct MyDocApp: App {
    // Connecting App Delegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var sessionService = SessionServiceImpl()
    
    var body: some Scene {
        WindowGroup{
            NavigationView{
                switch sessionService.state {
                case .loggedIn:
                    TabView {
                        HomeView()
                            .tabItem{
                                Label("MyDocs", systemImage: "house")
                            }
                        NotificationsView()
                            .badge(5)
                            .tabItem{
                                Label("Notifications", systemImage: "bell")
                            }
                        ChatView()
                            .tabItem{
                                Label("Chat", systemImage: "message")
                            }
                        ProfileView()
                            .environmentObject(SessionServiceImpl())
                            .tabItem{
                                Label("Profile", systemImage: "person")
                            }
                    }
                case .loggedOut:
                    SignInView()
                }
            }
        }
    }
}
