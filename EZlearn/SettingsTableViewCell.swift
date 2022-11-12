//
//  SettingsTableViewCell.swift
//  EZlearn
//
//  Created by Sharonda Daniels on 11/12/22.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var settingValueLabel: UILabel!
    @IBOutlet weak var settingNameLabel: UILabel!
    @IBOutlet weak var settingViewCell: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        settingViewCell.clipsToBounds = true
        settingViewCell.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
