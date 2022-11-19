//
//  ProfileViewController.swift
//  EZlearn
//
//  Created by Sharonda Daniels on 11/12/22.
//

import UIKit
import GoogleSignIn
import CoreData
import Parse


class ProfileViewController: UIViewController {

    @IBOutlet weak var learningDateLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var badgesLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var countCompleted:Int = 0

    @IBOutlet weak var fifteenBadge: UIImageView!
    @IBOutlet weak var tenBadge: UIImageView!
    @IBOutlet weak var fiveBadge: UIImageView!
    @IBOutlet weak var stack: UIView!

    
    
    override func viewDidAppear(_ animated: Bool) {
        retrieveCompletedTask()
        if countCompleted >= 5 {
            fiveBadge.image = UIImage(named: "5unlocked")
        }
        if countCompleted >= 10 {
            tenBadge.image = UIImage(named: "10unlocked")
        }
        if countCompleted >= 15 {
            fifteenBadge.image = UIImage(named: "15unlocked")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var theUser : User!
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let results:NSArray = try context.fetch(request) as NSArray
            for result in results
            {
                theUser = result as? User
            }
        } catch {
            print("Fetch Failed")
        }
        print("here is the user's icon:")
        if (theUser.icon != nil) {
            if let url = URL(string: theUser.icon!) {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async { /// execute on main thread
                        self.iconImageView.image = UIImage(data: data)!
                        let newImage = self.makeRoundImg(img: self.iconImageView)
                        self.iconImageView.image = newImage
                        //self.iconImageView.layer.cornerRadius = 90
                    }
                }
                
                
                emailLabel.text = theUser.email
                nameLabel.text = theUser.name
                learningDateLabel.text = theUser.dayJoined
                
                
                task.resume()
            }} else {
                
                
                emailLabel.text = theUser.email
                nameLabel.text = theUser.name
                learningDateLabel.text = theUser.dayJoined
            }
        print(stack.center.y)
        print(badgesLabel.frame.origin.y + 30)
        stack.center.y = badgesLabel.frame.origin.y + 130
        stack.center.x = self.view.center.x - 65
        print(stack.center.y)
        print(badgesLabel.frame.origin.y + 30)
    }
    
    /*
     This code is from https://stackoverflow.com/questions/46299926/crop-image-to-be-circular-swift-3
     This code crops a square image into a circle and is used for the user icon
     */
    func makeRoundImg(img: UIImageView) -> UIImage {
        let imgLayer = CALayer()
        imgLayer.frame = img.bounds
        imgLayer.contents = img.image?.cgImage;
        imgLayer.masksToBounds = true;
        imgLayer.cornerRadius = img.frame.size.width/2
        UIGraphicsBeginImageContext(img.bounds.size)
        imgLayer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedImage!;
    }
    
    @IBAction func onLogout(_ sender: Any) {
        uploadData()
        GIDSignIn.sharedInstance().signOut()
        let newWelcome = WelcomeViewController()
    
        newWelcome.theUser = ""
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext

            let results:NSArray = try context.fetch(request) as NSArray
            for result in results {
                let theUser = result as! User
                context.delete(theUser)
            }
            try context.save()
        } catch {
            print("Fetch Failed")
        }
        
        request = NSFetchRequest<NSFetchRequestResult>(entityName: "LearningGoal")
        do {
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext

            let results:NSArray = try context.fetch(request) as NSArray
            for result in results {
                let theGoal = result as! LearningGoal
                context.delete(theGoal)
            }
            try context.save()
        } catch {
            print("Fetch Failed")
        }
        
        self.dismiss(animated: true)
        ((self.presentingViewController as! UINavigationController).viewControllers[0] as? WelcomeViewController)?.theUser = ""
        //self.present(WelcomeViewController(), animated: true)
        /*
        print("presentingviewcontrollers")
        print(self.presentingViewController)
        ((self.presentingViewController as! UINavigationController).viewControllers[0] as? WelcomeViewController)?.theUser = ""
*/
        //self.present(newWelcome, animated: true)
    }
    
    func uploadData() {
        var saveThisUser : User!
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        var request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let results:NSArray = try context.fetch(request) as NSArray
            for result in results
            {
                saveThisUser = result as? User
            }
            
        } catch {
            print("Fetch Failed")
        }
        
        let name = saveThisUser?.name
        let icon = saveThisUser?.icon
        let email = saveThisUser?.email
        let dayJoined = saveThisUser?.dayJoined
        var goals = [Any]()
        //var goals = [(String, Dictionary<String, Any>)]

        
        request = NSFetchRequest<NSFetchRequestResult>(entityName: "LearningGoal")
        do {
            let results:NSArray = try context.fetch(request) as NSArray
            for result in results
            {
                let theGoal = result as! LearningGoal
                let keyValPair = [theGoal.name: [[
                    "colorIndex": theGoal.colorIndex,
                    "completed": theGoal.completed,
                    "resources": theGoal.resources!
                ]]
                ]
                goals.append(keyValPair)
                //goals.append(result as! LearningGoal)
            }
            
        } catch {
            print("Fetch Failed")
        }
        
        let jsonObject: [Any]  = [[
            "name": name!,
                 "icon": icon ?? "",
                 "email": email!,
                 "learning goals":goals
        ]]
        do {
            let data1 = try JSONSerialization.data(withJSONObject: jsonObject)
            var str = data1.base64EncodedString()
            var str2 = str.toBase64()
            let converted = String(data: data1, encoding: .utf8)
            //print(converted!)
            
            let query = PFQuery(className: "GoogleUser")
            query.whereKey("email", equalTo:email ?? "")
            query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
                if let error = error {
                    // Log details of the failure
                    print(error.localizedDescription)
                } else if let objects = objects {
                    // The find succeeded.
                    if (objects.count == 0) {
                        // User didn't login with Google
                        var theLoggedIn = PFUser.getCurrentUserInBackground()
                        let theQuery = PFUser.query()
                        let newQuery = theQuery!.whereKey("email", equalTo: email)
                        //newQuery.getFirstObjectInBackground()
                        newQuery.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
                            if let error = error {
                                // Log details of the failure
                                print(error.localizedDescription)
                            } else if let objects = objects {
                                var userAsObject = objects[objects.count - 1]
                                print(userAsObject)
                                userAsObject["data"] = str2
                                
                                userAsObject.saveInBackground { (succeeded, error)  in
                                    if (succeeded) {
                                        // The object has been saved.
                                    } else {
                                        // There was a problem, check error.description
                                    }
                                }
                            }
                        }
                        
                           /*
                        }
                        theLoggedIn.value(forKey: "data")
                        print(theLoggedIn)*/
                        //theLoggedIn.
                        //PFUser.
                        //print("making a new google user")
                        //let newGoogleUser = PFObject(className:"GoogleUser")
                    } else {
                        let retrievedUser = objects[0]
                        print(retrievedUser)
                        retrievedUser["data"] = str2
                        
                        retrievedUser.saveInBackground { (succeeded, error)  in
                            if (succeeded) {
                                // The object has been saved.
                            } else {
                                // There was a problem, check error.description
                            }
                        }
                    }
                    
                    
                }}
        } catch {
            
        }
        
    }
    
    func retrieveCompletedTask() {
        countCompleted = 0
        var appDelegate = UIApplication.shared.delegate as! AppDelegate
        var context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LearningGoal")
        
        do {
            let results = try context.fetch(fetchRequest) as! [NSManagedObject]
            for result in results {
                if (result.value(forKey: "completed") as! Bool? == true) {
                    countCompleted += 1
                }
            }
        } catch {
            print("Fetch Failed: \(error)")
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

}
