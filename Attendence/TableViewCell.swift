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

    @IBOutlet var cellView: UIView!
    
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var attendedStatus: UILabel!
    
    @IBOutlet var meetingLabel: UILabel!
    
    func statusColor(){
        if(attendedStatus.text=="PRESENT"){
            attendedStatus.textColor=UIColor.green
        }
        else{
            attendedStatus.textColor=UIColor.red
        }
        func setDefaultProperties(){
            
        }
    }
    
    func defaultTableView(month:String,updateDB:DatabaseReference!){
        updateDB.child(month)
        updateDB.observe(.value) { (snapshot) in
            if let data = snapshot.value as? Dictionary<String,String> {
                let jsonData = JSON(data)
                print("\n\n\n\n",jsonData,"\n\n")
            }
        }
        
        
    }
    
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    

}
