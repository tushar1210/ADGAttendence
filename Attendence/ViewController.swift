//
//  ViewController.swift
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
class ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource,UICircularProgressRingDelegate,UICollectionViewDelegate,UICollectionViewDataSource{
    
    var totalDB : DatabaseReference!
    var updateDB : DatabaseReference!
    //MARK:IBOutlets
    @IBOutlet var monthlyPicker: UIPickerView!
    @IBOutlet var attendenceTable: UITableView!
    @IBOutlet var Ring: UICircularProgressRingView!
    @IBOutlet var monthCollectionView: UICollectionView!
    @IBOutlet var monthCollectionViewFlowLayout: UICollectionViewFlowLayout!
    
    
    //==========================================================================================

    
    //MARK:INITIALISATION-
    let modeArray : [String] = ["Monthly","Weekly"]
    let monthArray : [String] = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
    var totalMeetings:Int = 4
    var totalAttendence=0
    var date:String=""
    var status:Bool=false
    var ringPercentage:CGFloat=58
    var selectedMonth:String=""
    let tableViewProperties=AttendenceTableViewCell()
    let currentDate = Date()
    let formatter = DateFormatter()
    var currentMonth:String = ""

    //==========================================================================================


    
    //MARK:  UIPicker methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return modeArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return modeArray[row]
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    //==========================================================================================

    
    
    //MARK:  AttendenceTableView Methods:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = attendenceTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AttendenceTableViewCell
        //setting up cell content propertiess
        cell.cellView.layer.cornerRadius = 14
        cell.cellView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cell.cellView.layer.shadowRadius = 3
        cell.cellView.layer.shadowOpacity = 0.16
        
        return cell
    }
    //Custom month:
//    @objc func customMonth(month:String,tap:UITapGestureRecognizer){
//        //print("\n",month,"\n")
//    }
    //==========================================================================================

    //MARK: CircularRingProperties
    func circularRing(){
        Ring.delegate=self
        let color1 = UIColor.red
        let color2 = UIColor.flatOrange().flatten()!
        Ring.ringStyle = UICircularProgressRingStyle.gradient
        Ring.gradientColors = [color1,color2]
        Ring.gradientStartPosition = UICircularProgressRingGradientPosition.topLeft
        Ring.gradientEndPosition = UICircularProgressRingGradientPosition.bottomLeft
        Ring.font = UIFont(name: "ProximaNovaA-Bold", size: 50)!
        Ring.animationStyle  = kCAMediaTimingFunctionLinear
        Ring.setProgress(to: 0, duration: 0.1)
    }
    //animating Ring:
    func finishedUpdatingProgress(for ring: UICircularProgressRingView) {
        Ring.animationStyle  = kCAMediaTimingFunctionLinear
        Ring.setProgress(to: ringPercentage, duration: TimeInterval(ringPercentage/25))//dummy data
        
    }
    //==========================================================================================

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
        print("\n\n",selectedMonth)
       
        
        
        
    }
    

    //==========================================================================================
    
    
    //MARK: Networking
    
    func getTotalMeetings(){
        
        totalDB.observe(.value) { (snapshot) in
            if let data = snapshot.value as? Dictionary<String,AnyObject> {
                let jsonData = JSON(data)
               
                print("\n\n\n\n",jsonData,"\n\n\n\n\n")
                self.totalMeetings=jsonData["Total"].intValue
                print(self.totalMeetings)
                
            }
        }
  
    }
   
 //    func getDate(){
    //
    //
    //    }
    //    func getStatus(){
    //
    //    }
    //==========================================================================================

    //MARK:ViewDidLoad()
    override func viewDidLoad() {
       super.viewDidLoad()
        totalDB = Database.database().reference().child("attendence")
        updateDB = Database.database().reference()
        monthCollectionViewFlowLayout.minimumLineSpacing=0
        monthlyPicker.delegate=self
        monthCollectionView.delegate=self
        monthCollectionView.dataSource=self
        monthlyPicker.dataSource=self
        attendenceTable.delegate=self
        attendenceTable.dataSource=self
        circularRing()
        attendenceTable.separatorStyle = .none
        getTotalMeetings()
        formatter.dateFormat = "Mon"
        currentMonth = monthArray[Int(formatter.string(from: currentDate))!-1]
        print("\n\n\n",currentMonth,"\n\n\n\n\n")
        tableViewProperties.defaultTableView(month: currentMonth,updateDB:updateDB)
        //        tableViewProperties.statusColor()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //==========================================================================================

    
}
