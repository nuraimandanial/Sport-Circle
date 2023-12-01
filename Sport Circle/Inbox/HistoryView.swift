////
//  HistoryView.swift
//  Sport Circle
//
//  Created by kinderBono on 28/10/2023.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) var dismiss
    
    @Binding var backButton: Bool
    
    var history: [Activity] {
        appModel.events.activity.filter { !$0.upcoming }
    }
    
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
                    ScrollView {
                        HStack {
                            Text("History")
                                .font(.title2)
                                .bold()
                            Spacer()
                        }
                        .padding()
                        if history.isEmpty {
                            Text("No history")
                        }
                        ForEach(history) { activity in
                            ZStack {
                                Rectangle()
                                    .stroke(lineWidth: 1)
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(activity.type)
                                            .bold()
                                        Spacer()
                                        Text("Date: \(activity.date.formatted(date: .long, time: .omitted))")
                                    }
                                    if activity.court.image != "" {
                                        Image(activity.court.image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 120)
                                    } else {
                                        Image("logo2")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 120)
                                    }
                                    HStack {
                                        Image(systemName: "mappin")
                                            .imageScale(.large)
                                        Text(activity.court.address)
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                                .padding(10)
                            }
                            .padding(.horizontal)
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
    HistoryView(backButton: .constant(false))
        .environmentObject(AppModel())
}
