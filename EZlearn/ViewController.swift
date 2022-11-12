//
//  ViewController.swift
//  EZlearn
//
//  Created by Sharonda Daniels on 10/28/22.
//
import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIBarPositioningDelegate, UINavigationBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellReuseIdentifier = "cell"
    let defaultValues = UserDefaults.standard
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var tasks:[LearningGoal] = []
    var taskToAdd:UserTask? = nil
    var firstLoad = true
    var cellColors = ["8C123E", "8C6312", "7E741A", "527E1A", "1A7E3C", "1A7E6C", "12768C"]
    var cellSelection : LearningGoal!
    var cellSelectionColor = UIColor.black
    var taskToDelete = ""
    
    @IBOutlet weak var helloLabel: UITextField!
    var usersName = "User"
    //var navBar = (self as? UIViewController)?.navigationController?;.navigationBar

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        helloLabel.text = "Hello " + usersName
        helloLabel.font = UIFont.systemFont(ofSize: 30)
        
        
        /*
        let mySpecialViewController = ViewController()
        let navigationController = UINavigationController(rootViewController: mySpecialViewController)
        present(navigationController, animated: true)
        */
        //var navBar = self.navigationController?.navigationBar
        //navBar!.delegate = self
        //navBar = position(for: navBar!)

        // Use this to restart tasks
        
        /*
        var appDelegate = UIApplication.shared.delegate as! AppDelegate
               let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LearningGoal")
               do {
                   let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext

                   let results:NSArray = try context.fetch(request) as NSArray
                   for result in results {
                       let theGoal = result as! LearningGoal
                       if theGoal.name == "Red Black Trees" {
                           context.delete(theGoal)
                       }
                       try context.save()
                   }
               } catch {

                   print("Fetch Failed")
               }*/
         
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
        }*/
        
        // Delete from CoreData
        //var appDelegate = UIApplication.shared.delegate as! AppDelegate
        /*
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
    
    func deleteTask(goal: LearningGoal) {
        // Delete from CoreData
        //print("im here")
        var appDelegate = UIApplication.shared.delegate as! AppDelegate
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LearningGoal")
        do {
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext

            let results:NSArray = try context.fetch(request) as NSArray
            for result in results {
                let theGoal = result as! LearningGoal
                if theGoal.isEqual(goal) {
                    context.delete(theGoal)
                    try context.save()
                    taskToDelete = ""
                    tasks.remove(at: tasks.firstIndex(of: goal)!)
                    tableView.reloadData()

                    
                }
            }
        } catch {
            print("Fetch Failed")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = UserDefaults.standard.object(forKey:"usersTasks") as? Data,
           let category = try? JSONDecoder().decode(UserTask.self, from: data) {
             //print(category.name)
        }
        //print("DID I RUN FIRST LETS SEEEEE")
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TaskTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! TaskTableViewCell
        //print("Count: " + String(tasks.count))
        //print(indexPath.row)
        cell.taskName.text = tasks[indexPath.item].name
        cell.goalCell.backgroundColor = hexStringToUIColor(hex: cellColors[Int(tasks[indexPath.item].colorIndex)])
        
        cell.setCompleted(tasks[indexPath.item].completed)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellSelectionColor = hexStringToUIColor(hex: cellColors[Int(tasks[indexPath.item].colorIndex)])
        cellSelection = tasks[indexPath.item]
        self.performSegue(withIdentifier: "showTask", sender: self)

    }
    /*
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //navigationController?.pushViewController(OpenTaskViewController, animated: yes)
        //tableView.deselectRowAtIndexPath(indexPath, animated: true)
//print("hi")
        self.performSegue(withIdentifier: "showTask", sender: self)
        //let vc = OpenTaskViewController as? UIViewController
        //print("was selected")
        //self.present(OpenTaskViewController(), animated: true)
        //println(tasks[indexPath.row])
    }*/
    //func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
        var theVC = OpenTaskViewController()
    theVC.view.backgroundColor = hexStringToUIColor(hex: cellColors[Int(tasks[indexPath.item].colorIndex)])
        theVC.title = tasks[indexPath.item].name
    //theVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
    self.present(theVC, animated: true)
        //self..naviga*/
    //}
    
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
            return .topAttached
        }
    
    /**
     Code is from: https://stackoverflow.com/questions/24263007/how-to-use-hex-color-values
     */
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
