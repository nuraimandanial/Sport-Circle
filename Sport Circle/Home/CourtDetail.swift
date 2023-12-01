////
//  CourtDetail.swift
//  Sport Circle
//
//  Created by kinderBono on 25/10/2023.
//

import SwiftUI

struct CourtDetail: View {
    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) var dismiss
    
    @Binding var court: Court
    @Binding var backButton: Bool
    
    @State private var ar: Bool = false
    @State private var book: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.bieges.ignoresSafeArea()
                
                VStack {
                    Button(action: {
                        backButton = false
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.oranges)
                    })
                    .padding()
                    if court.image == "" {
                        ZStack {
                            Rectangle()
                                .foregroundStyle(.grays.opacity(0.3))
                            Image("logo1")
                                .resizable()
                                .scaledToFit()
                        }
                        .frame(height: 250)
                    } else {
                        ZStack {
                            Rectangle()
                                .foregroundStyle(.grays.opacity(0.3))
                            Image(court.image)
                                .resizable()
                                .scaledToFit()
                        }
                        .frame(height: 250)
                    }
                    VStack(alignment: .leading) {
                        Text(court.name)
                            .font(.title)
                            .bold()
                            .padding(.vertical)
                        HStack(alignment: .top, spacing: 20) {
                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    Image(systemName: "person.text.rectangle.fill")
                                        .foregroundStyle(.oranges)
                                    Text("Host")
                                        .bold()
                                }
                                Text(court.host)
                                    .frame(maxWidth: 170, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                                    .padding([.bottom])
                                ForEach(court.slot.indices, id: \.self) { index in
                                    let slot = court.slot[index]
                                    Text("Slot \(index + 1)")
                                        .bold()
                                    Text(slot.display)
                                }
                            }
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: "location.north.fill")
                                        .foregroundStyle(.oranges)
                                    Text("Address")
                                        .bold()
                                }
                                Text(court.address)
                            }
                        }
                        Button(action: {
                            ar.toggle()
                        }, label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(height: 50)
                                    .foregroundStyle(.oranges)
                                Text("Go AR")
                                    .foregroundStyle(.whitey)
                                    .bold()
                            }
                        })
                        Button(action: {
                            book.toggle()
                        }, label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(height: 50)
                                    .foregroundStyle(.oranges)
                                Text("Book Now")
                                    .foregroundStyle(.whitey)
                                    .bold()
                            }
                        })
                        .navigationDestination(isPresented: $book) {
                            CourtBooking(court: $court, backButton: $book)
                                .environmentObject(appModel)
                        }
                    }
                }
                .foregroundStyle(.blues)
                .padding()
            }
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    CourtDetail(court: .constant(.perakCourt), backButton: .constant(false))
        .environmentObject(AppModel())
}
