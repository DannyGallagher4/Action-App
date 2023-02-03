//
//  Action_AppApp.swift
//  Action-App
//
//  Created by Danny Gallagher on 10/19/22.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct Action_AppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}
