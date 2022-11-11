//
//  AddTaskViewController.swift
//  EZlearn
//
//  Created by Sharonda Daniels on 10/29/22.
//

import UIKit
import CoreData

class AddTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var taskField: UITextField!
    let cellReuseIdentifier = "cell2"
    var videoTitles = [String]()
    var channelIDs = [String]()
    var videoThumbnails = [String]()
    var videoIds = [String]()
    var savedResources = String()
    
    var dict = [String:(String, String, String)]()
    //var dict = Dictionary<String, String()>

    
    var checkmarks = [Bool]()
    var selectedColor = 0

    @IBOutlet weak var pinkColorButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var selectedDotLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        print(selectedDotLabel.layer.position)
        
        var bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: taskField.frame.height - 1, width: taskField.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        taskField.borderStyle = UITextField.BorderStyle.none
        taskField.layer.addSublayer(bottomLine)
        taskField.textColor = .white
        taskField.font =  UIFont.systemFont(ofSize: 20.0)

        
        setDoneOnKeyboard()
        
    }
    
    @IBAction func onAdd(_ sender: Any) {
        // Insert to CoreData
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "LearningGoal", in: context)
        if (!taskField.text!.isEmpty) {
            let newGoal = LearningGoal(entity: entity!, insertInto: context)
        
            newGoal.name = taskField.text
            newGoal.colorIndex = Int64(selectedColor)
            newGoal.resources = savedResources
            //print(newGoal.resources ?? "")
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*
        if segue.identifier == "addMyTask" {
            let controller = segue.destination as! ViewController
            var newTask = UserTask()
            newTask.name = taskField.text  ?? ""
            
            controller.taskToAdd = newTask
        }*/
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ResourceTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ResourceTableViewCell
        cell.videoTitleLabel.text = videoTitles[indexPath.row]
        cell.channelIDLabel.text = channelIDs[indexPath.row]
        if checkmarks[indexPath.row] {
            cell.addResourceButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        } else {
            cell.addResourceButton.setImage(UIImage(systemName: "plus"), for: .normal)
            
        }
        
        if let url = URL(string: (self.videoThumbnails[indexPath.row])) {
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
    @IBAction func stoppedTyping(_ sender: Any) {
        var toSearch = taskField.text
        
        videoTitles = [String]()
        channelIDs = [String]()
        videoThumbnails = [String]()
        
        toSearch = toSearch?.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)

        
        // Get youtube data
        let url = URL(string: "https://www.googleapis.com/youtube/v3/search?part=snippet&q=how+to+\(toSearch ?? "")&type=video&maxResults=25&key=AIzaSyAToDe0wO-IUh2W6g3XcnU-3Rh-bhnP2iY")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                 let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                  if let itemArray = dataDictionary["items"] as? NSArray {
                      //print(itemArray[0])
                      for case let item as NSDictionary in itemArray {
                          //var theResource = (vidName: "", vidAuthor: "", vidThumb: "")
                          if let snippet = item["snippet"] as? NSDictionary {
                              if let title = snippet["title"] as? String {
                                  self.videoTitles.append(title)
                                  //theResource.vidName = title
                              }
                              if let chanId = snippet["channelTitle"] as? String {
                                  self.channelIDs.append(chanId)
                                  //theResource.vidAuthor = chanId
                              }
                              if let thumbNails = snippet["thumbnails"] as? NSDictionary {
                                  if let defals = thumbNails["high"] as? NSDictionary {
                                          if let imageUrl = defals["url"] as? String {
                                              self.videoThumbnails.append(imageUrl)
                                              //theResource.vidThumb = imageUrl
                                          }
                                  }
                              }
                              self.checkmarks.append(false)
                          }
                          if let vidIds = item["id"] as? NSDictionary {
                              if let videoId = vidIds["videoId"] as? String {
                                  self.videoIds.append(videoId)
                                  //self.dict[videoId] = theResource
                                  //print(videoId)
                              }
                          }

                      }
                  }
                 
             }
            self.tableView.reloadData()
        }
        task.resume()
    }
    
    @IBAction func onAddResource(_ sender: UITableViewCell) {
        guard let cell = sender.superview?.superview as? ResourceTableViewCell else {
            return // or fatalError() or whatever
        }
        //print(cell)
        //(tableView as? UITableView)?.indexPath(for: sender)
        
        checkmarks[tableView.indexPath(for: cell)!.row] = true
        var vidID = videoIds[tableView.indexPath(for: cell)!.row]
        var vidTitle = videoTitles[tableView.indexPath(for: cell)!.row]
        var vidAuthor = channelIDs[tableView.indexPath(for: cell)!.row]
        var vidThumb = videoThumbnails[tableView.indexPath(for: cell)!.row]
        var newString = vidID + "~" + vidTitle + "~" + vidAuthor + "~" + vidThumb + "^"
        savedResources += newString
        //savedResources.append(newString)
        //savedResources.append(<#T##self: &String##String#>)
        

        //savedResources.append(videoIds[tableView.indexPath(for: cell)!.row])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /**
         This code is from https://stackoverflow.com/questions/41542409/how-to-open-youtube-app-with-youtube-id-on-a-button-click-in-ios
         */
        let youtubeId = videoIds[indexPath.row]
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
    func setDoneOnKeyboard() {
        let ViewForDoneButtonOnKeyboard = UIToolbar()
        ViewForDoneButtonOnKeyboard.sizeToFit()
        let btnDoneOnKeyboard = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.dismissKeyboard))
        ViewForDoneButtonOnKeyboard.items = [btnDoneOnKeyboard]
        taskField.inputAccessoryView = ViewForDoneButtonOnKeyboard
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @IBAction func pinkIsSelected(_ sender: Any) {
        //selectedDotLabel.layer.position = CGPoint(x: 44,y: 219.5)
        selectedDotLabel.layer.position = CGPoint(x: 32, y: 206.5)
        selectedColor = 0
        print(selectedDotLabel.layer.position)
    }
    
    @IBAction func orangeIsSelected(_ sender: Any) {
        selectedColor = 1
        selectedDotLabel.layer.position = CGPoint(x: 84, y: 206.5)
        print(selectedDotLabel.layer.position)
    }
    
    @IBAction func yellowIsSelected(_ sender: Any) {
        selectedColor = 2
        selectedDotLabel.layer.position = CGPoint(x: 135, y: 206.5)

    }
    
    @IBAction func lightGreenIsSelected(_ sender: Any) {
        selectedColor = 3
        selectedDotLabel.layer.position = CGPoint(x: 187, y: 206.5)

    }
    
    @IBAction func darkGreenIsSelected(_ sender: Any) {
        selectedColor = 4
        selectedDotLabel.layer.position = CGPoint(x: 239, y: 206.5)

    }
    
    @IBAction func turquoiseIsSelected(_ sender: Any) {
        selectedColor = 5
        selectedDotLabel.layer.position = CGPoint(x: 291, y: 206.5)

    }
    
    @IBAction func blueIsSelected(_ sender: Any) {
        selectedColor = 6
        selectedDotLabel.layer.position = CGPoint(x: 343, y: 206.5)
        // 337, 200

    }
    
    
    
}
