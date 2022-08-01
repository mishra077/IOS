//
//  ContentView.swift
//  StockSearch2
//
//  Created by Manish on 4/17/22.
//

import SwiftUI

//struct localStorage: Codable {
//    let tickerName: StockDetails?
//    init(
//        name: StockDetails? = StockDetails()){
//            self.tickerName = name
//        }
//}

struct favArray: Codable {
    var favroites: [String]?
    init(
        fav:[String]?=[]){
            self.favroites = fav
        }
}

struct PortArray: Codable {
    var portfolioArray: [String]?
    
    init(
        port: [String]? = []){
            self.portfolioArray = port
        }
}

struct StockDetails: Codable {
    var companyName: String?
//    let tickerName: String?
    var currentPrice: Double?
    var closePrice: Double?
    var changePrice: Double?
    var percentageChange: Double?
    // PortFolio
    var sharesOwned: Int?
    var totalCost: Double?
    var marketValue: Double?
    var change: Double?
    var avgCost: Double?
    
    var inPortfloio: Bool?
    var inFavorites: Bool?
    
    init(
        name: String? = "",
//        tickerName: String? = "",
        cp: Double? = 0.00,
        close: Double? = 0.00,
        changep: Double? = 0.00,
        pc: Double? = 0.00,
        shares: Int? = 0,
        tc: Double? = 0.00,
        mV: Double? = 0.00,
        c: Double? = 0.00,
        avgcost: Double? = 0.00,
        inP: Bool? = false,
        inF: Bool? = false){
            self.companyName = name
//            self.tickerName = tickerName
            self.currentPrice = cp
            self.closePrice = close
            self.changePrice = changep
            self.percentageChange = pc
            self.sharesOwned = shares
            self.totalCost = tc
            self.marketValue = mV
            self.change = c
            self.avgCost = avgcost
            self.inPortfloio = inP
            self.inFavorites = inF
        }
}

struct Money: Codable {
    var CashBalance: Double
    var NetWorth: Double
    
    init(
        cb: Double = 25000.00,
        nw: Double = 25000.00
    ){
        self.CashBalance = cb
        self.NetWorth = nw
    }
}

func moneyExists()->Bool{
    if UserDefaults.standard.object(forKey: "MoneyDetails") == nil{
        print("Money Doesn't Exist... Loading into the storage")
        return false
    }
    else {
        return true
    }
    
}

func insertMoney(){
    if !moneyExists(){
        let money = Money()
        
        do {
            let enc = JSONEncoder()
            let data = try enc.encode(money)
            
            // Seting inside localStorage
            
            UserDefaults.standard.set(data, forKey: "MoneyDetails")
        }
        catch{
            print("Unable to encode ERROR !!!")
        }
    }
}

func getMoney()->Money{
    if !moneyExists() {
        return Money()
    }
    else {
        let data = UserDefaults.standard.data(forKey: "MoneyDetails")!
        
        do{
            let dec = JSONDecoder()
            let money = try dec.decode(Money.self, from: data)
            return money
        }
        catch{
            print("Money Exist but still not able to decode")
            return Money()
        }
    }
}

func createFavoriteCards()->[FavCard]{
    var FavoriteCardsList: [FavCard] = []
    var favoritesArray: favArray = favArray()
    if UserDefaults.standard.object(forKey: "FavoritesArray") == nil {
        return []
    }
    else{
        if let data = UserDefaults.standard.data(forKey: "FavoritesArray"){
            do {
                let dec = JSONDecoder()
                favoritesArray = try dec.decode(favArray.self, from: data)
            }
            catch {
                print("ERROR IN CREATE FAVORITE CARDS")
            }
        }
    }
    
    // Remeber when we delete from favorites delete from fav array as well
    // inFavorites = false and search for the tickername and delete from the favArray
    
    // if inFavorites and inPortfolio both are false then delete the stockdetails struct from the Local Storage
    
    for i in 0...favoritesArray.favroites!.count - 1{
        var favCard = FavCard()

        let tickerName = favoritesArray.favroites![i]

        var stockDetails = StockDetails()

        if UserDefaults.standard.object(forKey: tickerName) == nil{
            continue
        }
        else {
            if let data = UserDefaults.standard.data(forKey: tickerName){
                do {
                    let dec = JSONDecoder()
                    stockDetails = try dec.decode(StockDetails.self, from: data)
                }
                catch {
                    print("ERROR FROM CREATE FAV CARDS IN FOR LOOP")
                }
            }
        }

        if !stockDetails.inFavorites!{
            continue
        }
        else {
            favCard.ticker = tickerName
            print(stockDetails.companyName!)
            favCard.companyN = stockDetails.companyName!
            favCard.currentPrice = stockDetails.currentPrice! // current price
            favCard.changePrice = stockDetails.changePrice!
            favCard.changePercent = stockDetails.percentageChange!

            FavoriteCardsList.append(favCard)
        }

    }
    print("HELLO FROM CREATE FAV CARDS")
    return FavoriteCardsList
}

