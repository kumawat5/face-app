//
//  visible.swift
//  faceapp
//
//  Created by ankur kumawat on 3/7/17.
//  Copyright © 2017 sixthsense. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import SVProgressHUD

class visible: UIViewController , CLLocationManagerDelegate {
    @IBOutlet weak var map: MKMapView!
    var locationManager: CLLocationManager!
    
    @IBOutlet weak var visible_btn_outlet: UISwitch!
    
    var status = String()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.visible_btn_outlet.isEnabled = false
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        SVProgressHUD.show(withStatus: NSLocalizedString("Please_Wait", comment: ""))
        
        let myUrl = URL(string: "http://eleganteriors.co.in/toshow/location-chat/change_visibility.php");
        
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"// Compose a query string
        
         let postString = "uid=\(UserDefaults.standard.value(forKey: "dict")!)&action=\("status")&"
        //"email=\(login)&password=\(password)"
        
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
                   
                    print("=========== \(json!)")
                    let stat = json?["status"]
                    print(stat!)
                    
                    self.status = stat as! String
                    print(self.status)
                    
                    if self.status == "0"
                    {
                        print("status is 0")
                        OperationQueue.main.addOperation {
                            self.visible_btn_outlet.setOn(false, animated: true);
                            self.visible_btn_outlet.isEnabled = true
                            SVProgressHUD .dismiss()
                        }

                    }
                    else{
                        print("status is 1")
                        OperationQueue.main.addOperation {
                            self.visible_btn_outlet.setOn(true, animated: true);
                            self.visible_btn_outlet.isEnabled = true
                            SVProgressHUD .dismiss()
                        }
                    }
                    
                    
                    
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        print(location.coordinate.latitude)
        print(location.coordinate.longitude)
        
        self.map.setRegion(region, animated: true)
        
//        let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
//        let objectAnnotation = MKPointAnnotation()
//        objectAnnotation.coordinate = pinLocation
//        objectAnnotation.title = "My Location"
//        self.map.addAnnotation(objectAnnotation)
    }
    
    @IBAction func visible_action(_ sender: Any) {
        if (sender as AnyObject).isOn == true{
            self.visible_btn_outlet.isEnabled = false
            print("on")
            SVProgressHUD.show(withStatus: NSLocalizedString("Please_Wait", comment: ""))
            
            let myUrl = URL(string: "http://eleganteriors.co.in/toshow/location-chat/change_visibility.php");
            
            var request = URLRequest(url:myUrl!)
            
            request.httpMethod = "POST"// Compose a query string
            
            let postString = "uid=\(UserDefaults.standard.value(forKey: "dict")!)&action=\("")&status=\("1")"
            //"email=\(login)&password=\(password)"
            
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
                        
                        print("=========== \(json!)")
                         OperationQueue.main.addOperation {
                        SVProgressHUD .dismiss()
                        self.visible_btn_outlet.isEnabled = true
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
            print("off")
            self.visible_btn_outlet.isEnabled = false
            
            SVProgressHUD.show(withStatus: NSLocalizedString("Please_Wait", comment: ""))
            
            let myUrl = URL(string: "http://eleganteriors.co.in/toshow/location-chat/change_visibility.php");
            
            var request = URLRequest(url:myUrl!)
            
            request.httpMethod = "POST"// Compose a query string
            
            let postString = "uid=\(UserDefaults.standard.value(forKey: "dict")!)&action=\("")&status=\("0")"
            //"email=\(login)&password=\(password)"
            
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
                        
                        print("=========== \(json!)")
                        OperationQueue.main.addOperation {
                            SVProgressHUD .dismiss()
                            self.visible_btn_outlet.isEnabled = true
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
    
    
}
