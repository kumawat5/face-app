//
//  CheckIn.swift
//  faceapp
//
//  Created by ankur kumawat on 3/7/17.
//  Copyright © 2017 sixthsense. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import GooglePlaces
import SVProgressHUD

class CheckIn: UIViewController, CLLocationManagerDelegate {
    var placesClient: GMSPlacesClient!
   @IBOutlet weak var check_in_outlet: UIButton!
    @IBOutlet weak var address_lbl: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var place_name_lbl: UILabel!
    
    var lat = float_t()
    var lng = float_t()
    
    var check = String()
    
    var success = String()
    
    var old_lat = float_t()
    var old_lng = float_t()
    
    var event_get_lat = Array<String>()
    var event_get_lng = Array<String>()
    var event_lat = float_t()
    var event_lng = float_t()
    var event_name = Array<String>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.check_in_outlet.isEnabled = false
        SVProgressHUD.show(withStatus: NSLocalizedString("Please_Wait...", comment: ""))
        let myUrl = URL(string: "http://eleganteriors.co.in/toshow/location-chat/event_return.php");
        
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"// Compose a query string
        
        //let postString = "uid=\(UserDefaults.standard.value(forKey: "dict")!)&action=\("")&status=\("1")"
        //"email=\(login)&password=\(password)"
        
        //"email=\(login)&password=\(password)"
        
       // print(postString)
        
        //request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            //print("response = \(response)")
            
