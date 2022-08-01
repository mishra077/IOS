//
//  NewsModel.swift
//  StockSearch2
//
//  Created by Manish on 4/28/22.
//

import Foundation
import SwiftUI

// NewsApi sends a list of JSON
struct newsInfo: Codable{
    var category: String
    var datetime: Int
    var headline: String
    var id: Int
    var image: String
    var related: String
    var source: String
    var summary: String
    var url: String
    
    init(cat: String = "",
         dat:Int = 0,
         head: String = "",
         id: Int = 0,
         im: String = "",
         rel: String = "",
         src: String = "",
         sum: String = "",
         weburl: String = ""){
        self.category = cat
        self.datetime = dat
        self.headline = head
        self.id = id
        self.image = im
        self.related = rel
        self.source = src
        self.summary = sum
        self.url = weburl
    }
}

class newsViewModel: ObservableObject{
    @Published var newsResponse: [newsInfo] = []
    @Published var isNewsLoading: Bool = true
    
    func fetchNews(tickerName: String) async {
        
        guard let url = URL(string: "https://stock-service-backend.wl.r.appspot.com/api/v1.0.0/news/" + tickerName) else {
            print("INVALID URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let companysData = data, error == nil else {
                return
            }
//            print(companysData)
            
            // Convert to JSON obj
            
            do {
                let decoder = JSONDecoder()
                let newsRes = try decoder.decode([newsInfo].self, from: companysData)
//                print(newsRes)
                DispatchQueue.main.async { [self] in
                    self.newsResponse = newsRes
//                    print(self.sentimentsResponse)
                    self.isNewsLoading = false
                }
            }
            catch{
                print(String(describing: error))
                print(error.localizedDescription)
                print("error")
            }
        }
        task.resume()
        
    }
}
