//
//  RecommendationModel.swift
//  StockSearch2
//
//  Created by Manish on 5/1/22.
//

import Foundation
import SwiftUI

// Recommendation API responses with a list of recommendations JSON obj


struct recommendations: Codable{
    let buy: Int
    let hold: Int
    let period: String
    let sell: Int
    let strongBuy: Int
    let strongSell: Int
    let symbol: String
}

class RecommendationModel: ObservableObject {
    @Published var recommendResponse: [recommendations] = []
    @Published var isRecommendLoading: Bool = true
    var StrongBuyList:[Int] = []
    var BuyList: [Int] = []
    var HoldList: [Int] = []
    var SellList: [Int] = []
    var StrongSell: [Int] = []
    var timeStamp: [String] = []
    
    
    
    func fetchRecommendations(tickerName: String) async {
        
        guard let url = URL(string: "https://stock-service-backend.wl.r.appspot.com/api/v1.0.0/recommendations/" + tickerName) else {
            print("INVALID URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let recommendData = data, error == nil else {
                return
            }
//            print(companysData)
            
            // Convert to JSON obj
            
            do {
                let decoder = JSONDecoder()
                let recommendRes = try decoder.decode([recommendations].self, from: recommendData)
//                print(newsRes)
                DispatchQueue.main.async { [self] in
                    self.recommendResponse = recommendRes
//                    print(self.sentimentsResponse)
                    self.isRecommendLoading = false
                    self.createList(recommedRes: recommendRes)
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
    func createList(recommedRes: [recommendations]){
        //StrongBuy, Buy, Hold, Sell, StrongSell
//        var list:[Any] = []
        var StrongBuy: [Int] = []
        var Buy: [Int] = []
        var Hold: [Int] = []
        var Sell: [Int] = []
        var StrongSell: [Int] = []
        var timeStamp: [String] = []
        
        for res in recommedRes {
            StrongBuy.append(res.strongBuy)
            Buy.append(res.buy)
            Hold.append(res.hold)
            Sell.append(res.sell)
            StrongSell.append(res.strongSell)
            timeStamp.append(res.period)
        }
        self.StrongBuyList = StrongBuy
        self.BuyList = Buy
        self.HoldList = Hold
        self.SellList = Sell
        self.StrongSell = StrongSell
        self.timeStamp = timeStamp
    }
}
