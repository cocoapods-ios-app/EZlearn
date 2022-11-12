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
            print(animationView.animation ?? "nothing found")
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
        var appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let results:NSArray = try context.fetch(request) as NSArray
            print(results)
            for result in results
            {
                theUser = (result as! User).name!
            }
        } catch {
            print("Fetch Failed")
        }
                
        
        if (theUser.isEmpty) {
            playAnimation()
            print("no log in sorry")
        } else {
            GIDSignIn.sharedInstance().signIn()
            

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
            signedIn = true

            //self.signInButton.isHidden = true
            //self.output.isHidden = false
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            let emailAddress = user.profile?.email

            let fullName = user.profile?.name
            //let givenName = user.profile?.givenName
            //let familyName = user.profile?.familyName

            let profilePicUrl = user.profile?.imageURL(withDimension: 320)
            //print(fullName)
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

            let vc: UINavigationController = storyboard.instantiateViewController(withIdentifier: "homeNav") as! UINavigationController
            vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            print(vc.viewControllers)
            let homeView = (vc.viewControllers[0] as! ViewController)
            let splitName = fullName?.components(separatedBy: " ")

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
            let newUser = User(entity: entity!, insertInto: context)
            newUser.name = fullName
            newUser.email = emailAddress
            do {
                try newUser.icon = String(contentsOf: (profilePicUrl)!)
            } catch {
                newUser.icon = ""
            }
            do {
                try context.save()
                print(newUser)
            } catch {
                print("context save error")
                
            }


            self.present(vc, animated: true, completion: nil)
            
            homeView.usersName = splitName?[0] ?? "User"



            //fetchChannelResource()
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


