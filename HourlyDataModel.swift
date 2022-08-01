//
//  HourlyDataModel.swift
//  StockSearch2
//
//  Created by Manish on 5/1/22.
//

import Foundation
import SwiftUI


//struct HourlyInfo: Codable {
//    var c: [Double] = []
//    var t: [Int] = []
//
//    init(c: [Double] = [],
//         t:[Int] = []){
//        self.c = c
//        self.t = t
//    }
//}


class HourlyDataModel: ObservableObject {
    
    @Published var hourlyResponse: HourlyInfo = HourlyInfo()
    @Published var isHourlyLoading: Bool = true
    var dailyChartsData: [Any] = []
    
    func fetchHourly(tickerName: String, fromDate: Int) async {
        let updatedDate = fromDate * 1000
        guard let url = URL(string: "https://stock-service-backend.wl.r.appspot.com/api/v1.0.0/dailycharts/" + tickerName + "/date/" + String(updatedDate)) else {
            print("INVALID URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let hourlyData = data, error == nil else {
                return
            }
//            print(companysData)
            
            // Convert to JSON obj
            
            do {
                let decoder = JSONDecoder()
                let HourlyRes = try decoder.decode(HourlyInfo.self, from: hourlyData)
//                print(newsRes)
                DispatchQueue.main.async { [self] in
                    self.hourlyResponse = HourlyRes
//                    print(self.sentimentsResponse)
                    self.createData()
                    self.isHourlyLoading = false
//                    self.createList(recommedRes: recommendRes)
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
    
    func createData() {
        for i in 0..<self.hourlyResponse.c.endIndex {
            self.dailyChartsData.append([self.hourlyResponse.t[i], self.hourlyResponse.c[i]])
        }
    }
    
}
