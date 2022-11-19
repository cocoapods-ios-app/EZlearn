//
//  ProfileViewController.swift
//  EZlearn
//
//  Created by Sharonda Daniels on 11/12/22.
//

import UIKit
import GoogleSignIn
import CoreData


class ProfileViewController: UIViewController {
    var countCompleted:Int = 0

    @IBOutlet weak var fifteenBadge: UIImageView!
    @IBOutlet weak var tenBadge: UIImageView!
    @IBOutlet weak var fiveBadge: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(GIDSignIn.sharedInstance() ?? "Not signed in")
    }
    
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
    
    
    @IBAction func onLogout(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        self.dismiss(animated: true)
        let newWelcome = WelcomeViewController()
        newWelcome.theUser = ""
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext

            let results:NSArray = try context.fetch(request) as NSArray
            for result in results {
                let theUser = result as! User
                context.delete(theUser)
                try context.save()
            }
        } catch {
            print("Fetch Failed")
        }
        self.present(WelcomeViewController(), animated: true)
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
