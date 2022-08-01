//
//  function.swift
//  StockSearch2
//
//  Created by Manish on 4/20/22.
//
//var companyName: String?
////    let tickerName: String?
//var currentPrice: Double?
//var closePrice: Double?
//var changePrice: Double?
//var percentageChange: Double?
//// PortFolio
//var sharesOwned: Int?
//var totalCost: Double?
//var marketValue: Double?
//var change: Double?
//
//var inPortfloio: Bool?
//var inFavorites: Bool?



import Foundation


func getAllTickers()->[String] {
    
    var favoritesArray: favArray = favArray()
    var pArray: PortArray = PortArray()
    
    if UserDefaults.standard.object(forKey: "FavoritesArray") == nil && UserDefaults.standard.object(forKey: "PortfolioArray") == nil {
        return []
    }
    
    if UserDefaults.standard.object(forKey: "FavoritesArray") != nil{
        
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
    }
    
    if UserDefaults.standard.object(forKey: "PortfolioArray") != nil {
        
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
    }
    var a: Set<String> = Set()
    var b: Set<String> = Set()
    if favoritesArray.favroites!.count > 0{
        a = Set(favoritesArray.favroites!)
    }
    if pArray.portfolioArray!.count > 0 {
        b = Set(pArray.portfolioArray!)
    }
    
    if a.isEmpty && b.isEmpty{
        return []
    }
    else if a.isEmpty{
        return Array(b)
    }
    else if b.isEmpty{
        return Array(a)
    }
    else {
        return Array(a.union(b))
    }
}

func returnHTMLpath()->URL{
    guard let filePath = Bundle.main.path(forResource: "index", ofType:"html") else{
        print("Error file path")
        return URL(string: "")!
    }
    print(filePath)
    do {
        let htmlString = try String(contentsOfFile: filePath, encoding:.utf8)
        return URL(string: htmlString)!
//            loadHTMLString(htmlString, baseURL: URL(fileURLWithPath: filePath))
    } catch {
        print("error here")
        return URL(string: "")!
//        print("error here")
    }
//    return ""
}

func unixToDate(unixTimeStamp: Int)->String{
    let date = Date(timeIntervalSince1970: Double(unixTimeStamp))
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    return dateFormatter.string(from: date)
//    dateFormatter.timeZone = TimeZone(abbreviation: "America/Los_Angeles")
//    dateFormatter.locale = NSLocale.current
}

func createStockDetails(tickerName: String, name: String, latestPrice: LatestPriceModel, port: Bool, fav: Bool){
    
    var sd: StockDetails = StockDetails()
    
    sd.companyName = name
    sd.currentPrice = latestPrice.LatestPriceInfoResponse.c
    sd.closePrice = latestPrice.LatestPriceInfoResponse.pc
    sd.changePrice = latestPrice.LatestPriceInfoResponse.d
    sd.percentageChange = latestPrice.LatestPriceInfoResponse.dp
    // No need to update the info below this line portfolio section will handled later!
    //sd.sharesOwned = 0
    //sd.totalCost = 0.00
    //sd.marketValue = 0.00
    //sd.change = 0.00
    
    // inPortFolio and inFav
    
    // change the boolean if parameter suggests otherwise don't touch it
    
    if port {
        sd.inPortfloio = true
    }
    
    if fav {
        sd.inFavorites = true
    }
    
    do {
        let enc = JSONEncoder()
        let data = try enc.encode(sd)
        
        UserDefaults.standard.set(data, forKey: tickerName)
    }
    catch{
        print(" Unable to SET " + tickerName + "INTO THE LOCAL STORAGE")
        print(error)
    }
    
    print("ADDED INTO THE LOCAL STORAGE")
}


