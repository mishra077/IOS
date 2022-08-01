//
//  HistoricalChatsModel.swift
//  StockSearch2
//
//  Created by Manish on 4/29/22.
//

import Foundation

struct HistoricalData: Codable{
    var c: [Double] // list of close prices
    var h: [Double] // list of high prices
    var l: [Double] // list of low prices
    var o: [Double] // list of open prices
    var s: String // Status (ok)
    var t: [Int] // list of timestamps
    var v: [Int] // list of volume data
    
    init(c:[Double] = [],
         h:[Double] = [],
         l:[Double] = [],
         o:[Double] = [],
         s:String = "",
         t:[Int] = [],
         v:[Int] = []){
        self.c = c
        self.h = h
        self.l = l
        self.o = o
        self.s = s
        self.t = t
        self.v = v
    }
}


class HistoricalChatsViewModel: ObservableObject {
    
    @Published var HisData: HistoricalData = HistoricalData()
    @Published var isHisCharts: Bool = true
    
    func fetchHis(tickerName: String) async{
        
        let yrComp = DateComponents(year: -2)
        let fromdate = Calendar.current.date(byAdding: yrComp, to: Date())
        let comp = Calendar.current.dateComponents([.year,.month,.day], from: fromdate!)
        
        var yr: Int = comp.year!
        var month: Int = comp.month!
        var day: Int = comp.day!
        
        let fromStringDate:String = "\(month)-\(day)-\(yr)"
        print("date: from his charts")
//        print(fromStringDate)
        print("https://stock-service-backend.wl.r.appspot.com/api/v1.0.0/histcharts/" + tickerName + "/date/"+fromStringDate)
//        print("https://stock-service-backend.wl.r.appspot.com/api/v1.0.0/histcharts/"+tickerName+"/date/"+fromStringDate)
        
        guard let url = URL(string: "https://stock-service-backend.wl.r.appspot.com/api/v1.0.0/histcharts/" + tickerName + "/date/"+fromStringDate) else {
            
            print("INVALID URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let hisData = data, error == nil else {
                return
            }
//            print(hisData)
            
            // Convert to JSON obj
            
            do {
                let decoder = JSONDecoder()
                let hisRes = try decoder.decode(HistoricalData.self, from: hisData)
//                print(newsRes)
                DispatchQueue.main.async { [self] in
                    self.HisData = hisRes
                    print(self.HisData)
//                    print(self.sentimentsResponse)
                    self.isHisCharts = false
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
