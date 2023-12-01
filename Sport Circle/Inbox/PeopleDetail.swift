////
//  PeopleDetail.swift
//  Sport Circle
//
//  Created by kinderBono on 28/10/2023.
//

import SwiftUI

struct PeopleDetail: View {
    @EnvironmentObject var appModel: AppModel
    
    @Binding var profile: Profile
    @Binding var backButton: Bool
    
    @State private var isFriend: Bool = false
    @State private var chat: Bool = false
    @State private var alert: Bool = false
    @State private var messages: [Message] = []
    @State private var name: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.bieges.ignoresSafeArea()
                
                VStack(spacing: 40) {
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
                        if profile.image != "" {
                            Circle()
                                .frame(width: 180)
                                .overlay {
                                    Image(profile.image)
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(Circle())
                                }
                        } else {
                            Circle()
                                .frame(width: 180)
                                .overlay {
                                    Image("logo1")
                                        .resizable()
                                        .scaledToFit()
                                        .padding()
                                        .clipShape(Circle())
                                }
                        }
                        Text(profile.name)
                            .font(.title2)
                            .bold()
                        Text(profile.details.address)
                            .font(.title3)
                        HStack(spacing: 20) {
                            Text("Gender: \(profile.details.gender)")
                            Text("Birth Date: \(profile.details.birthDate.formatted(date: .numeric, time: .omitted))")
                        }
                        Text(profile.details.description)
                        Spacer().frame(height: 20)
                        if isFriend {
                            Button(action: {
                                chat.toggle()
                                messages = appModel.user.loadMessages(forFriend: profile.id)
                                name = profile.name
                            }, label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(height: 50)
                                        .foregroundStyle(.oranges)
                                    Text("View Chat")
                                        .foregroundStyle(.whitey)
                                        .bold()
                                }
                            })
                            .padding(.horizontal, 40)
                            .navigationDestination(isPresented: $chat) {
                                ChatView(name: $name, messages: $messages, backButton: $chat)
                                    .onDisappear {
                                        appModel.user.currentUser.friendChats[profile.id]?.messages = messages
                                    }
                            }
                        } else {
                            Spacer().frame(height: 50)
                        }
                        Button(action: {
                            if isFriend {
                                appModel.user.removeFriend(profile)
                            } else {
                                appModel.user.addFriend(profile)
                                alert.toggle()
                            }
                            isFriend = appModel.user.currentUser.friends.contains(profile.id)
                        }, label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(height: 50)
                                    .foregroundStyle(isFriend ? .red : .oranges)
                                Text(isFriend ? "Unfriend" : "Add Friend")
                                    .foregroundStyle(.whitey)
                                    .bold()
                            }
                        })
                        .padding(.horizontal, 40)
                        .alert(isPresented: $alert) {
                            Alert(title: Text("Friend Added"), message: Text("\(profile.name) is now your friend!"), dismissButton: .default(Text("OK")))
                        }
                    }
                    .padding()
                    Spacer()
                }
                .foregroundStyle(.blues)
            }
            .navigationBarBackButtonHidden()
        }
        .task {
            isFriend = appModel.user.isFriend(profile)
        }
    }
}

#Preview {
    PeopleDetail(profile: .constant(Profile.admin), backButton: .constant(false))
        .environmentObject(AppModel())
}
