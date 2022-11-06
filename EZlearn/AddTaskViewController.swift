//
//  AddTaskViewController.swift
//  EZlearn
//
//  Created by Sharonda Daniels on 10/29/22.
//

import UIKit

class AddTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var taskField: UITextField!
    let cellReuseIdentifier = "cell2"
    var videoTitles = [String]()
    var channelIDs = [String]()
    var videoThumbnails = [String]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        setDoneOnKeyboard()
        
        
        /*
        
        let url = URL(string: "https://www.googleapis.com/youtube/v3/search?part=snippet&q=how+to&type=video&maxResults=25&key=AIzaSyAToDe0wO-IUh2W6g3XcnU-3Rh-bhnP2iY")!
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
                                  self.videoTitles.append(title)
                              }
                              if let chanId = snippet["channelTitle"] as? String {
                                  self.channelIDs.append(chanId)
                              }
                              if let thumbNails = snippet["thumbnails"] as? NSDictionary {
                                  if let defals = thumbNails["high"] as? NSDictionary {
                                          if let imageUrl = defals["url"] as? String {
                                              self.videoThumbnails.append(imageUrl)
                                          }
                                  }
                              }
                              
                          }
                          //print(item)
                      }
                  }
              //}
          //}
                 
             }
            self.tableView.reloadData()
        }
        task.resume()*/
        
        /*
        print(self.titles.count)
        for aTitle in self.titles {
            print("you got it")
            print(aTitle)
        }*/
    }
    
    @IBAction func onAdd(_ sender: Any) {
        print(taskField.text ?? "")
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
        if segue.identifier == "addMyTask" {
            let navController = segue.destination as! UINavigationController
            let controller = navController.viewControllers[0] as! ViewController
            
            var newTask = UserTask()
            newTask.name = taskField.text  ?? ""
            
            //controller.taskToAdd = newTask
            //print(controller.tasks.count)
           
            //controller.taskToAddName = taskField.text ?? ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ResourceTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ResourceTableViewCell
        cell.videoTitleLabel.text = videoTitles[indexPath.row]
        cell.channelIDLabel.text = channelIDs[indexPath.row]
        
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
        print("you typed")
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
                                  self.videoTitles.append(title)
                              }
                              if let chanId = snippet["channelTitle"] as? String {
                                  self.channelIDs.append(chanId)
                              }
                              if let thumbNails = snippet["thumbnails"] as? NSDictionary {
                                  if let defals = thumbNails["high"] as? NSDictionary {
                                          if let imageUrl = defals["url"] as? String {
                                              self.videoThumbnails.append(imageUrl)
                                          }
                                  }
                              }
                              
                          }
                          //print(item)
                      }
                  }
              //}
          //}
                 
             }
            self.tableView.reloadData()
        }
        task.resume()
    }
    
    @IBAction func isTyping(_ sender: Any) {
    }
    
    func setDoneOnKeyboard() {
        var ViewForDoneButtonOnKeyboard = UIToolbar()
        ViewForDoneButtonOnKeyboard.sizeToFit()
        var btnDoneOnKeyboard = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.dismissKeyboard))
        ViewForDoneButtonOnKeyboard.items = [btnDoneOnKeyboard]
        taskField.inputAccessoryView = ViewForDoneButtonOnKeyboard
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    

}
