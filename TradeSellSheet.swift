//
//  TradeSellSheet.swift
//  StockSearch2
//
//  Created by Manish on 4/21/22.
//

import Foundation
import SwiftUI

func pricecal(cp:Double, numShare: Double)->Double{
    return cp * numShare
}

struct TradeSellSheetView: View {
    @Binding var tradeSheetView: Bool
//    @Binding var successBuy: Bool
//    @Binding var successSell: Bool
    
    var tickerName: String
    @Binding var currentPrice: Double?
    @Binding var CompanyName: String?
    @Binding var latestPrice: LatestPriceInfo
    @Binding var firstTimeBought: Bool
    @State private var numShare: String = ""
    @State private var MONEY: Money = getMoney()
    @State private var price: String = "0.00"
//    @State private var showToast: Bool = false
    @State private var notEnoughMoney: Bool = false
    @State private var validAmount: Bool = false
    @State private var notEnoughShares: Bool = false
    
    // Success Buy Sell Sheet
    @State var successBuy: Bool = false
    @State var successSell: Bool = false
//    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
            
        VStack{
            HStack{
                Spacer()
                Button(action: {
                    print("Dismissing sheet view...")
                    self.tradeSheetView = false
                }, label: {
                    Image(systemName: "xmark")
                })
                .padding()
                
            }
            VStack{
                Text("Trade " + (CompanyName ?? "ERROR") + " shares")
                    .bold()
                    .frame(height: 100)
                Spacer()
            }
            .frame(height:200)
//            .background(.red)
//            Spacer()
            
            VStack {
                HStack(alignment: .lastTextBaseline){
                    TextField("0", text: $numShare)
                        .font(.system(size:80))
                        .keyboardType(.decimalPad)
                        .frame(width: 300, height: 100)
//                        .background(.red)
                    if numShare.isEmpty || Double(numShare)! < 2{
                        Text("Share")
                            .padding(2)
                            .font(.system(size: 30))
                    }
                    else{
                        Text("Shares")
                            .padding(2)
                            .font(.system(size: 30))
                    }
                    
                }
                
                HStack{
                    Spacer()
                    if !numShare.isEmpty {
                        Text("x$" + String(format: "%.2f", currentPrice ?? 0) + "/share = $\(String(format: "%.2f", pricecal(cp: currentPrice!, numShare: Double(numShare) ?? 0)))").padding(2)
                    }
                    else{
                        Text("x$" + String(format: "%.2f", currentPrice ?? 0) + "/share = $\(price)").padding(2)
                    }
                }
                Spacer()
            }
//            .background(.green)
//            frame(height:700)
//            .background(.blue)
            
            Spacer()
            
            
            VStack{
//                Rectangle()
//                    .fill(Color.white)
//                    .frame(height:100, alignment:.center)
                Spacer()
                Text("$" + String(format: "%.2f", MONEY.CashBalance) + " available to buy " + tickerName)
                HStack{
                    EmptyView()
                    Spacer()
                    Button(action: {
                        price = String(pricecal(cp: currentPrice!, numShare: Double(numShare) ?? 0))
                        
                        if Double(MONEY.CashBalance) < Double(price)!{
                            self.notEnoughMoney = true
                        }
                        else if numShare.isEmpty {
                            self.validAmount = true
                        }
                        else {
                            buyShares(latestPrice: latestPrice, numShares: Double(numShare)!, tickerName: tickerName, companyName: CompanyName!)
                            //                                    self.tradeSheetView = false
                            firstTimeBought = true
                            firstTimeBought = false
                            firstTimeBought = true
                            
                            self.successBuy.toggle()
                        }
                        
                        print("Buy button pressed")
                    }, label: {
                        Text("Buy")
                            .padding(EdgeInsets(top: 10, leading: 35, bottom: 10, trailing: 35))
                            .font(.system(size:15))
                            .foregroundColor(.white)
                            .background(.green)
                        
                    })
                    .buttonStyle(BorderlessButtonStyle())
                    .frame(width: 160, height: 40)
                    .background(.green)
                    .cornerRadius(25)
                    .sheet(isPresented: self.$successBuy){
                        SuccessSheetView(successSheet: self.$successBuy, tradeSheet: self.$tradeSheetView, ticker: tickerName, numShares: Int(numShare)!, buyOrSell: true)
                        //                            tradeSheet: self.$tradeSheetView,
                    }
                    
                    
                    Spacer()
                    
                    Button(action: {
                        
                        var sd: StockDetails = getPortfolio(tickerName: tickerName)
                        if numShare.isEmpty {
                            self.validAmount = true
                        }
                        else if sd.sharesOwned == 0 || sd.sharesOwned! < Int(numShare)!{
                            self.notEnoughShares = true
                        }
                        else {
                            sellShares(tickerName: tickerName, numShares: Double(numShare)!, currentPrice: latestPrice.c!)
                            firstTimeBought = true
                            firstTimeBought = false
                            firstTimeBought = true
                            
                            if !isPortArray(tickerName: tickerName){
                                firstTimeBought = false
                            }
                            self.successSell.toggle()
                            //                                    self.tradeSheetView = false
                        }
                        
                        print("Sell button pressed")
                    }, label: {
                        Text("Sell")
                            .padding(EdgeInsets(top: 10, leading: 35, bottom: 10, trailing: 35))
                            .font(.system(size:15))
                            .foregroundColor(.white)
                            .background(.green)
                        
                    })
                    .buttonStyle(BorderlessButtonStyle())
                    .frame(width: 160, height: 40)
                    .background(.green)
                    .cornerRadius(25)
                    .sheet(isPresented: self.$successSell){
                        SuccessSheetView(successSheet: self.$successSell, tradeSheet: self.$tradeSheetView, ticker: tickerName, numShares: Int(numShare)!, buyOrSell: false)
                    }
                    Spacer()
                }
                .toast(isShowing: $notEnoughMoney, text: Text("Not enough money to buy"))
                .toast(isShowing: $notEnoughShares, text: Text("Not enough to sell"))
                .toast(isShowing: $validAmount, text: Text("Please enter a valid amount"))
                
            }
//            .background(.blue)
            .frame(height:100)
//            .background(.red)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            
            //                .padding(.bottom, keyboardHeight)
            
            //.offset(y:100)
        }
        
        
        .navigationBarItems(trailing: Button(action: {
            print("Dismissing sheet view...")
            self.tradeSheetView = false
        }, label: {
            Image(systemName: "xmark")
        }))
    }
}


// Sell

// cash increase : Money Balance  +  price
// net-worth update: Money Balance + check the portfolio array and calculate total number of shares owned * avg.cost/per share for that particular company and update the networth

// 4 shares : 200 avgcost = 50
// 2 share sell : 150 avg = 75
// profit = 25
// what will be my avg cost/share =
