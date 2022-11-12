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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(GIDSignIn.sharedInstance() ?? "Not signed in")
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
