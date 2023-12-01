//
//  Reward.swift
//  Sport Circle
//
//  Created by kinderBono on 26/10/2023.
//

import Foundation

class Reward: ObservableObject {
    @Published var current: [RewardData] = RewardData.rewards
    @Published var totalPoints: Int = 1500
}

struct RewardData: Identifiable {
    var id = UUID()
    
    var title: String = ""
    var pointsRequired: Int = 0
    var type: String = ""
}

extension RewardData: Encodable, Decodable {}

extension RewardData {
    static let rewards: [RewardData] = [
        RewardData(title: "5 % Discount", pointsRequired: 50, type: "discount"),
        RewardData(title: "30 % Discount", pointsRequired: 200, type: "discount"),
        RewardData(title: "50 % Discount", pointsRequired: 300, type: "discount"),
        RewardData(title: "Free 1 Book", pointsRequired: 500, type: "free")
    ]
}
