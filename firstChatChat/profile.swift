//
//  profile.swift
//  faceapp
//
//  Created by ankur kumawat on 3/7/17.
//  Copyright © 2017 sixthsense. All rights reserved.
//

import UIKit
import SVProgressHUD

class profile: UIViewController, QMChatServiceDelegate, QMChatConnectionDelegate, QMAuthServiceDelegate {
   private var observer: NSObjectProtocol?
    
    @IBOutlet weak var image_view: UIImageView!

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var aboutus: UILabel!
    
    @IBOutlet weak var update_btn_outlet: UIButton!
    
    let about_us = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.image_view.layer.cornerRadius = 64.0
        self.image_view.layer.masksToBounds = true
        
        let result = UserDefaults.standard.value(forKey: "dict")
        print(result!)
        
        
        
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Do any additional setup after loading the view.
       // SVProgressHUD.show(withStatus: NSLocalizedString("Please_Wait", comment: ""))
        let myUrl = URL(string: "http://eleganteriors.co.in/toshow/location-chat/profile_details.php");
        
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"// Compose a query string
        
        let postString = "uid=\(UserDefaults.standard.value(forKey: "dict")!)&"
        //"email=\(login)&password=\(password)"
        
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
                    let sucs = json?["details"]as! [String:Any]
                    print(sucs)
                    let name = sucs["name"]
                    print(name!)
                    let email = sucs["email"]
                    print(email!)
                    let address = sucs["address"]
                    print(address!)
                    let about = sucs["about"]
                    print("about us \(about!)")
                    
                    OperationQueue.main.addOperation {
                        
                        self.username.text = name as! String?
                        self.email.text = email as! String?
                        self.aboutus.text = about as! String?
                        self.address.text=address as! String?
                       // SVProgressHUD .dismiss()
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
    
    @IBAction func update(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UIViewControllerB") as! editProfile;
        vc.name = self.username.text
       // vc.uid_str =
        
        self.present(vc, animated: true, completion: nil)
       // self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func logout(_ sender: Any) {
        let prefs = UserDefaults.standard
        
        prefs.removeObject(forKey: "dict")
        
        if !QBChat.instance().isConnected {
            
            SVProgressHUD.showError(withStatus: "Error")
            return
        }
        
        SVProgressHUD.show(withStatus: "SA_STR_LOGOUTING".localized, maskType: SVProgressHUDMaskType.clear)
        
        ServicesManager.instance().logoutUserWithCompletion { [weak self] (boolValue) -> () in
            
            guard let strongSelf = self else { return }
            if boolValue {
                NotificationCenter.default.removeObserver(strongSelf)
                
                if strongSelf.observer != nil {
                    NotificationCenter.default.removeObserver(strongSelf.observer!)
                    strongSelf.observer = nil
                }
                
                ServicesManager.instance().chatService.removeDelegate(strongSelf)
                ServicesManager.instance().authService.remove(strongSelf)
                
                ServicesManager.instance().lastActivityDate = nil;
                
               // let _ = strongSelf.navigationController?.popToRootViewController(animated: true)
                self?.performSegue(withIdentifier: "logout", sender: self)
                
                SVProgressHUD.showSuccess(withStatus: "SA_STR_COMPLETED".localized)
            }
        }

        
        
        
    }
    
    

}
