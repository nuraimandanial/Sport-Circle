//
//  Invitation.swift
//  Sport Circle
//
//  Created by kinderBono on 24/10/2023.
//

import Foundation

class Invitations: ObservableObject {
    @Published var invitations: [Invitation] = []
    
    init() {
        invitations = fetchInvites(true)
    }
    
    func fetchInvites(_ test: Bool) -> [Invitation] {
        var all: [Invitation] = []
        if test {
            all.append(contentsOf: Invitation.invitation.compactMap { $0.self })
        }
        return all
    }
    
    func fetchInvites(for profile: Profile) -> [Invitation] {
        return invitations.filter( { $0.to == profile.id })
    }
    
    func rejectInvite(of invite: Invitation, for profile: Profile) -> Bool {
        if fetchInvites(for: profile).contains(where: { $0.id == invite.id }) {
            invitations.removeAll { $0.id == invite.id }
            return true
        } else {
            return false
        }
    }
}

struct Invitation: Identifiable {
    var id = UUID()
    
    var name: String = ""
    var to: UUID?
    var group: String = ""
    var message: String = ""
}

extension Invitation: Encodable, Decodable {}

extension Invitation {
    static let invitation = [
        Invitation(name: "Harraz", to: Profile.admin.id, group: "Futsal Arena", message: "We'd love to have you in our group!"),
        Invitation(name: "Fairuz", group: "Badminton", message: "Join us for some fun activities!"),
        Invitation(name: "Fitriah", group: "Basketball", message: "We're looking for new members.")
    ]
}
