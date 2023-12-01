//
//  RegisterView.swift
//  Sport Circle
//
//  Created by kinderBono on 24/10/2023.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) var dismiss
    
    @State private var profile: Profile = .init()
    @State private var rePass: String = ""
    
    @State private var register: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.bieges.ignoresSafeArea()
                VStack(spacing: 30) {
                    VStack {
                        Image("logo2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250)
                            .padding()
                        Text("Connect, Book & Play")
                            .font(.body)
                            .bold()
                    }
                    Text("Create New Account")
                        .bold()
                    VStack(spacing: 20) {
                        HStack {
                            Text("Username")
                            Spacer()
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.blues, lineWidth: 1.5)
                                .frame(width: 210, height: 50)
                                .overlay {
                                    TextField("Username", text: $profile.username)
                                        .textInputAutocapitalization(.never)
                                        .font(.body)
                                        .padding()
                                }
                        }
                        HStack {
                            Text("Email")
                            Spacer()
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.blues, lineWidth: 1.5)
                                .frame(width: 210, height: 50)
                                .overlay {
                                    TextField("Email", text: $profile.email)
                                        .textInputAutocapitalization(.never)
                                        .font(.body)
                                        .padding()
                                }
                        }
                        HStack {
                            Text("Phone")
                            Spacer()
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.blues, lineWidth: 1.5)
                                .frame(width: 210, height: 50)
                                .overlay {
                                    TextField("Phone", text: $profile.details.phone)
                                        .keyboardType(.numberPad)
                                        .font(.body)
                                        .padding()
                                }
                        }
                        HStack {
                            Text("Password")
                            Spacer()
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.blues, lineWidth: 1.5)
                                .frame(width: 210, height: 50)
                                .overlay {
                                    SecureField("Password", text: $profile.password)
                                        .font(.body)
                                        .padding()
                                }
                        }
                        HStack {
                            Text("Confirm Password")
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                                .frame(height: 50)
                            Spacer()
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.blues, lineWidth: 1.5)
                                .frame(width: 210, height: 50)
                                .overlay {
                                    SecureField("Confirm Password", text: $rePass)
                                        .font(.body)
                                        .padding()
                                }
                        }
                    }
                    .padding(.horizontal, 40)
                    VStack(spacing: 20) {
                        Button(action: {
                            if profile.password == rePass && profile.password != "" {
                                appModel.user.createProfile(for: profile)
                                register.toggle()
                            }
                        }, label: {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 50)
                                .foregroundStyle(.oranges)
                                .overlay {
                                    Text("Register")
                                        .foregroundStyle(.whitey)
                                        .bold()
                                }
                        })
                        .alert(isPresented: $register) {
                            Alert(title: Text("Success"), message: Text(""), dismissButton: .default(Text("OK"), action: {
                                dismiss()
                            }))
                        }
                        HStack {
                            Button(action: { dismiss() }, label: {
                                Text("Login")
                                    .underline()
                            })
                            Spacer()
                        }
                    }
                    .font(.body)
                    .padding(.horizontal, 40)
                }
                .font(.title3)
                .foregroundStyle(.blues)
            }
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    RegisterView()
        .environmentObject(AppModel())
}
