//
//  Signup.swift
//  faceapp
//
//  Created by ankur kumawat on 3/6/17.
//  Copyright © 2017 sixthsense. All rights reserved.
//

import UIKit

import AssetsLibrary
import SVProgressHUD
class Signup: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var image_view: UIImageView!
    
    @IBOutlet weak var tx_username: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tx_email: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tx_pwd: SkyFloatingLabelTextField!
   var imagePicker = UIImagePickerController()
   var suc = NSNumber()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.image_view.layer.cornerRadius = 64.0
        self.image_view.layer.masksToBounds = true
        imagePicker.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func image_btn(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            print("Button capture")
            
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    
//    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
//    {
//        
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let imageUrl          = info[UIImagePickerControllerReferenceURL] as! NSURL
        print("imageurl \(imageUrl)")
        let imageName         = imageUrl.lastPathComponent
        print("imagename \(imageName)")
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        print("documentdir \(documentDirectory)")
        let photoURL          = NSURL(fileURLWithPath: documentDirectory)
        print("photourl \(photoURL)")
        let localPath         = photoURL.appendingPathComponent(imageName!)
        print("localpath \(localPath)")
        let image             = info[UIImagePickerControllerOriginalImage]as! UIImage
        print("image \(image)")
        
        self.image_view.image=image
        let data              = UIImagePNGRepresentation(image)
        print("data \(data)")
        do
        {
            try data?.write(to: localPath!, options: Data.WritingOptions.atomic)
            
            
            print("do \(photoURL)")
        }
        catch
        {
            // Catch exception here and act accordingly
        }
        
        self.dismiss(animated: true, completion: nil);
        
        //_ = UploadRequest()
        
    }
    
    
