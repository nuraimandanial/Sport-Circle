////
//  ChatView.swift
//  Sport Circle
//
//  Created by kinderBono on 28/10/2023.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var appModel: AppModel
    
    @Binding var name: String
    @Binding var messages: [Message]
    @Binding var backButton: Bool
    
    @State private var newMessage: String = ""
    @State private var loadMessages: [Message] = []
    
    @State private var sender: String = ""
    
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
                    Text(name)
                        .font(.title2)
                        .bold()
                        .padding(10)
                    Divider()
                    ScrollViewReader { scroll in
                        ScrollView {
                            ForEach(loadMessages) { message in
                                chatBubble(message)
                                    .id(message.id)
                                    .padding([.horizontal, .top], 5)
                            }
                        }
                        .onChange(of: loadMessages.count) {
                            scroll.scrollTo(loadMessages.last?.id)
                        }
                    }
                    Divider()
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 1)
                                .frame(height: 50)
                            TextField("Type a message", text: $newMessage)
                                .padding()
                                .onSubmit {
                                    sendMessage()
                                }
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                        }
                        Button(action: {
                            sendMessage()
                        }, label: {
                            Text("Send")
                                .foregroundStyle(.oranges)
                        })
                    }
                    .padding()
                }
                .foregroundStyle(.blues)
            }
            .navigationBarBackButtonHidden()
        }
        .task {
            loadMessages = messages
        }
    }
    
    func sendMessage() {
        if !newMessage.isEmpty {
            let message = Message(sender: appModel.user.currentUser.profile.name, text: newMessage, timestamp: .now)
            messages.append(message)
            loadMessages.append(message)
            newMessage = ""
        }
    }
    
    func chatBubble(_ message: Message) -> some View {
        var selfMessage: Bool {
            message.sender == appModel.user.currentUser.profile.name
        }
        var width: CGFloat {
            let sender = message.sender.count
            let total = (sender != 0 ? sender : 3) + message.time.count
            if total < message.text.count {
                return CGFloat(message.text.count) * 8
            } else {
                return CGFloat(total) * 8
            }
        }
        
        return HStack(spacing: -5) {
            if selfMessage {
                Spacer()
            } else {
                VStack {
                    Spacer()
                    Image(systemName: "arrowtriangle.left.fill")
                        .imageScale(.small)
                        .padding(.bottom, 12)
                        .foregroundStyle(.grays)
                }
            }
            VStack(alignment: .leading) {
                HStack {
                    if !selfMessage {
                        Text(message.sender)
                            .bold()
                    } else {
                        Text("You")
                            .bold()
                    }
                    Spacer()
                    Text(message.time)
                }
                .font(.caption)
                Text(message.text)
                    .font(.callout)
            }
            .foregroundStyle(selfMessage ? .whitey : .whitey)
            .frame(width: width < 200 ? width : 250)
            .padding(10)
            .background(selfMessage ? .oranges : .grays)
            .cornerRadius(15)
            
            if !selfMessage {
                Spacer()
            } else {
                VStack {
                    Spacer()
                    Image(systemName: "arrowtriangle.right.fill")
                        .imageScale(.small)
                        .padding(.bottom, 12)
                        .foregroundStyle(.oranges)
                }
            }
        }
    }
}

#Preview {
    ChatView(name: .constant("Chat"), messages: .constant(Message.messages), backButton: .constant(false))
        .environmentObject(AppModel())
}
