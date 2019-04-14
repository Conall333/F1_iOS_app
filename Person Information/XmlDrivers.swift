//
//  XmlDrivers.swift
//  Person Information
//
//  Created by Conall Mc Carthy on 16/02/2019.
//  Copyright © 2019 Conall Mc Carthy. All rights reserved.
//

import Foundation

struct Driver{
    
    var name: String
    var team: String
    var races: String
    var image: String
    var country: String
    var url: String
    
}

class XmlDrivers: NSObject {
    var data: Data
    var rssHeader: Rss
    
    
    
    override init()
    {
        
    }
    
    deinit {
    
    }
}




