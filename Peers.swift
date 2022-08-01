//
//  Peers.swift
//  StockSearch2
//
//  Created by Manish on 4/28/22.
//

import Foundation
import SwiftUI

class PeersModel: ObservableObject {
    @Published var peersResponse:[String] = []
    
    func fetchPeers(tickerName: String) async {
        
        guard let url = URL(string: "https://stock-service-backend.wl.r.appspot.com/api/v1.0.0/companypeers/" + tickerName) else {
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
                let peersRes = try decoder.decode([String].self, from: companysData)
                print(peersRes)
                DispatchQueue.main.async { [self] in
                    self.peersResponse = peersRes
                    print(self.peersResponse)
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
