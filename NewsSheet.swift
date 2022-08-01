//
//  NewsSheet.swift
//  StockSearch2
//
//  Created by Manish on 4/29/22.
//

import Foundation
import SwiftUI
import Kingfisher

// View Structure

// News Source : String
// News Published Date : String (Conversion from Unix Timestamp to String)
// News Title
// News Description
// News WebURL
// Add twitter and facebook icon which will redirect to your account from posting the news article as if sharing in social media


struct NewsSheetView: View {
    
    @Binding var newsSheets: Bool
    @Binding var newsModel: newsInfo
//    @Binding var newModelHeadline: String
//    @Binding var newsModelDate: Int // change to String later
//    @Binding var newsModelSource: String
//    @Binding var newsModelSummary: String
//    @Binding var newsModelurl: String
 
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading){
                // Header
                HStack{
                    VStack(alignment: .leading){
                        Text(newsModel.source)
                            .font(.system(size:30))
                            .bold()
                        Text(String(unixToDate(unixTimeStamp: newsModel.datetime)))
                            .font(.system(size:15))
                            .opacity(0.7)
                            .foregroundColor(.gray)
                        
                    }
                    Spacer()
                }
                
                Divider()
                
                // Article Description
                
                // HEADLINE
                Text(newsModel.headline)
                    .font(.system(size:20))
                    .bold()
                Text(newsModel.summary)
                    .font(.system(size:13))
                HStack{
                    Text("For more details click")
                        .font(.system(size:10))
                        .foregroundColor(.gray)
                        .opacity(0.6)
                    Link("here", destination: URL(string: newsModel.url)!)
                        .foregroundColor(.blue)
                        .font(.system(size:10))
                        .buttonStyle(BorderlessButtonStyle())
                    Spacer()
                }
                HStack{
//                    Link(destination: URL(string:"https://twitter.com/intent/tweet?text=\(newsModel.headline)&url=\(newsModel.url)")!){
//                        
//                        Image("Twitter-icon")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 50, height: 50)
//                            .buttonStyle(BorderlessButtonStyle())
//
//                    }
//                        .environment(\.openURL, OpenURLAction {
//                            url in
//                            return .systemAction(URL(string: "https://www.bing.com")!)
//                        })
                    
                        
                    
                    
                    
                    Button(action:{
                        
                        let urlHeadline = "\(newsModel.headline)"
                        let urlLink = "\(newsModel.url)"
//                        print(urlHeadline)
//                        print(urlLink)
                        
                        let escapedHeadLine = urlHeadline.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                        let escapedLink = urlLink.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
//                        print(escapedHeadLine!)
//                        print(escapedLink!)
                        guard let tweeturl = URL(string:"https://twitter.com/intent/tweet?text=\(escapedHeadLine!)&url=\(escapedLink!)"),
                              UIApplication.shared.canOpenURL(tweeturl) else {
                                       return
                    }
                        UIApplication.shared.open(tweeturl,
                                                  options: [:],
                                                  completionHandler: nil)
                    
                    }){
                        Image("Twitter-icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .buttonStyle(BorderlessButtonStyle())
                        
                    }
                    
                    
                    Button(action:{
                        let urlLink = "\(newsModel.url)"
//                        print(urlHeadline)
//                        print(urlLink)
                        let escapedLink = urlLink.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
//                        print(escapedHeadLine!)
//                        print(escapedLink!)
                        guard let fburl = URL(string:"https://www.facebook.com/sharer/sharer.php?u=\(escapedLink!)"),
                              UIApplication.shared.canOpenURL(fburl) else {
                                       return
                    }
                        UIApplication.shared.open(fburl,
                                                  options: [:],
                                                  completionHandler: nil)
                    
                    }){
                        Image("FB-icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        
                    }
                    Spacer()
                }
                
                
                
                Spacer()
                
            }
            .navigationBarItems(trailing: Button(action: {
                    print("Dismissing news sheet view...")
                    
                    self.newsSheets = false
                }, label: {
                    Image(systemName: "xmark")
                }))
        }
        
    }
    
}

// https://twitter.com/intent/tweet?text=How%20to%20link%20to%20a%20Tweet%2C%20Moment%2C%20List%2C%20or%20Twitter%20Space&url=https%3A%2F%2Fhelp.twitter.com%2Fen%2Fusing-twitter%2Ftweet-and-moment-url