func createPortCard()->[PortCard] {
    var portCardList: [PortCard] = []
    var portArray: PortArray = PortArray()
    
    if UserDefaults.standard.object(forKey: "PortfolioArray") == nil {
        return []
    }
    else{
        if let data = UserDefaults.standard.data(forKey: "PortfolioArray"){
            do {
                let dec = JSONDecoder()
                portArray = try dec.decode(PortArray.self, from: data)
            }
            catch {
                print("ERROR IN DECODING PORT CARDS")
            }
        }
    }
    
    for i in 0...portArray.portfolioArray!.count - 1{
        
        var portCard = PortCard()

        let tickerName = portArray.portfolioArray![i]

        var sd = StockDetails()
        
        if UserDefaults.standard.object(forKey: tickerName) == nil{
            continue
        }
        else {
            if let data = UserDefaults.standard.data(forKey: tickerName){
                do {
                    let dec = JSONDecoder()
                    sd = try dec.decode(StockDetails.self, from: data)
                }
                catch {
                    print("ERROR FROM CREATE PORT CARDS IN FOR LOOP")
                }
            }
        }
        
        if !sd.inPortfloio!{
            continue
        }
        else {
            portCard.ticker = tickerName
            portCard.numShares = sd.sharesOwned!
            portCard.avgCost = sd.avgCost!
            portCard.marketValue = Double(sd.sharesOwned!) * sd.currentPrice!
            portCard.changePrice = (sd.currentPrice! - sd.avgCost!) * Double(sd.sharesOwned!)
            portCard.changePercent = (portCard.changePrice / (sd.avgCost! * Double(sd.sharesOwned!))) * 100
            //portCard.closePrice = sd.closePrice! // market value = share owned * current price
            //portCard.changePrice = sd.changePrice! // (current price - avgcost)* num shares
            //portCard.changePercent = sd.percentageChange! //(change /(avg cost * shares owned)) * 100

            portCardList.append(portCard)
        }
    }
    
    print("HELLO FROM CREATE PORT CARDS")
    return portCardList
}


func currentDate()->String{
    let date = Date()
    let df = DateFormatter()
    df.dateFormat = "MMMM dd, yyyy"
    return df.string(from: date)
}

// Date Display
struct TimeForm: View{
    
    var body: some View{
        let dateString: String = currentDate()
        if dateString.isEmpty{
            Text("Error")
        }
        else {
            Text(dateString)
                .font(.system(size: 27, weight: .bold))
                .foregroundColor(Color(red:0.36, green:0.36, blue: 0.35))
            
        }
    }
}

// Portfolio Form

