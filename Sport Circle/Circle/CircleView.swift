////
//  CircleView.swift
//  Sport Circle
//
//  Created by kinderBono on 24/10/2023.
//

import SwiftUI

struct CircleView: View {
    @EnvironmentObject var appModel: AppModel
    
    var sportType: [String] {
        appModel.circles.uniqueTypes()
    }
    
    var recommended: [Circles] {
        appModel.circles.randomThree()
    }
    
    @State private var create: Bool = false
    
    @State private var explore: Bool = false
    @State private var selectSport: Bool = false
    @State private var selectedSport: String = "Badminton"
    
    @State private var recommend: Bool = false
    @State private var selectedCircle: Circles = .basketball
    @State private var newCircle: Circles = .init()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.bieges.ignoresSafeArea()
                
                VStack {
                    TopBar(type: "Some")
                        .environmentObject(appModel)
                        .environmentObject(appModel.top)
                    
                    HStack {
                        Text("Circle")
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                    .padding()
                    
                    HStack(spacing: 10) {
                        Button(action: {
                            create.toggle()
                        }, label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 2)
                                    .frame(height: 90)
                                VStack {
                                    Image(systemName: "person.3.fill")
                                    Text("Create a circle")
                                }
                            }
                        })
                        .fullScreenCover(isPresented: $create, content: {
                            CreateCircle(backButton: $create)
                                .environmentObject(appModel)
                        })
                        Button(action: {
                            explore.toggle()
                        }, label: {
                            VStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 2)
                                        .frame(height: 90)
                                    VStack {
                                        Image(systemName: "location.fill")
                                        Text("Explore group")
                                    }
                                }
                            }
                        })
                        .sheet(isPresented: $explore) {
                            ZStack {
                                Color.bieges.ignoresSafeArea()
                                VStack {
                                    if sportType.isEmpty {
                                        Text("No circles available currently")
                                    } else {
                                        Text("Tap on Sport Type to be selected.")
                                            .padding()
                                        Picker("", selection: $selectedSport) {
                                            ForEach(sportType, id: \.self) { type in
                                                Text(type).tag(type)
                                            }
                                        }
                                        .environment(\.colorScheme, .light)
                                        .pickerStyle(.wheel)
                                        .padding([.horizontal, .bottom])
                                        .onTapGesture {
                                            explore.toggle()
                                            selectSport.toggle()
                                        }
                                    }
                                }
                            }
                            .presentationDetents([.height(150)])
                            .presentationCornerRadius(25)
                        }
                        .navigationDestination(isPresented: $selectSport) {
                            ExploreCircle(type: $selectedSport, backButton: $selectSport)
                                .environmentObject(appModel)
                        }
                    }
                    .padding(.horizontal)
                    Text("Recommended Group")
                        .font(.title3)
                        .bold()
                        .padding()
                    
                    if recommended.isEmpty {
                        Text("No circles available currently")
                    }
                    ScrollView {
                        ForEach(recommended) { circle in
                            Button(action: {
                                recommend.toggle()
                                selectedCircle = circle
                            }, label: {
                                ZStack {
                                    Rectangle()
                                        .stroke(lineWidth: 2)
                                    VStack(alignment: .leading) {
                                        Image(circle.image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: 120)
                                            .clipped()
                                        Text(circle.name)
                                            .bold()
                                        Text(circle.description)
                                            .font(.caption)
                                    }
                                    .padding()
                                }
                            })
                            .fullScreenCover(isPresented: $recommend) {
                                CircleDetail(circle: $selectedCircle, backButton: $recommend)
                                    .environmentObject(appModel)
                                    .onDisappear {
                                        newCircle = selectedCircle
                                        appModel.circles.updateCircle(for: circle, with: newCircle)
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .foregroundStyle(.blues)
            }
        }
    }
}

#Preview {
    CircleView()
        .environmentObject(AppModel())
}
