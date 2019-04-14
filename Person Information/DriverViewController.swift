//
//  PersonViewController.swift
//  Person Information
//
//  Created by Conall Mc Carthy on 05/02/2019.
//  Copyright © 2019 Conall Mc Carthy. All rights reserved.
//

import UIKit

class DriverViewController: UIViewController {
    
    
    //outlets and actions
    
    @IBOutlet weak var personImageView: UIImageView!
    
    @IBOutlet weak var personLabel: UILabel!
    
    @IBOutlet weak var customButton: UIButton!
    
    @IBAction func personInfoAction(_ sender: UIButton) {
    }
    
    var driverData : DriverModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        
        self.title = "Selected Driver"
        
        customButton.clipsToBounds = true
        customButton.layer.cornerRadius = 17.5
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundImage.png")!)
        
        
        //generate data
        
        // populate outlets with data
        
        personLabel.text = driverData.name
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = driverData.image
        let f = fileName!
        let fileURL = documentsDirectory.appendingPathComponent(fileName!)
        
        
        if f.contains("-") {
            personImageView.image = UIImage(contentsOfFile: fileURL.path)
        }
        else{
            personImageView.image = UIImage(named: driverData.image!)
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        let destination = segue.destination as! DetailsViewController
        
        // Pass the selected object to the new view controller.
        
        destination.driverData = self.driverData
    }
 

}