func inFavArray(tickerName: String){
    
    var favoritesArray: favArray = favArray()
    
    if UserDefaults.standard.object(forKey: "FavoritesArray") == nil {
        
        favoritesArray.favroites!.append(tickerName)
        print("NO FAV ARRAY APPENDING THIS FIRST TICKER INSIDE THE FAV ARRAY")
        print(favoritesArray.favroites!)
        
        // NOW THIS DOESN'T MEAN THAT WE DONT HAVE ITS TICKER STORED AS STOCK DETAILS IN OUR LOCAL STORAGE NEED TO CHECK FIRST AND IF YES UPDATE THE IN-FAV ARRAY BOOLEAN TO TRUE
        
        if UserDefaults.standard.object(forKey: tickerName) != nil{
            
            var sd: StockDetails = StockDetails()
            
            if let data = UserDefaults.standard.data(forKey: tickerName) {
                do {
                    let dec = JSONDecoder()
                    sd = try dec.decode(StockDetails.self, from: data)
                }
                catch {
                    print("NOT ABLE TO DECODE PORTFOLIO FROM THE LOCAL STORAGE => IN GET PORTFOLIO FUNCTION")
                    print(error)
                }
            }
            sd.inFavorites = true
            
            do {
                let enc = JSONEncoder()
                let data = try enc.encode(sd)
                
                UserDefaults.standard.set(data, forKey: tickerName)
            }
            catch{
                print(" Unable to SET " + tickerName + "INTO THE LOCAL STORAGE")
                print(error)
            }
            
        }

        
        do {
            let enc = JSONEncoder()
            let data = try enc.encode(favoritesArray)
            
            UserDefaults.standard.set(data, forKey: "FavoritesArray")
        }
        catch {
            print("NOT ABLE TO SET FAV ARRAY INTO LOCAL STORAGE KILL ME!!!!")
            print(error)
        }
    }
    else {
        // Check if the tickerName exist inside the fav Array
        // Need to load the data from the local storage and check
        // If it's there do nothing pls
        // else append the tickername and set the updated list inside the local storage
        
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
        print("AFTER DECODIN CHECKING IF FAV ARRAY HAS THE TICKER OR NOT")
        print(favoritesArray.favroites!)
        if favoritesArray.favroites?.count == 0 || !(favoritesArray.favroites?.contains(tickerName))!{
            print("APPENDING INTO THE FAV ARRAY")
            favoritesArray.favroites?.append(tickerName)
        }
        
        if UserDefaults.standard.object(forKey: tickerName) != nil{
            
            var sd: StockDetails = StockDetails()
            
            if let data = UserDefaults.standard.data(forKey: tickerName) {
                do {
                    let dec = JSONDecoder()
                    sd = try dec.decode(StockDetails.self, from: data)
                }
                catch {
                    print("NOT ABLE TO DECODE PORTFOLIO FROM THE LOCAL STORAGE => IN GET PORTFOLIO FUNCTION")
                    print(error)
                }
            }
            sd.inFavorites = true
            
            do {
                let enc = JSONEncoder()
                let data = try enc.encode(sd)
                
                UserDefaults.standard.set(data, forKey: tickerName)
            }
            catch{
                print(" Unable to SET " + tickerName + "INTO THE LOCAL STORAGE")
                print(error)
            }
            
        }
        
        do {
            let enc = JSONEncoder()
            let data = try enc.encode(favoritesArray)
            
            UserDefaults.standard.set(data, forKey: "FavoritesArray")
        }
        
        catch {
            print("ISSUE HAPPENED WHILE ENCODING THE DECODED ARRAY => AT THIS POINT IDK WHAT I WILL DO")
            print(error)
        }
    }
}

func inPortArray(tickerName: String){
    
    var pArray: PortArray = PortArray()
    
    if UserDefaults.standard.object(forKey: "PortfolioArray") == nil {
        
        pArray.portfolioArray?.append(tickerName)
        
        print(pArray.portfolioArray?[0] ?? "NOT ABLE TO APPEND INSIDE PORTFOLIO ARRAY FIX IT")
        
        
        do {
            let enc = JSONEncoder()
            let data = try enc.encode(pArray)
            
            UserDefaults.standard.set(data, forKey: "PortfolioArray")
        }
        catch {
            print("NOT ABLE TO SET PORT ARRAY INTO LOCAL STORAGE")
            print(error)
        }
    }
    else {
        
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
        
        if pArray.portfolioArray?.count == 0 || !(pArray.portfolioArray?.contains(tickerName))! {
            pArray.portfolioArray?.append(tickerName)
        }
        
        do {
            let enc = JSONEncoder()
            let data = try enc.encode(pArray)
            
            UserDefaults.standard.set(data, forKey: "PortfolioArray")
        }
        catch {
            print("ISSUE HAPPEND WHILE ENCODING THE DECODE PORT ARRAY")
            print(error)
        }
    }
}


