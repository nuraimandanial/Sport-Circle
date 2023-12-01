//
//  News.swift
//  Sport Circle
//
//  Created by kinderBono on 24/10/2023.
//

import Foundation

fileprivate let relativeDateFormatter = RelativeDateTimeFormatter()

class News: ObservableObject {
    @Published var news: [NewsData] = []
    
    init() {
        news = fetchNews(true)
    }
    
    func fetchNews(_ test: Bool) -> [NewsData] {
        var all: [NewsData] = []
        if test {
            all.append(contentsOf: NewsData.previewData.compactMap({ $0.self }))
        }
        return all
    }
}

struct Source: Codable, Equatable {
    let name: String
}

struct NewsData: Identifiable, Codable, Equatable {
    var id = UUID()
    
    let source: Source
    let title: String
    var publishedAt: Date = .distantPast
    
    let author: String?
    let description: String?
    let urlToImage: String?
    
    var authorText: String {
        author ?? ""
    }
    
    var descriptionText: String {
        description ?? ""
    }
    
    var captionText: String {
        "\(source.name) · \(relativeDateFormatter.localizedString(for: publishedAt, relativeTo: Date()))"
    }
    
    var imageURL: URL? {
        guard let urlToImage = urlToImage else {
            return nil
        }
        return URL(string: urlToImage)
    }
}

extension NewsData {
    static let previewData = [
        NewsData(source: Source(name: "Malaysia Kini"), title: "Ministry targets Malaysia becoming 'Sporting Nation' by 2025", author: "Afiq Yusof", description: "The Youth and Sports Ministry (KBS) is targeting Malaysia to become a Sporting Nation by 2025, with a Malaysia Sports Culture Index (IBSM) score of over 75 per cent. \nIts Deputy Minister, Datuk Seri Ti Lian Ker said the overall IBSM achievement for 2021 was 52 per cent, which showed that the involvement of the people in sports activities was still at a moderate level.", urlToImage: nil),
        NewsData(source: Source(name: "Sports Malaysia"), title: "Malaysian Football Team Qualifies for World Cup", author: "Amanda Lee", description: "In a historic achievement, the Malaysian national football team has qualified for the FIFA World Cup for the first time ever. The team's remarkable journey through the qualifiers has captured the hearts of fans nationwide.", urlToImage: "news1"),
        NewsData(source: Source(name: "Badminton Gazette"), title: "National Badminton Champion Wins Gold at Olympics", author: "Rahul Sharma", description: "Malaysia's badminton sensation, Lee Chong Wei, clinched the gold medal in men's singles at the Tokyo Olympics. This victory marks a historic moment in Malaysian sports history, as Lee Chong Wei becomes an Olympic champion.", urlToImage: "news2"),
        NewsData(source: Source(name: "Cricket Times"), title: "Malaysia Hosts International Cricket Tournament", author: "Samantha Tan", description: "Malaysia is set to host an international cricket tournament, featuring top teams from around the world. The tournament aims to promote cricket in the country and provide a platform for local talent to shine on the global stage.", urlToImage: "news3"),
        NewsData(source: Source(name: "Aquatic Achievers"), title: "Youth Athlete Breaks National Records in Swimming", author: "David Lim", description: "A young Malaysian swimmer, Sarah Tan, has made waves by breaking multiple national records in swimming events. Her exceptional performance has not only brought glory to the nation but also raised hopes for the future of Malaysian swimming.", urlToImage: "")
    ]
}
