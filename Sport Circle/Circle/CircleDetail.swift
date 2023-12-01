////
//  CircleDetail.swift
//  Sport Circle
//
//  Created by kinderBono on 27/10/2023.
//

import SwiftUI

struct CircleDetail: View {
    @EnvironmentObject var appModel: AppModel
    
    @Binding var circle: Circles
    @Binding var backButton: Bool
    
    @State private var isJoined: Bool = false
    @State private var chat: Bool = false
    
    @State private var messages: [Message] = []
    @State private var name: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.bieges.ignoresSafeArea()
                
                VStack {
                    ZStack {
                        TopBar(type: "Plain")
                            .environmentObject(appModel)
                            .environmentObject(appModel.top)
                        HStack {
                            Button(action: {
                                backButton = false
                            }, label: {
                                Image(systemName: "chevron.left")
                                    .foregroundStyle(.oranges)
                            })
                            Spacer()
                        }
                        .padding()
                    }
                    VStack(spacing: 10) {
                        Spacer()
                        VStack {
                            if circle.image != "" {
                                Image(circle.image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 200)
                                    .clipped()
                            } else {
                                Image("logo2")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                            }
                        }
                        .padding([.horizontal, .top])
                        Text(circle.name)
                            .font(.title3)
                            .bold()
                        Text(circle.description)
                        Text("Capacity: \(String(circle.capacity))")
                        
                        VStack {
                            if appModel.user.currentUser.joinedCircles.contains(circle.id) {
                                Button(action: {
                                    chat.toggle()
                                }, label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .frame(height: 50)
                                        Text("View Chat")
                                            .foregroundStyle(.whitey)
                                            .bold()
                                    }
                                })
                                .navigationDestination(isPresented: $chat) {
                                    ChatView(name: $name, messages: $messages, backButton: $chat)
                                        .environmentObject(appModel)
                                        .onDisappear {
                                            circle.chat.messages = messages
                                        }
                                }
                            } else {
                                Spacer().frame(height: 60)
                            }
                            Button(action: {
                                if appModel.user.currentUser.joinedCircles.contains(circle.id) {
                                    appModel.circles.leaveCircle(appModel.user, in: circle)
                                } else {
                                    appModel.circles.joinCircle(appModel.user, in: circle)
                                }
                                isJoined = appModel.circles.isJoined(appModel.user, in: circle)
                            }, label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(height: 50)
                                    Text(isJoined ? "Leave" : "Join")
                                        .foregroundStyle(.whitey)
                                        .bold()
                                }
                            })
                        }
                        .padding(.horizontal, 40)
                        Spacer()
                    }
                }
                .foregroundStyle(.blues)
            }
            .navigationBarBackButtonHidden()
        }
        .task {
            isJoined = appModel.circles.isJoined(appModel.user, in: circle)
            messages = circle.chat.messages
            name = circle.name
        }
    }
}

#Preview {
    CircleDetail(circle: .constant(Circles.futsalArena), backButton: .constant(false))
        .environmentObject(AppModel())
}
