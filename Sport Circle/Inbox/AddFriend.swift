////
//  AddFriend.swift
//  Sport Circle
//
//  Created by kinderBono on 28/10/2023.
//

import SwiftUI

struct AddFriend: View {
    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) var dismiss
    
    @Binding var backButton: Bool
    
    @State private var searchText: String = ""
    var filterSearch: [Profile] {
        if searchText.isEmpty {
            return appModel.user.profileData.map { $0.profile }
        } else {
            return appModel.user.profileData.map { $0.profile }.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    @State private var detail: Bool = false
    @State private var selectedProfile: Profile = .admin
    
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
                                dismiss()
                            }, label: {
                                Image(systemName: "chevron.left")
                                    .foregroundStyle(.oranges)
                            })
                            Spacer()
                        }
                        .padding()
                    }
                    HStack {
                        Text("Find Friends")
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                    .padding()
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(.whitey)
                            .frame(height: 60)
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(lineWidth: 1)
                            .frame(height: 60)
                        HStack(spacing: 10) {
                            Image(systemName: "magnifyingglass")
                            TextField("Search User", text: $searchText)
                                .environment(\.colorScheme, .light)
                            if !searchText.isEmpty {
                                Button(action: {
                                    searchText = ""
                                }, label: {
                                    Image(systemName: "xmark.circle.fill")
                                })
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.horizontal)
                    ScrollView {
                        ForEach(filterSearch) { profile in
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundStyle(.whitey.opacity(0.3))
                                Button(action: {
                                    detail.toggle()
                                    selectedProfile = profile
                                }, label: {
                                    HStack(spacing: 20) {
                                        if profile.image != "" {
                                            Circle()
                                                .frame(width: 80)
                                                .overlay {
                                                    Image(profile.image)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .clipShape(Circle())
                                                }
                                        } else {
                                            Placeholder(type: "Empty Image")
                                        }
                                        VStack(alignment: .leading) {
                                            Text(profile.name)
                                                .bold()
                                            Text(profile.details.address)
                                        }
                                        Spacer()
                                    }
                                })
                                .padding()
                                .fullScreenCover(isPresented: $detail) {
                                    PeopleDetail(profile: $selectedProfile, backButton: $detail)
                                        .environmentObject(appModel)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                    }
                }
                .foregroundStyle(.blues)
            }
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    AddFriend(backButton: .constant(false))
        .environmentObject(AppModel())
}
