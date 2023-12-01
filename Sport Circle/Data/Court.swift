//
//  Court.swift
//  Sport Circle
//
//  Created by kinderBono on 24/10/2023.
//

import Foundation

class Event: ObservableObject {
    @Published var courtData: [Court] = []
    @Published var bookings = Booking.bookData
    @Published var activity = Activity.activity
    
    init() {
        courtData = fetchCourt(true)
    }
    
    func fetchCourt(_ test: Bool) -> [Court] {
        var all: [Court] = []
        if test {
            all.append(contentsOf: Court.courtData.map { $0.self })
        }
        return all
    }
    
    func createBook(_ booking: Booking) {
        let newActivity = Activity(type: booking.type, date: booking.date, court: booking.court)
        bookings.append(booking)
        activity.append(newActivity)
    }
}

struct Court: Identifiable {
    var id = UUID()
    
    var name: String = ""
    var host: String = ""
    var address: String = ""
    var image: String = ""
    
    var slot: [TimeSlot] = []
    var type: [String] = []
}

extension Court: Encodable, Decodable {}

extension Court {
    static let courtData = [ttdi, um, eight, melakaCourt, johorCourt, penangCourt, perakCourt, selangorCourt, kedahCourt]
    
    static let ttdi = Court(name: "Pusat Komuniti TTDI", host: "Komuniti TTDI", address: "Pusat Komuniti TTDI, Taman Tun Dr Ismail", image: /*"Pusat Komuniti TTDI"*/"", slot: [.twelvepm, .threepm], type: ["Badminton", "Futsal", "Basketball"])
    static let um = Court(name: "Arena Sukan UM", host: "Universiti Malaya", address: "833, Lingkungan Budi, 50603 Kuala Lumpur, WP Kuala Lumpur", image: "", slot: [.twelvepm], type: ["Swimming", "Badminton", "Basketball"])
    static let eight = Court(name: "Gelanggang Komuniti Presint 8", host: "", address: "Gelanggang Komuniti Presint Lapan (8), Putrajaya", image: "Pusat Komuniti Presint 8", slot: [.threepm], type: ["Badminton", "Futsal", "Basketball", "Hockey"])
    
    static let melakaCourt = Court(name: "Melaka Sports Hub", host: "Melaka Sports Council", address: "Jalan Hang Tuah, Melaka", image: "", slot: [.threepm, .sixpm], type: ["Badminton", "Futsal"])
    static let johorCourt = Court(name: "Johor Recreational Center", host: "Johor Recreational", address: "Jalan Larkin, Johor Bahru", image: "", slot: [.twelvepm, .threepm, .sixpm], type: ["Basketball", "Futsal"])
    static let penangCourt = Court(name: "Penang Indoor Arena", host: "Penang Sports Council", address: "Lebuh Light, George Town, Penang", image: "", slot: [.twelvepm, .threepm, .sixpm], type: ["Badminton", "Futsal"])
    static let perakCourt = Court(name: "Perak Sports Complex", host: "Perak Sports Development", address: "Jalan Ghazali, Ipoh, Perak", image: "", slot: [.twelvepm, .threepm, .sixpm], type: ["Basketball", "Badminton"])
    static let selangorCourt = Court(name: "Selangor Sports Center", host: "Selangor Sports Council", address: "Persiaran Kewajipan, Shah Alam, Selangor", image: "Selangor Sports Center", slot: [.twelvepm, .threepm, .sixpm], type: ["Badminton", "Basketball"])
    static let kedahCourt = Court(name: "Kedah Sports Arena", host: "Kedah State Sports Association", address: "Jalan Langgar, Alor Setar, Kedah", image: "", slot: [.twelvepm, .threepm, .sixpm], type: ["Futsal", "Hockey"])
    
    static let state = ["Johor", "Kelantan", "Kedah", "Melaka", "Negeri Sembilan", "Pahang", "Perak", "Perlis", "Pulau Pinang", "Sabah", "Sarawak", "Selangor", "Terengganu", "WP Kuala Lumpur"]
}

extension Array where Element == Court {
    func uniqueCategories() -> [String] {
        var uniqueCategories = [String]()
        for court in self {
            for type in court.type {
                if !uniqueCategories.contains(type) {
                    uniqueCategories.append(type)
                }
            }
        }
        return uniqueCategories
    }
    func courtsInState(_ state: String) -> [Court] {
        return filter { $0.address.contains(state) }
    }
}

struct TimeSlot {
    var start: Date = Date()
    var end: Date = Date()
    var display: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let startTimeString = dateFormatter.string(from: start)
        let endTimeString = dateFormatter.string(from: end)
        return "\(startTimeString) - \(endTimeString)"
    }
} 

extension TimeSlot: Hashable, Encodable, Decodable {}

extension TimeSlot {
    static let twelvepm = TimeSlot(start: setTime(12, 0), end: setTime(15, 0))
    static let threepm = TimeSlot(start: setTime(15, 0), end: setTime(18, 0))
    static let sixpm = TimeSlot(start: setTime(18, 0), end: setTime(21, 0))
    
}

struct Activity: Identifiable {
    var id = UUID()
    
    var type: String = ""
    var date: Date = Date()
    var court: Court = Court()
    var upcoming: Bool {
        let oneHourFromNow = Calendar.current.date(byAdding: .minute, value: 30, to: Date()) ?? Date()
        
        return date >= oneHourFromNow
    }
}

extension Activity: Encodable, Decodable {}

extension Activity {
    static let activity = [
        Activity(type: "Badminton", date: dateFormat(from: "22/08/2023,23:10", set: "dd/MM/yyyy,HH:mm"), court: Court.eight),
        Activity(type: "Futsal", date: dateFormat(from: "23/08/2023,10:50", set: "dd/MM/yyyy,HH:mm"), court: Court.eight),
        Activity(type: "Badminton", date: dateFormat(from: "28/10/2023,19:10", set: "dd/MM/yyyy,HH:mm"), court: Court.um),
        Activity(type: "Basketball", date: dateFormat(from: "8/11/2023,20:00", set: "dd/MM/yyyy,HH:mm"), court: Court.ttdi),
        Activity(type: "Swimming", date: dateFormat(from: "29/11/2023,17:00", set: "dd/MM/yyyy,HH:mm"), court: Court.um),
    ]
}

struct Booking: Identifiable {
    var id = UUID()
    
    var court: Court = Court()
    var type: String = ""
    var date: Date = Date()
    var slot: TimeSlot = TimeSlot()
    var capacity: Int = 0
}

extension Booking: Encodable, Decodable {}

extension Booking {
    static let bookData = [
        Booking(court: Court.um, type: "Badminton")
    ]
}
