//
//  SportCircleApp.swift
//  Sport Circle
//
//  Created by kinderBono on 24/10/2023.
//

import SwiftUI
import Firebase

@main
struct SportCircleApp: App {
    @StateObject var appModel = AppModel()
    
    @State var splash: Bool = false
    
    init() {
        FirebaseApp.configure()
        
        UITabBar.appearance().backgroundColor = UIColor.init(Color.blues)
        UITabBar.appearance().unselectedItemTintColor = UIColor.init(Color.bieges)
        UITabBar.appearance().barTintColor = UIColor.init(Color.blues)
        UITableView.appearance().backgroundColor = UIColor.init(Color.bieges)
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if self.splash {
                    if appModel.isLoggedIn {
                        ContentView()
                            .environmentObject(appModel)
                    } else {
                        LoginView()
                            .environmentObject(appModel)
                    }
                } else {
                    SplashView()
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    withAnimation {
                        self.splash = true
                    }
                }
            }
        }
    }
}
