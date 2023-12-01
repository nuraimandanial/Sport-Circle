//
//  DataManager.swift
//  Sport Circle
//
//  Created by kinderBono on 24/10/2023.
//

import Foundation
import Firebase
import FirebaseFirestore
import Combine

class AppModel: ObservableObject {
    @Published var user = User()
    @Published var news = News()
    @Published var events = Event()
    @Published var circles = CircleData()
    @Published var invites = Invitations()
    
    @Published var top = TopState()
    @Published var home = HomeState()
    @Published var rewardAvaliable = Reward()
    
    @Published var selectedTab: Int = 0
    @Published var isLoggedIn: Bool = false
}

class HomeState: ObservableObject {
    @Published var reward: Bool = false
    
    @Published var selectState: Bool = false
    @Published var selectedState: String = "Selangor"
    @Published var selectDate: Bool = false
    @Published var selectedDate: Date = .now
    @Published var stateDate: Int = 0
    @Published var courtToggle: Bool = false
    
    @Published var selectNews: Bool = false
    @Published var selectedNews: NewsData = .previewData[0]
    
    @Published var selectedIndex: Int = 0
    @Published var selectedCategory: String = "Badminton"
    @Published var courtRefresh: Bool = false
    @Published var courtDetail: Bool = false
    @Published var selectedCourt: Court = .courtData[0]
}

class TopState: ObservableObject {
    @Published var history: Bool = false
    @Published var addFriend: Bool = false
    @Published var notification: Bool = false
}

func dateString(from date: Date, set format: String = "dd MMM yyyy") -> String {
    let df = DateFormatter()
    df.dateFormat = format
    return df.string(from: date)
}

func dateFormat(from string: String, set format: String = "dd MMM yyyy") -> Date {
    let df = DateFormatter()
    df.dateFormat = format
    if let date = df.date(from: string) {
        return date
    } else {
        return Date()
    }
}

func setTime(_ hour: Int, _ minutes: Int) -> Date {
    let calendar = Calendar.current
    return calendar.date(bySettingHour: hour, minute: minutes, second: 0, of: Date())!
}

class FirebaseService {
    private let db = Firestore.firestore()
    
    func addUserData(_ userData: UserData) {
        do {
            let userDataJSON = try JSONEncoder().encode(userData)
            let documentReference = db.collection("user_data").document(userData.profile.id.uuidString)
            documentReference.setData(["data": userDataJSON])
        } catch {
            print("Error encoding user data: \(error)")
        }
    }
    
    func fetchAllUserData(completion: @escaping ([UserData]) -> Void) {
        db.collection("user_data").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching user data: \(error)")
                completion([])
            } else {
                var userDatas: [UserData] = []
                for document in querySnapshot!.documents {
                    if let data = document.data()["data"] as? Data {
                        do {
                            let userData = try JSONDecoder().decode(UserData.self, from: data)
                            userDatas.append(userData)
                        } catch {
                            print("Error decoding user data: \(error)")
                        }
                    }
                }
                completion(userDatas)
            }
        }
    }
    
    func updateUserData(_ userData: UserData, completion: @escaping (Bool) -> Void) {
        do {
            let userDataJSON = try JSONEncoder().encode(userData)
            let documentReference = db.collection("user_data").document(userData.id.uuidString)
            documentReference.setData(["data": userDataJSON], merge: true) { error in
                if let error = error {
                    print("Error updating user data: \(error)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        } catch {
            print("Error encoding user data: \(error)")
            completion(false)
        }
    }
    
    func updateMultipleUserData(_ userDatas: [UserData], completion: @escaping (Bool) -> Void) {
        var successCount = 0
        
        for userData in userDatas {
            updateUserData(userData) { success in
                if success {
                    successCount += 1
                    if successCount == userDatas.count {
                        completion(true)
                    }
                } else {
                    completion(false)
                    return
                }
            }
        }
    }
}
