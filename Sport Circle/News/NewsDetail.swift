//
//  NewsDetail.swift
//  Sport Circle
//
//  Created by kinderBono on 25/10/2023.
//

import SwiftUI

struct NewsDetail: View {
    @Binding var news: NewsData
    @Binding var backButton: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.bieges.ignoresSafeArea()
                
                VStack {
                    Button(action: {
                        backButton = false
                    }, label: {
                        Image(systemName: "xmark")
                    })
                    AsyncImage(url: news.imageURL) { phase in
                        switch phase {
                            case .empty:
                                Placeholder(type: "Empty Image", height: 200)
                            case .success(let image):
                                image
                            case .failure:
                                Placeholder(type: "Empty Image")
                            @unknown default:
                                EmptyView()
                        }
                    }
                    .padding()
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Published On")
                                    .bold()
                                Text(news.publishedAt, style: .date)
                                    .foregroundStyle(.grays)
                            }
                            Spacer()
                        }
                        Text(news.title)
                            .font(.title3)
                            .bold()
                        Text(news.descriptionText)
                            .opacity(0.5)
                    }
                    .foregroundStyle(.blues)
                    .padding(.horizontal, 30)
                }
            }
        }
    }
}

#Preview {
    NewsDetail(news: .constant(NewsData.previewData[0]), backButton: .constant(false))
}