func isPortArray(tickerName:String)->Bool{
    
    var pArray: PortArray = PortArray()
    
    if UserDefaults.standard.object(forKey: "PortfolioArray") == nil {
        return false
    }
    else {
        if let data = UserDefaults.standard.data(forKey: "PortfolioArray") {
            do {
                let dec = JSONDecoder()
                pArray = try dec.decode(PortArray.self, from: data)
            }
            catch {
                print("ERROR IN isPortArray FUNC")
                print(error)
            }
        }
        
        if pArray.portfolioArray?.count == 0 || !(pArray.portfolioArray?.contains(tickerName))!{
            return false
        }
        return true
    }
    
}

// To check if we own shares for a particular company
// check if the tickerName exists in portfolio array
// if not it means its 0 otherwise return the value from ticker's stock details struct

func getPortfolio(tickerName:String)->StockDetails{
    
    var sd: StockDetails = StockDetails()
    
    if UserDefaults.standard.object(forKey: tickerName) == nil{
        return sd // empty StockDetails
    }
    else {
        if let data = UserDefaults.standard.data(forKey: tickerName) {
            do {
                let dec = JSONDecoder()
                sd = try dec.decode(StockDetails.self, from: data)
            }
            catch {
                print("NOT ABLE TO DECODE PORTFOLIO FROM THE LOCAL STORAGE => IN GET PORTFOLIO FUNCTION")
                print(error)
            }
        }
        print(sd)
        return sd // Updated stock details
    }
}

//func updateNetworth(currNetWorth: Double, numSharesSold: Double, AvgCostperShare: Double, sellingPrice: Double) -> Double{
//    return currNetWorth + (sellingPrice - AvgCostperShare) * numSharesSold
//}


func updateNetworth()->Double{
    
    if UserDefaults.standard.object(forKey: "PortfolioArray") == nil {
        return 0.00
    }
    var sd: StockDetails = StockDetails()
    
    var pArray: PortArray = PortArray()
    
    var totalPrice: Double = 0.00
    
    if let data = UserDefaults.standard.data(forKey: "PortfolioArray") {
        do {
            let dec = JSONDecoder()
            pArray = try dec.decode(PortArray.self, from: data)
        }
        catch {
            print("ERROR IN isPortArray FUNC")
            print(error)
        }
    }
    
    for ticker in pArray.portfolioArray! {
        
        if let data = UserDefaults.standard.data(forKey: ticker) {
            do {
                let dec = JSONDecoder()
                sd = try dec.decode(StockDetails.self, from: data)
            }
            catch {
                print("ERROR in decoding .... HOUSTON WE GOT A SITUATION HERE !!!")
                print(error)
            }
        }
        
        totalPrice += sd.currentPrice! * Double(sd.sharesOwned!)
    }
    return totalPrice
}

//func gainLoss()


