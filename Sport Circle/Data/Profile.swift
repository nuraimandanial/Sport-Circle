//
//  Profile.swift
//  Sport Circle
//
//  Created by kinderBono on 24/10/2023.
//

import Foundation

class User: ObservableObject {
    let firebaseService = FirebaseService()
    
    @Published var profileData: [UserData] = []
    
    @Published var currentUser = UserData()
    
    init() {
        fetchProfiles(false) { profiles in
            self.profileData = profiles
        }
    }
    
    func fetchProfiles(_ test: Bool, completion: @escaping ([UserData]) -> Void) {
        firebaseService.fetchAllUserData { userData in
            var all: [UserData] = []
            
            for profile in userData {
                all.append(profile)
            }
            if test {
                all.append(contentsOf: Profile.profiles.map { profile in
                    return UserData(profile: profile)
                })
            }
            completion(all)
        }
    }
    
    func fetchProfile(for username: String) -> Profile? {
        profileData.first { $0.profile.username == username }?.profile
    }
    
    func createProfile(for new: Profile) {
        let userData = UserData(profile: new)
        profileData.append(userData)
        currentUser.profile = new
        firebaseService.addUserData(userData)
    }
    
    func updateProfile(with new: Profile) -> Bool {
        if let index = profileData.firstIndex(where: { $0.profile.id == currentUser.profile.id }) {
            var status: Bool = true
            profileData[index].profile = new
            currentUser.profile = new
            
            firebaseService.updateUserData(currentUser) { success in
                if success {
                    status = true
                    print("Profile updated in Firestore")
                } else {
                    status = false
                    print("Failed to update profile in Firestore")
                }
            }
            return status
        } else {
            return false
        }
    }
    
    func addFriend(_ friend: Profile) {
        guard var friendUserData = profileData.first(where: { $0.profile.id == friend.id }) else {
            return
        }
        
        friendUserData.friends.append(currentUser.profile.id)
        currentUser.friends.append(friend.id)
        
        firebaseService.updateMultipleUserData([currentUser, friendUserData]) { [self] success in
            if success {
                associateChat(withFriend: friendUserData, chat: Chat(participant: [currentUser.profile, friend]))
            }
        }
    }
    
    func removeFriend(_ friend: Profile) {
        guard var friendUserData = profileData.first(where: { $0.profile.id == friend.id }) else {
            return
        }
        
        friendUserData.friends.removeAll { $0 == currentUser.profile.id }
        currentUser.friends.removeAll { $0 == friend.id }
        
        firebaseService.updateMultipleUserData([currentUser, friendUserData]) { [self] success in
            if success {
                friendUserData.friendChats[currentUser.profile.id] = nil
            }
        }
    }
    
    func fetchFriendsProfile() -> [Profile] {
        let friendProfiles = currentUser.friends.compactMap { friendID in
            profileData.first { $0.profile.id == friendID }?.profile
        }
        return friendProfiles
    }
    
    func isFriend(_ friend: Profile) -> Bool {
        currentUser.friends.contains(friend.id)
    }
    
    func associateChat(withFriend friendUserData: UserData, chat: Chat) {
        currentUser.friendChats[friendUserData.profile.id] = chat
    }
    
    func chat(friendID: UUID) -> Chat {
        guard let friendUserData = profileData.first(where: { $0.friends.contains(friendID) }) else {
            return Chat()
        }
        
        if let exist = currentUser.friendChats[friendUserData.profile.id] {
            return exist
        } else {
            let new = Chat(participant: [currentUser.profile, friendUserData.profile])
            currentUser.friendChats[friendUserData.profile.id] = new
            return new
        }
    }
    
    func loadMessages(forFriend friendID: UUID) -> [Message] {
        guard profileData.first(where: { $0.friends.contains(friendID) }) != nil else {
            return []
        }
        
        return chat(friendID: friendID).messages
    }
    
    func logout() {
        firebaseService.updateMultipleUserData(profileData) { _ in }
        currentUser = UserData()
    }
}

struct UserData: Identifiable {
    var id: UUID { profile.id }
    var profile: Profile = Profile()
    var points: Int = 500
    
    var friends: [UUID] = []
    var joinedCircles: [UUID] = []
    var friendChats: [UUID: Chat] = [:]
}

extension UserData: Encodable, Decodable {}

struct Profile: Identifiable {
    var id = UUID()
    
    var image: String = ""
    var username: String = ""
    var email: String = ""
    var password: String = ""
    
    var name: String = ""
    var details: Detail = Detail()
}

struct Detail {
    var description: String = ""
    var phone: String = ""
    var address: String = ""
    var gender: String = "Undefined"
    var birthDate: Date = Date()
    
    var notification: Bool = false
}

extension Profile {
    static let profiles = [admin, fit]
    
    static let admin = Profile(username: "admin", email: "admin@email.com", password: "admin0", name: "Admin", details: Detail(description: "Admin Overpowered", phone: "011-23458697", address: "Malaysia", gender: "Undefined", notification: true))
    static let fit = Profile(username: "fitriah", name: "Fitriah", details: Detail(address: "Selangor", gender: "Female"))
}

extension Profile: Encodable, Decodable {}
extension Detail: Encodable, Decodable {}
