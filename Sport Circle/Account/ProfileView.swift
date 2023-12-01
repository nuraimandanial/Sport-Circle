////
//  ProfileView.swift
//  Sport Circle
//
//  Created by kinderBono on 24/10/2023.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appModel: AppModel
    
    @State private var profile: Profile = .admin
    @State private var edit: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.bieges.ignoresSafeArea()
                
                VStack {
                    TopBar(type: "Plain")
                        .environmentObject(appModel)
                        .environmentObject(appModel.top)
                    
                    if profile.image != "" {
                        Circle()
                            .frame(width: 95)
                            .overlay {
                                Image(profile.image)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                            }
                            .padding(.top, 5)
                    } else {
                        Placeholder(type: "Empty Profile", width: 95)
                            .padding(.top, 5)
                    }
                    List {
                        Section(header: Text("Personal Information")) {
                            HStack {
                                Text("Name")
                                Spacer()
                                Text(profile.name)
                                    .bold()
                            }
                            HStack {
                                Text("Email")
                                Spacer()
                                Text(profile.email)
                                    .bold()
                            }
                            HStack {
                                Text("Password")
                                Spacer()
                                Text(String(repeating: "*", count: profile.password.count))
                                    .bold()
                            }
                            HStack {
                                Text("Phone")
                                Spacer()
                                Text(profile.details.phone)
                                    .bold()
                            }
                            HStack {
                                Text("Gender")
                                Spacer()
                                Text(profile.details.gender)
                                    .bold()
                            }
                            HStack {
                                Text("Birth Date")
                                Spacer()
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(.grays.opacity(0.3))
                                        .frame(width: 120)
                                    Text(profile.details.birthDate.formatted(date: .abbreviated, time: .omitted))
                                        .bold()
                                }
                            }
                        }
                        .foregroundStyle(.blues)
                        .listRowBackground(Color.whitey.opacity(0.3))
                        Section(header: Text("Preferences")) {
                            HStack {
                                Text("Allow Notification")
                                Spacer()
                                ZStack {
                                    Capsule()
                                        .foregroundStyle(profile.details.notification ? .green : .grays.opacity(0.3))
                                    HStack {
                                        if profile.details.notification {
                                            Spacer().frame(width: 25)
                                        }
                                        Circle()
                                            .frame(width: 30)
                                            .foregroundStyle(.whitey)
                                        if !profile.details.notification {
                                            Spacer()
                                            Spacer().frame(width: 25)
                                        }
                                    }
                                    .padding(.horizontal, 3)
                                }
                                .frame(width: 55)
                            }
                        }
                        .listRowBackground(Color.whitey.opacity(0.3))
                        
                        Section {
                            Button(action: {
                                edit.toggle()
                            }, label: {
                                HStack {
                                    Spacer()
                                    Text("Edit Profile")
                                        .foregroundStyle(.oranges)
                                        .bold()
                                    Spacer()
                                }
                            })
                            .navigationDestination(isPresented: $edit) {
                                ProfileEdit(create: $profile, backButton: $edit)
                                    .environmentObject(appModel)
                                    .onDisappear {
                                        appModel.user.currentUser.profile = profile
                                    }
                            }
                        }
                        .listRowBackground(Color.whitey.opacity(0.3))
                        Button(action: {
                            appModel.user.logout()
                            appModel.isLoggedIn = false
                            appModel.selectedTab = 0
                        }, label: {
                            HStack {
                                Spacer()
                                Text("Log Out")
                                    .foregroundStyle(.whitey)
                                    .bold()
                                Spacer()
                            }
                        })
                        .listRowBackground(Color.red)
                    }
                    .environment(\.colorScheme, .light)
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.hidden)
                    .listSectionSpacing(10)
                }
                .foregroundStyle(.blues)
            }
        }
        .task {
            profile = appModel.user.currentUser.profile
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppModel())
}
