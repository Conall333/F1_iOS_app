//
//  Person.swift
//  NavigationTest
//
//  Created by Conall Mc Carthy on 04/02/2019.
//  Copyright © 2019 Conall Mc Carthy. All rights reserved.
//

import Foundation

class Driver{
    
    // properties
    
    var name    : String
    var team   : String
    var races : String
    var country: String
    var image   : String
    var carImage: String
    var points: String
   
    
    //inittialisers
    
    // implicit initializer
    
    init() {
        
        self.name = "John Doe"
        self.team = "none"
        self.races = "no known address"
        self.country = "no where"
        self.image = "none"
        self.carImage = "car"
        self.points = "100"
        
        
    }
    
    // explicit initializer
    
    
    init(name: String, team: String, races: String, country: String, image: String,carImage: String, points: String) {
        
        self.name = name
        self.team = team
        self.races = races
        self.country = country
        self.image = image
        self.carImage = carImage
        self.points = points
        
    }
    
    //methods
    
    func setName(name: String) {self.name = name}
    func getName()->String{return self.name}
    
    func setRaces(address: String) {self.races = address}
    func getRaces()->String{return self.races}
    
    func setTeam(team: String) {self.team = team}
    func getTeam()->String{return self.team}
    
    func setCountry(country: String) {self.country = country}
    func getCountry()->String{return self.country}
    
    func setImage(image: String) {self.image = image}
    func getImage()->String{return self.image}
    
    func setCarImage(carImage: String) {self.carImage = carImage}
    func getCarImage()->String{return self.carImage}
    
    func setPoints(points: String) {self.points = points}
    func getPoints()->String{return self.points
    }
    
    
    
    
    
    
    
    
}
