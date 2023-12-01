////
//  CourtView.swift
//  Sport Circle
//
//  Created by kinderBono on 25/10/2023.
//

import SwiftUI

struct CourtView: View {
    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) var dismiss
    
    @Binding var state: String
    @Binding var date: Date
    
    @Binding var backButton: Bool
    @Binding var stateDate: Int
    
    @State private var filteredCourt: [Court] = []
    @State private var courtDetail: Bool = false
    @State private var selectedCourt: Court = .johorCourt
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.bieges.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    ZStack {
                        TopBar(type: "Plain")
                            .environmentObject(appModel)
                            .environmentObject(appModel.top)
                        HStack {
                            Button(action: {
                                backButton = false
                                stateDate = 0
                                dismiss()
                            }, label: {
                                Image(systemName: "chevron.left")
                            })
                            Spacer()
                        }
                        .padding()
                    }
                    VStack {
                        Text(state)
                            .font(.title)
                            .bold()
                        Text(date, style: .date)
                    }
                    .foregroundStyle(.blues)
                    ScrollView(showsIndicators: false) {
                        ForEach(filteredCourt) { court in
                            Button(action: {
                                courtDetail.toggle()
                                selectedCourt = court
                            }, label: {
                                VStack(alignment: .leading) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundStyle(.grays.opacity(0.3))
                                        Image(court.image)
                                    }
                                    .frame(height: 120)
                                    Text(court.name)
                                        .foregroundStyle(.blues)
                                        .bold()
                                        .padding(.horizontal, 10)
                                }
                            })
                            .navigationDestination(isPresented: $courtDetail) {
                                CourtDetail(court: $selectedCourt, backButton: $courtDetail)
                                    .environmentObject(appModel.top)
                            }
                        }
                    }
                    .padding()
                }
            }
            .task {
                filteredCourt = Court.courtData.courtsInState(state)
            }
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    CourtView(state: .constant("WP Kuala Lumpur"), date: .constant(.now), backButton: .constant(false), stateDate: .constant(0))
        .environmentObject(AppModel())
}
