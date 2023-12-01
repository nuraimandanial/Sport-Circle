//
//  NewsView.swift
//  Sport Circle
//
//  Created by kinderBono on 24/10/2023.
//

import SwiftUI

struct NewsView: View {
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var news: News
    
    @State var newsLiked: [String: Bool] = [:]
    @State private var detail: Bool = false
    @State private var selectedNews: NewsData = .previewData[0]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.bieges.ignoresSafeArea()
                
                VStack {
                    TopBar(type: "Full")
                        .environmentObject(appModel)
                        .environmentObject(appModel.top)
                    
                    HStack {
                        Text("News")
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                    .padding()
                    if news.news.isEmpty {
                        Text("No news available currently")
                    }
                    ScrollView {
                        ForEach(news.news, id: \.title) { news in
                            VStack(alignment: .leading) {
                                Button(action: {
                                    detail.toggle()
                                    selectedNews = news
                                }, label: {
                                    VStack {
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
                                    }
                                })
                                VStack(alignment: .leading) {
                                    Text(news.title)
                                        .font(.title3)
                                        .bold()
                                        .multilineTextAlignment(.leading)
                                    HStack {
                                        Text(news.captionText)
                                            .font(.callout)
                                        Spacer()
                                        Button(action: {
                                            let bind = bindingLiked(news)
                                            bind.wrappedValue.toggle()
                                        }, label: {
                                            Image(systemName: newsLiked[news.title] == true ? "heart.fill" : "heart")
                                                .foregroundStyle(newsLiked[news.title] == true ? .pink : .grays)
                                                .imageScale(.large)
                                        })
                                    }
                                    .foregroundStyle(.grays)
                                }
                                .padding(.horizontal, 10)
                            }
                            .fullScreenCover(isPresented: $detail) {
                                NewsDetail(news: $selectedNews, backButton: $detail)
                            }
                            .padding(.bottom)
                        }
                        .padding(.horizontal)
                    }
                }
                .foregroundStyle(.blues)
            }
        }
    }
    
    func bindingLiked(_ news: NewsData) -> Binding<Bool> {
        let key = news.title
        return Binding(get: {
            newsLiked[key] ?? false
        }, set: {
            newsLiked[key] = $0
        })
    }
}

#Preview {
    NewsView()
        .environmentObject(AppModel().news)
        .environmentObject(AppModel().top)
}

/*
 ForEach(news.news) { news in
 ScrollView {
 AsyncImage(url: news.imageURL) { phase in
 switch phase {
 case .empty:
 Image(systemName: "photo")
 case .success(let image):
 image
 case .failure:
 Image(systemName: "photo")
 @unknown default:
 EmptyView()
 }
 }
 Text(news.title)
 HStack {
 Text(news.captionText)
 Button(action: {
 liked.toggle()
 }, label: {
 Image(systemName: liked ? "heart.fill" : "heart")
 .foregroundStyle(liked ? .pink : .grays)
 })
 }
 }
 }
 */
