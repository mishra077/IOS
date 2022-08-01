//
//  DetailsPage.swift
//  StockSearch2
//
//  Created by Manish on 4/19/22.
//

import Foundation
import SwiftUI
import Kingfisher
import WebKit


// Second Main page for company details

// Content: Company's Title
//          Company's Name
//          Company's Logo
//          Price of the stock with change percent
//          Company's Historical Data "USE HIGHCHARTS"
//          Company's Houlry Price Variation Chart "USE HIGHCHARTS"
//          Both the high charts will be in the same level use button to switch between different charts
//          Portfolio Section
//                  * One View if we don't have any stocks for that company
//                  * One View to display following details if we own some shares
//                      # Shares owned
//                      # Avg. Cost / Share
//                      # Total Cost
//                      # Change in price
//                      # Market Value

//          Stats of the Company Section
//              * High Price, Low Price, Open Price, Previous Close Price

//          About Section (Info abou the company)
//              * IPO Start Date
//              * Industry
//              * Webpage
//              * Company Peers
//          Insights
//          News


func calTimeIneterval(UnixTimeStamp: Int)->String {
    let todayDate = Date()
    let timeStampDate = Date(timeIntervalSince1970: Double(UnixTimeStamp))
    
    let diffComponents = Calendar.current.dateComponents([.day, .hour, .minute], from: timeStampDate, to: todayDate)

    let days: Int = diffComponents.day!
    let hours: Int = diffComponents.hour!
    let mins: Int = diffComponents.minute!
    
    if days == 0 {
        return "\(hours)" + " hr " + "\(mins)" + " min"
    }
    else {
        return "\(days)" + " day " + "\(hours)" + " hr " + "\(mins)" + " min "
    }
}

func datefordailycharts(_ UnixTimeStamp: Int) -> String {
    let timeStamp = Date(timeIntervalSince1970: Double(UnixTimeStamp))
    
    let component = Calendar.current.dateComponents([.day, .hour, .minute], from: timeStamp)
    
//    let days: Int = component.day!
    let hours: Int = component.hour!
    let mins: Int = component.minute!
    
    return "\(hours):\(mins)"
}


struct DetailsView: View{
    //    let path = Bundle.main.path(forResource: "index", ofType: "html")
    //    let htmlString = returnHTMLpath()
    var tickerName: String // Company's tickerName
    @StateObject var headerViewModel = HeaderViewModel()
    @StateObject var latestPriceModel = LatestPriceModel()
    @StateObject var peersViewModel = PeersModel()
    @StateObject var senViewModel = sentimentsViewMode()
    @StateObject var newsModel = newsViewModel()
    @StateObject var hisChartsModel = HistoricalChatsViewModel()
    @StateObject var RecommendationsModel = RecommendationModel()
    @StateObject var EPSModel = CompanyEarningsModel()
    //    @StateObject var dailyChartsModel = HourlyDataModel()
    //    @State private var isHeaderLoading = true
    //    @State private var isLatestPriceLoading = true
    @State var tradeSheetView: Bool = false
    @State var CongSheetView: Bool = false
    @State var newsSheets: Bool = false
    @State var newsSheets2: Bool = false
    @State var tempNews: newsInfo = newsInfo()
    @State var firstTimeBought: Bool = false
    @State var inFavorites: Bool = false
    @State var inFavToast: Bool = false
    @State var notinFavToast: Bool = false
//    @State var notinFavorites: Bool = true
//    @Published var firstTimeBought: Bool = false
    
    
    
    //    @State var successBuy: Bool = false
    //    @State var successSell: Bool = false
    
    //    let tickerName: String = "" // Company Name
    //    senViewModel.sentimentsResponse.Reddit.isEmpty || senViewModel.totalMentions.isEmpty
    
