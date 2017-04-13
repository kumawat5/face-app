//
//  NearByPoeple.swift
//  faceapp
//
//  Created by ankur kumawat on 3/8/17.
//  Copyright © 2017 sixthsense. All rights reserved.
//

import UIKit
import SVProgressHUD


class NearByPoeple: UIViewController,UITableViewDataSource, UITableViewDelegate {
    var msg = String()
    
    var name = Array<String>()
    

    @IBOutlet weak var table_view: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
//        let result = UserDefaults.standard.value(forKey: "array")
//        print(result!)
        
        
       
        
      
        // Do any additional setup after loading the view.
        
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.name.removeAll()
        print("disappear====================================================")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SVProgressHUD.show(withStatus: NSLocalizedString("Search_People", comment: ""))
        
        let myUrl = URL(string: "http://eleganteriors.co.in/toshow/location-chat/currrent_chkin_people.php");
        
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
                    
                    
                    
                    let message = json?["error_message"]
                    self.msg = message as! String
                    if self.msg == "no user found"
                    {
                        OperationQueue.main.addOperation {
                            SVProgressHUD .dismiss()
                            let alert = UIAlertController(title: "No User Found", message: "Go to another place Check In", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                            
                        }
                    }
                    else if self.msg == "user is not checkin currently"
                    {
                        OperationQueue.main.addOperation {
                            SVProgressHUD .dismiss()
                            let alert = UIAlertController(title: "You Are Not Check In", message: "Please Check In current Place", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                            
                        }
                    }
                    else{
                        print("success")
                        
                       
                      let lists = json?["list"] as? [[String:Any]]
                       // print(jsons!)
                        
                       
                        for item in lists! {
                            let names = item["name"] as! String
                            print(names)
                            self.name.append(names)
                            
                            let img = item["profile_img"] as! String
                            print(img)
                            let uids = item["uid"] as! String
                            print(uids)
                        }
                        OperationQueue.main.addOperation {
                        print("names print \(self.name)")
                            SVProgressHUD .dismiss()
                        self.table_view.reloadData()
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
    // MARK: UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count
    }

       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cellIdentifier = "CellComment"
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! NearByCell?
        
        
        cell?.name_lbl.text = name[indexPath.row]
        // connect objects with our information from arrays
//        cell.usernameBtn.setTitle(usernameArray[indexPath.row], for: UIControlState.normal)
//        cell.usernameBtn.sizeToFit()
//        cell.commentLbl.text = commentArray[indexPath.row]
        return cell!
    }

    
}
