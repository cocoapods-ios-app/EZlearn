//
//  OpenTaskViewController.swift
//  EZlearn
//
//  Created by Sharonda Daniels on 11/8/22.
//

import UIKit
import CoreData

class OpenTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var goalName: UILabel!
    var goalResources = String()
    //var goalResources =
    @IBOutlet weak var tableView: UITableView!
    var cellReuseIdentifier = "cell3"
    var allResources = [String]()
    var checkmarks = [Bool]()
    var theSelectedGoal : LearningGoal!

    @IBOutlet weak var deleteButtonBorder: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        let thevc = (self.presentingViewController as? UINavigationController)?.viewControllers[0] as? ViewController
        //let thevc = navigationController?.viewControllers
        view.backgroundColor = thevc?.cellSelectionColor
        theSelectedGoal = thevc?.cellSelection as? LearningGoal
        goalName.text = theSelectedGoal!.name
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LearningGoal")
        do {
            let results:NSArray = try context.fetch(request) as NSArray
            for result in results
            {
                let theGoal = result as! LearningGoal
                if (theGoal.name == theSelectedGoal!.name) {
                    goalResources = (theGoal.resources ?? "") as String

                    if !goalResources.isEmpty {
                        allResources = goalResources.components(separatedBy: "^")
                        allResources.remove(at: allResources.count - 1)
                        for _ in allResources {
                            checkmarks.append(false)
                        }
                       
                    }
                }
                //print(theGoal.name ?? "nothing here")
            }
            tableView.reloadData()
        } catch {
            print("Fetch Failed")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        deleteButtonBorder.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
        //view.backgroundColor =

        // Do any additional setup after loading the view.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("made it")
        //print(allResources.count)
        return allResources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ResourceTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ResourceTableViewCell
        //print(Array(goalResources)[indexPath.row].key)

        let resourceInfo = allResources[indexPath.row].components(separatedBy: "~")
        
        cell.videoTitleLabel.text = resourceInfo[1]
        //print("kwnfjen")
        //print(resourceInfo[2])
        cell.channelIDLabel.text = resourceInfo[3]
        var checkBool = false
        if resourceInfo[4] == "true" {
            checkBool = true
        }
        //var checkBool = resourceInfo[4] as! Bool
        
        if checkBool {
            cell.addResourceButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        } else {
            cell.addResourceButton.setImage(UIImage(systemName: "circle"), for: .normal)
            
        }
        
        if let url = URL(string: (resourceInfo[3])) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async { /// execute on main thread
                    cell.videoThumbnail.image = UIImage(data: data)
                }
            }
            
            task.resume()
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /**
         This code is from https://stackoverflow.com/questions/41542409/how-to-open-youtube-app-with-youtube-id-on-a-button-click-in-ios
         */
        let resourceInfo = allResources[indexPath.row].components(separatedBy: "~")
        
        let youtubeId = resourceInfo[0]
        //var youtubeUrl = NSURL(string: "https://www.youtube.com/watch?v=\(videoIds[indexPath.row])")
        var youtubeUrl = NSURL(string:"youtube://\(youtubeId)")!

        /*
        guard let youtubeUrl = URL(string: "https://www.youtube.com/watch?v=\(videoIds[indexPath.row])") else {
          return //be safe
        }*/
        if UIApplication.shared.canOpenURL(youtubeUrl as URL){
            UIApplication.shared.open(youtubeUrl as URL)
            //UIApplication.shared.openURL(youtubeUrl)
            } else{
                youtubeUrl = NSURL(string:"https://www.youtube.com/watch?v=\(youtubeId)")!
                UIApplication.shared.open(youtubeUrl as URL)

                //UIApplication.shared.openURL(youtubeUrl)
            }
        /*
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }*/
    }
    
    @IBAction func onAddResource(_ sender: UITableViewCell) {
        guard let cell = sender.superview?.superview as? ResourceTableViewCell else {
            return // or fatalError() or whatever
        }
        //var nameOfGoal = cell.
        checkmarks[tableView.indexPath(for: cell)!.row] = true
        var theIntegerInvolved = tableView.indexPath(for: cell)!.row + 1
        //3 * theIntegerInvolved - 1
        //theIntegerInvolved
        //title~author~url~completed^title~author~url~completed
        
        /**
         Code is from https://stackoverflow.com/questions/39358798/find-index-of-nth-instance-of-substring-in-string-in-swift
         */
        
        // Find the ~ before the completion
        var query = "~"
        var searchRange = goalResources.startIndex..<goalResources.endIndex
        var indices: [String.Index] = []

        while let range = goalResources.range(of: query, options: .caseInsensitive, range: searchRange) {
            searchRange = range.upperBound..<searchRange.upperBound
            indices.append(range.lowerBound)
        }
        
        // Find the ^ after the completion
        query = "^"
        searchRange = goalResources.startIndex..<goalResources.endIndex
        var indices2: [String.Index] = []

        while let range = goalResources.range(of: query, options: .caseInsensitive, range: searchRange) {
            searchRange = range.upperBound..<searchRange.upperBound
            indices2.append(range.lowerBound)
        }
        
        // Change the resource string
        var indexFirstLetter = indices[4 * theIntegerInvolved - 1]
        var indexLastLetter = indices2[theIntegerInvolved - 1]
        var firstPart = goalResources[...indexFirstLetter]
        firstPart += "true"
        firstPart += goalResources[indexLastLetter...]
        print(firstPart)
        
        
        //title~author~thumbnail~completed^title~author~thumbnail~completed
        // vidID + "~" + vidTitle + "~" + vidAuthor + "~" + vidThumb + "~" + "false" + "^"

        
        // Make sure the new resource string is saved on the learning goal
        var appDelegate = UIApplication.shared.delegate as! AppDelegate
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LearningGoal")
                do {
                    let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext

                    let results:NSArray = try context.fetch(request) as NSArray
                    for result in results {
                        let theGoal = result as! LearningGoal
                        if(theGoal.name == goalName.text) {
                            theGoal.resources = String(firstPart)
                            //theGoal.name = "I was changed"
                            try context.save()
                        }
                    }
                } catch {

                    print("Fetch Failed")
                }
         
    }
    
    
    @IBAction func onDeleteTask(_ sender: Any) {
        //((presentingViewController as! UINavigationController).viewControllers[0] as! ViewController).taskToDelete = goalName.text!
        self.dismiss(animated: true)
        ((presentingViewController as! UINavigationController).viewControllers[0] as! ViewController).deleteTask(goal: theSelectedGoal)
    }
    
    @IBAction func onDismiss(_ sender: Any) {
        self.dismiss(animated: true)
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
