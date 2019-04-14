//
//  WebViewController.swift
//  Person Information
//
//  Created by Conall Mc Carthy on 12/02/2019.
//  Copyright © 2019 Conall Mc Carthy. All rights reserved.
//

import UIKit
import WebKit


class WebViewController: UIViewController, WKNavigationDelegate {
    
    
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    

    func loadErrorMessage() {
        webView.loadHTMLString("<html><title>" + driverData.name! + "'s Web Info" + "</title><head><style> * { font-size: 50px; background: linear-gradient(0deg, rgba(123,253,255,1) 0%, rgba(255,107,107,1) 100%); }</style></head><body><p>" + "The Name you entered does not have a wikipedia page, please enter a valid name if you wish to see their wikipedia page" + "</p></body></hmtl>", baseURL: nil)
        
    }
    
    var driverData : DriverModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = driverData.name! + "'s Web Info"
        var dName = driverData.name!
        
        var wikipediaInfo : String!
        
            
        let driverName = dName.split(separator: " ")
        
        let url: String
        var invalidName = false
        
        if driverName.count < 2 {
            
            url = "https://www.google.com"
            invalidName = true
        
        }
        
        else {
            let firstName = driverName[0]
            let lastName =  driverName[1]
        
            url = "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro&explaintext&redirects=1&titles=" + firstName + "%20" + lastName
            
        }
        
        let urlData = URL(string: url)
        
        
        if invalidName != true {
            
            URLSession.shared.dataTask(with: urlData!) {(data,response,error) in
                    
                    //let myData = data.  (using: .utf8)!
                let jsonData = try? JSONDecoder().decode(WikipediaData.self, from: data!)
                
                wikipediaInfo = jsonData?.query.pages.unknownId?.extract
                
                // loads web view in main thread onces it has got a response
                DispatchQueue.main.async {
                    
                    if wikipediaInfo != nil {
                        loadWebView()
                    }
                    else {
                        self.loadErrorMessage()
                    }
                }
            
                
            }.resume()
            
            
        }
        
        else {
            loadErrorMessage()
        }
        
        
    
        func loadWebView() {
            // web data loaded as a html string
            webView.loadHTMLString("<html><title>" + driverData.name! + "'s Web Info" + "</title><head><style> * { font-size: 50px; background: linear-gradient(0deg, rgba(123,253,255,1) 0%, rgba(255,107,107,1) 100%); }</style></head><body><p>" + wikipediaInfo + "</p></body></hmtl>", baseURL: nil)
            
        }
     
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    

}

// struct for the awkward json data from wikipedia
struct WikipediaData: Decodable {
    let batchcomplete: String
    let query: Query
    struct Query: Decodable {
        let pages: Pages
        struct Pages: Decodable {
            var unknownId: UnknownID?
            struct UnknownID: Decodable {
                let pageid: Int
                let ns: Int
                let title: String
                let extract: String
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                for key in container.allKeys {
                    unknownId = try? container.decode(UnknownID.self, forKey: key)
                }
            }
            
            struct CodingKeys: CodingKey {
                var stringValue: String
                init?(stringValue: String) {
                    self.stringValue = stringValue
                }
                var intValue: Int?
                init?(intValue: Int) {
                    return nil
                }
            }
        }
    }
}
