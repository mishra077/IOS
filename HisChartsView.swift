//
//  HisChartsView.swift
//  StockSearch2
//
//  Created by Manish on 4/29/22.
//




import Foundation
import UIKit
import SwiftUI
import Combine
import WebKit


 
struct WebView: UIViewRepresentable {
 
//    var url: URL
    @Binding var hisData: HistoricalData
    var tickerName: String
    
    let webView = WKWebView()
    func makeUIView(context: Context) -> WKWebView {
//        let webView = WKWebView()
        self.webView.navigationDelegate = context.coordinator
        let path = Bundle.main.url(forResource: "index", withExtension: "html")!
        let text = try! String(contentsOf: path, encoding: String.Encoding.utf8)
        self.webView.loadHTMLString(text, baseURL: path)
        return self.webView
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        self.webView.frame.size.height = 2000
        let path = Bundle.main.url(forResource: "index", withExtension: "html")!
        let text = try! String(contentsOf: path, encoding: String.Encoding.utf8)
        self.webView.loadHTMLString(text, baseURL: path)
        self.webView.frame.size.width = 460
        
        
        
//        let scriptSource = "createHisCharts('\(jsonString)','\(tickerName)')"
        
    }
    
    func makeCoordinator() -> WebViewCoordinator {
//        WebViewCoordinator()
        WebViewCoordinator(didFinish:{
            let data:[[Any]] = [hisData.o, hisData.h, hisData.l, hisData.c, hisData.v, hisData.t]
//            print(data[0].count)
//            let data: [[Double]] = [hisData.c, hisData.h, hisData.l, hisData.o, hisData.t, hisData.v]
//            let jsonData = try! JSONSerialization.data(withJSONObject: data, options: [])
//            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)!
            let scriptSource = "createHisCharts(\(data),'\(tickerName)')"
            print("SCRIPT SCOURCE ////////////////////////")
//            print(scriptSource)
//            print(data[0].count)
//            print(data[1].count)
//            print(data[2].count)
//            print(data[3][504])
//            print(data[4][504])
//            print(data[5][504])
            
            
//            let scriptSource = "alertH()"
            self.webView.evaluateJavaScript(scriptSource, completionHandler: { (object, error) in
                if let error = error {
                    print("Error calling javascript:valueGotFromIOS()")
                    print(error)
                } else {
                    print("Called javascript:valueGotFromIOS()")
                }
            })
        })
    }
}


class WebViewCoordinator: NSObject, WKNavigationDelegate {
//    var parent: WebView
    var didStart: () -> Void
    var didFinish: () -> Void
    
    
    init(didStart: @escaping () -> Void = {}, didFinish: @escaping () -> Void = {}){
//        self.parent = uiWebView
        self.didStart = didStart
        self.didFinish = didFinish
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        didFinish()
    }
}


//struct WebView: UIViewRepresentable {
//    @Binding var hisData: HistoricalData
//    var tickerName: String
//
//    func makeCoordinator() -> WebView.Coordinator {
//        Coordinator(self, self.hisData, self.tickerName)
//    }
//
//    func makeUIView(context: Context) -> WKWebView {
//        // Enable javascript in WKWebView to interact with the web app
//        let preferences = WKPreferences()
//        preferences.javaScriptEnabled = true
//
//        let configuration = WKWebViewConfiguration()
//        configuration.preferences = preferences
//
//        let userContentController = WKUserContentController()
//
//        userContentController.add(context.coordinator, name:"observer")
//
//        configuration.userContentController = userContentController
//        // Here "iOSNative" is our interface name that we pushed to the website that is being loaded
////        configuration.userContentController.add(Coordinator(self, self.hisData, self.tickerName))
//        configuration.preferences = preferences
//
//        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
//        webView.navigationDelegate = context.coordinator
//        webView.allowsBackForwardNavigationGestures = true
//        webView.scrollView.isScrollEnabled = true
//        return webView
//    }
//
//    func updateUIView(_ webView: WKWebView, context: Context) {
//        let path = Bundle.main.url(forResource: "index", withExtension: "html")!
//        let text = try! String(contentsOf: path, encoding: String.Encoding.utf8)
//        webView.loadHTMLString(text, baseURL: path)
//    }
//
//    class Coordinator: NSObject, WKNavigationDelegate {
//        var parent: WebView
//
//        var hisData: HistoricalData
//        var tickerName: String
////        var webViewNavigationSubscriber: AnyCancellable? = nil
//
//        init(_ uiWebView: WebView, _ hisData: HistoricalData, _ tickerName: String){
//            self.parent = uiWebView
////            self.delegate = parent
//            self.hisData = hisData
//            self.tickerName = tickerName
//
//        }
//
//        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//            let data: [String:Any] = ["c": hisData.c, "h": hisData.h, "l": hisData.l, "o": hisData.o, "t":hisData.t, "v": hisData.v]
//            let jsonData = try! JSONSerialization.data(withJSONObject: data, options: [])
//            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)!
//            let scriptSource = "createHisCharts('\(jsonString)','\(tickerName)')"
//            webView.evaluateJavaScript(scriptSource, completionHandler: { (object, error) in
//                if let error = error {
//                    print("Error calling javascript:valueGotFromIOS()")
//                    print(error)
//                } else {
//                    print("Called javascript:valueGotFromIOS()")
//                }
//            })
//        }
//    }
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//