//    func UploadRequest()
//    {
//        let url = NSURL(string: "http://eleganteriors.co.in/toshow/location-chat/register.php")
//        
//        let request = NSMutableURLRequest(url: url! as URL)
//        request.httpMethod = "POST"
//        
//        let boundary = generateBoundaryString()
//        
//        //define the multipart request type
//        
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        let image = image_view
//        
//        if (image?.image == nil)
//        {
//            
//            return
//        }
//        
//        let image_data = UIImagePNGRepresentation((image?.image!)!)
//        
//        
//        if(image_data == nil)
//        {
//            return
//        }
//        
//        
//        let body = NSMutableData()
//        
//        let fname = "test.png"
//        let mimetype = "image/png"
//        
//        //define the data post parameter
//        
//        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
//        body.append("Content-Disposition:form-data; name=\"file\"\r\n\r\n".data(using: String.Encoding.utf8)!)
//        body.append("hi\r\n".data(using: String.Encoding.utf8)!)
//        
//        
//        
//        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
//        body.append("Content-Disposition:form-data; name=\"file\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
//        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
//        body.append(image_data!)
//        body.append("\r\n".data(using: String.Encoding.utf8)!)
//        
//        
//        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
//        
//        
//        
//        request.httpBody = body as Data
//        
//        
//        
//        let session = URLSession.shared
//        
//        
//        let task = session.dataTask(with: request as URLRequest) {
//            (
//            data, response, error) in
//            
//            guard let _:NSData = data as NSData?, let _:URLResponse = response, error == nil else {
//                print("error")
//                return
//            }
//            
//            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            print(dataString!)
//            
//        }
//        
//        task.resume()
//        
//        
//    }
//    
//    
//    func generateBoundaryString() -> String
//    {
//        return "Boundary-\(NSUUID().uuidString)"
//    }
    
    
//    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
//        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
//            self.image_view.image = image
//        }
//        else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            self.image_view.image = image
//        } else{
//            print("Something went wrong")
//        }
//        
//        self.dismiss(animated: true, completion: nil)
//    }
    
    @IBAction func registerration(_ sender: Any) {
    
        
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let passRegEx = "^[a-zA-Z\\-_,;.:#+*?=!§$%&/()@]+$"
       
        let passTest = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        
        if self.tx_username.text == ""  {
            let alert = UIAlertController(title: "Error", message: "Please enter username", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if emailTest .evaluate(with: self.tx_email.text) == false  {
            let alert = UIAlertController(title: "Error", message: "Please enter correct email", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if passTest.evaluate(with: self.tx_pwd.text) == false || ((self.tx_pwd.text?.characters.count)!<=7 || (self.tx_pwd.text?.characters.count)!>=21){
            let alert = UIAlertController(title: "Error", message: "Please enter minimum 8 and maximum 20 alphabet characters", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

        else{
        SVProgressHUD.show(withStatus: NSLocalizedString("Please_Wait", comment: ""))
        let user = QBUUser()
        user.password = tx_pwd.text!
        user.email = tx_email.text!
        user.fullName = tx_username.text!
        
            print("user text \(user.email)")
        
        QBRequest .signUp(user, successBlock: {(response: QBResponse?, user: QBUUser?)in
            print("ankur=== \(response)")
            print("user=== \(user)")
            let use_id = user?.id
            print("user_id == \(use_id)")
            //SVProgressHUD .dismiss()
            
            //////////////////////////////////////////////////////////////////////////////////
            
            let myUrl = URL(string: "http://eleganteriors.co.in/toshow/location-chat/register.php");
            
            var request = URLRequest(url:myUrl!)
            
            request.httpMethod = "POST"// Compose a query string
            
            let postString = "name=\(self.tx_username.text!)&email=\(self.tx_email.text!)&password=\(self.tx_pwd.text!)&chat_userid=\(use_id!)"
            //"email=\(login)&password=\(password)"
            print(postString)
            print("post string == \(postString)")
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
                        let sucs = json?["success"]
                        
                        self.suc = sucs as! NSNumber
                        //print(self.suc)
                        
                        if self.suc == 1
                        {
                            print("ankurkumawat")
                            OperationQueue.main.addOperation {
                                
                                SVProgressHUD .dismiss()
                                let uid = json?["uid"]
                                print(uid!)
                                UserDefaults.standard.set(uid, forKey: "dict")
                                
                               self.performSegue(withIdentifier: "gotologin", sender: self)
                                
                            }
                        }
                        else{
                            OperationQueue.main.addOperation {
                                SVProgressHUD .dismiss()
                                let alert = UIAlertController(title: "Error", message: "This Email Already Registred", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
                catch {
                    print(error)
                }
            }
            
            task.resume()
            //////////////////////////////////////////////////////////////////////////////////
            
        }, errorBlock: {(response:QBResponse)in
            print("kumawat==\(response)")
           // SVProgressHUD .dismiss()
            let myUrl = URL(string: "http://eleganteriors.co.in/toshow/location-chat/register.php");
            
            var request = URLRequest(url:myUrl!)
            
            request.httpMethod = "POST"// Compose a query string
            
            let postString = "name=\(self.tx_username.text!)&email=\(self.tx_email.text!)&password=\(self.tx_pwd.text!)"
            //"email=\(login)&password=\(password)"
            print(postString)
            print("post string == \(postString)")
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
                        let sucs = json?["success"]
                        
                        self.suc = sucs as! NSNumber
                        //print(self.suc)
                        
                        if self.suc == 1
                        {
                            print("ankurkumawat")
                            OperationQueue.main.addOperation {
                                
                                SVProgressHUD .dismiss()
                                let uid = json?["uid"]
                                print(uid!)
                               // UserDefaults.standard.set(uid, forKey: "dict")
                                
                                
                                
                            }
                        }
                        else{
                            OperationQueue.main.addOperation {
                                
                                let alert = UIAlertController(title: "Error", message: "This Email Already Registred", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
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

        })
            
        }
    }
    
    @IBAction func done(_ sender: Any) {
//        if (![self isFormValid]) {
//            
//            return;
//            
//        }

//        if !self .isFormValid() {
//            return
//        }
//       
//        
//        
//        
//        let error: NSError?
//        if (error != nil) {
//            
//            print("ankurkumawat")
//        }

       SVProgressHUD.show(withStatus: NSLocalizedString("Please_Wait", comment: ""))
        
        let myUrl = URL(string: "http://eleganteriors.co.in/toshow/location-chat/register.php");
        
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"// Compose a query string
        
        let postString = "name=\(self.tx_username.text!)&email=\(self.tx_email.text!)&password=\(self.tx_pwd.text!)"
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
                    let sucs = json?["success"]
                   
                    self.suc = sucs as! NSNumber
                    //print(self.suc)

                    if self.suc == 1
                    {
                        print("ankurkumawat")
                        OperationQueue.main.addOperation {
                            
                            SVProgressHUD .dismiss()
                            let uid = json?["uid"]
                            print(uid!)
                            UserDefaults.standard.set(uid, forKey: "dict")
                            
                            
                            self.performSegue(withIdentifier: "login", sender: self)
                        }
                    }
                    else{
                         OperationQueue.main.addOperation {
                            SVProgressHUD .dismiss()
                        let alert = UIAlertController(title: "Error", message: "This Email Already Registred", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
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
    
//    func isFormValid() -> Bool {
//        if (self.tx_username.text != nil && (self.tx_username.text!))
//        {
//            print("not valid")
//            //[self showErrorMessage:@"Please Choose Name "];
//            return false
//        }
//        return true
//
//        
//    }

//     MARK: - Validating the fields when "submit" is pressed
    
//    func showingTitleInAnimationComplete(_ completed: Bool) {
//        // If a field is not filled out, display the highlighted title for 0.3 seco
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
//            self.showingTitleInProgress = false
//            if(!self.isSubmitButtonPressed) {
//                self.hideTitleVisibleFromFields()
//            }
//        }
//    }

    
   

    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
}


//                    let sucs = json["success"]
//
//                    let uid = json["uid"]
//                    print(uid!)
//                    //print("The name of the airport is \(sucs!).")
//
//                    self.suc = sucs as! NSNumber
//                    //print(self.suc)
//
//                    if self.suc == 1
//                    {
//
//                    OperationQueue.main.addOperation {
//
//                        self.performSegue(withIdentifier: "login", sender: self)
//                    }
//
//                    }

