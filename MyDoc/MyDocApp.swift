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
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate{
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        func registerForPushNotifications() {
            
            UNUserNotificationCenter.current()
                .requestAuthorization(
                    options: [.alert, .sound, .badge]) { [weak self] granted, _ in
                        print("Permission granted: \(granted)")
                        guard granted else { return }
                        self?.getNotificationSettings()
                    }
        }
        
        registerForPushNotifications()
        
        let notificationOption = launchOptions?[.remoteNotification]
        
        if
            let notification = notificationOption as? [String: AnyObject],
            let aps = notification["aps"] as? [String: AnyObject] {
//            NewsItem.makeNewsItem(aps)
//
//            (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
        }
        
        // Initializing Firebase
        FirebaseApp.configure()
        return true
    }
    
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
    -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler:
        @escaping (UIBackgroundFetchResult) -> Void
    ) {
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler(.failed)
            return
        }
//        NewsItem.makeNewsItem(aps)
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
