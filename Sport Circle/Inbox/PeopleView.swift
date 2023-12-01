////
//  PeopleView.swift
//  Sport Circle
//
//  Created by kinderBono on 24/10/2023.
//

import SwiftUI

struct PeopleView: View {
    @EnvironmentObject var appModel: AppModel
    
    @State private var circleChat: Bool = false
    @State private var userChat: Bool = false
    @State private var selectedCircle: Circles = .init()
    @State private var selectedProfile: Profile = .init()
    @State private var circleMessages: [Message] = []
    @State private var userMessages: [Message] = []
    
    @State private var newCircle: Circles = .init()
    @State private var name: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.bieges.ignoresSafeArea()
                
                ScrollView {
                    HStack {
                        Text("Circles")
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                    .padding(.vertical)
                    if appModel.user.currentUser.joinedCircles.isEmpty {
                        Text("You didn't joined any circles.")
                    } else {
                        ForEach(appModel.user.currentUser.joinedCircles.compactMap { id in
                            appModel.circles.circleData.first { $0.id == id }
                        }) { circle in
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundStyle(.whitey.opacity(0.3))
                                Button(action: {
                                    circleChat.toggle()
                                    selectedCircle = circle
                                    name = circle.name
                                }, label: {
                                    HStack(spacing: 20) {
                                        if circle.image != "" {
                                            Circle()
                                                .frame(width: 60)
                                                .overlay {
                                                    Image(circle.image)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .clipShape(Circle())
                                                }
                                        } else {
                                            Circle()
                                                .frame(width: 60)
                                                .overlay {
                                                    Image("logo2")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .clipShape(Circle())
                                                }
                                        }
                                        VStack(alignment: .leading) {
                                            Text(circle.name)
                                                .bold()
                                            if let lastMessage = circleMessages.last {
                                                Text("\(messageFormat(lastMessage)): \(lastMessage.text)")
                                            } else {
                                                Text(circle.description)
                                            }
                                        }
                                        Spacer()
                                    }
                                })
                                .padding()
                                .fullScreenCover(isPresented: $circleChat) {
                                    ChatView(name: $name, messages: $circleMessages, backButton: $circleChat)
                                        .environmentObject(appModel)
                                        .onDisappear {
                                            selectedCircle.chat.messages = circleMessages
                                            newCircle = selectedCircle
                                            appModel.circles.updateCircle(for: circle, with: newCircle)
                                            name = ""
                                        }
                                }
                                .task {
                                    circleMessages = circle.chat.messages
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    HStack {
                        Text("Friends")
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                    .padding(.vertical)
                    if appModel.user.currentUser.friends.isEmpty {
                        Text("You didn't have any friends.")
                    } else {
                        ForEach(appModel.user.fetchFriendsProfile()) { profile in
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundStyle(.whitey.opacity(0.3))
                                Button(action: {
                                    userChat.toggle()
                                    selectedProfile = profile
                                    userMessages = appModel.user.loadMessages(forFriend: profile.id)
                                    name = profile.name
                                }, label: {
                                    HStack(spacing: 20) {
                                        if profile.image != "" {
                                            Circle()
                                                .frame(width: 60)
                                                .overlay {
                                                    Image(profile.image)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .clipShape(Circle())
                                                }
                                        } else {
                                            Circle()
                                                .frame(width: 60)
                                                .overlay {
                                                    Image("logo1")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .clipShape(Circle())
                                                }
                                        }
                                        VStack(alignment: .leading) {
                                            Text(profile.name)
                                                .bold()
                                            if let lastMessage = userMessages.last {
                                                Text("\(messageFormat(lastMessage)): \(lastMessage.text)")
                                                    .multilineTextAlignment(.leading)
                                            } else {
                                                Text(profile.details.address)
                                                    .multilineTextAlignment(.leading)
                                            }
                                        }
                                        Spacer()
                                    }
                                })
                                .padding()
                                .fullScreenCover(isPresented: $userChat) {
                                    ChatView(name: $name, messages: $userMessages, backButton: $userChat)
                                        .environmentObject(appModel)
                                        .onDisappear {
                                            appModel.user.currentUser.friendChats[profile.id]?.messages = userMessages
                                            name = ""
                                        }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .foregroundStyle(.blues)
            }
        }
    }
    
    func messageFormat(_ message: Message) -> String {
        if message.sender == appModel.user.currentUser.profile.name {
            return "You"
        } else {
            return message.sender
        }
    }
}

#Preview {
    PeopleView()
        .environmentObject(AppModel())
}
