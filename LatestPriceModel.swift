//
//  LatestPriceModel.swift
//  StockSearch2
//
//  Created by Manish on 4/20/22.
//

import Foundation

struct LatestPriceInfo: Codable{
    var c: Double? // currentPrice
    var d: Double? // changeInPrice
    var dp: Double? //percentageChange
    var h: Double? //highPrice
    var l: Double? //lowPrice
    var o: Double? //openPrice
    var pc: Double? //previousClosePrice
    var t: Double? //timeStamp
    
    init(
        currentPrice: Double? = nil,
        changeInPrice: Double? = nil,
        percentageChange: Double? = nil,
        highPrice: Double? = nil,
        lowPrice: Double? = nil,
        openPrice: Double? = nil,
        previousClosePrice: Double? = nil,
        timeStamp: Double? = nil) {
            self.c = currentPrice
            self.d = changeInPrice
            self.dp = percentageChange
            self.h = highPrice
            self.l = lowPrice
            self.o = openPrice
            self.pc = previousClosePrice
            self.t = timeStamp
        }
}

struct HourlyInfo: Codable {
    var c: [Double] = []
    var t: [Int] = []
    
    init(c: [Double] = [],
         t:[Int] = []){
        self.c = c
        self.t = t
    }
}

class LatestPriceModel: ObservableObject {
    
    @Published var LatestPriceInfoResponse: LatestPriceInfo = LatestPriceInfo()
    @Published var hourlyResponse: HourlyInfo = HourlyInfo()
    @Published var isHourlyLoading: Bool = true
    @Published var isLatestLoading: Bool = true
//    var xAxisData: [String]
//    var hourlyPrice: [Double]
    
    func fetchLatestPrice(tickerName: String) async {
        guard let url = URL(string: "https://stock-service-backend.wl.r.appspot.com/api/v1.0.0/latestprice/" + tickerName) else {
            print("INVALID URL")
            return
        }
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let latestPriceData = data, error == nil else {
                return
            }
//            print(companysData)
            
            // Convert to JSON obj
            
            do {
                let decoder = JSONDecoder()
                let latestPriceRes = try decoder.decode(LatestPriceInfo.self, from: latestPriceData)
                print(latestPriceRes)
                DispatchQueue.main.async { [self] in
                    self.LatestPriceInfoResponse = latestPriceRes
                    self.isLatestLoading = false
                    self.fetchDailyCharts(tickerName: tickerName, fromDate: Int(latestPriceRes.t!))
                    print(self.LatestPriceInfoResponse)
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
    
    func fetchDailyCharts(tickerName: String, fromDate: Int){
        
        let updatedDate = fromDate * 1000 - 7200000
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
//                    self.createData()
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
    
//    func createData() {
//        for i in 0..<self.hourlyResponse.c.endIndex {
//            self.dailyChartsData.append([self.hourlyResponse.t[i], self.hourlyResponse.c[i]])
//        }
//    }
}
