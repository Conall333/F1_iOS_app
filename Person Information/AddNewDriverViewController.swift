//
//  AddNewDriverViewController.swift
//  F1 Grid Viewer
//
//  Created by Conall Mc Carthy on 24/03/2019.
//  Copyright © 2019 Conall Mc Carthy. All rights reserved.
//

import UIKit
import CoreData
import Photos

class AddNewDriverViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    let imagePicker = UIImagePickerController()
    
    var ImageType = ""
    var carImageName = ""
    var driverImageName = ""
    var carUIImage = UIImage()
    var driverUIImage = UIImage()
    var spinner : UIView?
    var download1Complete = "done"
    var download2Complete = "done"
    var attemptsCounter = 0

    // core data objects context, entity, managedObjects
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var driverManagedObject : DriverModel!
    
    func save() { // save a new managed object
        
        // make a new managed object
        driverManagedObject = DriverModel(context: context)
        //fill with data from textfields
        
        driverManagedObject.name = nameTextField.text
        driverManagedObject.team = teamTextField.text
        driverManagedObject.races = racesTextField.text
        driverManagedObject.country = countryTextField.text
        driverManagedObject.points = ponitsTextField.text
        driverManagedObject.isFavourited = "no"

        
        driverManagedObject.carImage = carImageName
        saveImageToDocuments(image: carUIImage, fileName: carImageName)
        
        saveImageToDocuments(image: driverUIImage, fileName: driverImageName)
        driverManagedObject.image = driverImageName
        
        // save
        
        do {
            try context.save()
            
        } catch {
            print("error, core data does not save")
        }

    }
    
    
    func update() { // save a new managed object
        
        //fill with data from textfields
        driverManagedObject.name = nameTextField.text
        driverManagedObject.team = teamTextField.text
        driverManagedObject.races = racesTextField.text
        driverManagedObject.country = countryTextField.text
        driverManagedObject.points = ponitsTextField.text
        
        print("X25 carImageName:" + carImageName)
        
        if carImageName != "" {
            
            driverManagedObject.carImage = carImageName
            saveImageToDocuments(image: carUIImage, fileName: carImageName)
        }
        
        if driverImageName != "" {
            saveImageToDocuments(image: driverUIImage, fileName: driverImageName)
            driverManagedObject.image = driverImageName
        }
            
        // save
        
        do {
            
            try context.save()
            
            
        } catch {
            print("error, core data does not save")
        }
        
    }
    
    @IBAction func driverButton(_ sender: Any) {
        ImageType = "driver"
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func carButton(_ sender: Any) {
        ImageType = "car"
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func randomImgBtn(_ sender: UISwitch) {
        if sender.isOn {
            downloadNewDriverImage()
        }
        else {
            driverImageName = ""
            driverUIImage = UIImage()
            
        }
    }
    
    
    @IBAction func randomCarBtn(_ sender: UISwitch) {
        if sender.isOn {
            downloadNewCarImage()
        }
        else {
            carImageName = ""
            carUIImage = UIImage()
        }
    }
    
    
    
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var teamTextField: UITextField!
    @IBOutlet weak var racesTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var ponitsTextField: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func addUpdateAction(_ sender: Any) {
        
        if attemptsCounter == 2 {
            
            let alert = UIAlertController(title: nil, message: "cannot download image form api, please try again later", preferredStyle: .alert)
            alert.view.backgroundColor = .black
            alert.view.alpha = 0.5
            alert.view.layer.cornerRadius = 15
            
            self.present(alert, animated: true)

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                alert.dismiss(animated: true)
            }
        
        }
        
        else {
        
        
            if download1Complete != "done" || download2Complete  != "done" {
                
                let alert = UIAlertController(title: nil, message: "waiting for download to complete", preferredStyle: .alert)
                alert.view.backgroundColor = .black
                alert.view.alpha = 0.5
                alert.view.layer.cornerRadius = 15
                
                self.present(alert, animated: true)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                        alert.dismiss(animated: true)
                    
                    if self.download1Complete == "done" && self.download2Complete  == "done" {
                        self.attemptsCounter = 0
                    }
                    
                    }
            }
        

            else {
                    if driverManagedObject != nil{
                        update()
                    } else {
                        save()
                    }
                    navigationController?.popViewController(animated: true)
                
            }
        }
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.sourceType = .photoLibrary
        addButton.clipsToBounds = true
        addButton.layer.cornerRadius = 17.5
        
        self.title = "Add/Update Driver"
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundImage.png")!)
        

        if driverManagedObject != nil {
            nameTextField.text = driverManagedObject.name
            teamTextField.text = driverManagedObject.team
            racesTextField.text = driverManagedObject.races
            countryTextField.text = driverManagedObject.country
            ponitsTextField.text = driverManagedObject.points
        }
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage]! as! UIImage
        holdImage(type: ImageType, image: selectedImage)
        dismiss(animated: true, completion: nil)
        
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // there isn't any api that can give me acess to f1 images so i used an api that can give me pictures of cars and people instead
    
    func downloadNewCarImage(){
        let urlString = URL(string: "https://api.unsplash.com/photos/random?&collections=3567802/fast-cars&orientation=landscape")
        let fileManager = FileManager()
        download2Complete = "nope"
        
        fileManager.getPersonImageUrl(url: urlString!, completion: { (returnedString) in
            print("X25: " + returnedString)
            fileManager.downloadImage(url: URL(string: returnedString)!, completion: { (returnedImage,done) in
                self.holdImage(type: "car", image: returnedImage)
                self.download2Complete = done
                
            })
        })
        
    }
    
    func downloadNewDriverImage() {
        let urlString = URL(string: "https://api.unsplash.com/photos/random?&collections=4498490/head-shots&orientation=portrait")
        let fileManager = FileManager()
        download1Complete = "nope"
        
        fileManager.getPersonImageUrl(url: urlString!, completion: { (returnedString) in
            print("X25: " + returnedString)
            fileManager.downloadImage(url: URL(string: returnedString)!, completion: { (returnedImage,done) in
                self.holdImage(type: "driver", image: returnedImage)
                self.download1Complete = done
                
            })
        })
        
    }
    
    
    // temporarly holds the most recent image selections and their names
    func holdImage(type: String, image: UIImage){
            
        let fileName = "(\(UUID().uuidString).jpg"
        
        if type == "driver" {
             driverImageName = fileName
             driverUIImage = image
        }
        
        else {
            carImageName = fileName
            carUIImage = image
                
        }
        
    }
    
    // saves an image to the documents with a given filename
    func saveImageToDocuments(image: UIImage, fileName: String){
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if let data = image.jpegData(compressionQuality:  0.5),
            !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                // writes the image data to disk
                try data.write(to: fileURL)
                
            }
            catch{
                print("unable to save image")
            }
            
        }
        
    }
    
}

// downloads an image from a given url
extension FileManager {
    func downloadImage(url : URL, completion:@escaping (UIImage,String) -> Void) {
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let image = UIImage.init(data: data){
                    print("we have image")
                    DispatchQueue.main.async {
                        completion(image,"done")
                    }
                }
            }
            
        }
        task.resume()
    }
    
}

//  sends a request to the unsplash api and returns the url of an image
extension FileManager {
    func getPersonImageUrl(url : URL, completion:@escaping (String) -> Void) {
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Client-ID 854f0609dd77881332ce6970abfba23c648d6a14dde7bc964ac07c12101b9200", forHTTPHeaderField: "Authorization")
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data {
                do {
                let imageData = try JSONDecoder().decode(ImageResponseFormat.self, from: data)
                let returnedUrl = imageData.urls.regular
                    DispatchQueue.main.async {
                        completion(returnedUrl);
                    }
                }catch{print(error)}
                
                }
        }
        task.resume()
    }
    
}


// structures for api json response
struct ImageResponseFormat: Decodable {
    let id: String
    let width: Int
    let height: Int
    let likes: Int
    let color: String
    let urls: ResponseURLs
    let keyNotExist: String?
}


struct ResponseURLs: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}





