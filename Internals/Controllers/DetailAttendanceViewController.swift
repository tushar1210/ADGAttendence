//
//  DetailAttendanceViewController.swift
//  Attendence
//
//  Created by Tushar Singh on 17/06/18.
//  Copyright © 2018 Tushar Singh. All rights reserved.
//

import UIKit
import UICircularProgressRing
import ChameleonFramework
import Firebase
import SwiftyJSON
import SwiftKeychainWrapper
import TableViewReloadAnimation

class DetailAttendanceViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICircularProgressRingDelegate,UICollectionViewDelegate,UICollectionViewDataSource{
    
    var totalDB : DatabaseReference!
    var updateDB : DatabaseReference!
    var currentDB: DatabaseReference!
    
    //MARK:IBOutlets
    @IBOutlet weak var attendenceTable: UITableView!
    @IBOutlet weak var Ring: UICircularProgressRingView!
    @IBOutlet weak var monthCollectionView: UICollectionView!
    @IBOutlet var monthCollectionViewFlowLayout: UICollectionViewFlowLayout!    

    
    //MARK:Variables
    var userReg:String = "17BCE2246"
    let modeArray : [String] = ["Monthly","Weekly"]
    let monthArray : [String] = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
    let meetingArray:[String] = ["meeting1","meeting2","meeting3","meeting4"]
    var attend = [DetailAttendanceModel]()
    var totalMeetings:Int = 0
    var totalAttendence=0
    var date:String=""
    var status:Bool=false
    var ringPercentage:CGFloat=58
    var selectedMonth:String=""
    var tableViewCellProperties=AttendenceTableViewCell()
    let currentDate = Date()
    let formatter = DateFormatter()
    var currentMonth:String = ""
    var totalMeetingsKeychain:Bool = true
    var dataDictionary = ["":["","."]]
    var counter:Int = 0
    var totValue:CGFloat = 0.0
    var singluarVal:CGFloat = 0.0
    var divider:Int = 0
    var dateArray = [""]
    var statusArray = [""]
    var registrationNo:String?
    
    
    
    //MARK:  AttendenceTableView Methods:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attend.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableViewCellProperties = attendenceTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AttendenceTableViewCell
        tableViewCellProperties.cellView.layer.cornerRadius = 14
        tableViewCellProperties.cellView.layer.shadowOffset = CGSize(width: 0, height: 3)
        tableViewCellProperties.cellView.layer.shadowRadius = 3
        tableViewCellProperties.cellView.layer.shadowOpacity = 0.16
        tableViewCellProperties.attend = attend[indexPath.row]
        return tableViewCellProperties
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        attendenceTable.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: CircularRingProperties
    func circularRing(){
        let color1 = UIColor.red
        let color2 = UIColor.flatOrange().flatten()!
        Ring.delegate=self
        Ring.ringStyle = UICircularProgressRingStyle.gradient
        Ring.gradientColors = [color1,color2]
        Ring.gradientStartPosition = UICircularProgressRingGradientPosition.topLeft
        Ring.gradientEndPosition = UICircularProgressRingGradientPosition.bottomLeft
        Ring.font = UIFont(name: "ProximaNovaA-Bold", size: 50)!
        Ring.animationStyle  = kCAMediaTimingFunctionLinear
        Ring.setProgress(to: 0, duration: 0.1)
        print(TimeInterval(ringPercentage/25))
    }
    //animating Ring:
    func finishedUpdatingProgress(for ring: UICircularProgressRingView) {
        Ring.animationStyle  = kCAMediaTimingFunctionLinear
        Ring.setProgress(to: ringPercentage, duration: TimeInterval(ringPercentage/25))
    }
    
    //MARK:UICollectionViewsMethods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "monthCollectionView", for: indexPath as IndexPath) as! AttendenceCollectionViewCell
        collectionCell.collectionViewCellLabel.text=monthArray[indexPath.item]
        collectionCell.backgroundColor = UIColor.clear
        
        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMonth=monthArray[indexPath.item]
        collectionView.cellForItem(at: indexPath)
        print(selectedMonth)
        loadDataWithMonth(month: selectedMonth)
        
    }
    
    
    //MARK: Networking
    func loadData(){
        totalDB.child(currentMonth).child("meetings").observe(.value) { (snap) in
            self.attend = []
            let array = snap.children.allObjects as! [DataSnapshot]
            self.totValue = array[2].value as! CGFloat
            self.divider = Int(self.totValue)
            self.singluarVal = 100.0/self.totValue
            self.totValue = 0.0
            
            for val in array{
                guard let data = val.value as? [String: Any] else { continue }
                print(data)
                let status = data["status"] as? [String: String]
                guard let stat = status![self.registrationNo!] else {return}
                
                if stat.lowercased() == "present"{
                    self.totValue += self.singluarVal
                }
                
                let newOnj = DetailAttendanceModel(date: data["date"] as! String, attendanceStatus: stat, meeting: data["randomMeeting"] as! String)
                self.attend.append(newOnj)
            }
            self.ringPercentage = self.totValue
            self.attendenceTable.reloadData(
                with: .simple(duration: 0.45, direction: .left(useCellsFrame: true),
                              constantDelay: 0))
            self.circularRing()
            self.totValue = 0.0
            
        }
        
    }
    
    func loadDataWithMonth(month:String){
        totalDB.child(month).child("meetings").observe(.value) { (snap) in
            self.attend = []
            let array = snap.children.allObjects as! [DataSnapshot]
            self.totValue = array[2].value as! CGFloat
            self.divider = Int(self.totValue)
            self.singluarVal = 100.0/self.totValue
            self.totValue = 0.0
            
            for val in array{
                guard let data = val.value as? [String: Any] else { continue }
                print(data)
                
                let status = data["status"] as? [String: String]
                guard let stat = status![self.userReg] else {return}
                
                if stat.lowercased() == "present"{
                    self.totValue += self.singluarVal
                }
                
                let newOnj = DetailAttendanceModel(date: data["date"] as! String, attendanceStatus: stat, meeting: data["randomMeeting"] as! String)
                self.attend.append(newOnj)
                
            }
            self.ringPercentage = self.totValue
            self.attendenceTable.reloadData(
                with: .simple(duration: 0.45, direction: .left(useCellsFrame: true),
                              constantDelay: 0))
            self.circularRing()
            self.totValue = 0.0
            
        }
    }
    
    
    
    
    //MARK:ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalDB = Database.database().reference().child("attendence")
        updateDB = Database.database().reference()
        monthCollectionView.delegate=self
        monthCollectionView.dataSource=self
        attendenceTable.delegate=self
        attendenceTable.dataSource=self
        attendenceTable.separatorStyle = .none
        formatter.dateFormat = "Mon"
        currentMonth = monthArray[Int(formatter.string(from: currentDate))!-1]
         guard let valueAvail = KeychainWrapper.standard.string(forKey: "regno") else{ return }
        registrationNo = valueAvail
        loadData()
        
    }
}

extension UITableView {
    func reloadDataWithAnimation(duration: TimeInterval, options: UIViewAnimationOptions) {
        UIView.animate(withDuration: duration, delay: 0.0, options: options, animations: { self.alpha = 0 }, completion: nil)
        self.reloadData()
        UIView.animate(withDuration: duration, delay: 0.0, options: options, animations: { self.alpha = 1 }, completion: nil)
    }
}