struct PortfolioForm: View{
    let timer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()
    @State private var MONEY: Money = getMoney()
    @State private var portCardList:[PortCard] = createPortCard()
    var body: some View {
        HStack(){
            VStack(alignment: .leading){
                Text("Net Worth")
                    .font(.system(size: 20))
                    .foregroundColor(Color(red:0.00, green: 0.00, blue: 0.00))
                Text("$" + String(format: "%.2f", MONEY.NetWorth))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(red:0.00, green: 0.00, blue: 0.00))
//                Text("$25000.00")
//                    .font(.system(size: 20, weight: .bold))
//                    .foregroundColor(Color(red:0.00, green: 0.00, blue: 0.00))
            }
            Spacer()
            VStack(alignment: .leading){
                Text("Cash Balance")
                    .font(.system(size: 20))
                    .foregroundColor(Color(red:0.00, green: 0.00, blue: 0.00))
                Text("$" + String(format: "%.2f", MONEY.CashBalance))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(red:0.00, green: 0.00, blue: 0.00))
//                Text("$25000.00")
//                    .font(.system(size: 20, weight: .bold))
//                    .foregroundColor(Color(red:0.00, green: 0.00, blue: 0.00))
            }
        }
        // If I bought any stocks the list of stocks will be shown here!!!
        ForEach(portCardList, id: \.self) { pCard in
            NavigationLink(destination: DetailsView(tickerName: pCard.ticker)){
                PortfolioCard(Card: pCard)
            }
        }
        .onMove {
            portCardList.move(fromOffsets: $0, toOffset: $1)
            var pArray: PortArray = PortArray()
            if let data = UserDefaults.standard.data(forKey: "PortfolioArray") {
                do {
                    let dec = JSONDecoder()
                    pArray = try dec.decode(PortArray.self, from: data)
                }
                catch {
                    print("NOT ABLE TO DECODE PORT ARRAY FROM THE LOCAL STORAGE")
                    print(error)
                }
            }
            pArray.portfolioArray?.move(fromOffsets: $0, toOffset: $1)
            do {
                let enc = JSONEncoder()
                let data = try enc.encode(pArray)
                
                UserDefaults.standard.set(data, forKey: "PortfolioArray")
            }
            catch {
                print("NOT ABLE TO SET FAV ARRAY INTO LOCAL STORAGE KILL ME!!!!")
                print(error)
            }
        }
        .onAppear{
            self.portCardList = createPortCard()
        }
        .onReceive(timer){ time in
            
//            self.portCardList = createPortCard()
            self.MONEY = getMoney()
            
            print("from port form\(time)")
            
            
        }
        
    }
    
}

// Favorites Card or WatchList Card

struct FavCard:Hashable {
    var id =  UUID()
    var ticker : String = "" // tickerName
    var companyN : String = "" // companyName
    var currentPrice : Double = 0.00 // currentPrice
    var changePrice: Double = 0.00 // changePrice
    var changePercent : Double = 0.00 // cp
}

struct PortCard:Hashable {
    var id =  UUID()
    var ticker : String = "" // tickerName
    var numShares : Int = 0 // No of shares Owned
    var marketValue: Double = 0.00 // Market Value
    var avgCost: Double = 0.00 // avgCost
    //var closePrice : Double = 0.00 // closePrice
    var changePrice: Double = 0.00 // changePrice
    var changePercent : Double = 0.00 // cp
}


