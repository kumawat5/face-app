//
//  LoginTableViewController.swift
//  sample-chat-swift
//
//  Created by Anton Sokolchenko on 3/31/15.
//  Copyright (c) 2015 quickblox. All rights reserved.
//

import UIKit

/**
 *  Default test users password
 */

class LoginTableViewController: UsersListTableViewController, NotificationServiceDelegate {
   
    var suc = NSNumber()
    @IBOutlet weak var tx_id: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tx_pwd: SkyFloatingLabelTextField!
   
    
    
    @IBOutlet weak var buildNumberLabel: UILabel!

    // MARK: ViewController overrides
    
    override func viewDidLoad() {
		super.viewDidLoad()
		
		//self.buildNumberLabel.text = self.versionBuild();
        
		guard let currentUser = ServicesManager.instance().currentUser() else {
			return
		}
        
		currentUser.password = UserDefaults.standard.value(forKey: "pwd") as! String?
		
		SVProgressHUD.show(withStatus: "SA_STR_LOGGING_IN_AS".localized + currentUser.email!, maskType: SVProgressHUDMaskType.clear)
		
		// Logging to Quickblox REST API and chat.
		ServicesManager.instance().logIn(with: currentUser, completion: {
			[weak self] (success,  errorMessage) -> Void in
			
			guard let strongSelf = self else {
                return
            }
			
			guard success else {
				SVProgressHUD.showError(withStatus: errorMessage)
				return
			}
			
			strongSelf.registerForRemoteNotification()
			SVProgressHUD.showSuccess(withStatus: "SA_STR_LOGGED_IN".localized)
			
			if (ServicesManager.instance().notificationService.pushDialogID != nil) {
				ServicesManager.instance().notificationService.handlePushNotificationWithDelegate(delegate: strongSelf)
			}
			else {
				strongSelf.performSegue(withIdentifier: "SA_STR_SEGUE_GO_TO_DIALOGS".localized, sender: nil)
			}
			})
		
		//self.tableView.reloadData()
    }

    // MARK: NotificationServiceDelegate protocol
	
    func notificationServiceDidStartLoadingDialogFromServer() {
        SVProgressHUD.show(withStatus: "SA_STR_LOADING_DIALOG".localized, maskType: SVProgressHUDMaskType.clear)
    }
	
    func notificationServiceDidFinishLoadingDialogFromServer() {
        SVProgressHUD.dismiss()
    }
    
    func notificationServiceDidSucceedFetchingDialog(chatDialog: QBChatDialog!) {
        
        let dialogsController = self.storyboard?.instantiateViewController(withIdentifier: "DialogsViewController") as! DialogsViewController
        let chatController = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        chatController.dialog = chatDialog

        self.navigationController?.viewControllers = [dialogsController, chatController]
    }
    
    func notificationServiceDidFailFetchingDialog() {
        self.performSegue(withIdentifier: "SA_STR_SEGUE_GO_TO_DIALOGS".localized, sender: nil)
    }
    
    // MARK: Actions
	
	/**
	Login in chat with user and register for remote notifications
	
	- parameter user: QBUUser instance
	*/
    func logInChatWithUser() {
        
        if self.tx_id.text == "" || self.tx_pwd.text == "" {
            let alert = UIAlertController(title: "Error", message: "Please fill the both filds", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
        
        
        let userq = QBUUser()
        userq.email = tx_id.text!
        userq.password = tx_pwd.text!
        
        SVProgressHUD.show(withStatus: "SA_STR_LOGGING_IN_AS".localized + userq.email!, maskType: SVProgressHUDMaskType.clear)
        // Logging to Quickblox REST API and chat.
        ServicesManager.instance().logIn(with: userq, completion:{
            [unowned self] (success, errorMessage) -> Void in

			guard success else {
				SVProgressHUD.showError(withStatus: errorMessage)
				return
			}
            let postString = ["email": self.tx_id.text!, "password": self.tx_pwd.text!] as Dictionary<String, String>
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
                                UserDefaults.standard.set(self.tx_pwd.text!, forKey: "pwd")
                                
                                
                                
                                self.registerForRemoteNotification()
                                self.performSegue(withIdentifier: "SA_STR_SEGUE_GO_TO_DIALOGS".localized, sender: nil)
                                SVProgressHUD.showSuccess(withStatus: "SA_STR_LOGGED_IN".localized)
                            }
                            
                        }
                        else{
                            OperationQueue.main.addOperation {
                                SVProgressHUD .dismiss()
                                let alert = UIAlertController(title: "Error", message: "Your id and Password is incorrect", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                self.tx_id.text = ""
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

			
			
			
        })
        }
    }
    
    @IBAction func back_btn(_ sender: Any) {
    
        dismiss(animated: true, completion: nil)
    }
	
    // MARK: Remote notifications
    
    func registerForRemoteNotification() {
        // Register for push in iOS 8
        if #available(iOS 8.0, *) {
            let settings = UIUserNotificationSettings(types: [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
        else {
            // Register for push in iOS 7
            UIApplication.shared.registerForRemoteNotifications(matching: [UIRemoteNotificationType.badge, UIRemoteNotificationType.sound, UIRemoteNotificationType.alert])
        }
    }
    
    // MARK: UITableViewDataSource

//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SA_STR_CELL_USER".localized, for: indexPath) as! UserTableViewCell
//        cell.isExclusiveTouch = true
//        cell.contentView.isExclusiveTouch = true
//        
//        let user = self.users[indexPath.row]
//        
//        cell.setColorMarkerText(String(indexPath.row + 1), color: ServicesManager.instance().color(forUser: user))
//        cell.userDescription = "SA_STR_LOGIN_AS".localized + " " + user.fullName!
//        cell.tag = indexPath.row
//        
//        return cell
//    }
//    
//    // MARK: UITableViewDelegate
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        tableView.deselectRow(at: indexPath, animated:true)
//        
//        let user = self.users[indexPath.row]
//        user.password = kTestUsersDefaultPassword
//        
//        //self.logInChatWithUser(user: user)
//    }
    
    
    
    
   
    @IBAction func login(_ sender: Any) {
        
    
//        QBRequest .logIn(withUserLogin: tx_login_id.text!, password: "Xvm123DqkM", successBlock: {(response: QBResponse?, user: QBUUser?)in
//            
//            
//            print("ankur=== \(response)")
//            print("user=== \(user)")
            self.logInChatWithUser()
            
            
            
//        }, errorBlock: {(response:QBResponse)in
//            print("kumawat==\(response)")
//            
//        })

    }
   
    //MARK: Helpers
    
    func appVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    func build() -> String {
         return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }

    func versionBuild() -> String {
        
        let version = self.appVersion()
        let build = self.build()
        var versionBuild = String(format:"v%@",version)
        if version != build {
            versionBuild = String(format:"%@(%@)", versionBuild, build )
        }
        return versionBuild as String!
    }
}