func sellShares(tickerName:String, numShares: Double, currentPrice: Double){
    print("SELL SHARES FUNCTION IS CALLED")
    print(numShares)
    var sd = getPortfolio(tickerName: tickerName)
    var pArray: PortArray = PortArray()
    
    if numShares == Double(sd.sharesOwned!){
        print("ALL SHARES HAVE BEEN SOLD")
        print(sd.sharesOwned!)
        if !sd.inFavorites!{
            // Because this company is neither in favorites nor in portfolio
            // We need to delete the stock details for that particular company's Name
            
            UserDefaults.standard.removeObject(forKey: tickerName)
        }
        else {
            sd.sharesOwned = 0
            sd.totalCost = 0.00
            sd.marketValue = 0.00
            sd.change = 0.00
            sd.inPortfloio = false
            
            do {
                let enc = JSONEncoder()
                let data = try enc.encode(sd)
                
                UserDefaults.standard.set(data, forKey: tickerName)
            }
            catch{
                print(" Unable to SET " + tickerName + "INTO THE LOCAL STORAGE")
                print(error)
            }
            
        }
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
        
        pArray.portfolioArray = pArray.portfolioArray?.filter {$0 != tickerName}
        print(pArray.portfolioArray!)
        if pArray.portfolioArray!.count == 0 {
            UserDefaults.standard.removeObject(forKey: "PortfolioArray")
        }
        else {
            do {
                let enc = JSONEncoder()
                let data = try enc.encode(pArray)
                
                UserDefaults.standard.set(data, forKey: "PortfolioArray")
            }
            catch {
                print("ISSUE HAPPEND WHILE ENCODING THE DECODE PORT ARRAY")
                print(error)
            }
        }
        
        
    }
    else {
        // Update the stock details as numShares changed
        sd.sharesOwned = sd.sharesOwned! - Int(numShares)
        sd.totalCost = sd.avgCost! * Double(sd.sharesOwned!)
        sd.marketValue = sd.currentPrice! * Double(sd.sharesOwned!)
        sd.change = (currentPrice - sd.avgCost!) * Double(sd.sharesOwned!) // Basically it tells us are we in profit or loss
        
        // Now populate the Local Storage with the updated stock detail
        
        do {
            let enc = JSONEncoder()
            let data = try enc.encode(sd)
            
            UserDefaults.standard.set(data, forKey: tickerName)
        }
        catch {
            print("ISSUE WHILE ENCODING THE UPDATED STOCKDETAIL IN SELL SHARES FUNC")
            print(error)
        }
    }
    
    // Updating the Cash Balance and Networth
    
    var MONEY: Money = getMoney()
    
    MONEY.CashBalance = MONEY.CashBalance + numShares * currentPrice
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
    
}

func buyShares(latestPrice: LatestPriceInfo, numShares: Double, tickerName: String, companyName: String){
    
    // update money as well
    
    if UserDefaults.standard.object(forKey: tickerName) == nil {
        
        // Create a stock detail struct for this ticker and also add the ticker's value into the portArray
        var sd = StockDetails()
        sd.companyName = companyName
        sd.sharesOwned = Int(numShares)
        
        sd.currentPrice = latestPrice.c
        sd.closePrice = latestPrice.pc
        sd.changePrice = latestPrice.d
        sd.percentageChange = latestPrice.dp
        
        sd.inPortfloio = true
        sd.inFavorites = false
        
        sd.avgCost = latestPrice.c
        sd.marketValue = latestPrice.c! * Double(sd.sharesOwned!)
        sd.change = 0.00
        sd.totalCost = latestPrice.c! * Double(numShares)
        
        print("WHEN NO SD WAS INSIDE THE LOACAL STORAGE")
        print(sd)
        
        // Populate this sd inside the local Storage
        
        do {
            let enc = JSONEncoder()
            let data = try enc.encode(sd)
            
            UserDefaults.standard.set(data, forKey: tickerName)
        }
        catch{
            print(" Unable to SET " + tickerName + "INTO THE LOCAL STORAGE")
            print(error)
        }
        
        
        
        // Insert this ticker inside port array
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
        pArray.portfolioArray?.append(tickerName)
        
        do {
            let enc = JSONEncoder()
            let data = try enc.encode(pArray)
            
            UserDefaults.standard.set(data, forKey: "PortfolioArray")
        }
        catch {
            print("ISSUE HAPPEND WHILE ENCODING THE DECODE PORT ARRAY")
            print(error)
        }
        
    }
    else {
        var sd = StockDetails()
        if let data = UserDefaults.standard.data(forKey: tickerName) {
            do {
                let dec = JSONDecoder()
                sd = try dec.decode(StockDetails.self, from: data)
            }
            catch {
                print("NOT ABLE TO DECODE PORT ARRAY FROM THE LOCAL STORAGE")
                print(error)
            }
        }
        
        if sd.sharesOwned == 0{ // This if means that it is in fav array but not in portfolio array
            
            // Insert the tickerName in portArray
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
            pArray.portfolioArray?.append(tickerName)
            
            do {
                let enc = JSONEncoder()
                let data = try enc.encode(pArray)
                
                UserDefaults.standard.set(data, forKey: "PortfolioArray")
            }
            catch {
                print("ISSUE HAPPEND WHILE ENCODING THE DECODE PORT ARRAY")
                print(error)
            }
            
            // update the stock details for this ticker
            print("ALREADY IN FAV ARRAY TRYING TO ADD IN PORTFOLIO AS WELL")
            print(sd)
            print("UPDATING THE PORTFOLIO SECTION IN STOCK DETAILS")
            print(latestPrice.c!)
            sd.sharesOwned = Int(numShares)
            sd.avgCost = latestPrice.c
            sd.marketValue = latestPrice.c! * Double(sd.sharesOwned!)
            sd.change = 0.00
            sd.totalCost = latestPrice.c! * numShares
            
            sd.inPortfloio = true
            
            do {
                let enc = JSONEncoder()
                let data = try enc.encode(sd)
                
                UserDefaults.standard.set(data, forKey: tickerName)
            }
            catch {
                print("ISSUE WHILE ENCODING THE UPDATED STOCKDETAIL IN SELL SHARES FUNC")
                print(error)
            }
            
            print(sd)
            
            
            
        }
        else {
            // we already have some shares for this company
            // Changes will happen in all the params of portfolio sections of stock details
            
            // And no need to update the portfolio array
            
            sd.avgCost = updateAvgCost(currentAvgCost: sd.avgCost!, currentPrice: latestPrice.c!, prevSharesOwned: sd.sharesOwned!, newSharesOwned: Int(numShares))
            
            sd.marketValue = latestPrice.c! * Double(Double(sd.sharesOwned!) + numShares)
            sd.change = (latestPrice.c! - sd.avgCost!) * Double(Double(sd.sharesOwned!) + numShares)
            sd.totalCost = sd.avgCost! * Double(Double(sd.sharesOwned!) + numShares)
            sd.sharesOwned = sd.sharesOwned! + Int(numShares)
            
            do {
                let enc = JSONEncoder()
                let data = try enc.encode(sd)
                
                UserDefaults.standard.set(data, forKey: tickerName)
            }
            catch {
                print("ISSUE WHILE ENCODING THE UPDATED STOCKDETAIL IN SELL SHARES FUNC")
                print(error)
            }
            
            print(sd)
            
        }
    }
    
    // Update the Cash Balance and NetWorth
    
    var MONEY: Money = getMoney()
    
    MONEY.CashBalance = MONEY.CashBalance - numShares * latestPrice.c!
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
    
}