struct FavoritesCard: View {
    let timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()
    @StateObject var latestPrice: LatestPriceModel = LatestPriceModel()
    var Card: FavCard
    var body : some View {
        if latestPrice.isLatestLoading {
            ProgressView()
                .frame(height:40)
                .onAppear{
                    async{
                        await latestPrice.fetchLatestPrice(tickerName: Card.ticker)
                    }
                    
                }
        }
        else{
            HStack{
                VStack{
                    //Ticker Name
                    Text(String(Card.ticker))
                        .font(.system(size:25, weight: .bold))
                    // Company Name
                    Text(String(Card.companyN))
                        .font(.system(size: 15, weight: .light))
                        .foregroundColor(Color(red:0.00, green: 0.00, blue: 0.00))
                        .opacity(0.5)
                }
                Spacer()
                VStack {
                    // Current Price
//                    Text("$" + String(format:"%.2f",Card.currentPrice))
//                        .font(.system(size:20, weight: .bold))
                    
                    Text("$" + String(format:"%.2f",latestPrice.LatestPriceInfoResponse.c!))
                        .font(.system(size:20, weight: .bold))
                    
                    // Change Percentage
                    HStack{
                        //Arrow Sign
//                        if Card.changePrice == 0.00 {
//                            Image(systemName: "minus")
//                                .foregroundColor(.gray)
//                            Text("$" + String(format: "%.2f", Card.changePrice))
//                                .foregroundColor(.gray)
//                            Text("(" + String(format: "%.2f", Card.changePercent) + "%)")
//                                .foregroundColor(.gray)
//                        }
//                        else{
//                            Image(systemName: Card.changePrice < 0.00 ? "arrow.down.right" : "arrow.up.right")
//                                .foregroundColor(Card.changePrice < 0.00 ? .red : .green)
//                            Text("$" + String(format: "%.2f", Card.changePrice))
//                                .foregroundColor(Card.changePrice < 0.00 ? .red : .green)
//                            // Chage Percent
//                            Text("(" + String(format: "%.2f", Card.changePercent) + "%)")
//                                .foregroundColor(Card.changePrice < 0.00 ? .red : .green)
//                        }
                        if latestPrice.LatestPriceInfoResponse.d! == 0.00 {
                            Image(systemName: "minus")
                                .foregroundColor(.gray)
                            Text("$" + String(format: "%.2f", latestPrice.LatestPriceInfoResponse.d!))
                                .foregroundColor(.gray)
                            Text("(" + String(format: "%.2f", latestPrice.LatestPriceInfoResponse.dp!) + "%)")
                                .foregroundColor(.gray)
                        }
                        else{
                            Image(systemName: latestPrice.LatestPriceInfoResponse.d! < 0.00 ? "arrow.down.right" : "arrow.up.right")
                                .foregroundColor(latestPrice.LatestPriceInfoResponse.d! < 0.00 ? .red : .green)
                            Text("$" + String(format: "%.2f", latestPrice.LatestPriceInfoResponse.d!))
                                .foregroundColor(latestPrice.LatestPriceInfoResponse.d! < 0.00 ? .red : .green)
                            // Chage Percent
                            Text("(" + String(format: "%.2f", latestPrice.LatestPriceInfoResponse.dp!) + "%)")
                                .foregroundColor(latestPrice.LatestPriceInfoResponse.d! < 0.00 ? .red : .green)
                        }
                    }
                    
                }
                
            }
            .onAppear{
                // update loacal storage with update latest price
                var sd = StockDetails()
                
                if let data = UserDefaults.standard.data(forKey: Card.ticker) {
                    do {
                        let dec = JSONDecoder()
                        sd = try dec.decode(StockDetails.self, from: data)
                    }
                    catch {
                        print("NOT ABLE TO DECODE PORT ARRAY FROM THE LOCAL STORAGE")
                        print(error)
                    }
                }
                sd.currentPrice = latestPrice.LatestPriceInfoResponse.c!
                sd.changePrice = latestPrice.LatestPriceInfoResponse.d!
                sd.percentageChange = latestPrice.LatestPriceInfoResponse.dp!
                
                do {
                    let enc = JSONEncoder()
                    let data = try enc.encode(sd)
                    
                    UserDefaults.standard.set(data, forKey: Card.ticker)
                }
                catch {
                    print("ISSUE WHILE ENCODING THE UPDATED STOCKDETAIL IN SELL SHARES FUNC")
                    print(error)
                }
                
            }
            .onReceive(timer){ time in
                latestPrice.isLatestLoading = true
            }
        }
        
    }
}
struct PortfolioCard: View {
    let timer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()
    @StateObject var latestPrice: LatestPriceModel = LatestPriceModel()
    var Card: PortCard
    var body : some View {
        
        if latestPrice.isLatestLoading {
            ProgressView()
                .frame(height:40)
                .onAppear{
                    async{
                        await latestPrice.fetchLatestPrice(tickerName: Card.ticker)
                    }
                }
        }
        else{
            HStack{
                VStack{
                    //Ticker Name
                    Text(String(Card.ticker))
                        .font(.system(size:25, weight: .bold))
                    // Number of Shares Owned
                    Text(String(Card.numShares) + String((Card.numShares > 1) ? " shares" : " share"))
                        .font(.system(size: 15, weight: .light))
                        .foregroundColor(Color(red:0.00, green: 0.00, blue: 0.00))
                        .opacity(0.5)
                }
                Spacer()
                VStack {
                    let marketValue: Double = latestPrice.LatestPriceInfoResponse.c! * Double(Card.numShares)
                    // Close Price
                    Text("$" + String(format:"%.2f", marketValue))
                        .font(.system(size:20, weight: .bold))
                    
                    // Change Percentage
                    HStack{
                        //Arrow Sign
                        let change: Double = (latestPrice.LatestPriceInfoResponse.c! - Card.avgCost) * Double(Card.numShares)
                        
                        let changeP: Double = (change / (Card.avgCost * Double(Card.numShares))) * 100.00
                        
                        // Change price
                        if (latestPrice.LatestPriceInfoResponse.c! - Card.avgCost)  == 0.00 {
                            
                            
                            Image(systemName: "minus")
                                .foregroundColor(.gray)
                            Text("$" + String(format: "%.2f", change))
                                .foregroundColor(.gray)
                            Text("(" + String(format: "%.2f", changeP) + "%)")
                                .foregroundColor(.gray)
                        }
                        else{
                            Image(systemName: change < 0.00 ? "arrow.down.right" : "arrow.up.right")
                                .foregroundColor(change < 0.00 ? .red : .green)
                                Text("$" + String(format: "%.2f", change))
                                .foregroundColor(change < 0.00 ? .red : .green)
                            // Chage Percent
                                Text("(" + String(format: "%.2f", changeP) + "%)")
                                .foregroundColor(change < 0.00 ? .red : .green)
                        }
                        
                    }
                    .onAppear{
                        var sd = StockDetails()
                        
                        if let data = UserDefaults.standard.data(forKey: Card.ticker) {
                            do {
                                let dec = JSONDecoder()
                                sd = try dec.decode(StockDetails.self, from: data)
                            }
                            catch {
                                print("NOT ABLE TO DECODE PORT ARRAY FROM THE LOCAL STORAGE")
                                print(error)
                            }
                        }
                        
                        sd.currentPrice = latestPrice.LatestPriceInfoResponse.c!
                        sd.changePrice = latestPrice.LatestPriceInfoResponse.d!
                        sd.percentageChange = latestPrice.LatestPriceInfoResponse.dp!
                        sd.marketValue = latestPrice.LatestPriceInfoResponse.c! * Double(Card.numShares)
                        sd.change = (latestPrice.LatestPriceInfoResponse.c! - Card.avgCost) * Double(Card.numShares)
                        
                        var MONEY: Money = getMoney()
                        
                        MONEY.NetWorth = MONEY.CashBalance + updateNetworth()
                        do {
                            let enc = JSONEncoder()
                            let data = try enc.encode(MONEY)
                            
                            // Seting inside localStorage
                            
                            UserDefaults.standard.set(data, forKey: "MoneyDetails")
                        }
                        catch{
                            print("Unable to encode ERROR !!!")
                        }
                        
                        
                        do {
                            let enc = JSONEncoder()
                            let data = try enc.encode(sd)
                            
                            UserDefaults.standard.set(data, forKey: Card.ticker)
                        }
                        catch {
                            print("ISSUE WHILE ENCODING THE UPDATED STOCKDETAIL IN SELL SHARES FUNC")
                            print(error)
                        }
                        
                        
                        
                    }
                    .onReceive(timer){ time in
                        latestPrice.isLatestLoading = true
                    }
                    
                }
                
            }
        }
        
        
    }
}

