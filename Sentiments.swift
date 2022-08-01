//
//  Sentiments.swift
//  StockSearch2
//
//  Created by Manish on 4/28/22.
//

import Foundation
import SwiftUI

struct Sentiments: Codable{
    let reddit: [sentimentScore]
    let symbol: String
    let twitter: [sentimentScore]
    
    init(red: [sentimentScore] = [],
         sym: String = "",
         twi: [sentimentScore] = []){
        self.reddit = red
        self.symbol = sym
        self.twitter = twi
    }
}

struct sentimentScore: Codable{
//    let atTime: String //time 2022-02-18 00:00:00
    let mention: Int // number of mentions
    let negativeMention: Int // number of negative mentions
//    let negativeScore: Double // Range from 0-1
    let positiveMention: Int // number of positive mentions
//    let positiveScore: Double // Range from 0-1
//    let score: Double // Range from -1 to 1
}


class sentimentsViewMode: ObservableObject{
    
    @Published var sentimentsResponse: Sentiments = Sentiments()
    @Published var totalMentions: [Int] = []
    @Published var positiveMentions: [Int] = []
    @Published var negativeMentions: [Int] = []
    @Published var isSenLoading: Bool = true
    
    func fetchSentiments(tickerName: String) async {
        
        guard let url = URL(string: "https://stock-service-backend.wl.r.appspot.com/api/v1.0.0/sentiments/" + tickerName) else {
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
                let senRes = try decoder.decode(Sentiments.self, from: companysData)
//                print(senRes)
                DispatchQueue.main.async { [self] in
                    self.sentimentsResponse = senRes
//                    print(self.sentimentsResponse)
                    self.calculate()
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
    
    func calculate() {
        var totMentions: Int = 0
        var posMentions: Int = 0
        var negMentions: Int = 0
        
//        print("CALCULATING........")
        for senScore in sentimentsResponse.reddit{
//            print(senScore.mention)
            totMentions += senScore.mention
            posMentions += senScore.positiveMention
            negMentions += senScore.negativeMention
        }
        totalMentions.append(totMentions)
        positiveMentions.append(posMentions)
        negativeMentions.append(negMentions)
        
        totMentions = 0
        posMentions = 0
        negMentions = 0
        
        for senScore in sentimentsResponse.twitter{
            totMentions += senScore.mention
            posMentions += senScore.positiveMention
            negMentions += senScore.negativeMention
        }
        
        totalMentions.append(totMentions)
        positiveMentions.append(posMentions)
        negativeMentions.append(negMentions)
//        print("ALL THE MENTIONS")
//        print(totalMentions)
//        print(positiveMentions)
//        print(negativeMentions)
        
        if !totalMentions.isEmpty && !positiveMentions.isEmpty && !negativeMentions.isEmpty{
            self.isSenLoading = false
        }
//        print(self.isSenLoading)
    }
}