func deleteFav(tickerName: String){
    
    var favoritesArray: favArray = favArray()
    var sd = StockDetails()
    
    if UserDefaults.standard.object(forKey: "FavoritesArray") != nil{
        
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
        
        favoritesArray.favroites = favoritesArray.favroites?.filter {$0 != tickerName}
        if let data = UserDefaults.standard.data(forKey: tickerName) {
            do {
                let dec = JSONDecoder()
                sd = try dec.decode(StockDetails.self, from: data)
            }
            catch {
                print("NOT ABLE TO DECODE PORT ARRAY FROM THE LOCAL STORAGE")
                print(error)
            }
        }
        sd.inFavorites = false
        print(sd.companyName!)
        if sd.inPortfloio!{
            do {
                let enc = JSONEncoder()
                let data = try enc.encode(sd)
                
                UserDefaults.standard.set(data, forKey: tickerName)
            }
            catch {
                print("ISSUE WHILE ENCODING THE UPDATED STOCKDETAIL IN SELL SHARES FUNC")
                print(error)
            }
        }
        else{
            // remove ticker from the local storage
            UserDefaults.standard.removeObject(forKey: tickerName)
        }
        
        if favoritesArray.favroites!.count == 0 {
            UserDefaults.standard.removeObject(forKey: "FavoritesArray")
        }
        else{
            do {
                let enc = JSONEncoder()
                let data = try enc.encode(favoritesArray)
                
                UserDefaults.standard.set(data, forKey: "FavoritesArray")
            }
            catch {
                print("NOT ABLE TO SET FAV ARRAY INTO LOCAL STORAGE KILL ME!!!!")
                print(error)
            }
        }
        
        
        
    }
    
}




// Calculations for the portfolio

func updateAvgCost(currentAvgCost: Double, currentPrice: Double, prevSharesOwned: Int, newSharesOwned: Int) -> Double{
    
    return (currentAvgCost * Double(prevSharesOwned) + currentPrice * Double(newSharesOwned)) / Double(prevSharesOwned + newSharesOwned)
}


                
