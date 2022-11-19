//
//  TaskTableViewCell.swift
//  EZlearn
//
//  Created by Sharonda Daniels on 10/29/22.
//

import UIKit
import CoreData

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var taskName: UILabel!
    
    @IBOutlet weak var goalCell: UIView!
    @IBOutlet weak var completeTask: UIButton!
    
    var complete:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        goalCell.clipsToBounds = true
        goalCell.layer.cornerRadius = 10
        

        // Initialization code
        /*
        let screenSize = UIScreen.main.bounds
        let separatorHeight = CGFloat(40.0)
        let additionalSeparator = UIView.init(frame: CGRect(x: 0, y: self.frame.size.height-separatorHeight, width: screenSize.width, height: separatorHeight))
        additionalSeparator.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
        self.addSubview(additionalSeparator)
         */
        
        
    }
    
    @IBAction func completeTaskButton(_ sender: Any) {
        let toBeCompleted = !complete
        
        if (toBeCompleted) {
            // change coredata
            self.setCompleted(true)
//            userLearningGoal.completed = true
            self.saveCompleteTask(completed: true, name: taskName.text!)
        } else {
            self.setCompleted(false)
//            userLearningGoal.completed = false
            self.saveCompleteTask(completed: false, name: taskName.text!)
        }
    }
    
    func setCompleted(_ isComplete:Bool) {
        complete = isComplete
        if (complete) {
            completeTask.setImage(UIImage(systemName: "circle.inset.filled"), for: UIControl.State.normal)
//            completeTask.isEnabled = true
        } else {
            completeTask.setImage(UIImage(systemName: "circle"), for: UIControl.State.normal)
        }
    }
    
    func saveCompleteTask(completed: Bool, name: String) {
        var appDelegate = UIApplication.shared.delegate as! AppDelegate
        var context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LearningGoal")
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                // In my case, I only updated the first item in results
                results?[0].setValue(completed, forKey: "completed")
            }
        } catch {
            print("Fetch Failed: \(error)")
        }

        do {
            try context.save()
           }
        catch {
            print("Saving Completion Failed: \(error)")
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
