//
//  ViewController.swift
//  EZlearn
//
//  Created by Sharonda Daniels on 10/28/22.
//
import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIBarPositioningDelegate, UINavigationBarDelegate {
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    let cellReuseIdentifier = "cell"
    let defaultValues = UserDefaults.standard
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var tasks:[LearningGoal] = []
    var taskToAdd:UserTask? = nil
    var firstLoad = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        navBar.delegate = self
        
        // Retrieve from CoreData
        if(firstLoad) {
            firstLoad = false
            appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LearningGoal")
            do {
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results
                {
                    let theGoal = result as! LearningGoal
                    tasks.append(theGoal)
                }
            } catch {
                print("Fetch Failed")
            }
        }
        
         /*
        // Edit from CoreData
        //var appDelegate = UIApplication.shared.delegate as! AppDelegate
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LearningGoal")
        do {
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext

            let results:NSArray = try context.fetch(request) as NSArray
            for result in results {
                let theGoal = result as! LearningGoal
                if(theGoal.name == "testTask") {
                    theGoal.name = "I was changed"
                    try context.save()
                }
            }
        } catch {
            
            print("Fetch Failed")
        }
        
        // Delete from CoreData
        //var appDelegate = UIApplication.shared.delegate as! AppDelegate
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LearningGoal")
        do {
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext

            let results:NSArray = try context.fetch(request) as NSArray
            for result in results {
                let theGoal = result as! LearningGoal
                context.delete(theGoal)
                try context.save()
            }
        } catch {
            
            print("Fetch Failed")
        }*/
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = UserDefaults.standard.object(forKey:"usersTasks") as? Data,
           let category = try? JSONDecoder().decode(UserTask.self, from: data) {
             print(category.name)
        }
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TaskTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! TaskTableViewCell
        cell.taskName.text = tasks[indexPath.item].name
        
        return cell
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
            return .topAttached
        }

}


/*
import GoogleSignIn
import GoogleAPIClientForREST
import UIKit

class ViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    private let scopes = [kGTLRAuthScopeYouTubeReadonly]

    private let service = GTLRYouTubeService()
    let signInButton = GIDSignInButton()
    let output = UITextView()
    var titles = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure Google Sign-in.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().signInSilently()

        // Add the sign-in button.
        signInButton.center = CGPoint(x: 30.0, y: 60.0)

        
        view.addSubview(signInButton)

        // Add a UITextView to display output.
        output.frame = view.bounds
        output.isEditable = false
        output.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        output.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        output.isHidden = true
        view.addSubview(output);
        
        //URLSession("https://www.googleapis.com/youtube/v3/search?key=AIzaSyCFPWPRSf3dWlb-71fRkWL7vVj4tU-bE3Q")
        //var urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=hello&type=video&maxResults=25&key=\(apiKey)"

        
        let url = URL(string: "https://www.googleapis.com/youtube/v3/search?part=snippet&q=hello&type=video&maxResults=25&key=AIzaSyCFPWPRSf3dWlb-71fRkWL7vVj4tU-bE3Q")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                 let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
              //if let dictionary = jsonResult as? NSDictionary {
                  if let itemArray = dataDictionary["items"] as? NSArray {
                      for case let item as NSDictionary in itemArray {
                              if let snippet = item["snippet"] as? NSDictionary {
                                  if let title = snippet["title"] as? String {
                                      self.titles.append(title)
                                      print("got here")
                                      print(title)
                                  }
                              }
                      }
                  }
              //}
          //}
                 
             }
        }
        task.resume()
        
        /*
        print(self.titles.count)
        for aTitle in self.titles {
            print("you got it")
            print(aTitle)
        }*/
        
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            showAlert(title: "Authentication Error", message: error.localizedDescription)
            self.service.authorizer = nil
        } else {
            self.signInButton.isHidden = true
            self.output.isHidden = false
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            fetchChannelResource()
        }
    }


    // List up to 10 files in Drive
    func fetchChannelResource() {
        let query = GTLRYouTubeQuery_ChannelsList.query(withPart: "snippet,statistics")
        query.identifier = "UC_x5XG1OV2P6uZZ5FSM9Ttw"
        // To retrieve data for the current user's channel, comment out the previous
        // line (query.identifier ...) and uncomment the next line (query.mine ...)
        // query.mine = true
        service.executeQuery(query,
                             delegate: self,
                             didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))
    }

    // Process the response and display output
    @objc func displayResultWithTicket(
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
*/
