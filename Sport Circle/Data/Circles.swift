//
//  Circle.swift
//  Sport Circle
//
//  Created by kinderBono on 24/10/2023.
//

import Foundation

class CircleData: ObservableObject {
    @Published var circleData: [Circles] = []
    @Published var circle = Circles()
    
    init() {
        circleData = fetchCircles(true)
    }
    
    func fetchCircles(_ test: Bool) -> [Circles] {
        var all: [Circles] = []
        if test {
            all.append(contentsOf: Circles.circles.compactMap { $0.self })
        }
        return all
    }
    
    func fetchCircle(by name: String) -> Circles? {
        circleData.first(where: { $0.name == name })
    }
    
    func uniqueTypes() -> [String] {
        return circleData.uniqueTypes()
    }
    
    func randomThree() -> [Circles] {
        return circleData.randomThree()
    }
    
    func isJoined(_ user: User, in circle: Circles) -> Bool {
        return circle.isJoinedBy(user)
    }
    
    func joinCircle(_ user: User, in circle: Circles) {
        if !isJoined(user, in: circle) {
            user.currentUser.joinedCircles.append(circle.id)
        }
    }
    
    func leaveCircle(_ user: User, in circle: Circles) {
        user.currentUser.joinedCircles.removeAll { $0 == circle.id }
    }
    
    func updateCircle(for circle: Circles, with new: Circles) {
        if let index = circleData.firstIndex(where: { $0.id == circle.id }) {
            circleData[index] = new
        }
    }
}

struct Circles: Identifiable {
    var id = UUID()
    
    var name: String = ""
    var description: String = ""
    var image: String = ""
    var type: String = ""
    var capacity: Int = 0
    
    var chat: Chat = Chat()
    
    func isJoinedBy(_ user: User) -> Bool {
        return user.currentUser.joinedCircles.contains(id)
    }
}

extension Circles: Encodable, Decodable {}

extension Circles {
    static let setapak = Circles(name: "Budak Setapak", description: "Beginner", image: "badminton1", type: "Badminton", capacity: 8, chat: Chat.chats)
    static let lightningSmash = Circles(name: "Lightning Smash", description: "Intermediate level players", image: "badminton2", type: "Badminton", capacity: 8, chat: Chat.chats)
    static let selectMember = Circles(name: "Select Member", description: "Advanced level players", image: "badminton3", type: "Badminton", capacity: 12, chat: Chat.chats)
    static let casualMember = Circles(name: "Casual Member", description: "Master level players", image: "badminton", type: "Badminton", capacity: 12, chat: Chat.chats)
    static let swimmingWithSam = Circles(name: "Swimming with Sam", description: "Beginner level players", image: "swim1", type: "Swimming", capacity: 8, chat: Chat.chats)
    static let renangBerirama = Circles(name: "Renang Berirama", description: "Intermediate level players", image: "swim2", type: "Swimming", capacity: 8, chat: Chat.chats)
    static let peraSwimming = Circles(name: "Pera Swimming", description: "Advanced level players", image: "swim3", type: "Swimming", capacity: 12, chat: Chat.chats)
    static let justSwimFaster = Circles(name: "Just Swim Faster", description: "Master level players", image: "swim4", type: "Swimming", capacity: 12, chat: Chat.chats)
    static let basketballLeague = Circles(name: "Basketball League", description: "Beginner level players", image: "bb1", type: "Basketball", capacity: 8, chat: Chat.chats)
    static let basketballChampionsLeague = Circles(name: "Basketball Champions League", description: "Intermediate level players", image: "bb2", type: "Basketball", capacity: 8, chat: Chat.chats)
    static let basketball = Circles(name: "Basketball", description: "Advanced level players", image: "bb3", type: "Basketball", capacity: 12, chat: Chat.chats)
    static let futsalArena = Circles(name: "Futsal Arena", description: "Beginner level players", image: "futsal1", type: "Futsal", capacity: 8, chat: Chat.chats)
    static let soccer = Circles(name: "Soccer", description: "Intermediate level players", image: "futsal2", type: "Futsal", capacity: 8, chat: Chat.chats)
    static let soccerSport = Circles(name: "Soccer Sport", description: "Advanced level players", image: "futsal3", type: "Futsal", capacity: 12, chat: Chat.chats)
    static let bolaMbappe = Circles(name: "Bola Mbappe", description: "Master level players", image: "futsal4", type: "Futsal", capacity: 12, chat: Chat.chats)
    
    static let circles = [
        setapak,
        lightningSmash,
        selectMember,
        casualMember,
        swimmingWithSam,
        renangBerirama,
        peraSwimming,
        justSwimFaster,
        basketballLeague,
        basketballChampionsLeague,
        basketball,
        futsalArena,
        soccer,
        soccerSport,
        bolaMbappe
    ]
}

extension Array where Element == Circles {
    func uniqueTypes() -> [String] {
        var uniqueTypes: [String] = []
        for circle in self {
            if !uniqueTypes.contains(circle.type) {
                uniqueTypes.append(circle.type)
            }
        }
        return uniqueTypes
    }
    
    func randomThree() -> [Circles] {
        guard count >= 3 else {
            return self
        }
        
        var uniqueIndexes = Set<Int>()
        var randomCircles: [Circles] = []
        
        while uniqueIndexes.count < 3 {
            let randomIndex = Int.random(in: 0..<count)
            if !uniqueIndexes.contains(randomIndex) {
                uniqueIndexes.insert(randomIndex)
                randomCircles.append(self[randomIndex])
            }
        }
        
        return randomCircles
    }
    
    func circlesWithType(_ type: String) -> [Circles] {
        return filter { $0.type == type }
    }
}

struct Chat {
    var participant: [Profile] = []
    var messages: [Message] = []
    
    mutating func sendMessage(_ message: Message) {
        messages.append(message)
    }
}

extension Chat: Encodable, Decodable {}

extension Chat {
    static let chats = Chat(participant: [Profile.admin, Profile.fit], messages: Message.messages)
}

struct Message: Identifiable {
    var id = UUID()
    var sender: String
    var text: String
    var timestamp: Date = .distantPast
    
    var time: String {
        timestamp.formatted(date: .omitted, time: .shortened)
    }
}

extension Message: Encodable, Decodable {}

extension Message {
    static let messages = [
        Message(sender: "Sakinah", text: "Hello!"),
        Message(sender: "Shazlen", text: "Hi there!"),
        Message(sender: "Sakinah", text: "How are you?"),
        Message(sender: "Shazlen", text: "I'm fine, thanks! Btw, what do you guys want to do this weekend?"),
        Message(sender: "userName", text: "Lets playy!"),
        Message(sender: "Sakinah", text: "Suree", timestamp: Date.now)
    ]
}
