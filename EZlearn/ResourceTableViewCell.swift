//
//  ResourceTableViewCell.swift
//  EZlearn
//
//  Created by Sharonda Daniels on 11/6/22.
//

import UIKit

class ResourceTableViewCell: UITableViewCell {

    @IBOutlet weak var videoTitleLabel: UILabel!
    
    @IBOutlet weak var channelIDLabel: UILabel!
    
    @IBOutlet weak var videoThumbnail: UIImageView!
    
    @IBOutlet weak var addResourceButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //UITableViewCell.selectio
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        videoTitleLabel.adjustsFontSizeToFitWidth = false;
        videoTitleLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
    }

    @IBAction func onAddResource(_ sender: Any) {
        addResourceButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        //addResourceButton.backgroundColor = .black
    }
}
