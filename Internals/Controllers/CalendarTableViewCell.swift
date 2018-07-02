//
//  CalendarTableViewCell.swift
//  Internals
//
//  Created by Sarvad shetty on 6/5/18.
//  Copyright © 2018 Sarvad shetty. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {
    
    
    //MARK:IBOutlets
    @IBOutlet weak var nextEventLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var noOfDaysLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var workAllotmentButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:IBAction
    @IBAction func workAllotAction(_ sender: UIButton) {
        print("clicked")
    }
    
}