var tickerName:[String] = ["AAPL", "TSLA"]
var companyName:[String] = ["Apple Inc", "Tsla Inc"]
var closingPrice:[Double] = [174.59, 1088.57]
var changePrice:[Double] = [-0.13, 77.93]
var changePercent:[Double] = [-0.07, 7.71]
//var changePercent:[String] = ["$-0.13 (-0.07%)", "$77.93 (7.71%)"]








// Favorites Form or Watchlist
struct FavoritesForm: View{
    // Loading from the localStorage
    
//    @State private var favCardArray: favArray =
//    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var favCardList:[FavCard] = createFavoriteCards()
//    @State private var favCardList:[FavCard] = []
    var body: some View {
        
        
            ForEach(favCardList, id: \.self) { fCard in
                NavigationLink(destination: DetailsView(tickerName: fCard.ticker)){
                    FavoritesCard(Card: fCard)
                }
                
                
            }
            .onDelete {
                let index = $0[$0.startIndex]
                deleteFav(tickerName: favCardList[index].ticker)
                favCardList.remove(atOffsets: $0)
                print(index)
    //            print(favCardList[index].ticker)
    //            deleteFav(tickerName: favCardList[index].ticker)
                
            }
            .onMove {
                favCardList.move(fromOffsets: $0, toOffset: $1)
                let index = $0[$0.startIndex]
                let secIndex = $1
                
                
                var favoritesArray: favArray = favArray()
                if let data = UserDefaults.standard.data(forKey: "FavoritesArray") {
                    do {
                        let dec = JSONDecoder()
                        favoritesArray = try dec.decode(favArray.self, from: data)
                    }
                    catch {
                        print("NOT ABLE TO DECODE FAV ARRAY FROM THE LOCAL STORAGE PLS CHECK PLS")
                        print(error)
                    }
                }
                favoritesArray.favroites?.move(fromOffsets: $0, toOffset: $1)
                do {
                    let enc = JSONEncoder()
                    let data = try enc.encode(favoritesArray)
                    
                    UserDefaults.standard.set(data, forKey: "FavoritesArray")
                }
                catch {
                    print("NOT ABLE TO SET FAV ARRAY INTO LOCAL STORAGE KILL ME!!!!")
                    print(error)
                }
    //            names.swapAt(0, 1)
    //
    //            print(index)
    //            print(secIndex)
            }
            .onAppear{
                print("HELLO THERE")
                self.favCardList = createFavoriteCards()
            }
        
//        VStack{
//
//        }
//        .frame(height:0)
//        .onAppear{
//            print("HELLO THERE")
//            self.favCardList = createFavoriteCards()
//        }
//        EmptyView()
//            .onAppear{
//                print("HELLO THERE")
//                self.favCardList = createFavoriteCards()
//            }
        
        
        //.onReceive(timer){time in
//            var sd = StockDetails()
//            if let data = UserDefaults.standard.data(forKey: "TSLA") {
//                do {
//                    let dec = JSONDecoder()
//                    sd = try dec.decode(StockDetails.self, from: data)
//                }
//                catch {
//                    print("NOT ABLE TO DECODE PORT ARRAY FROM THE LOCAL STORAGE")
//                    print(error)
//                }
//            }
//            sd.closePrice = 600.00
//            do {
//                let enc = JSONEncoder()
//                let data = try enc.encode(sd)
//
//                UserDefaults.standard.set(data, forKey: "TSLA")
//            }
//            catch {
//                print("ISSUE WHILE ENCODING THE UPDATED STOCKDETAIL IN SELL SHARES FUNC")
//                print(error)
//            }
            
            //self.favCardList = createFavoriteCards()
            
           // print("from fav form\(time)")
            
            
        //}
    }
    
}
//https://www.appcoda.com/swiftui-searchable/

