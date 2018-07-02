//
//  ProfileTableViewCell.swift
//  Internals
//
//  Created by Sarvad shetty on 5/16/18.
//  Copyright © 2018 Sarvad shetty. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    //MARK:IBOutlets
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellOption: UIButton!
    @IBOutlet weak var organisationLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
