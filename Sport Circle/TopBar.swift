//
//  TopBar.swift
//  Sport Circle
//
//  Created by kinderBono on 24/10/2023.
//

import SwiftUI

struct TopBar: View {
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var top: TopState
    
    var type: String
    
    var body: some View {
        NavigationStack {
            ZStack {
                if type == "Full" {
                    ZStack {
                        Color.blues.ignoresSafeArea()
                        Image("logo1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 160)
                        HStack(spacing: 20) {
                            Button(action: {
                                top.history.toggle()
                            }, label: {
                                Image(systemName: "calendar")
                            })
                            .navigationDestination(isPresented: $top.history) {
                                HistoryView(backButton: $top.history)
                                    .environmentObject(appModel)
                            }
                            Spacer()
                            Button(action: {
                                top.addFriend.toggle()
                            }, label: {
                                Image(systemName: "person.fill.badge.plus")
                            })
                            .navigationDestination(isPresented: $top.addFriend) {
                                AddFriend(backButton: $top.addFriend)
                                    .environmentObject(appModel)
                            }
                            Button(action: {
                                top.notification.toggle()
                            }, label: {
                                Image(systemName: "bell.fill")
                            })
                            .navigationDestination(isPresented: $top.notification) {
                                Notification(backButton: $top.notification)
                                    .environmentObject(appModel)
                            }
                        }
                        .foregroundStyle(.whitey)
                        .imageScale(.large)
                        .padding(.horizontal)
                    }
                } else if type == "Some" {
                    some
                } else {
                    plain
                }
            }
            .frame(height: 80)
        }
    }
    var some: some View {
        ZStack {
            Color.blues.ignoresSafeArea()
            Image("logo1")
                .resizable()
                .scaledToFit()
                .frame(width: 160)
            HStack {
                Button(action: {
                    top.history.toggle()
                }, label: {
                    Image(systemName: "calendar")
                })
                .navigationDestination(isPresented: $top.history) {
                    HistoryView(backButton: $top.history)
                        .environmentObject(appModel)
                }
                Spacer()
                Button(action: {
                    top.notification.toggle()
                }, label: {
                    Image(systemName: "bell.fill")
                })
                .navigationDestination(isPresented: $top.notification) {
                    Notification(backButton: $top.notification)
                        .environmentObject(appModel)
                }
            }
            .foregroundStyle(.whitey)
            .imageScale(.large)
            .padding(.horizontal)
        }
    }
    var plain: some View {
        ZStack {
            Color.blues.ignoresSafeArea()
            Image("logo1")
                .resizable()
                .scaledToFit()
                .frame(width: 160)
        }
    }
}

#Preview {
    TopBar(type: "Full")
        .environmentObject(AppModel())
        .environmentObject(AppModel().top)
}
