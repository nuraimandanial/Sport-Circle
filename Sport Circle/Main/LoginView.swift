//
//  LoginView.swift
//  Sport Circle
//
//  Created by kinderBono on 24/10/2023.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appModel: AppModel
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State private var loginSuccess: Bool = false
    @State private var alert: Bool = false
    @State private var alertMessage: String = ""
    
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
                    Text("Existing Account")
                        .font(.title3)
                        .bold()
                    VStack(spacing: 20) {
                        HStack {
                            Text("Username")
                            Spacer()
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.blues, lineWidth: 1.5)
                                .frame(width: 210, height: 50)
                                .overlay {
                                    TextField("Enter Username", text: $username)
                                        .textInputAutocapitalization(.never)
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
                                    SecureField("Password", text: $password)
                                        .font(.body)
                                        .padding()
                                }
                        }
                        VStack {
                            Button(action: {
                                login()
                            }, label: {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(height: 50)
                                    .foregroundStyle(.oranges)
                                    .overlay {
                                        Text("Login")
                                            .foregroundStyle(.whitey)
                                            .bold()
                                    }
                            })
                            .alert(isPresented: $alert) {
                                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                            }
                            HStack {
                                NavigationLink(destination: RegisterView().environmentObject(appModel), label: {
                                    Text("Register")
                                        .underline()
                                })
                                Spacer()
                                Button(action: {}, label: {
                                    Text("Forget Password")
                                        .underline()
                                })
                            }
                        }
                        .font(.body)
                    }
                    .padding([.horizontal], 40)
                }
                .foregroundStyle(.blues)
                .font(.title3)
            }
        }
    }
    
    func login() {
        if let user = appModel.user.fetchProfile(for: username) {
            if user.password == password {
                loginSuccess = true
                appModel.isLoggedIn = true
                appModel.user.currentUser.profile = user
            } else {
                alertMessage = "Wrong Password!"
                alert = true
                password = ""
            }
        } else {
            alertMessage = "Not Registered Yet!"
            alert = true
            username = ""
            password = ""
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AppModel())
}
