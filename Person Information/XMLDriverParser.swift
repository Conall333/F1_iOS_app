//
//  XMLDriverParser.swift
//  Person Information
//
//  Created by Conall Mc Carthy on 18/02/2019.
//  Copyright © 2019 Conall Mc Carthy. All rights reserved.
//

import Foundation

class XMLDriverParser: NSObject,XMLParserDelegate {
    
    var name: String
    init(name: String) { self.name = name}
    
    //vars to hold tag data
    var dName,dTeam, dRaces, dImage, dCarImage, dCountry, dPoints  : String!
    var elementID = -1
    var passData = false
    
    //vars to manage whole data
    var driver = Driver()
    var drivers = [Driver]() // makes an empty array of drivers
    
    var parser = XMLParser()
    
    var tags = ["name","team","races","image","image2", "country","points"]
    
    
    // parser delegate methods
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        // based on the spies, grab some data into pVarse
        if passData {
            switch elementID{
                case 0 : dName = string
                case 1 : dTeam = string
                case 2 : dRaces = string
                case 3 : dImage = string
                case 4 : dCarImage = string
                case 5 : dCountry = string
                case 6 : dPoints = string
                
                default:break
                
                
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        // reset the spies
        
        if tags.contains(elementName){
            passData = false
            elementID = -1
        }
        // if elment is person then make a person and append to people
        
        if elementName == "person"{
            driver = Driver(name: dName, team: dTeam, races: dRaces, country: dCountry, image: dImage, carImage: dCarImage, points: dPoints)
            drivers.append(driver)
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        // if elementName (tag being pulled) in the tag then spy
        
        if tags.contains(elementName){
            
            passData = true
            
            switch elementName {
                case "name"     : elementID = 0
                case "team"     : elementID = 1
                case "races"    : elementID = 2
                case "image"    : elementID = 3
                case "image2"   : elementID = 4
                case "country"  : elementID = 5
                case "points"   : elementID = 6
            default : break
                
            }
        
        }
    }
    
    func parsing() {
        
         // get the path of the xml file
        let bundleUrl = Bundle.main.bundleURL
       // let fileUrl = URL (fileURLWithPath: self.name, relativeTo: bundleUrl)
         let fileUrl = URL(string: self.name, relativeTo: bundleUrl)
        
        // make a parser for this file
        parser = XMLParser(contentsOf: fileUrl!)!
        
        // give the delegate and parse
        
        parser.delegate = self
        parser.parse()
        
        
    }
    

    
    
    
    
    
    
    
    
}
