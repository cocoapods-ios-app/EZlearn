//
//  WelcomeViewController.swift
//  EZlearn
//
//  Created by Sharonda Daniels on 11/11/22.
//

import UIKit
import Lottie

import GoogleAPIClientForREST
import GoogleSignIn
import UIKit
import CoreData
import Parse

class WelcomeViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    let animationView = LottieAnimationView()
    var signedIn = false
    var theUser = ""

    
    @IBOutlet weak var newToLabel: UIButton!
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    private let scopes = [kGTLRAuthScopeYouTubeReadonly]

    private let service = GTLRYouTubeService()
    //let signInButton = GIDSignInButton()
    let output = UITextView()
    
    @IBOutlet weak var containerView: UIView!
    
    let yourAttributes: [NSAttributedString.Key: Any] = [
          .underlineStyle: NSUnderlineStyle.single.rawValue
      ]
    override func viewDidLoad() {
            super.viewDidLoad()
            //GIDSignIn.sharedInstance().signOut()
            
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().uiDelegate = self
            let attributeString = NSMutableAttributedString(
                string: "New to EZlearn? Sign Up",
                attributes: yourAttributes
            )
            newToLabel.setAttributedTitle(attributeString, for: .normal)
            
        
        
            //signInButton.backgroundColor = UIColor.init(red: 0, green: 0, blue: 15/255, alpha: 1)
            
            
            // Add a UITextView to display output.
            output.frame = view.bounds
            output.isEditable = false
            output.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
            output.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            output.isHidden = true
            view.addSubview(output);
            
            
            //animationView.animation = LottieAnimation.named("28893-book-loading")
            animationView.animation = LottieAnimation.named("87271-atom-cascade-loader")
            
            //LottieAnimation.named("28893-book-loading")
            animationView.frame = containerView.bounds
            containerView.backgroundColor = .clear
            animationView.center = containerView.center
            //animationView.contentMode = .scaleAspectFit
            animationView.stop()
            playAnimation()
            
            view.addSubview(animationView)
        

        // Do any additional setup after loading the view.
        //setUpAnimation()
        
        // Add the sign-in button.
        //view.addSubview(signInButton)
        //signInButton.center = CGPoint(x: view.center.x, y: 600)
    }
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let results:NSArray = try context.fetch(request) as NSArray
            for result in results
            {
                theUser = (result as! User).name!
            }
        } catch {
            print("Fetch Failed")
        }
        if (theUser.isEmpty) {
            playAnimation()
        } else {
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

            let vc: UINavigationController = storyboard.instantiateViewController(withIdentifier: "homeNav") as! UINavigationController
            vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            let homeView = (vc.viewControllers[0] as! ViewController)
            /*
            let splitName = fullName?.components(separatedBy: " ")

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
            let newUser = User(entity: entity!, insertInto: context)
            newUser.name = fullName
            newUser.email = emailAddress
            newUser.icon = profilePicUrl?.absoluteString
            
            let dateComponents = (NSDate().description.components(separatedBy: " ")[0]).components(separatedBy: "-")
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
            
            let learningDate = month + " " + dateComponents[2] + dayPrefix + ", " + dateComponents[0]
            newUser.dayJoined = learningDate
            do {
                try context.save()
            } catch {
                print("context save error")
                
            }
*/

            self.present(vc, animated: true, completion: nil)
            
            homeView.usersName = theUser
        }
    }
    
    @IBAction func onSignInWithGoogle(_ sender: Any) {
        
        // Configure Google Sign-in.
        //GIDSignIn.sharedInstance().scopes = scopes
        //GIDSignIn.sharedInstance().signInSilently()
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            showAlert(title: "Authentication Error", message: error.localizedDescription)
            self.service.authorizer = nil
        } else {
            // Check if they've ever signed in through Google before
            //var outsideUser : PFObject!
            var learningDate = ""
            var splitName = [String]()
            let query = PFQuery(className: "GoogleUser")
            query.whereKey("email", equalTo:user.profile.email ?? "")
            query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
                if let error = error {
                    // Log details of the failure
                    print(error.localizedDescription)
                } else if let objects = objects {
                    // The find succeeded.
                    if (objects.count == 0) {
                        // Make a new google user
                        print("making a new google user")
                        let newGoogleUser = PFObject(className:"GoogleUser")
                        newGoogleUser["email"] = user.profile.email
                        newGoogleUser["name"] = user.profile.name
                        newGoogleUser["icon"] = user.profile?.imageURL(withDimension: 320).absoluteString
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
                        
                        
                        learningDate = String(finalDate).replacingOccurrences(of: ",", with: dayPrefix + ",")
                        newGoogleUser["dayJoined"] = learningDate
                        newGoogleUser.saveInBackground { (succeeded, error)  in
                            if (succeeded) {
                                // The object has been saved.
                            } else {
                                // There was a problem, check error.description
                            }
                        }
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
                        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
                        let newUser = User(entity: entity!, insertInto: context)
                        
                        
                        var fullName = user.profile.name!
                        var emailAddress = user.profile.email
                        var profilePicUrl = user.profile?.imageURL(withDimension: 320).absoluteString
                        splitName = fullName.components(separatedBy: " ")

                        
                        newUser.name = fullName
                        newUser.email = emailAddress
                        newUser.icon = profilePicUrl
                        print("this was saved")
                        print(learningDate)
                        newUser.dayJoined = learningDate
                        
                        
                        
                        do {
                            try context.save()
                        } catch {
                            print("context save error")
                            
                        }
                        
                        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc: UINavigationController = storyboard.instantiateViewController(withIdentifier: "homeNav") as! UINavigationController
                        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                        let homeView = (vc.viewControllers[0] as! ViewController)
                        self.present(vc, animated: true, completion: nil)
                        homeView.usersName = splitName[0]
                        
                    } else {
                        // Get the google user and the data
                        var userAsObject = objects[objects.count - 1]
                        learningDate = userAsObject["dayJoined"] as! String
                        //print(userAsObject["dayJoined"])
                        // Decode the JSON here
                        
                        
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
                        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
                        let newUser = User(entity: entity!, insertInto: context)
                        
                        
                        var fullName = user.profile.name!
                        var emailAddress = user.profile.email
                        var profilePicUrl = user.profile?.imageURL(withDimension: 320).absoluteString
                        splitName = fullName.components(separatedBy: " ")

                        
                        newUser.name = fullName
                        newUser.email = emailAddress
                        newUser.icon = profilePicUrl
                        newUser.dayJoined = learningDate
                        
                        
                        
                        
                        
                        do {
                            try context.save()
                        } catch {
                            print("context save error")
                            
                        }
                        
                        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc: UINavigationController = storyboard.instantiateViewController(withIdentifier: "homeNav") as! UINavigationController
                        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                        let homeView = (vc.viewControllers[0] as! ViewController)
                        self.present(vc, animated: true, completion: nil)
                        homeView.usersName = splitName[0]
                        
                        var userData = userAsObject["data"] as! String
                        userData = userData.fromBase64()!
                        userData = userData.fromBase64()!
                        do {
                            
                            let unserializedBSONDoc = try JSONSerialization.jsonObject(with: userData.data(using: .utf8)!) as! NSArray
                            let theDict = unserializedBSONDoc[0] as! NSDictionary
                            
                            // Here begins decoding
                            if let itemArray = theDict["learning goals"] as? NSArray {
                                for case let item as NSDictionary in itemArray {
                                    //var allTheKeys = item.allKeys
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
                                        do {
                                            try context.save()
                                            let thevc = (self.presentingViewController as? UINavigationController)?.viewControllers[0] as? ViewController
                                            thevc?.tasks.append(newGoal)
                                            thevc?.tableView.reloadData()
                                            //print(taskField.text ?? "Nada")
                                        } catch {
                                            print("context save error")
                                            
                                        }
                                    }
                                }
                            }
                            
                            
                        } catch {
                            
                        }
                        //let unserializedBSONDoc = try JSONSerialization.jsonObject(with: s2.data(using: .utf8)!)
                        

                        /*
                        print(userAsObject)
                        print("HERE!!")
                         */
                        /*
                            userAsObject["data"] = str2
                            
                            userAsObject.saveInBackground { (succeeded, error)  in
                                if (succeeded) {
                                    // The object has been saved.
                                } else {
                                    // There was a problem, check error.description
                                }
                            }*/
                    }
                }
            }
            
            

            


        }
    }
    
    /**
     This code is from https://github.com/airbnb/lottie-ios/issues/996
     */
    func playAnimation() {
        DispatchQueue.main.async {
            self.animationView.currentProgress = 0
            self.animationView.play()
            self.animationView.loopMode = .loop
        }
    }


    // List up to 10 files in Drive
    /*
    func fetchChannelResource() {
        let query = GTLRYouTubeQuery_ChannelsList.query(withPart: "snippet,statistics")
        query.identifier = "UC_x5XG1OV2P6uZZ5FSM9Ttw"
        // To retrieve data for the current user's channel, comment out the previous
        // line (query.identifier ...) and uncomment the next line (query.mine ...)
        // query.mine = true
        service.executeQuery(query,
                             delegate: self,
                             didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))
    }*/

    // Process the response and display output
    /*
    func displayResultWithTicket(
        ticket: GTLRServiceTicket,
        finishedWithObject response : GTLRYouTube_ChannelListResponse,
        error : NSError?) {

        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }

        var outputText = ""
        if let channels = response.items, !channels.isEmpty {
            let channel = response.items![0]
            let title = channel.snippet!.title
            let description = channel.snippet?.descriptionProperty
            let viewCount = channel.statistics?.viewCount
            outputText += "title: \(title!)\n"
            outputText += "description: \(description!)\n"
            outputText += "view count: \(viewCount!)\n"
        }
        output.text = outputText
    }
*/
    // Helper for showing an alert
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}
    
    private func setUpAnimation() {

        /*
        animationView.frame = self.containerView.bounds
                self.containerView.addSubview(animationView)
                animationView.play()
                animationView.loopAnimation = true*/
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