    var body: some View {
        //        WebView(htmlFileName: "index")
        //Ttitle => will be handle by navigation view's title
        if headerViewModel.CompanyInfoResponse.name == nil || latestPriceModel.LatestPriceInfoResponse.c == nil || peersViewModel.peersResponse.isEmpty || senViewModel.isSenLoading || newsModel.isNewsLoading || hisChartsModel.isHisCharts || RecommendationsModel.isRecommendLoading || EPSModel.isEarnLoading || latestPriceModel.isHourlyLoading{
            ProgressView(){
                //                || hisChartsModel.isHisCharts
                Text("Fetching Data...")
                    .foregroundColor(.gray)
                    .font(.system(size:15))
                    .opacity(0.5)
            }
            .onAppear(){
                var sd = getPortfolio(tickerName: tickerName)
                if sd.sharesOwned ?? 0>0{
                    firstTimeBought = true
                }
                if sd.inFavorites! {
                    inFavorites = true
//                    notinFavorites = false
                }
                async {
                    await headerViewModel.fetchCompanysInfo(tickerName: tickerName)
                    await latestPriceModel.fetchLatestPrice(tickerName: tickerName)
                    await peersViewModel.fetchPeers(tickerName: tickerName)
                    await senViewModel.fetchSentiments(tickerName: tickerName)
                    await newsModel.fetchNews(tickerName: tickerName)
                    await hisChartsModel.fetchHis(tickerName: tickerName)
                    await RecommendationsModel.fetchRecommendations(tickerName: tickerName)
                    await EPSModel.fetchEarnings(tickerName: tickerName)
                    //                        await dailyChartsModel.fetchHourly(tickerName: tickerName, fromDate: <#T##Int#>)
                }
            }
        }
        else{
            
            //            WebView(request: URLRequest(url: htmlString), hisData: $hisChartsModel.HisData, tickerName: tickerName)
            //            WebView(HTMLfileName: "index", hisData: $hisChartsModel.HisData, tickerName: tickerName)
            //            WebView(hisData: $hisChartsModel.HisData, tickerName: tickerName)
            //                .frame(minWidth: 350, maxWidth: .infinity, minHeight: 350, maxHeight: .infinity)
            //            WebView()
            //            ESPChartView()
            
            ScrollView {
                VStack{
                    Group{
                        VStack{
                            HStack{
                                Text(headerViewModel.CompanyInfoResponse.name!)
                                    .foregroundColor(Color(red: 0.36, green: 0.36, blue: 0.35))
                                    .font(.system(size: 15))
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))

                                Spacer()
                                AsyncImage(url: URL(string: headerViewModel.CompanyInfoResponse.logo!)) {
                                    image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .aspectRatio(contentMode: .fill)
                                        .clipped()
                                        .cornerRadius(10)
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 50, height: 50)
                                
//                                .resizable()
//                                .scaledToFill()
////                                .frame(width: 100, height: 100)
//                                .aspectRatio(contentMode: .fill)
//                                .clipped()
//                                .cornerRadius(10)
                                
                            }
                            
                            .frame(width:400, height: 60)
                            //                    .frame(width:370, height: 60)
                            // Current Price, Change Price, Change Percentage
                            HStack(){
                                Text("$" + String(format:"%.2f",latestPriceModel.LatestPriceInfoResponse.c ?? 0.00))
                                    .font(.system(size:35, weight: .bold))
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                if latestPriceModel.LatestPriceInfoResponse.d! < 0.00{
                                    Image(systemName: "arrow.down.right").foregroundColor(.red)
                                }
                                else{
                                    Image(systemName:"arrow.up.right").foregroundColor(.green)
                                }
//                                Image(latestPriceModel.LatestPriceInfoResponse.d ?? 0.00 < 0.00 ? (systemName: "arrow.up.right") : (systemName: "arrow.up.right"))
                                Text(String(format: "%.2f", latestPriceModel.LatestPriceInfoResponse.d ?? 0.00))
                                    .foregroundColor(latestPriceModel.LatestPriceInfoResponse.d ?? 0.00 < 0.00 ? .red : .green)
                                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                                    .font(.system(size:20))
                                Text("(" + String(format: "%.2f", latestPriceModel.LatestPriceInfoResponse.dp ?? 0.00) + "%)")
                                    .foregroundColor(latestPriceModel.LatestPriceInfoResponse.dp ?? 0.00 < 0.00 ? .red : .green)
                                    .font(.system(size:20))
                                
                                Spacer()
                            }
                            .frame(width: 400, height: 60)
                            
                            TabView{
                                DailyChartsView(data: $latestPriceModel.hourlyResponse, posChange: latestPriceModel.LatestPriceInfoResponse.d! > 0.0 ? true : false, tickerName: self.tickerName)
                                    //.frame(width:420, height: 360)
                                    .tabItem{
                                        Label("Hourly", systemImage: "chart.xyaxis.line")
                                    }
//                                WebView()
//                                    .tabItem{
//                                        Label("Historical", systemImage:"clock.fill")
//                                    }
                                WebView(hisData: $hisChartsModel.HisData, tickerName: tickerName)
                                    .frame(minWidth: 350, maxWidth: .infinity, minHeight: 350, maxHeight: .infinity)
                                    .tabItem {
                                        Label("Historical", systemImage: "clock.fill")
                                    }
                                
                            }
                            .frame(width:400, height: 410)
                            
                            
                            // HighCharts
                            
                            
                            
                            
                            // ########################### PORTFOLIO ##############################
                            Text("Portfolio")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 0))
                                .foregroundColor(.black)
                                .font(.system(size:23))
                            HStack{
                                // if sharesOwned == 0:
                                if !firstTimeBought || !isPortArray(tickerName: tickerName) {
                                    VStack(alignment: .leading){
                                        Text("You have 0 shares of " + tickerName)
                                            .font(.system(size:15))
                                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                        Text("Start Trading!")
                                            .font(.system(size:15))
                                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                    }
                                    
                                    //                                Spacer()
                                }
                                else {
                                    // if tickerName is in the Port Array then it means that in ticker's stock details sharesOwned is > 0
                                    let sd = getPortfolio(tickerName: tickerName)
                                    let avgCostperShare = sd.totalCost!/Double(sd.sharesOwned!)
                                    VStack(alignment: .leading, spacing: 3){
                                        Text("**Shares Owned:**  ")
                                            .font(.system(size: 15)) + Text(String(sd.sharesOwned!)).font(.system(size: 15))
                                        Text("**Avg. Cost/ Share:**  $").font(.system(size: 15))
                                             + Text(String(format:"%.2f", avgCostperShare)).font(.system(size: 15))
                                        Text("**Total Cost:**  $").font(.system(size: 15)) + Text(String(format:"%.2f", sd.totalCost!)).font(.system(size: 15))
                                        if(sd.change == 0.00){
                                            Text("**Change:**  $").font(.system(size: 15))
                                                 + Text(String(format:"%.2f", sd.change!)).font(.system(size: 15))
                                                .foregroundColor(.gray)
                                            Text("**Market Value:**  $").font(.system(size: 15)) + Text(String(format:"%.2f", sd.marketValue!)).font(.system(size: 15))
                                                .foregroundColor(.gray)
                                        }
                                        else{
                                            Text("**Change:**  $").font(.system(size: 15)) + Text(String(format:"%.2f", sd.change!)).font(.system(size: 15))
                                                .foregroundColor(sd.change! < 0.00 ? .red : .green)
                                            Text("**Market Value:**  $").font(.system(size: 15)) + Text(String(format:"%.2f", sd.marketValue!)).font(.system(size: 15))
                                                .foregroundColor(sd.change! < 0.00 ? .red : .green)
                                        }
                                        
                                    }
                                    .padding()
//                                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                }
                                Spacer()
                                Button(action:{
                                    print("Button Tapped")
                                    self.tradeSheetView.toggle()
                                } ,label: {
                                    Text("Trade")
                                        .padding(EdgeInsets(top: 10, leading: 35, bottom: 10, trailing: 35))
                                        .font(.system(size:18))
                                        .frame(width:170, height:50)
                                        .background(.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(30)
                                })
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
                                .buttonStyle(BorderlessButtonStyle())
                                .sheet(isPresented: $tradeSheetView){
                                    TradeSellSheetView(tradeSheetView: self.$tradeSheetView, tickerName: self.tickerName, currentPrice: $latestPriceModel.LatestPriceInfoResponse.c, CompanyName: $headerViewModel.CompanyInfoResponse.name, latestPrice: $latestPriceModel.LatestPriceInfoResponse, firstTimeBought: self.$firstTimeBought)
                                }
                                
                                
                            }
                        
                            // ########################### STATS ##############################
                            Text("Stats")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 0))
                                .foregroundColor(.black)
                                .font(.system(size:23))
                            
                            HStack(spacing: 7){
                                VStack(alignment: .leading, spacing: 5){
                                    HStack{
                                        Text("**High Price:**  ")
                                            .font(.system(size: 15))
                                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                        Text(String(format:"%.2f", latestPriceModel.LatestPriceInfoResponse.h!)).font(.system(size: 15))
                                            .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0))
                                        Spacer()
                                    }
                                    HStack{
                                        Text("**Low Price:**  ")
                                            .font(.system(size: 15))
                                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                        Text(String(format:"%.2f", latestPriceModel.LatestPriceInfoResponse.l!))
                                            .font(.system(size: 15))
                                            .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0))
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 5){
                                    
                                    HStack{
                                        
                                        Text("**Open Price:**  ")
                                            .font(.system(size: 15))
                                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                        
                                        Text(String(format:"%.2f",latestPriceModel.LatestPriceInfoResponse.o!))
                                            .font(.system(size: 15))
                                            .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0))
                                        Spacer()
                                        
                                    }
                                    
                                    HStack{
                                        
                                        Text("**Prev. Close:**  ")
                                            .font(.system(size: 15))
                                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                        
                                        Text(String(format:"%.2f", latestPriceModel.LatestPriceInfoResponse.pc!))
                                            .font(.system(size: 15))
                                            .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0))
                                        
                                        Spacer()
                                        
                                    }
                                }
