//
//  AttendenceTableViewCell.swift
//  Attendence
//
//  Created by Tushar Singh on 17/06/18.
//  Copyright © 2018 Tushar Singh. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class AttendenceTableViewCell: UITableViewCell {
    
    //MARK:IBOutlets
    @IBOutlet var cellView: UIView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var attendedStatus: UILabel!
    @IBOutlet var meetingLabel: UILabel!
    
    //MARK:Variables
    var attend:DetailAttendanceModel?{
        didSet{
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func updateView(){
        dateLabel.text = attend?.date
        if attend?.attendanceStatus.lowercased() == "absent"{
            attendedStatus.textColor = .red
        }
        else{
            attendedStatus.textColor = .green
        }
        
        attendedStatus.text = attend?.attendanceStatus
        meetingLabel.text = attend?.meeting
    }
    
    
}

