//
//  SignUpViewController.swift
//  EZlearn
//
//  Created by Sharonda Daniels on 11/12/22.
//

import UIKit
import Parse
import CommonCrypto
import Foundation
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG
import CoreData

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var newUser: PFUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        changePlaceholderColors()
        
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    @IBAction func onCreateAccount(_ sender: Any) {
        /*
         var checkOne = firstNameTextField.text?.isEmpty
         var checkTwo = lastNameTextField.text?.isEmpty
         var checkThree = emailTextField.text?.isEmpty
         var checkFour = passwordTextField.text?.isEmpty
         */
        if firstNameTextField.text == "" || lastNameTextField.text == "" || emailTextField.text == "" || passwordTextField.text == "" {
            print("Blank error")
        } else {
            newUser = PFUser()
            let hashedPassword = SHA(string: passwordTextField.text!).base64EncodedString()
            //newUser.username = firstNameTextField.text! + "_" + lastNameTextField.text!
            newUser.setValue(firstNameTextField.text, forKey: "First")
            newUser.setValue(lastNameTextField.text, forKey: "Last")
            newUser.username = emailTextField.text
            newUser.email = emailTextField.text
            newUser.password = hashedPassword
            /*
            let formatter = DateFormatter()
            //formatter.date
            
            let dateComponents = (NSDate().description.components(separatedBy: " ")[0]).components(separatedBy: "-")
             let dayAsInteger = Int(dateComponents[2])
             var dayPrefix = ""
             switch dayAsInteger {
                 case 1, 21, 31:
                     dayPrefix = "st"
                 case 2, 22:
                     dayPrefix = "nd"
                 case 3, 23:
                     dayPrefix = "rd"
                 default:
                     dayPrefix = "th"
             }
            var month = ""
            switch dateComponents[1] {
            case "1":
                month = "January"
            case "2":
                month = "February"
            case "3":
                month = "March"
            case "4":
                month = "April"
            case "5":
                month = "May"
            case "6":
                month = "June"
            case "7":
                month = "July"
            case "8":
                month = "August"
            case "9":
                month = "September"
            case "10":
                month = "October"
            case "11":
                month = "November"
            case "12":
                month = "December"
            default:
                print("Month not found")
            }

            let dayAsInteger = Int(dateComponents[2])
            var dayPrefix = ""
            switch dayAsInteger {
                case 1, 21, 31:
                    dayPrefix = "st"
                case 2, 22:
                    dayPrefix = "nd"
                case 3, 23:
                    dayPrefix = "rd"
                default:
                    dayPrefix = "th"
            }
            
            let learningDate = month + " " + dateComponents[2] + dayPrefix + ", " + dateComponents[0]*/
            let dateAsString = Date().description(with: .current)
            let firstSpace = dateAsString.firstIndex(of: " ")!
            let theRange = dateAsString.range(of: " at")
            var finalDate = dateAsString[firstSpace..<theRange!.lowerBound]
            finalDate = finalDate.dropFirst()
            let dateComponents = finalDate.components(separatedBy: " ")
            let dayAsInteger = Int(dateComponents[1])
            var dayPrefix = ""
            switch dayAsInteger {
                case 1, 21, 31:
                 dayPrefix = "st"
                case 2, 22:
                 dayPrefix = "nd"
                case 3, 23:
                 dayPrefix = "rd"
                default:
                 dayPrefix = "th"
            }
            let learningDate = String(finalDate).replacingOccurrences(of: ",", with: dayPrefix + ", ")
            newUser.setValue(learningDate, forKey: "learningDate")
            newUser.setValue("", forKey: "icon")


            //let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            //newUser.setValue(context, forKey: "data")
            //PFO
            //newUser..data
            
            newUser.signUpInBackground{(success, error) in
                if success {
                    let vc: UINavigationController = self.storyboard!.instantiateViewController(withIdentifier: "homeNav") as! UINavigationController
                    vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                    let homeView = (vc.viewControllers[0] as! ViewController)
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
                    let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
                    let aNewUser = User(entity: entity!, insertInto: context)
                    let firstString = self.newUser?.value(forKey: "First") as! String
                    let secondString = self.newUser?.value(forKey: "Last") as! String
                    aNewUser.email = self.newUser?.email
                    aNewUser.name = firstString + " " + secondString
                    //aNewUser.icon = profilePicUrl?.absoluteString
                    
                    aNewUser.dayJoined = self.newUser?.value(forKey: "learningDate") as? String
                    do {
                        try context.save()
                    } catch {
                        print("context save error")
                    }
                    self.present(vc, animated: true, completion: nil)
                    
                    _ = self.navigationController?.popToRootViewController(animated: true)
                    //homeView.usersName = "hi"
                    homeView.usersName = self.newUser?.value(forKey: "First") as! String
                } else {
                    print ("Error: \(error?.localizedDescription ?? "none")")
                }
            }
            
        }
        /*
         Parse.initialize(with: <#T##ParseClientConfiguration#>)
         ParseClientConfiguration.
         var server = new ParseServer({
         
         })*/
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*
        if segue.identifier == "loginSegue" {
            if let home = segue.destination as? ViewController {
                home.usersName = newUser.value(forKey: "First") as! String
            }
        }*/
    }
        @IBAction func onToggleSecure(_ sender: Any) {
            passwordTextField.togglePasswordVisibility()
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
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    
    
    func changePlaceholderColors() {
        firstNameTextField.attributedPlaceholder =
        NSAttributedString(string: firstNameTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 1, alpha: 0.6)])
        lastNameTextField.attributedPlaceholder =
        NSAttributedString(string: lastNameTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 1, alpha: 0.6)])
        emailTextField.attributedPlaceholder =
        NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 1, alpha: 0.6)])
        passwordTextField.attributedPlaceholder =
        NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 1, alpha: 0.6)])
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: firstNameTextField.frame.height - 1, width: firstNameTextField.frame.width, height: 1.0)
        bottomLine.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 0.6)
        let bottomLine2 = CALayer()
        bottomLine2.frame = CGRect(x: 0.0, y: firstNameTextField.frame.height - 1, width: firstNameTextField.frame.width, height: 1.0)
        bottomLine2.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 0.6)
        let bottomLine3 = CALayer()
        bottomLine3.frame = CGRect(x: 0.0, y: firstNameTextField.frame.height - 1, width: firstNameTextField.frame.width, height: 1.0)
        bottomLine3.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 0.6)
        let bottomLine4 = CALayer()
        bottomLine4.frame = CGRect(x: 0.0, y: firstNameTextField.frame.height - 1, width: firstNameTextField.frame.width, height: 1.0)
        bottomLine4.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 0.6)
        
        lastNameTextField.borderStyle = UITextField.BorderStyle.none
        lastNameTextField.layer.addSublayer(bottomLine)
        emailTextField.borderStyle = UITextField.BorderStyle.none
        emailTextField.layer.addSublayer(bottomLine2)
        passwordTextField.borderStyle = UITextField.BorderStyle.none
        passwordTextField.layer.addSublayer(bottomLine3)
        firstNameTextField.borderStyle = UITextField.BorderStyle.none
        firstNameTextField.layer.addSublayer(bottomLine4)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
