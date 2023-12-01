////
//  RewardView.swift
//  Sport Circle
//
//  Created by kinderBono on 26/10/2023.
//

import SwiftUI

struct RewardView: View {
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var reward: Reward
    @Environment(\.dismiss) var dismiss
    
    @Binding var backButton: Bool
    @State private var alert: Bool = false
    
    var progress: Double {
        return Double(appModel.user.currentUser.points) / Double(reward.totalPoints)
    }
    
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
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundStyle(.blues)
                            .frame(height: 150)
                        VStack(spacing: 20) {
                            Text("Sports Reward")
                                .foregroundStyle(.oranges)
                                .font(.title2)
                                .bold()
                            Progress(progress: progress)
                                .frame(height: 10)
                            HStack {
                                Spacer()
                                Text("\(appModel.user.currentUser.points) points available")
                                    .foregroundStyle(.grays)
                            }
                        }
                        .padding()
                    }
                    .padding(.horizontal)
                    ScrollView {
                        ZStack {
                            Color.whitey.opacity(0.3)
                                .cornerRadius(15)
                            VStack {
                                ForEach(reward.current) { reward in
                                    HStack(spacing: 20) {
                                        Image(reward.type)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50)
                                        VStack(alignment: .leading) {
                                            Text(reward.title)
                                                .foregroundStyle(.blues)
                                                .bold()
                                                .frame(width: 120, alignment: .leading)
                                            Text("\(reward.pointsRequired) Points")
                                                .foregroundStyle(.grays)
                                        }
                                        Spacer()
                                        if reward.pointsRequired <= appModel.user.currentUser.points {
                                            Button(action: {
                                                redeem(reward)
                                            }, label: {
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .frame(height: 40)
                                                    Text("Redeem")
                                                        .font(.callout)
                                                        .foregroundStyle(.whitey)
                                                }
                                            })
                                        } else {
                                            VStack(alignment: .center) {
                                                Text("Cannot Redeem")
                                                    .foregroundStyle(.red)
                                                    .font(.caption)
                                                    .multilineTextAlignment(.center)
                                            }
                                        }
                                    }
                                    .alert(isPresented: $alert) {
                                        Alert(title: Text("Reward Redeemed!"), message: Text("You have successfully redeemed this reward."), dismissButton: .default(Text("OK")))
                                    }
                                    .frame(height: 80)
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
    
    func redeem(_ reward: RewardData) {
        appModel.user.currentUser.points -= reward.pointsRequired
        alert = true
    }
}

#Preview {
    RewardView(backButton: .constant(false))
        .environmentObject(AppModel())
        .environmentObject(AppModel().rewardAvaliable)
}

struct Progress: View {
    var progress: Double
    var body: some View {
        GeometryReader { gr in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 25)
                    .frame(width: gr.size.width, height: gr.size.height)
                    .foregroundStyle(.grays.opacity(0.3))
                RoundedRectangle(cornerRadius: 25)
                    .frame(width: min(CGFloat(progress) * gr.size.width, gr.size.width), height: gr.size.height)
                    .foregroundStyle(.oranges)
            }
        }
    }
}
