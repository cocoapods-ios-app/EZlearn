//
//  SignInViewController.swift
//  EZlearn
//
//  Created by Sharonda Daniels on 11/12/22.
//

import UIKit
import Parse
import CommonCrypto
import Foundation
import CoreData

class SignInViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!
    
    var newUser: PFUser!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self


        // Do any additional setup after loading the view.
        changePlaceholderColors()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        var theUser = ""
        do {
            let results:NSArray = try context.fetch(request) as NSArray
            for result in results
            {
                theUser = (result as! User).name!
            }
        } catch {
            print("Fetch Failed")
        }
        print("first of all i ran")

        if (theUser == "") {
            print("second of all here is the user")
            print(theUser)
            self.dismiss(animated: false)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func changePlaceholderColors() {
        emailTextField.attributedPlaceholder =
        NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 1, alpha: 0.6)])
        passwordTextField.attributedPlaceholder =
        NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 1, alpha: 0.6)])
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: emailTextField.frame.height - 1, width: emailTextField.frame.width, height: 1.0)
        bottomLine.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 0.6)
        let bottomLine2 = CALayer()
        bottomLine2.frame = CGRect(x: 0.0, y: emailTextField.frame.height - 1, width: emailTextField.frame.width, height: 1.0)
        bottomLine2.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 0.6)
        
        
        emailTextField.borderStyle = UITextField.BorderStyle.none
        emailTextField.layer.addSublayer(bottomLine)
        passwordTextField.borderStyle = UITextField.BorderStyle.none
        passwordTextField.layer.addSublayer(bottomLine2)
    }
    
    @IBAction func onLogin(_ sender: Any) {
        if emailTextField.text == "" || passwordTextField.text == "" {
            print("Blank error")
        } else {
            //let email = emailTextField.text
            let hashedPassword = SHA(string: passwordTextField.text!).base64EncodedString()
            //PFUser.login
            PFUser.logInWithUsername(inBackground: emailTextField.text!, password: hashedPassword){ (user, error) in
                if user != nil {
                    do {
                        let vc: UINavigationController = self.storyboard!.instantiateViewController(withIdentifier: "homeNav") as! UINavigationController
                        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                        let homeView = (vc.viewControllers[0] as! ViewController)
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
                        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
                        let aNewUser = User(entity: entity!, insertInto: context)
                        let firstString = user?.value(forKey: "First") as! String
                        let secondString = user?.value(forKey: "Last") as! String
                        aNewUser.email = user?.email
                        aNewUser.name = firstString + " " + secondString
                        
                        //var theLoggedIn = PFUser.getCurrentUserInBackground()
                        let theQuery = PFUser.query()
                        let newQuery = theQuery!.whereKey("email", equalTo: user!.email!)
                        //newQuery.getFirstObjectInBackground()
                        //newQuery.findObjects()
                        var objects = try newQuery.findObjects()
                        var userAsObject = objects[objects.count - 1]
                        //print(userAsObject)
                        var userData = userAsObject["data"] as! String
                        userData = userData.fromBase64()!
                        userData = userData.fromBase64()!
                        do {
                            
                            let unserializedBSONDoc = try JSONSerialization.jsonObject(with: userData.data(using: .utf8)!) as! NSArray
                            let theDict = unserializedBSONDoc[0] as! NSDictionary
                            
                            // Here begins decoding
                            if let itemArray = theDict["learning goals"] as? NSArray {
                                for case let item as NSDictionary in itemArray {
                                    for (lGoal, settings) in item {
                                        let arraySets = settings as? NSArray
                                        let theVal = arraySets![0] as? NSDictionary
                                        
                                        // Insert to CoreData
                                        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
                                        let entity = NSEntityDescription.entity(forEntityName: "LearningGoal", in: context)
                                        let newGoal = LearningGoal(entity: entity!, insertInto: context)
                                        
                                        newGoal.name = lGoal as? String
                                        newGoal.colorIndex = theVal?.value(forKey: "colorIndex") as! Int64
                                        newGoal.resources = theVal?.value(forKey: "resources") as? String
                                        newGoal.completed = theVal?.value(forKey: "completed") as! Bool
                                        
                                    }
                                }
                            }
                            
                            
                        } catch {
                            
                        }
                        
                        userAsObject.saveInBackground { (succeeded, error)  in
                            if (succeeded) {
                                // The object has been saved.
                            } else {
                                // There was a problem, check error.description
                            }
                        }
                        
                        
                        //aNewUser.icon = profilePicUrl?.absoluteString
                        
                        aNewUser.dayJoined = user?.value(forKey: "learningDate") as? String
                        do {
                            try context.save()
                        } catch {
                            print("context save error")
                        }
                        self.present(vc, animated: true, completion: nil)
                        
                        _ = self.navigationController?.popToRootViewController(animated: true)
                        //homeView.usersName = "hi"
                        homeView.usersName = user?.value(forKey: "First") as! String
                    } catch {
                        
                    }
                    
                    
                }
            }
        }
    }
    
    
    
    @IBAction func onToggleSecure(_ sender: Any) {
        passwordTextField.togglePasswordVisibility()
    }
    @IBAction func onChangeToSign(_ sender: Any) {
        _ = self.navigationController?.popToRootViewController(animated: true)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SignUp") as! SignUpViewController
        self.navigationController?.pushViewController(newViewController, animated: true)
        //self.navigationController?.pushViewController(SignUpViewController(), animated: true)
        //print(self.navigationController?.viewControllers)
        //self.navigationController?.popToViewController(self.navigationController?.viewControllers[1], animated: true)
    }
    
    
    /**
     Code is from https://stackoverflow.com/questions/32163848/how-can-i-convert-a-string-to-an-md5-hash-in-ios-using-swift
     */
    func SHA(string: String) -> Data {
        let length = Int(CC_SHA256_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: length)
        
        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_SHA256(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    

}
