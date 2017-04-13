//
//  editProfile.swift
//  faceapp
//
//  Created by ankur kumawat on 3/7/17.
//  Copyright © 2017 sixthsense. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SVProgressHUD
class editProfile: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate  {
    @IBOutlet weak var image_view: UIImageView!
    @IBOutlet weak var tx_usename: SkyFloatingLabelTextField!
    @IBOutlet weak var tx_address: SkyFloatingLabelTextField!
    @IBOutlet weak var tx_aboutus: SkyFloatingLabelTextField!
    var imagePicker = UIImagePickerController()
    
    var name: String?
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.image_view.layer.cornerRadius = 64.0
        self.image_view.layer.masksToBounds = true
        // Do any additional setup after loading the view.
         imagePicker.delegate = self
        
        print(name ?? String())
        
        self.tx_usename.text = name
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func edit_image(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            print("Button capture")
            
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.image_view.image = image
        }
        else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.image_view.image = image
        } else{
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func done(_ sender: Any) {
        SVProgressHUD.show(withStatus: NSLocalizedString("Please_Wait", comment: ""))
        
        let myUrl = URL(string: "http://eleganteriors.co.in/toshow/location-chat/edit_profile.php");
        
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"// Compose a query string
        
        let postString = "name=\(self.tx_usename.text!)&address=\(self.tx_address.text!)&about=\(self.tx_aboutus.text!)&uid=\(UserDefaults.standard.value(forKey: "dict")!)"
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
                           self.dismiss(animated: true, completion: nil)
                            
                        }

                }
            }
            catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    
    @IBAction func back(_ sender: Any) {
       // navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }

}
