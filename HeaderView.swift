//
//  HeaderView.swift
//  StockSearch2
//
//  Created by Manish on 4/19/22.
//

import Foundation

struct CompanyInfo: Codable{
    var country: String?
    var currency: String?
    var exchange: String?
    var finnhubIndustry: String?
    var ipo: String?
    var logo: String?
//    let marketCapitalization: Int?
    var name: String?
    var phone: String?
//    let shareOutstanding: Int?
    var ticker: String?
    var weburl: String?
    
    init(country: String? = nil,
         currency: String? = nil,
         exchange: String? = nil,
         finnhubIndustry: String? = nil,
         ipo: String? = nil,
         logo: String? = nil,
//         marketCapitalization: Int? = nil,
         name: String? = nil,
         phone: String? = nil,
//         shareOutstanding: String? = nil,
         ticker: String? = nil,
         weburl: String? = nil) {
        self.country = country
        self.currency = currency
        self.exchange = exchange
        self.finnhubIndustry = finnhubIndustry
        self.ipo = ipo
        self.logo = logo
//        self.marketCapitalization = marketCapitalization
        self.name = name
        self.phone = phone
//        self.shareOutstanding = shareOutstanding
        self.ticker = ticker
        self.weburl = weburl
    }
}

class HeaderViewModel: ObservableObject {
    
    @Published var CompanyInfoResponse: CompanyInfo = CompanyInfo()
    
    func fetchCompanysInfo(tickerName: String) async {
        
        guard let url = URL(string: "https://stock-service-backend.wl.r.appspot.com/api/v1.0.0/metadata/" + tickerName) else {
            print("INVALID URL")
            return
        }
//        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let companysData = data, error == nil else {
                return
            }
//            print(companysData)
            
            // Convert to JSON obj
            
            do {
                let decoder = JSONDecoder()
                let companyInfoRes = try decoder.decode(CompanyInfo.self, from: companysData)
                print(companyInfoRes)
                DispatchQueue.main.async { [self] in
                    self.CompanyInfoResponse = companyInfoRes
                    print(self.CompanyInfoResponse)
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
