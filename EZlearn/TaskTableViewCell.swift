//
//  TaskTableViewCell.swift
//  EZlearn
//
//  Created by Sharonda Daniels on 10/29/22.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var taskName: UILabel!
    
    @IBOutlet weak var goalCell: UIView!
    
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
