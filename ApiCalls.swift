//
//  ApiCalls.swift
//  StockSearch2
//
//  Created by Manish on 4/17/22.
//

import Foundation



// Companys Historical Data
// each key is a list

// Recommendation API responses with a list of recommendations JSON obj





// AutoComplete sends a list of JSON
struct AutoComplete: Codable, Hashable{
    let description: String
    let displaySymbol: String
    let symbol: String
    let type: String
}

enum NetworkError: Error {
    case badURL
    case badID
}


//https://medium.com/macoclock/simple-async-api-request-with-swift-5-result-type-in-swiftui-d45e2ea04a7d


class ViewModel: ObservableObject {
    
    @Published var searchResults: [AutoComplete] = []
    
    
    func fetch(queryString: String) async {
        guard let url = URL(string: "https://stock-service-backend.wl.r.appspot.com/api/v1.0.0/searchutil/" + queryString + "/") else {
            return
        }
//        print(url)
        let task = URLSession.shared.dataTask(with: url) {[weak self] data, _,
            error in
            guard let sdata = data, error == nil else {
                return
            }
            
            // Convert to JSON
            
            do {
                let sResults = try JSONDecoder().decode([AutoComplete].self, from: sdata)
                DispatchQueue.main.async { [self] in
                    self?.searchResults = sResults
                    print(self!.searchResults)
                }
//                print(sResults)
            }
            catch {
                print(error.localizedDescription)
                print("error")
            }
            
        }
        task.resume()
    }
}


