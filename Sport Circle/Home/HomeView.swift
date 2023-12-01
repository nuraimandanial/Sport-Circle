//
//  HomeView.swift
//  Sport Circle
//
//  Created by kinderBono on 24/10/2023.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var homeState: HomeState
    
    let categories = Court.courtData.uniqueCategories()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.bieges.ignoresSafeArea()
                
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 45)
                            .shadow(radius: 10)
                            .ignoresSafeArea()
                        
                        LinearGradient(colors: [.blues, .blues.opacity(0.5), .blues.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                            .cornerRadius(45)
                            .shadow(radius: 10)
                            .ignoresSafeArea()
                        
                        VStack {
                            HStack {
                                Image("logo1")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200)
                                Button(action: {
                                    homeState.reward.toggle()
                                }, label: {
                                    Image(systemName: "crown.fill")
                                        .imageScale(.large)
                                })
                                .navigationDestination(isPresented: $homeState.reward) {
                                    RewardView(backButton: $homeState.reward)
                                        .environmentObject(appModel)
                                        .environmentObject(appModel.rewardAvaliable)
                                }
                            }
                            VStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(height: 50)
                                        .foregroundStyle(.blues)
                                    HStack {
                                        Text("Please select an area")
                                            .foregroundStyle(.whitey)
                                        Spacer()
                                        Button(action: {
                                            homeState.selectState.toggle()
                                            homeState.stateDate = 0
                                        }, label: {
                                            Image(systemName: "mappin.and.ellipse")
                                        })
                                        .sheet(isPresented: $homeState.selectState) {
                                            ZStack {
                                                Color.bieges.ignoresSafeArea()
                                                VStack {
                                                    HStack {
                                                        VStack {
                                                            Image(systemName: "chevron.down")
                                                                .offset(y: 2.5)
                                                            Image(systemName: "chevron.down")
                                                                .offset(y: -2.5)
                                                        }
                                                        Text("Swipe down to close ")
                                                        VStack {
                                                            Image(systemName: "chevron.down")
                                                                .offset(y: 2.5)
                                                            Image(systemName: "chevron.down")
                                                                .offset(y: -2.5)
                                                        }
                                                    }
                                                    Picker("", selection: $homeState.selectedState) {
                                                        ForEach(Court.state, id: \.self) { state in
                                                            Text(state).tag(state)
                                                        }
                                                    }
                                                    .pickerStyle(.wheel)
                                                }
                                                .environment(\.colorScheme, .light)
                                                .padding()
                                            }
                                            .presentationDetents([.height(250)])
                                            .presentationCornerRadius(45)
                                            .onDisappear {
                                                homeState.stateDate += 1
                                                if homeState.stateDate == 2 {
                                                    homeState.courtToggle.toggle()
                                                }
                                            }
                                        }
                                    }
                                    .padding()
                                }
                                .padding(.horizontal, 40)
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(height: 50)
                                        .foregroundStyle(.blues)
                                    HStack {
                                        Text("Please select a date")
                                            .foregroundStyle(.whitey)
                                        Spacer()
                                        Button(action: {
                                            homeState.selectDate.toggle()
                                        }, label: {
                                            Image(systemName: "calendar")
                                        })
                                        .sheet(isPresented: $homeState.selectDate) {
                                            ZStack {
                                                Color.bieges.ignoresSafeArea()
                                                VStack {
                                                    HStack {
                                                        VStack {
                                                            Image(systemName: "chevron.down")
                                                                .offset(y: 2.5)
                                                            Image(systemName: "chevron.down")
                                                                .offset(y: -2.5)
                                                        }
                                                        Text("Swipe down to close ")
                                                        VStack {
                                                            Image(systemName: "chevron.down")
                                                                .offset(y: 2.5)
                                                            Image(systemName: "chevron.down")
                                                                .offset(y: -2.5)
                                                        }
                                                    }
                                                    DatePicker("", selection: $homeState.selectedDate, displayedComponents: .date)
                                                        .datePickerStyle(GraphicalDatePickerStyle())
                                                }
                                                .environment(\.colorScheme, .light)
                                                .padding()
                                            }
                                            .presentationDetents([.height(450)])
                                            .presentationCornerRadius(45)
                                            .onDisappear {
                                                homeState.stateDate += 1
                                                if homeState.stateDate == 2 {
                                                    homeState.courtToggle.toggle()
                                                }
                                            }
                                        }
                                    }
                                    .padding()
                                }
                                .padding(.horizontal, 40)
                            }
                            .navigationDestination(isPresented: $homeState.courtToggle) {
                                CourtView(state: $homeState.selectedState, date: $homeState.selectedDate, backButton: $homeState.courtToggle, stateDate: $homeState.stateDate)
                                    .environmentObject(appModel)
                                    .environmentObject(appModel.top)
                            }
                            .padding()
                        }
                    }
                    .frame(height: 280)
                    ScrollView {
                        HStack {
                            Text("Announcement")
                                .font(.title2)
                                .bold()
                            Spacer()
                            if !appModel.news.news.isEmpty {
                                Button(action: {
                                    appModel.selectedTab = 1
                                }, label: {
                                    Text("See All")
                                })
                            }
                        }
                        .padding([.horizontal, .top])
                        if appModel.news.news.isEmpty {
                            Text("No news available currently")
                                .padding(.top)
                        }
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHGrid(rows: [GridItem()], spacing: 0) {
                                ForEach(appModel.news.news) { news in
                                    Button(action: {
                                        homeState.selectNews.toggle()
                                        homeState.selectedNews = news
                                    }, label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 15)
                                                .foregroundStyle(.grays.opacity(0.3))
                                            AsyncImage(url: news.imageURL) { phase in
                                                switch phase {
                                                    case .empty:
                                                        Placeholder(type: "Empty Image")
                                                    case .success(let image):
                                                        image
                                                    case .failure:
                                                        Placeholder(type: "Empty Image")
                                                    @unknown default:
                                                        EmptyView()
                                                }
                                            }
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(lineWidth: 1)
                                            VStack {
                                                Spacer()
                                                Text(news.title)
                                                    .foregroundStyle(.whitey)
                                                    .bold()
                                                    .lineLimit(2)
                                                    .shadow(radius: 5)
                                            }
                                            .padding()
                                        }
                                        .frame(width: 200, height: 120)
                                        .padding(.vertical, 2)
                                    })
                                    .fullScreenCover(isPresented: $homeState.selectNews) {
                                        NewsDetail(news: $homeState.selectedNews, backButton: $homeState.selectNews)
                                    }
                                    .padding(.leading)
                                }
                            }
                        }
                        HStack {
                            Text("Sports")
                                .font(.title2)
                                .bold()
                            Spacer()
                        }
                        .padding([.horizontal, .top])
                        if categories.isEmpty || appModel.events.courtData.isEmpty {
                            Text("No courts available currently")
                                .padding(.top)
                        } else {
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(Array(categories.enumerated()), id: \.element.self) { index, category in
                                        Button(action: {
                                            homeState.selectedIndex = index
                                            homeState.selectedCategory = category
                                            withAnimation {
                                                homeState.courtRefresh.toggle()
                                            }
                                        }, label: {
                                            CourtTab(isActive: homeState.selectedIndex == index, text: category)
                                        })
                                    }
                                }
                            }
                            .padding(.leading)
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHGrid(rows: [GridItem()], spacing: 0) {
                                    ForEach(appModel.events.courtData) { court in
                                        if court.type.contains(homeState.selectedCategory) {
                                            Button(action: {
                                                homeState.courtDetail.toggle()
                                                homeState.selectedCourt = court
                                            }, label: {
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .foregroundStyle(.grays.opacity(0.3))
                                                    if court.image != "" {
                                                        Image(court.image)
                                                            .resizable()
                                                            .scaledToFit()
                                                    } else {
                                                        Image("logo2")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .padding()
                                                    }
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .stroke(lineWidth: 1)
                                                    VStack {
                                                        Spacer()
                                                        Text(court.name)
                                                            .lineLimit(2)
                                                            .bold()
                                                            .foregroundStyle(.whitey)
                                                            .shadow(radius: 5)
                                                    }
                                                    .padding()
                                                }
                                                .frame(width: 180, height: 120)
                                                .padding(.vertical, 2)
                                            })
                                            .fullScreenCover(isPresented: $homeState.courtDetail) {
                                                CourtDetail(court: $homeState.selectedCourt, backButton: $homeState.courtDetail)
                                                    .environmentObject(appModel)
                                            }
                                            .padding(.leading)
                                        }
                                    }
                                    .id(homeState.courtRefresh)
                                }
                            }
                        }
                    }
                    .foregroundStyle(.blues)
                }
            }
        }
    }
}

struct CourtTab: View {
    var isActive: Bool
    var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(text)
                .font(.body)
                .foregroundStyle(isActive ? .blues : .grays)
            if isActive {
                Color.oranges
                    .frame(width: 15, height: 2)
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppModel())
        .environmentObject(AppModel().home)
}
