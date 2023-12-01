////
//  ProfileEdit.swift
//  Sport Circle
//
//  Created by kinderBono on 24/10/2023.
//

import SwiftUI

struct ProfileEdit: View {
    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) var dismiss
    
    @Binding var create: Profile
    @Binding var backButton: Bool
    
    @State private var alert: Bool = false
    
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
                    
                    if create.image != "" {
                        Circle()
                            .frame(width: 95)
                            .overlay {
                                Image(create.image)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                            }
                            .padding(.top, 5)
                    } else {
                        Placeholder(type: "Empty Profile", width: 95)
                            .padding(.top, 5)
                    }
                    Form {
                        Section(header: Text("Personal Information")) {
                            TextField("Name", text: $create.name)
                            TextField("Email", text: $create.email)
                            SecureField("Password", text: $create.password)
                            TextField("Phone Number", text: $create.details.phone)
                            Picker("Gender", selection: $create.details.gender) {
                                Text("Male").tag("Male")
                                Text("Female").tag("Female")
                                Text("Undefined").tag("Undefined")
                            }
                            DatePicker("Birth Date", selection: $create.details.birthDate, displayedComponents: .date)
                        }
                        .listRowBackground(Color.whitey.opacity(0.3))
                        
                        Section(header: Text("Preferences")) {
                            Toggle("Allow Notification", isOn: $create.details.notification)
                        }
                        .listRowBackground(Color.whitey.opacity(0.3))
                        
                        Button(action: {
                            alert = appModel.user.updateProfile(with: create)
                        }, label: {
                            HStack {
                                Spacer()
                                Text("Submit")
                                    .foregroundStyle(.whitey)
                                    .bold()
                                Spacer()
                            }
                        })
                        .alert(isPresented: $alert) {
                            Alert(title: Text("Profile Updated"), message: Text(""), dismissButton: .default(Text("OK"), action: {
                                backButton = false
                                dismiss()
                            }))
                        }
                        .listRowBackground(Color.oranges)
                    }
                    .environment(\.colorScheme, .light)
                    .scrollContentBackground(.hidden)
                    .listSectionSpacing(10)
                }
                .foregroundStyle(.blues)
            }
            .navigationBarBackButtonHidden()
        }
        .task {
            create = appModel.user.currentUser.profile
        }
    }
}

#Preview {
    ProfileEdit(create: .constant(.init()), backButton: .constant(false))
        .environmentObject(AppModel())
}
