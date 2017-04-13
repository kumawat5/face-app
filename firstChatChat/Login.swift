//
//  Login.swift
//  faceapp
//
//  Created by ankur kumawat on 3/6/17.
//  Copyright © 2017 sixthsense. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SVProgressHUD

class Login: UIViewController {
    @IBOutlet weak var tx_usr: SkyFloatingLabelTextField!

    @IBOutlet weak var tx_pwd: SkyFloatingLabelTextField!
    
  
    var suc = NSNumber()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func login(_ sender: Any) {
        if self.tx_usr.text == "" || self.tx_pwd.text == "" {
            let alert = UIAlertController(title: "Error", message: "Please fill the both filds", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
        SVProgressHUD.show(withStatus: NSLocalizedString("LOGIN_PROGRESS", comment: ""))
            
        let postString = ["email": self.tx_usr.text!, "password": self.tx_pwd.text!] as Dictionary<String, String>
        print(postString)
        
        //create the url with URL
        let url = URL(string: "http://eleganteriors.co.in/toshow/location-chat/signin.php")! //change the url
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
           
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    
                    print(json)
                    let sucs = json["success"]
                    
                    
                   
                    self.suc = sucs as! NSNumber
                    //print(self.suc)
                    
                    if self.suc == 1
                    {
                        print("ankurkumawat")
                        OperationQueue.main.addOperation {
                            
                          SVProgressHUD .dismiss()
                            
                            let detail = json["details"] as? [String:Any]
                            let uid = detail?["uid"]
                            print(uid!)
                            UserDefaults.standard.set(uid, forKey: "dict")
                            
                            
                        self.performSegue(withIdentifier: "login", sender: self)
                        }
                        
                    }
                    else{
                         OperationQueue.main.addOperation {
                            SVProgressHUD .dismiss()
                        let alert = UIAlertController(title: "Error", message: "Your id and Password is incorrect", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                            self.tx_usr.text = ""
                            self.tx_pwd.text = ""
                        }
                        
                    }
                    
                    
                }
                
                
            }
            
            catch let error {
                print(error.localizedDescription)
            }
        })
        
        task.resume()
        
    }
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
