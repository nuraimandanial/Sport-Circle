////
//  Notification.swift
//  Sport Circle
//
//  Created by kinderBono on 29/10/2023.
//

import SwiftUI

struct Notification: View {
    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) var dismiss
    
    @Binding var backButton: Bool
    @State private var userInvitations: [Invitation] = []
    
    @State private var accept: Bool = false
    @State private var reject: Bool = false
    @State private var selectedInvite: Invitation = .init()
    
    @State private var alert: Bool = false
    @State private var message: String = ""
    
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
                        Text("Invitation Notification")
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                    .padding()
                    if userInvitations.isEmpty {
                        Text("No invitations currently")
                    }
                    ScrollView {
                        ForEach(userInvitations) { invite in
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundStyle(.whitey.opacity(0.3))
                                VStack(alignment: .leading) {
                                    Text("\(invite.name) · \(invite.group)")
                                        .bold()
                                    Text(invite.message)
                                    HStack(spacing: 10) {
                                        Spacer().frame(width: 120)
                                        Button(action: {
                                            selectedInvite = invite
                                            if let circle = appModel.circles.fetchCircle(by: invite.group) {
                                                accept = true
                                                appModel.circles.joinCircle(appModel.user, in: circle)
                                                message = "Success!"
                                            } else {
                                                message = "Internal Error!"
                                            }
                                            alert.toggle()
                                        }, label: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .foregroundStyle(.oranges)
                                                    .frame(height: 30)
                                                Text("Accept")
                                                    .foregroundStyle(.whitey)
                                            }
                                        })
                                        .alert(isPresented: $alert) {
                                            Alert(title: Text(message), message: Text(""), dismissButton: .default(Text("OK"), action: {
                                                if accept {
                                                    appModel.invites.invitations.removeAll(where: { $0.id == selectedInvite.id })
                                                    accept = false
                                                }
                                            }))
                                        }
                                        Button(action: {
                                            selectedInvite = invite
                                            reject = appModel.invites.rejectInvite(of: selectedInvite, for: appModel.user.currentUser.profile)
                                        }, label: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .foregroundStyle(.red)
                                                    .frame(height: 30)
                                                Text("Reject")
                                                    .foregroundStyle(.whitey)
                                            }
                                        })
                                    }
                                }
                                .padding()
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .foregroundStyle(.blues)
            }
            .navigationBarBackButtonHidden()
            .task {
                userInvitations = appModel.invites.fetchInvites(for: appModel.user.currentUser.profile)
            }
        }
    }
}

#Preview {
    Notification(backButton: .constant(false))
        .environmentObject(AppModel())
}
