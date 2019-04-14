//
//  FavourtiesTableViewController.swift
//  F1 Grid Viewer
//
//  Created by Conall Mc Carthy on 26/03/2019.
//  Copyright © 2019 Conall Mc Carthy. All rights reserved.
//

import UIKit
import CoreData

class FavourtiesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var driverManagedObject : DriverModel! = nil
    var entity : NSEntityDescription! = nil
    var frc : NSFetchedResultsController<NSFetchRequestResult>! = nil
    
    
    
    @IBAction func favouriteButton(_ sender: Any) {
        
        let point = tableView.convert(CGPoint.zero, from: sender as! UIButton)
        let indexPath = tableView.indexPathForRow(at: point)
        
        let driver = frc.object(at: indexPath!) as? DriverModel
        
        driver?.isFavourited = "no"
    
        do {
        try context.save()
        
        } catch {
        print("error, core data does not save")
        }
        
        frc = NSFetchedResultsController(fetchRequest: getFavourites(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        do{try frc.performFetch()}
        catch{}
        
        tableView.reloadData()
        
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.title = "Favourite Drivers"
         self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundImage.png")!)
        
        if let navBar = self.navigationController?.navigationBar {
            navBar.barTintColor = UIColor(patternImage: UIImage(named: "backgroundImage2")!)
            
            
        frc = NSFetchedResultsController(fetchRequest: getFavourites(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        do{try frc.performFetch()}
        catch{print("Core Data Cannot Find")}
        }


    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
         return frc.sections![section].numberOfObjects
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)

        driverManagedObject = frc.object(at: indexPath) as? DriverModel
        
        
        let nameLabel = cell.viewWithTag(21) as! UILabel
        let teamLabel = cell.viewWithTag(22) as! UILabel
        let image = cell.viewWithTag(23) as! UIImageView
        
        
        let editButton = cell.viewWithTag(24) as! UIButton
        let favButton = cell.viewWithTag(25) as! UIButton
        
        editButton.clipsToBounds = true
        editButton.layer.cornerRadius = 18.75
        
        favButton.clipsToBounds = true
        favButton.layer.cornerRadius = 10
        
        
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = driverManagedObject.image
        let f = fileName!
        let fileURL = documentsDirectory.appendingPathComponent(fileName!)
        
        nameLabel.text = driverManagedObject.name
        teamLabel.text = driverManagedObject.team
        
        if f.contains("-") {
            image.image = UIImage(contentsOfFile: fileURL.path)
        }
        else{
            image.image = UIImage(named: driverManagedObject.image!)
        }
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.backgroundView = UIImageView(image: UIImage(named: "backgroundImage"))
        //cell.backgroundView = UIImageView(image: UIImage(named: "backgroundImage2"))
        
        cell.backgroundColor = UIColor(white: 1, alpha: 0.1)
        
        
    }
    

   

    
    func getFavourites() -> NSFetchRequest<NSFetchRequestResult>{
        
        print("X25 request for favourites started")
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DriverModel")
        let sorter = NSSortDescriptor(key: "team", ascending: true)
        let isFavourited = "yes"
        fetchRequest.predicate = NSPredicate(format: "isFavourited == %@", isFavourited)
        fetchRequest.sortDescriptors = [sorter]
        print("X25 request for favourites ended")
        return fetchRequest
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        if segue.identifier == "addSegue"{
            // Get the new view controller using segue.destination.
            _ = segue.destination as! AddNewDriverViewController
            
        }
        
        else if segue.identifier == "editSegue"{
            
            let destination = segue.destination as! AddNewDriverViewController
            
            let point = tableView.convert(CGPoint.zero, from: sender as! UIButton)
            
            let indexPath = tableView.indexPathForRow(at: point)
            
            destination.driverManagedObject = frc.object(at: indexPath!) as? DriverModel
        
            
            
        }
        
        
        else if segue.identifier == "tableSegue"{
            // Get the new view controller using segue.destination.
            
            let destination = segue.destination as! DriverViewController
            // Pass the selected object to the new view controller.
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
            // need to pass a different index if the user has filtered their search
            
            destination.driverData = frc.object(at: indexPath!) as? DriverModel
            
        }
    
        
    }
    

}
