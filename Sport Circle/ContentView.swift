//
//  ContentView.swift
//  Sport Circle
//
//  Created by kinderBono on 24/10/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appModel: AppModel
    
    var body: some View {
        NavigationStack {
            TabView(selection: $appModel.selectedTab) {
                HomeView()
                    .tabItem { Label(
                        title: { Text("Home") },
                        icon: { Image(systemName: "house") }
                    ) }
                    .tag(0)
                    .environmentObject(appModel)
                    .environmentObject(appModel.home)
                NewsView()
                    .tabItem { Label(
                        title: { Text("News") },
                        icon: { Image(systemName: "newspaper") }
                    ) }
                    .tag(1)
                    .environmentObject(appModel)
                    .environmentObject(appModel.news)
                CircleView()
                    .tabItem { Label(
                        title: { Text("Circle") },
                        icon: { Image(systemName: "person.3") }
                    ) }
                    .tag(2)
                    .environmentObject(appModel)
                InboxView()
                    .tabItem { Label(
                        title: { Text("Inbox") },
                        icon: { Image(systemName: "message") }
                    ) }
                    .tag(3)
                    .environmentObject(appModel)
                ProfileView()
                    .tabItem { Label(
                        title: { Text("Account") },
                        icon: { Image(systemName: "person.circle") }
                    ) }
                    .tag(4)
                    .environmentObject(appModel)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppModel())
}