            //Let's convert response sent from a server side script to a NSDictionary object:
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if json != nil {
                    
                    print("===========ankur kumawat \(json!)")
                    OperationQueue.main.addOperation {
                        let locations = json?["status"]as? [[String:Any]]
                        for item in locations! {
                            let addr = item["address"] as! String
                            self.event_name.append(addr)
                            let lat_ev = item["lat"]as! String
                            self.event_get_lat.append(lat_ev)
                            let lng_ev = item["lng"]as! String
                            self.event_get_lng.append(lng_ev)
                            
                           
                        }
                        
                        
                        
                        
                        for (index, element) in self.event_get_lng.enumerated() {
                            //print(element)
                            //print(self.event_get_lat[index])
                            print(self.event_name[index])
                            
                            self.event_lat = (self.event_get_lat[index] as NSString).floatValue
                            self.event_lng = (element as NSString).floatValue
                            
                            let annotation = MKPointAnnotation()
                            

                            annotation.title = self.event_name[index]
                            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(self.event_lat), longitude: CLLocationDegrees(self.event_lng))
                            //annotation.imageName = "pin-map-7.png"
                            self.map.addAnnotation(annotation)
                            
                        }
                        
                  
                        SVProgressHUD .dismiss()
                        
                    }
                    
                }
            }
            catch {
                print(error)
            }
        }
        
        task.resume()

    
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        SVProgressHUD.show(withStatus: NSLocalizedString("Please_Wait...", comment: ""))
        
        let myUrl = URL(string: "http://eleganteriors.co.in/toshow/location-chat/checkin_status.php");
        
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"// Compose a query string
        
        let postString = "uid=\(UserDefaults.standard.value(forKey: "dict")!)&"
        //"email=\(login)&password=\(password)"
        //let postString = "uid=\("10")&"
        //"email=\(login)&password=\(password)"
        
        print(postString)
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            
            // You can print out response object
            //print("response = \(response)")
            
            //Let's convert response sent from a server side script to a NSDictionary object:
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if json != nil {
                    print(json!)
                    let resp = json?["success"]
                    print(resp!)
                    self.success = resp as! String
                    print(self.success)
                    if self.success == "1"
                    {
                        print("success")
                        let sucs = json?["details"]as! [String:Any]
                        let address = sucs["address"]
                        print(address!)
                        let place_name = sucs["name"]
                        print(place_name!)
                        let lat_old = sucs["lat"]
                        print(lat_old!)
                        self.old_lat = (lat_old as! NSString).floatValue
                        print(self.old_lat)
                        let lng_old = sucs["lng"]
                        print(lng_old!)
                        self.old_lng = (lng_old as! NSString).floatValue
                        print(self.old_lng)
                        OperationQueue.main.addOperation {
                            self.place_name_lbl.text = place_name as! String?
                            self.address_lbl.text = address as!String?
                            self.check_in_outlet.setTitle("Check Out",for: .normal)
                            
                            let center = CLLocationCoordinate2D(latitude: CLLocationDegrees(self.old_lat), longitude: CLLocationDegrees(self.old_lng))
                            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                            
                            
                            
                            self.map.setRegion(region, animated: true)
                            
                            let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(self.old_lat), CLLocationDegrees(self.old_lng))
                            let objectAnnotation = MKPointAnnotation()
                            objectAnnotation.coordinate = pinLocation
                            objectAnnotation.title = "My Location"
                            self.map.addAnnotation(objectAnnotation)
                            SVProgressHUD .dismiss()
                             self.check_in_outlet.isEnabled = true

                            
                        }
                        
                    }
                    else
                    {
                        OperationQueue.main.addOperation {
                        print("google search")
                        self.check_in_outlet.isEnabled = false
                        SVProgressHUD.show(withStatus: NSLocalizedString("Searching...", comment: ""))
                        
                        let yourOtherArray = ["MonkeysRule", "RemoveMe", "SwiftRules"]
                        
                        UserDefaults.standard.set(yourOtherArray, forKey: "array")
                        
                        
                        
                        self.placesClient = GMSPlacesClient.shared()
                        
                        
                        self.placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
                            if let error = error {
                                print("Pick Place error: \(error.localizedDescription)")
                                return
                            }
                            
                            // self.nameLabel.text = "No current place"
                            // self.addressLabel.text = ""
                            
                            if let placeLikelihoodList = placeLikelihoodList {
                                let place = placeLikelihoodList.likelihoods.first?.place
                                if let place = place {
                                    // self.nameLabel.text = place.name
                                    // print(place.name)
                                    self.place_name_lbl.text = place.name
                                    // print(place.coordinate.latitude)
                                    self.lat = float_t(place.coordinate.latitude)
                                    self.lng = float_t(place.coordinate.longitude)
                                    // print(place.coordinate.longitude)
                                    self.address_lbl.text = place.formattedAddress?.components(separatedBy: "").joined(separator: "\n")
                                    // print(place.formattedAddress?.components(separatedBy: ", ").joined(separator: "\n"))
                                    
                                    let center = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                                    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                                    
                                    
                                    
                                    self.map.setRegion(region, animated: true)
                                    
                                    let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude)
                                    
                                    let objectAnnotation = MKPointAnnotation()
                                    objectAnnotation.coordinate = pinLocation
                                    objectAnnotation.title = "My Location"
                                    
                                    self.map.addAnnotation(objectAnnotation)
                                    SVProgressHUD .dismiss()
                                    self.check_in_outlet.isEnabled = true
                                }
                            }
                        })
                        }

                }
                  //SVProgressHUD .dismiss()
                    
                    
                }
            }
            catch {
                print(error)
            }
        }
        
        task.resume()
    }

        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func check_IN(_ sender: Any) {
        
        if check_in_outlet.titleLabel?.text == "Check In" {
            self.check_in_outlet.isEnabled = false
            print("check in")
            UserDefaults.standard.set("Check In", forKey: "check_in")
            
            print(self.lat)
            print(self.lng)
            print(self.address_lbl.text!)
            print(self.place_name_lbl.text!)
            print(UserDefaults.standard.value(forKey: "dict")!)
            SVProgressHUD.show(withStatus: NSLocalizedString("Please_Wait", comment: ""))
            
            let myUrl = URL(string: "http://eleganteriors.co.in/toshow/location-chat/place_insert.php");
            
            var request = URLRequest(url:myUrl!)
            
            request.httpMethod = "POST"// Compose a query string
            
            let postString = "uid=\(UserDefaults.standard.value(forKey: "dict")!)&place_id=\("")&place_name=\(self.place_name_lbl.text!)&place_address=\(self.address_lbl.text!)&lat=\(self.lat)&lng=\(self.lng)&status=\("IN")"
            //"email=\(login)&password=\(password)"
            print(postString)
            
            request.httpBody = postString.data(using: String.Encoding.utf8);
            
            let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                
                if error != nil
                {
                    print("error=\(error)")
                    return
                }
                
                // You can print out response object
                //print("response = \(response)")
                
                //Let's convert response sent from a server side script to a NSDictionary object:
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    
                    if json != nil {
                        print(json!)
                        
                        OperationQueue.main.addOperation {
                            SVProgressHUD .dismiss()
                            //self.dismiss(animated: true, completion: nil)
                            self.check_in_outlet.setTitle("Check Out",for: .normal)
                            self.check_in_outlet.isEnabled = true
                            
                        }
                        
                    }
                }
                catch {
                    print(error)
                }
            }
            
            task.resume()
        }

        else{
            print("check out")
             self.check_in_outlet.isEnabled = false
            UserDefaults.standard.set("Check Out", forKey: "check_out")
            
            SVProgressHUD.show(withStatus: NSLocalizedString("Please_Wait", comment: ""))
            
            let myUrl = URL(string: "http://eleganteriors.co.in/toshow/location-chat/place_insert.php");
            
            var request = URLRequest(url:myUrl!)
            
            request.httpMethod = "POST"// Compose a query string
            
            let postString = "uid=\(UserDefaults.standard.value(forKey: "dict")!)&place_id=\("")&place_name=\(self.place_name_lbl.text!)&place_address=\(self.address_lbl.text!)&lat=\(self.lat)&lng=\(self.lng)&status=\("OUT")"
            //"email=\(login)&password=\(password)"
            print(postString)
            
            request.httpBody = postString.data(using: String.Encoding.utf8);
            
            let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                
                if error != nil
                {
                    print("error=\(error)")
                    return
                }
                
                // You can print out response object
                //print("response = \(response)")
                
                //Let's convert response sent from a server side script to a NSDictionary object:
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    
                    if json != nil {
                        print(json!)
                        
                        OperationQueue.main.addOperation {
                            SVProgressHUD .dismiss()
                            //self.dismiss(animated: true, completion: nil)
                           // self.check_in_outlet.setTitle("Check In",for: .normal)
                            //self.check_in_outlet.isEnabled = true
                            self.servicecall()
                        }
                        
                    }
                }
                catch {
                    print(error)
                }
            }
            
            task.resume()
        }
        
    }
    
  func servicecall()
  {
    print("google search")
    self.check_in_outlet.isEnabled = false
    SVProgressHUD.show(withStatus: NSLocalizedString("Searching...", comment: ""))
    
    self.placesClient = GMSPlacesClient.shared()
    
    
    self.placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
        if let error = error {
            print("Pick Place error: \(error.localizedDescription)")
            return
        }
        
        // self.nameLabel.text = "No current place"
        // self.addressLabel.text = ""
        
        if let placeLikelihoodList = placeLikelihoodList {
            let place = placeLikelihoodList.likelihoods.first?.place
            if let place = place {
                // self.nameLabel.text = place.name
                // print(place.name)
                self.place_name_lbl.text = place.name
                // print(place.coordinate.latitude)
                self.lat = float_t(place.coordinate.latitude)
                self.lng = float_t(place.coordinate.longitude)
                // print(place.coordinate.longitude)
                self.address_lbl.text = place.formattedAddress?.components(separatedBy: "").joined(separator: "\n")
                // print(place.formattedAddress?.components(separatedBy: ", ").joined(separator: "\n"))
                
                let center = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                
                
                
                self.map.setRegion(region, animated: true)
                
                let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude)
                let objectAnnotation = MKPointAnnotation()
                objectAnnotation.coordinate = pinLocation
                objectAnnotation.title = "My Location"
                self.map.addAnnotation(objectAnnotation)
                SVProgressHUD .dismiss()
                 self.check_in_outlet.setTitle("Check In",for: .normal)
                self.check_in_outlet.isEnabled = true
            }
        }
    })
    
    }




}







