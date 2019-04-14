//
//  People.swift
//  Person Information
//
//  Created by Conall Mc Carthy on 05/02/2019.
//  Copyright © 2019 Conall Mc Carthy. All rights reserved.
//

import Foundation

class Drivers {
    
    // interface + code for interface

    var peopleData : [Driver]
    
    //inits
    
    init(fromContentofXml : String){
        
        // make a XMLPeopleParser
        let parser = XMLDriverParser(name: fromContentofXml)
        
        // parsing
        parser.parsing()
        
        // set peopleData with what comes from parsing
        peopleData = parser.drivers
        
    }
    
    
    //methods
    
    func count()->Int{return peopleData.count}
    func getDriverData(index : Int)->Driver{return peopleData[index]}
    func search(query : String)->[Driver] {
        
        var driversWithSearchQuery = [Driver]()
        for driver in peopleData {
            
            if (driver.name.lowercased().contains(query.lowercased())) {
                    driversWithSearchQuery.append(driver)
                
            }
            
        }
        return driversWithSearchQuery
        

    }
    
    
    
    func getArrayOfDrivers()->[Driver] {
        
        var driversWithSearchQuery = [Driver]()
        for driver in peopleData {
            driversWithSearchQuery.append(driver)
        }
        return driversWithSearchQuery
        
        
    }
    
    
    
    
}
