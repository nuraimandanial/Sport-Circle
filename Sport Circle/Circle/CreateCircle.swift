////
//  CreateCircle.swift
//  Sport Circle
//
//  Created by kinderBono on 24/10/2023.
//

import SwiftUI

struct CreateCircle: View {
    @EnvironmentObject var appModel: AppModel
    
    @Binding var backButton: Bool
    
    @State private var create: Circles = Circles()
    @State private var capacity: String = ""
    
    @State private var success: Bool = false
    @State private var detail: Bool = false
    
    @State private var newCircle: Circles = .init()
    
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
                    
                    Form {
                        Section(header: Text("Circle Information")) {
                            TextField("Name", text: $create.name)
                            TextField("Description", text: $create.description)
                            TextField("Type", text: $create.type)
                            TextField("Capacity", text: $capacity).keyboardType(.numberPad)
                        }
                        .listRowBackground(Color.whitey.opacity(0.3))
                        
                        Button(action: {
                            success = createCircle()
                        }, label: {
                            HStack {
                                Spacer()
                                Text("Submit")
                                Spacer()
                            }
                        })
                        .alert(isPresented: $success) {
                            Alert(title: Text("Success"), message: Text("Circle created!"), dismissButton: .default(Text("OK"), action: {
                                detail.toggle()
                            }))
                        }
                        .fullScreenCover(isPresented: $detail) {
                            CircleDetail(circle: $create, backButton: $backButton)
                                .environmentObject(appModel)
                                .onDisappear {
                                    newCircle = create
                                    appModel.circles.updateCircle(for: create, with: newCircle)
                                }
                        }
                        .foregroundStyle(.whitey)
                        .listRowBackground(Color.oranges)
                    }
                    .environment(\.colorScheme, .light)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
    
    func createCircle() -> Bool {
        create.capacity = (capacity as NSString).integerValue
        guard create.capacity == (capacity as NSString).integerValue else { return false }
        appModel.circles.joinCircle(appModel.user, in: create)
        appModel.circles.circleData.append(create)
        return true
    }
}

#Preview {
    CreateCircle(backButton: .constant(false))
        .environmentObject(AppModel())
}
