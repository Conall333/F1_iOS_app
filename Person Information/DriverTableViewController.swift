//
//  PeopleTableViewController.swift
//  Person Information
//
//  Created by Conall Mc Carthy on 12/02/2019.
//  Copyright © 2019 Conall Mc Carthy. All rights reserved.
//

import UIKit
import CoreData

class DriverTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // delete images once they are no longer in use
    
    // array of filtered drivers
    var filteredDrivers = [DriverModel]()
    // initializing search controller
    var searchController = UISearchController(searchResultsController: nil)
    //core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var driverManagedObject : DriverModel! = nil
    var entity : NSEntityDescription! = nil
    var frc : NSFetchedResultsController<NSFetchRequestResult>! = nil
    
    
    func populateCoreDataFromXml() {
        let driverData = Drivers(fromContentofXml: "drivers.xml").getArrayOfDrivers()
        
        for driver in driverData {
        // for loop though list of drivers form xml
        var peopleManagedObject : DriverModel! = nil
        peopleManagedObject = DriverModel(context: context)
        peopleManagedObject.name = driver.name
        peopleManagedObject.team = driver.team
        peopleManagedObject.races = driver.races
        peopleManagedObject.country = driver.country
        peopleManagedObject.image = driver.image
        peopleManagedObject.carImage = driver.carImage
        peopleManagedObject.points = driver.points
        peopleManagedObject.isFavourited = "no"
    
        do {
            try context.save()
            
        } catch {
            print("error, core data does not save")
        }
            
        }
    
    }
    
    
    @IBAction func addToFavourites(_ sender: Any) {
        
        let point = tableView.convert(CGPoint.zero, from: sender as! UIButton)
        let indexPath = tableView.indexPathForRow(at: point)
        
        
        if driversBeingFiltered() {
            
            let fetchRequest = NSFetchedResultsController(fetchRequest: getDriverForNameRequest(name:  filteredDrivers[indexPath!.row].name!), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            do{try fetchRequest.performFetch()}
            catch{print("Core Data Cannot Find")}
        
            let returnedArray = fetchRequest.fetchedObjects
            let returnedObject = returnedArray![0] as? DriverModel
            

            if returnedObject?.isFavourited == "yes" {
                returnedObject?.isFavourited = "no"
            }
            else {
                returnedObject?.isFavourited = "yes"
            }
            
        
            }
            
            else {
                let driver = frc.object(at: indexPath!) as? DriverModel
            if driver?.isFavourited == "yes" {
                driver?.isFavourited = "no"
            }
            else{
                driver?.isFavourited = "yes"
            }
            
            }
        
            do {
                try context.save()
                
            } catch {
                print("error, core data does not save")
            }

    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up the search bar
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Drivers"
        searchController.searchBar.scopeButtonTitles = ["Name", "Team", "Country"]
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // setting background of nav bar and search bar
        if let navBar = self.navigationController?.navigationBar {
            navBar.barTintColor = UIColor(patternImage: UIImage(named: "backgroundImage2")!)
        }
        
        self.title = "F1 Grid"
        
        
        
        
        let request = makeRequest()
        do{
            let count = try context.count(for: request)
            if count == 0 {
                populateCoreDataFromXml()
            }
        }
        catch{
            print("error")
        }
        

        
        frc = NSFetchedResultsController(fetchRequest: makeRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        
        do{try frc.performFetch()}
        catch{print("Core Data Cannot Find")}
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
    // function to hide or show bar when scrolling
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
        
    }
    
    // function that indicated if drivers are being filtered
    
    func driversBeingFiltered() -> Bool {
        
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && !searchBarIsEmpty() || searchBarScopeIsFiltering
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if driversBeingFiltered() {
            return filteredDrivers.count
        }
        
        else {
            return frc.sections![section].numberOfObjects
            
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        driverManagedObject = frc.object(at: indexPath) as? DriverModel
        
        let currentDriver: DriverModel
        
        let nameLabel = cell.viewWithTag(11) as! UILabel
        let teamLabel = cell.viewWithTag(12) as! UILabel
        let image = cell.viewWithTag(13) as! UIImageView
        let editButton = cell.viewWithTag(14) as! UIButton
        let favButton = cell.viewWithTag(15) as! UIButton
        
        editButton.clipsToBounds = true
        editButton.layer.cornerRadius = 18.75
        favButton.clipsToBounds = true
        // favButton.layer.cornerRadius = 18.75
        
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        if driversBeingFiltered() {
            
        
            currentDriver = filteredDrivers[indexPath.row]
            
            let fileName = currentDriver.image
            let fileURL = documentsDirectory.appendingPathComponent(fileName!)
            
            nameLabel.text = currentDriver.name
            teamLabel.text = currentDriver.team
            
            if currentDriver.isFavourited == "yes"{
                favButton.setImage(UIImage(named: "goldStar"), for: .normal)
            }
            
            else {
                favButton.setImage(UIImage(named: "star"), for: .normal)
                
            }
            
            if fileName!.contains("-") {
                image.image = UIImage(contentsOfFile: fileURL.path)
            }
            else{
                image.image = UIImage(named: currentDriver.image!)
            }
            
           
        }
        
        else {
            
            let fileName = driverManagedObject.image
            let fileURL = documentsDirectory.appendingPathComponent(fileName!)
            
            nameLabel.text = driverManagedObject.name
            teamLabel.text = driverManagedObject.team
            
            if driverManagedObject.isFavourited == "yes"{
                favButton.setImage(UIImage(named: "goldStar"), for: .normal)
            }
            
            else {
                favButton.setImage(UIImage(named: "star"), for: .normal)
                
            }
            
            if fileName!.contains("-") {
                image.image = UIImage(contentsOfFile: fileURL.path)
            }
            else{
                image.image = UIImage(named: driverManagedObject.image!)
            }
        }
        return cell
        
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // get the managed object to delete
            driverManagedObject = (frc.object(at: indexPath) as! DriverModel)
            
            let imagefileName = driverManagedObject.image
            let carfileName = driverManagedObject.carImage
            
            // delete it from context
            context.delete(driverManagedObject)
            
            // delete associated images
            
            let fileManager = FileManager.default
            
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let url = NSURL(fileURLWithPath: path)
            
            
            
            for x in Range (0...1) {
                
                var fileName = ""
                
                if x == 0 { fileName = imagefileName!}
                if x == 1 {fileName = carfileName!}
                
                
                if let imagePath = url.appendingPathComponent(fileName) {
                    let filePath = imagePath.path
                    if  fileManager.fileExists(atPath: filePath) {
                        print("deleted imageFile")
                        
                        try! fileManager.removeItem(atPath: filePath)
                        
                    }
                    else {
                        print("no file at that path")
                    }
                    
                }
                
            }
            
            // save context
            do{ try context.save()} catch{print("core data didn't save")}
            
            // fetch and reload
            
            do{ try frc.performFetch()} catch{print("core data did not fetch")}
            tableView.reloadData()
        
            
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.backgroundView = UIImageView(image: UIImage(named: "backgroundImage"))
        //cell.backgroundView = UIImageView(image: UIImage(named: "backgroundImage2"))
        cell.backgroundColor = UIColor(white: 1, alpha: 0.1)
        
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    // takes in the search query and uses the drivers class to filter into a new list, then reloads the table data
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        do {
            // fetch core dat and store it in an array which can be filtered
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DriverModel")
            let sorter = NSSortDescriptor(key: "team", ascending: true)
            fetchRequest.sortDescriptors = [sorter]
            
            let results = try context.fetch(fetchRequest)
            let driverCoreData = results as! [DriverModel]
            
            filteredDrivers = driverCoreData.filter({ (driver : DriverModel) -> Bool
                in
                
                if searchBarIsEmpty() {
                    
                    return true
                } else {
                    var result = driver.name!.lowercased().contains(searchText.lowercased())
                    if scope == "Team" {
                    result = driver.team!.lowercased().contains(searchText.lowercased())
                    }
                    else if scope == "Country" {
                    result = driver.country!.lowercased().contains(searchText.lowercased())
                    }
                    return true && result
                }
                
            })
            
            tableView.reloadData()
        }
        catch{
            print("X25 error in filet content")
            
        }
    }
    
    // creates a request for a specific drivers name
    func getDriverForNameRequest(name: String) -> NSFetchRequest<NSFetchRequestResult>{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DriverModel")
        let sorter = NSSortDescriptor(key: "team", ascending: true)
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        fetchRequest.sortDescriptors = [sorter]
        return fetchRequest
        
    }
    
    func makeRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DriverModel")
        let sorter = NSSortDescriptor(key: "team", ascending: true)
        request.sortDescriptors = [sorter]
        
        do{
            let count = try context.count(for: request)
            if count != 0 {
                // do nothing
            }
            else {
                // when count is == 0 populate coreData
                populateCoreDataFromXml()
            }
        }
        catch{
            print("error")
        }
        return request
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addSegue"{
            // Get the new view controller using segue.destination.
            _ = segue.destination as! AddNewDriverViewController
        }
            
        else if segue.identifier == "favouritesSegue" {
            _ = segue.destination as! FavourtiesTableViewController
        }
            
        else if segue.identifier == "editSegue"{
            
            let destination = segue.destination as! AddNewDriverViewController
            
            let point = tableView.convert(CGPoint.zero, from: sender as! UIButton)
            
            let indexPath = tableView.indexPathForRow(at: point)
            
            if driversBeingFiltered() {
                destination.driverManagedObject  = filteredDrivers[indexPath!.row]
            }
            
            else {
                destination.driverManagedObject = frc.object(at: indexPath!) as? DriverModel
            }
        }
        
        
        else if segue.identifier == "tableSegue"{
            // Get the new view controller using segue.destination.
            let destination = segue.destination as! DriverViewController
            // Pass the selected object to the new view controller.
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
            // need to pass a different index if the user has filtered their search
            
            if driversBeingFiltered() {
                destination.driverData = filteredDrivers[indexPath!.row]
            }
            else {
                destination.driverData = frc.object(at: indexPath!) as? DriverModel
            }
            
        }
    }
    

}


extension DriverTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)

    }
}


extension DriverTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}


