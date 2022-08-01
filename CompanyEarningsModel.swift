//
//  CompanyEarningsModel.swift
//  StockSearch2
//
//  Created by Manish on 5/1/22.
//

import Foundation
import SwiftUI
// CompanyEarnings API responses with a list of earnings JSON obj
struct earnings: Codable{
    let actual: Double
    let estimate: Double
    let period: String
    let surprise: Double
//    let surprisePercent: Float
//    let symbol: String
}


class CompanyEarningsModel: ObservableObject {
    
    @Published var earningsResponse: [earnings] = []
    @Published var isEarnLoading: Bool = true
    
    var XAxis: [String] = []
    var ActualList: [Double] = []
    var EstimateList: [Double] = []
    
    func fetchEarnings(tickerName: String) async {
        
        guard let url = URL(string: "https://stock-service-backend.wl.r.appspot.com/api/v1.0.0/companyearnings/" + tickerName) else {
            print("INVALID URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let earningsData = data, error == nil else {
                return
            }
//            print(companysData)
            
            // Convert to JSON obj
            
            do {
                let decoder = JSONDecoder()
                let earningsRes = try decoder.decode([earnings].self, from: earningsData)
//                print(newsRes)
                DispatchQueue.main.async { [self] in
                    self.earningsResponse = earningsRes
                    self.createDataChart()
//                    print(self.sentimentsResponse)
                    self.isEarnLoading = false
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
    
    func createDataChart(){
        for res in self.earningsResponse{
            self.ActualList.append(res.actual)
            self.EstimateList.append(res.estimate)
            self.XAxis.append("\(res.period)</br>Surprise:\(res.surprise)")
        }
    }
    
    
    
}
