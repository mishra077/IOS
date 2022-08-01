//
//  SuccessSheet.swift
//  StockSearch2
//
//  Created by Manish on 4/27/22.
//

import Foundation
import SwiftUI

struct SuccessSheetView: View {
    
    @Binding var successSheet: Bool
    @Binding var tradeSheet: Bool
    var ticker: String
    var numShares: Int
    var buyOrSell: Bool
    
        
    
    var body: some View {
        VStack{
            Spacer()
            Text("Congratulations!")
                .bold()
                .font(.system(size:30))
//                .frame(width: 200, height: 100)
                .background(.green)
                .foregroundColor(.white)
            
            Text("You have successfully " + String((buyOrSell) ?  "bought " : "sold ") + String(numShares) + String((numShares > 1) ? " shares of " : " share of ") + String(ticker))
                .frame(width: 300, height: 100)
                .multilineTextAlignment(.center)
                .font(.system(size:20))
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: {
                self.successSheet = false
                self.tradeSheet = false

            }, label: {
                Text("Done")
                    .foregroundColor(.green)
                    .frame(width: 360, height: 50)
            })
            .buttonStyle(BorderlessButtonStyle())
            .frame(width: 360, height: 50)
            .background(.white)
            .cornerRadius(25)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.green)
    }
}



