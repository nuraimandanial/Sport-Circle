////
//  ActivityView.swift
//  Sport Circle
//
//  Created by kinderBono on 24/10/2023.
//

import SwiftUI

struct ActivityView: View {
    @EnvironmentObject var appModel: AppModel
    
    @State private var detail: Bool = false
    
    @State private var upcoming: [Activity] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.bieges.ignoresSafeArea()
                
                ScrollView {
                    HStack {
                        Text("Upcoming")
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                    .padding(.vertical)
                    if upcoming.isEmpty {
                        Text("No upcoming activity available")
                    }
                    ForEach(upcoming) { activity in
                        ZStack {
                            Rectangle()
                                .stroke(lineWidth: 1)
                            Button(action: {
                                detail.toggle()
                            }, label: {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(activity.type)
                                            .bold()
                                        Spacer()
                                        Text("Date: \(activity.date.formatted(date: .abbreviated, time: .omitted))")
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
                            })
                            .padding(10)
                        }
                        .padding(.horizontal)
                    }
                }
                .foregroundStyle(.blues)
            }
            .task {
                upcoming = appModel.events.activity.filter { $0.upcoming }
            }
        }
    }
}

#Preview {
    ActivityView()
        .environmentObject(AppModel())
}