//import Foundation
//import SwiftUI
//import WebKit
//
//
////class Coordinator: NSObject, WKNavigationDelegate {
////    var webView: WKWebView?
////    var hisData: HistoricalData
////    var tickerName: String
////
////    init(web: WKWebView? = nil,
////         hisData: HistoricalData = HistoricalData(),
////         tickerName:String = ""){
////        self.webView = web
////        self.hisData = hisData
////        self.tickerName = tickerName
////    }
////    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
////        self.webView = webView
////        self.messageToWebview(data: hisData, tickerName: tickerName)
////    }
////
////    func messageToWebview(data: HistoricalData, tickerName: String) {
////        self.webView?.evaluateJavaScript("webkit.messageHandlers.bridge.onMessage(\(data), \(tickerName)")
////    }
////
////}
//
//
//struct WebView: UIViewRepresentable {
//
//    @Binding var hisData: HistoricalData
//    var tickerName: String
//
//    class Coordinator: NSObject, WKNavigationDelegate {
//        let parent: WebView
//
//        init(_ parent: WebView) {
//            self.parent = parent
//        }
//
//    }
//
////    func makeCoordinator() -> Coordinator {
////        return Coordinator(hisData:hisData, tickerName:tickerName)
////    }
//
//    func makeCoordinator() -> WebView.Coordinator {
//        Coordinator(self)
//    }
//
//
//
//    func makeUIView(context: Context) -> WKWebView {
//        let coordinator = makeCoordinator()
//        print("FROM MAKE UIview")
////        print(hisData)
//
//        let userContentController = WKUserContentController()
////        let data: [String:Any] = ["c": hisData.c, "h": hisData.h, "l": hisData.l, "o": hisData.o, "t":hisData.t, "v": hisData.v]
////        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: [])
////        let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)!
//////        print(jsonString)
////        let scriptSource = """
////                            createHisCharts(\(jsonString),\(tickerName));
////                            """
//
////        print(scriptSource)
////        let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentStart, forMainFrameOnly: true)
////        userContentController.addUserScript(script)
////        userContentController.add(coordinator as! WKScriptMessageHandler, name: "bridge")
//
//        let configuration = WKWebViewConfiguration()
//        configuration.userContentController = userContentController
//
//        let webView = WKWebView(frame: .zero, configuration: configuration)
////        webView.evaluateJavaScript(scriptSource, completionHandler: { (object, error) in
////            if let error = error {
////                print("Error calling javascript:valueGotFromIOS()")
////                print(error.localizedDescription)
////            } else {
////                print("Called javascript:valueGotFromIOS()")
////            }
////        })
//        webView.navigationDelegate = self
//        let path = Bundle.main.url(forResource: "index", withExtension: "html")!
//        let text = try! String(contentsOf: path, encoding: String.Encoding.utf8)
//        webView.loadHTMLString(text, baseURL: path)
//
////        webView.evaluateJavaScript(scriptSource, completionHandler: nil)
////        _wkwebview.navigationDelegate = coordinator
//
//        return webView
//    }
//
//    func updateUIView(_ webView: WKWebView, context: Context) {
////        print("updateuiview")
////        let path = Bundle.main.url(forResource: "index", withExtension: "html")!
////        let text = try! String(contentsOf: path, encoding: String.Encoding.utf8)
////        webView.loadHTMLString(text, baseURL: path)
//        let data: [String:Any] = ["c": hisData.c, "h": hisData.h, "l": hisData.l, "o": hisData.o, "t":hisData.t, "v": hisData.v]
//        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: [])
//        let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)!
////        print(jsonString)
//        let scriptSource = "createHisCharts('\(jsonString)','\(tickerName)')"
////        let scriptSource = "populate(\"ATOR01\")"
//        print("FROM WEBVIEW FUNCTION")
//        print("EVALUATING")
//        print(scriptSource)
//        webView.evaluateJavaScript(scriptSource, completionHandler: { (object, error) in
//            if let error = error {
//                print("Error calling javascript:valueGotFromIOS()")
//                print(error)
//            } else {
//                print("Called javascript:valueGotFromIOS()")
//            }
//        })
//
////        let localHTMLUrl = URL(fileURLWithPath: path, isDirectory: false)
////        webView.loadFileURL(localHTMLUrl, allowingReadAccessTo: localHTMLUrl)
//    }
//
//
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        let data: [String:Any] = ["c": hisData.c, "h": hisData.h, "l": hisData.l, "o": hisData.o, "t":hisData.t, "v": hisData.v]
//        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: [])
//        let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)!
////        print(jsonString)
//        let scriptSource = """
//                            createHisCharts(\(jsonString),\(tickerName));
//                            """
////        let scriptSource = "populate(\"ATOR01\")"
//        print("FROM WEBVIEW FUNCTION")
//        print("EVALUATING")
//        print(scriptSource)
//        webView.evaluateJavaScript(scriptSource, completionHandler: { (object, error) in
//            if let error = error {
//                print("Error calling javascript:valueGotFromIOS()")
//                print(error.localizedDescription)
//            } else {
//                print("Called javascript:valueGotFromIOS()")
//            }
//        })
//    }
//}
