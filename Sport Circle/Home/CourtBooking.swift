////
//  CourtBooking.swift
//  Sport Circle
//
//  Created by kinderBono on 25/10/2023.
//

import SwiftUI

struct CourtBooking: View {
    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) var dismiss
    
    @Binding var court: Court
    @Binding var backButton: Bool
    
    @State private var booking: Booking = .init()
    @State private var capacity: String = ""
    
    @State private var submit: Bool = false
    
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
                            })
                            Spacer()
                        }
                        .padding()
                    }
                    
                    Form {
                        Section(header: Text("Booking Details")) {
                            Picker("", selection: $booking.type) {
                                ForEach(court.type, id: \.self) { type in
                                    Text(type).tag(type)
                                }
                            }
                            .pickerStyle(.segmented)
                            Text(court.name)
                            DatePicker("Date", selection: $booking.date, displayedComponents: .date)
                            Picker("Slot", selection: $booking.slot) {
                                ForEach(court.slot.indices, id: \.self) { index in
                                    let slot = court.slot[index]
                                    let slotText = "Slot \(index + 1): \(slot.display)"
                                    Text(slotText).tag(slot)
                                }
                            }
                            TextField("Capacity", text: $capacity).keyboardType(.numberPad)
                        }
                        .foregroundStyle(.blues)
                        .listRowBackground(Color.whitey.opacity(0.3))
                        
                        Button(action: {
                            createBooking()
                        }, label: {
                            HStack {
                                Spacer()
                                Text("Confirm")
                                Spacer()
                            }
                        })
                        .alert(isPresented: $submit) {
                            Alert(title: Text("Success"), message: Text("Your booking have been submitted, thank you!"), dismissButton: .default(Text("OK")) {
                                backButton = false
                                dismiss()
                            })
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
        .task {
            booking = Booking(court: court)
        }
    }
    
    func createBooking() {
        let start = booking.slot.start
        
        booking.date = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: start), minute: Calendar.current.component(.minute, from: start), second: 0, of: booking.date) ?? booking.date
        booking.capacity = (capacity as NSString).integerValue
        appModel.events.createBook(booking)
        
        submit.toggle()
    }
}

#Preview {
    CourtBooking(court: .constant(.um), backButton: .constant(false))
        .environmentObject(AppModel())
}
