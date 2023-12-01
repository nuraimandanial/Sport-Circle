//
//  ExploreCircle.swift
//  Sport Circle
//
//  Created by kinderBono on 24/10/2023.
//

import SwiftUI

struct ExploreCircle: View {
    @EnvironmentObject var appModel: AppModel
    
    @Binding var type: String
    @Binding var backButton: Bool
    
    @State private var detail: Bool = false
    @State private var selectedCircle: Circles = .init()
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
                    HStack {
                        Text(type)
                            .font(.title2)
                            .bold()
                        Spacer()
                    }.padding()
                    
                    ScrollView {
                        ForEach(appModel.circles.circleData.circlesWithType(type)) { circle in
                            Button(action: {
                                detail.toggle()
                                selectedCircle = circle
                            }, label: {
                                VStack(spacing: 10) {
                                    Image(circle.image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 120)
                                        .clipped()
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(circle.name)
                                            Text(circle.description)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                    }
                                    .padding([.horizontal, .bottom], 10)
                                }
                            })
                            .fullScreenCover(isPresented: $detail) {
                                CircleDetail(circle: $selectedCircle, backButton: $detail.animation())
                                    .environmentObject(appModel)
                                    .onDisappear {
                                        newCircle = selectedCircle
                                        appModel.circles.updateCircle(for: selectedCircle, with: newCircle)
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .foregroundStyle(.blues)
            }
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    ExploreCircle(type: .constant("Futsal"), backButton: .constant(false))
        .environmentObject(AppModel())
}
