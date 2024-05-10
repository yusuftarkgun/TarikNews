//
//  NewsAppApp.swift
//  NewsApp
//
//  Created by Yusuf Tarık Gün on 24.04.2024.
//

import SwiftUI

@main
struct NewsAppApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
    }
    
    class AppDelegate: NSObject, UIApplicationDelegate {
        func application(_ application: UIApplication,
                         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
  
            return true
        }
    }
}
