////
//  InboxView.swift
//  Sport Circle
//
//  Created by kinderBono on 24/10/2023.
//

import SwiftUI

struct InboxView: View {
    @EnvironmentObject var appModel: AppModel
    
    @State private var selectionIndex: Int = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.bieges.ignoresSafeArea()
                
                VStack {
                    TopBar(type: "Some")
                        .environmentObject(appModel)
                        .environmentObject(appModel.top)
                    
                    VStack {
                        Picker("", selection: $selectionIndex) {
                            Text("People").tag(0)
                            Text("Activity").tag(1)
                        }
                        .environment(\.colorScheme, .light)
                        .pickerStyle(.segmented)
                        
                        TabView(selection: $selectionIndex) {
                            PeopleView()
                                .tag(0).id(0)
                                .environmentObject(appModel.user)
                                .environmentObject(appModel.circles)
                                .environmentObject(appModel.top)
                            
                            ActivityView()
                                .tag(1).id(1)
                                .environmentObject(appModel.events)
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    InboxView()
        .environmentObject(AppModel())
}