//                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                Spacer()
                            }
                            // ########################### ABOUT ##############################
                            Text("About")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 0))
                                .foregroundColor(.black)
                                .font(.system(size:23))
                            
                            
                            HStack (spacing: 5){
                                // Keys
                                VStack(alignment: .leading, spacing: 4){
                                    Text("**IPO Start Date:**").font(.system(size: 15))
                                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                    //                                + Text(String(headerViewModel.CompanyInfoResponse.ipo!)).font(.system(size: 15))
                                    Text("**Industry:**").font(.system(size: 15))
                                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                    Text("**WebPage:**").font(.system(size: 15))
                                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                    Text("**CompanyPeers:**").font(.system(size: 15))
                                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                }
                                Spacer()
                                // Value
                                VStack(alignment: .leading, spacing: 4){
                                    Text(String(headerViewModel.CompanyInfoResponse.ipo!)).font(.system(size: 15))
                                    Text(String(headerViewModel.CompanyInfoResponse.finnhubIndustry!)).font(.system(size: 15))
                                    Link(String(headerViewModel.CompanyInfoResponse.weburl!), destination: URL(string: headerViewModel.CompanyInfoResponse.weburl!)!)
                                        .foregroundColor(.blue)
                                        .font(.system(size: 15))
                                        .buttonStyle(BorderlessButtonStyle())
                                    
                                    // Company Peers
                                    ScrollView(.horizontal){
                                        HStack{
                                            ForEach(0..<peersViewModel.peersResponse.endIndex){ idx in
                                                if idx == peersViewModel.peersResponse.endIndex - 1 {
                                                    NavigationLink(destination: DetailsView(tickerName: peersViewModel.peersResponse[idx])){
                                                        Text(peersViewModel.peersResponse[idx])
                                                            .foregroundColor(.blue)
                                                            .font(.system(size: 15))
                                                    }
                                                }
                                                else {
                                                    NavigationLink(destination: DetailsView(tickerName: peersViewModel.peersResponse[idx])){
                                                        Text(peersViewModel.peersResponse[idx] + ", ")
                                                            .foregroundColor(.blue)
                                                            .font(.system(size: 15))
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                    
                    Group{
                        // INSIGHTS
                        Text("Insights")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 0))
                            .foregroundColor(.black)
                            .font(.system(size:23))
                        
                        Text("Social Sentiments")
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                            .foregroundColor(.black)
                            .font(.system(size:23))
                        
                        // ######################### TABLE VIEW #############################
                        HStack{
                            // TITLE ROW
                            
                            VStack {
                                
                                Divider()
                                
                                Text(String(headerViewModel.CompanyInfoResponse.name!))
                                    .bold()
                                    .font(.system(size:18))
                                    .frame(width : 100, height : 50)
                                
                                Divider()
                                
                                Text("Total Mentions")
                                    .bold()
                                    .font(.system(size:15))
                                    .frame(width : 100, height : 50)
                                
                                Divider()
                                
                                Text("Positive Mentions")
                                    .bold()
                                    .font(.system(size:15))
                                    .frame(width : 100, height : 50)
                                
                                Divider()
                                
                                Text("Negative Mentions")
                                    .bold()
                                    .font(.system(size:15))
                                    .frame(width : 100, height : 50)
                                
                                Divider()
                                
                            }
                            .padding()
                            
                            Spacer()
                            
                            VStack {
                                Divider()
                                
                                Text("Reddit")
                                    .bold()
                                    .font(.system(size:15))
                                    .frame(width : 100, height : 50)
                                
                                Divider()
                                
                                Text(String(senViewModel.totalMentions[0])) // REDDIT TOTAL MENTIONS
                                    .font(.system(size:15))
                                    .frame(width : 100, height : 50)
                                
                                Divider()
                                
                                Text(String(senViewModel.positiveMentions[0])) // REDDIT POSITIVE MENTIONS
                                    .font(.system(size:15))
                                    .frame(width : 100, height : 50)
                                
                                Divider()
                                
                                Text(String(senViewModel.negativeMentions[0])) // REDDIT NEGATIVE MENTIONS
                                    .font(.system(size:15))
                                    .frame(width : 100, height : 50)
                                
                                Divider()
                                
                            }
                            .padding()
                            
                            Spacer()
                            
                            VStack {
                                
                                Divider()
                                
                                Text("Twitter")
                                    .bold()
                                    .font(.system(size:15))
                                    .frame(width : 100, height : 50)
                                
                                Divider()
                                
                                Text(String(senViewModel.totalMentions[1])) // TWITTER TOTAL MENTIONS
                                    .font(.system(size:15))
                                    .frame(width : 100, height : 50)
                                
                                Divider()
                                
                                Text(String(senViewModel.positiveMentions[1])) // TWITTER POSITIVE MENTIONS
                                    .font(.system(size:15))
                                    .frame(width : 100, height : 50)
                                
                                Divider()
                                
                                Text(String(senViewModel.negativeMentions[1])) // TWITTER NEGATIVE MENTIONS
                                    .font(.system(size:15))
                                    .frame(width : 100, height : 50)
                                
                                Divider()
                            }
                            .padding()
                        }
                        RecommendaChartView(StrongBuyList: $RecommendationsModel.StrongBuyList, StronSelllList: $RecommendationsModel.StrongSell, SelllList: $RecommendationsModel.SellList, HoldList: $RecommendationsModel.HoldList, timeStamp: $RecommendationsModel.timeStamp, BuyList: $RecommendationsModel.BuyList)
                            .frame(width:420, height: 500)
//                            .offset(x: -40, y: 10)
                        
                        EPSChartView(XaxisData: $EPSModel.XAxis, ActualData: $EPSModel.ActualList, EstimateData: $EPSModel.EstimateList)
                            .frame(width:420, height: 500)
//                            .offset(x: -40, y: 10)
                        
                    }
                    Text("NEWS")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 0))
                        .foregroundColor(.black)
                        .font(.system(size:23))
                    
                    KFImage(URL(string: newsModel.newsResponse[0].image))
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 380, maxHeight: 200)
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .cornerRadius(20)
                    
                    Group{
                        // ################# NEWS #################
                        VStack (alignment: .leading){
                            
                            HStack{
                                Text(String(newsModel.newsResponse[0].source))
                                    .font(.system(size:12))
                                    .bold()
                                    .opacity(0.6)
                                    .foregroundColor(.gray)
                                //                        Text(newsTimeConversion(timeStamp: newsModel.newsResponse[0].datetime))
                                Text(String(calTimeIneterval(UnixTimeStamp: newsModel.newsResponse[0].datetime)))
                                    .font(.system(size:12))
                                    .opacity(0.6)
                                    .foregroundColor(.gray)
                                //                        Text(String(newsModel.newsResponse[0].datetime))
                                Spacer()
                            }
                            
                            Text(String(newsModel.newsResponse[0].headline))
                                .bold()
                                .font(.system(size:17))
                        }
                        .padding()
                        .onTapGesture{
                            self.tempNews = newsModel.newsResponse[0]
                            self.newsSheets.toggle()
                            
                        }
                        .sheet(isPresented: $newsSheets){
                            NewsSheetView(newsSheets: $newsSheets, newsModel: $tempNews)
                        }
                        .listRowSeparator(.hidden)
                        
                        
                        Divider()
                        
                        ForEach(1..<newsModel.newsResponse.endIndex, id: \.self) { idx  in
                            VStack{
                                HStack{
                                    VStack(alignment:.leading){
                                        HStack(spacing:5){
                                            Text(String(newsModel.newsResponse[idx].source))
                                                .font(.system(size:12))
                                                .bold()
                                                .opacity(0.6)
                                                .foregroundColor(.gray)
                                            
                                            Text(String(calTimeIneterval(UnixTimeStamp: newsModel.newsResponse[idx].datetime)))
                                                .font(.system(size:12))
                                                .opacity(0.6)
                                                .foregroundColor(.gray)
                                            Spacer()
                                        }
                                        
                                        Text(String(newsModel.newsResponse[idx].headline))
                                            .bold()
                                            .font(.system(size:15))
                                    }
                                    Spacer(minLength: 10)
                                    KFImage(URL(string: newsModel.newsResponse[idx].image))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .aspectRatio(contentMode: .fill)
                                        .clipped()
                                        .cornerRadius(10)
//                                        .aspectRatio(contentMode: .fit)
                                    
//                                        .resizable()
                                        
//                                        .frame(maxWidth: 380, maxHeight: 200)
//
//
//                                        .cornerRadius(20)
                                    
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                .onTapGesture{
                                    print(idx)
                                    
                                    print(newsModel.newsResponse[idx].headline)
                                    self.tempNews = newsModel.newsResponse[idx]
                                    self.newsSheets2.toggle()
                                }
                                
                                
                            }
                            .padding()
                            .listRowSeparator(.hidden)
                            
                            
                        }
                        .sheet(isPresented: $newsSheets2){
                            NewsSheetView(newsSheets: $newsSheets2, newsModel: $tempNews)
                            //                    NewsSheetView(newsSheets: $newsSheets2, newModelHeadline: $newsModel.newsResponse[$0].headline, newsModelDate: $newsModel.newsResponse[$0].datetime, newsModelSource: $newsModel.newsResponse[$0].source, newsModelSummary: $newsModel.newsResponse[$0].summary, newsModelurl: $newsModel.newsResponse[$0].url)
                        }
                        
                    }
                    
                    
                }
                .navigationTitle(tickerName)
                .toolbar{
                    ToolbarItem(placement: .primaryAction){
                        Button(action: {
                            if !inFavorites{
                                inFavorites.toggle()
//                                notinFavorites.toggle()
                                inFavToast.toggle()
                                inFavArray(tickerName: tickerName)
                                print("Added to fav array local storage")
                                if UserDefaults.standard.object(forKey: tickerName) == nil{
                                    createStockDetails(tickerName: tickerName, name: headerViewModel.CompanyInfoResponse.name!, latestPrice: latestPriceModel, port: false, fav: true)
                                }
                                print("Stock details local storage updated")
                                print("Favorites button tapped")
                            }
                            else{
                                deleteFav(tickerName: tickerName)
                                inFavorites.toggle()
                                notinFavToast.toggle()
                            }
                        }, label: {
                            if !inFavorites{
                                Image(systemName: "plus.circle")
                            }
                            else{
                                Image(systemName: "plus.circle.fill")
                            }
                            
                        })
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
                
                //            .listSeparatorStyle(style: .none)
                .background(.white)
                
                
                // INSIGHTS
                
                
                
                
                
            }
            .toast(isShowing: $inFavToast, text: Text("Adding \(tickerName) to Favorites"))
            .toast(isShowing: $notinFavToast, text: Text("Removiing \(tickerName) from Favorites"))
            // ########################### HEADER VIEW ##############################
            
            
            
            
            
            
            
            
            
        }
        
    }
}


struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
//        DetailsView(tickerName: .constant(""))
        DetailsView(tickerName: "")
    }
}

extension Date {

    static func -(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }

}
extension Binding where Value == Bool {
    func negate() -> Bool {
        return !(self.wrappedValue)
    }
}



// TO COMPLETE

// TABLE VIEW FOR INSIGHTS
// COMPLETE HIGHCHARTS - HIGHER PRIORITY
// ADD THE ARROW SYMBOLS
// FAVORITES ADD AND REMOVE BUTTON -> ADD IF CONDITION TO CHAGE THE SF SYMBOL PLUS.CIRCLE.FILL TO PLUS.CIRCLE
// NEWS API CALL
// POPULATE THE NEWS INTO DETAILS PAGE
// ADD THE SHEET FOR NEWS -> PASS THE NEWWS SOURCE, DESCRIPTION, TWITTER AND FACEBOOK SYMBOL WITH DATE