struct ContentView: View {
//    let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    @State private var counter = 0
    @State var searchText: String = ""
    @State var isLoading: Bool = false
    @StateObject var viewmodel = ViewModel()
    @StateObject var latestPriceModel = LatestPriceModel()
    
    var body: some View {
        
        if !isLoading {
            ProgressView(){
                Text("Fetching Data...")
                    .foregroundColor(.gray)
                    .font(.system(size:15))
                    .opacity(0.5)
            }
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5){
                        isLoading.toggle()
                    }
                }
        }
        else {
            
            NavigationView{
                List {
                    if !searchText.isEmpty {
                        ForEach(viewmodel.searchResults, id: \.self) { res in
                            
                            NavigationLink(destination: DetailsView(tickerName: res.displaySymbol)){
                                VStack(alignment: .leading){
                                    Text(res.description)
                                        .bold()
                                    Text(res.displaySymbol)
                                }
                                .padding(10)
                            }
                        }
                    }
                    else {
                        Section(){
                            // Date display
                            TimeForm().padding(10)
                        }
                        Section(header: Text("PORTFOLIO")
                            .font(.system(size:15, weight: .light))
                            .opacity(0.5)){
                                PortfolioForm().padding(10)
                        }
                        Section(header: Text("FAVORITES")
                            .font(.system(size:15, weight: .light))
                            .opacity(0.5)) {
                                FavoritesForm().padding(10)
                            }
                        
                        
                        HStack{
                            Spacer()
                            Text("Powered by")
    //                            .padding(.leading)
                                .foregroundColor(.gray)
                            Link("Finnhub.io", destination: URL(string: "https://finnhub.io")!)
    //                            .padding(.leading)
                                .foregroundColor(.blue)
                            Spacer()
                        }
                        
                    }
                    
                }.searchable(text: $searchText, placement: .automatic)
    //                .navigationViewStyle(StackNavigationViewStyle())
                    .toolbar {EditButton()}
                    .navigationTitle("Stocks")
    //
                    .onChange(of: searchText) { searchText in
                        
    //                    async {await viewmodel.fetch(queryString: searchText)}
                        print(searchText)
                        
                        async {
                            if !searchText.isEmpty && searchText.count > 1 {
                                await viewmodel.fetch(queryString: searchText)
                                
                            }
                            else {
                                viewmodel.searchResults = []
                            }
                        }
                        
                    }
                    
            }.onAppear(){
                insertMoney()
            }
        
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct TickerName {
    static var tickerName: String = ""
}


//func updatePrice(){
//    var tickerList: [String] = getAllTickers()
//
//
//}
