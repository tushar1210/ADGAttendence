//
//  AttendenceTableViewCell.swift
//  Attendence
//
//  Created by Tushar Singh on 17/06/18.
//  Copyright © 2018 Tushar Singh. All rights reserved.
//

import UIKit

class AttendenceTableViewCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var attendedStatus: UILabel!
    
    @IBOutlet var meetingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    

}
