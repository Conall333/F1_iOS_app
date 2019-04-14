//
//  DetailsViewController.swift
//  Person Information
//
//  Created by Conall Mc Carthy on 05/02/2019.
//  Copyright © 2019 Conall Mc Carthy. All rights reserved.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var racesLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var teamCar: UIImageView!
    
    @IBOutlet weak var customButton: UIButton!
    
    @IBAction func webInfoAction(_ sender: UIButton) {
    }
    
    var driverData : DriverModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundImage.png")!)
        
        customButton.clipsToBounds = true
        customButton.layer.cornerRadius = 17.5
        // Do any additional setup after loading the view.
        
        self.title = driverData.name! + "'s Details"
        
        // populate outlets with data
        nameLabel.text = driverData.name
        teamLabel.text = "Team: " + driverData.team!
        racesLabel.text = "Races: " + driverData.races!
        countryLabel.text = "Country: " + driverData.country!
        pointsLabel.text = "Points: " + driverData.points!
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = driverData.carImage
        let f = fileName!
        let fileURL = documentsDirectory.appendingPathComponent(fileName!)
        
        if f.contains("-") {
            teamCar.image = UIImage(contentsOfFile: fileURL.path)
        }
        else{
           teamCar.image = UIImage(named: driverData.carImage!)
        }
        
        customButton.center.x = view.frame.width/2
        
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        
        let destination = segue.destination as! WebViewController
        
        // Pass the selected object to the new view controller.
        
        destination.driverData = self.driverData
        
        
    }
    

}
