//
//  CalendarViewController.swift
//  Internals
//
//  Created by Sarvad shetty on 6/5/18.
//  Copyright © 2018 Sarvad shetty. All rights reserved.
//

import UIKit
import FSCalendar
import FirebaseDatabase
import SwiftyJSON
import TableViewReloadAnimation


//MARK:Variables
fileprivate let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}()
fileprivate let formatterDay :DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd"
    return formatter
}()
fileprivate let formatterMonth :DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM"
    return formatter
}()
fileprivate let formatterDay2 :DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy"
    return formatter
}()
fileprivate let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)

var eventArray = [String]()
var calendarModelArray = [CalendarModel]()
var sortedCalendarModelArray = [CalendarModel]()
var counter = true
var todayDate:Int = 0
var todayDate1:Int = 0
var todayMonth:Int = 0
var todayMonthString:String = ""
var todayDateString:String = ""
var feb = [29]
var thirtyones = [01,03,05,07,08,10,12]
var thirtys = [04,06,09,11]


class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
    
    //MARK:IBOutlets
    @IBOutlet weak var calendarTableView: UITableView!
    @IBOutlet weak var calls: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calendarTableView.separatorStyle = .none
        loadData()
        
    }
    
    
    //MARK:FSCalender methods
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        if gregorian.isDateInToday(date){
            todayDate = Int(formatterDay.string(from: date))!
            todayDateString = formatterDay2.string(from: date)
            todayMonth = Int(formatterMonth.string(from: date))!
            todayMonthString = formatterMonth.string(from: date)
            print(todayDateString)
            print(todayMonthString)
        }
        
        let datesss = formatter.string(from: date)
        if eventArray.contains(datesss){
            return 1
        }else{
            return 0
        }
    }
    
    //MARK:Functions
    func loadData(){
        Database.database().reference().child("events").observe(.value) { (snapshot) in
            if let data = snapshot.value as? Dictionary<String,AnyObject> {
                let jsonData = JSON(data)
                print(jsonData)
                let dataKeys = data.keys
                for i in dataKeys{
                    let newObject = CalendarModel(date: jsonData[i]["date"].stringValue, name: jsonData[i]["name"].stringValue, dateForCell: jsonData[i]["dateForCell"].stringValue)
                    
                    //getting current date
                    let a1 = Int(newObject.dateForCell.split(separator: "-")[0])
                    let a2 = Int(todayDateString.split(separator: "-")[0])
                    //getting current month
                    let a3 = Int(newObject.dateForCell.split(separator: "-")[1])
                    let a4 = todayMonth
                    print(a3)
                    
                    //to check if event has passed away
                    if newObject.dateForCell != todayDateString && a1! > a2! && (a4 == a3! || a4 < a3!) {
                        calendarModelArray.append(newObject)
                        eventArray.append(jsonData[i]["date"].stringValue)
                    }
                }
                sortedCalendarModelArray = calendarModelArray.sorted{ $0.dateForCell < $1.dateForCell}
                self.calendarTableView.reloadData(
                    with: .simple(duration: 0.45, direction: .left(useCellsFrame: true),
                                  constantDelay: 0))
                self.calls.reloadData()
            }
        }
    }
    
}


//MARK:UITableView properties
extension CalendarViewController :UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendarModelArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = calendarTableView.dequeueReusableCell(withIdentifier: "calendarCell", for: indexPath) as! CalendarTableViewCell
        cell.cardView.layer.cornerRadius = 14
        cell.cardView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cell.cardView.layer.shadowRadius = 3
        cell.cardView.layer.shadowOpacity = 0.16
        cell.workAllotmentButton.layer.cornerRadius = 12
        
        let newStr = Int(sortedCalendarModelArray[indexPath.row].dateForCell.split(separator: "-")[0])
        var newStr2 = Int(sortedCalendarModelArray[indexPath.row].dateForCell.split(separator: "-")[1])
        todayDate1 = newStr! - todayDate
        print(todayDate1)
        print("newstr2",newStr2!)
        if newStr2! > todayMonth{
            if feb.contains(newStr2!){
                newStr2 = newStr2! - todayMonth
                todayDate1 = todayDate1 + (newStr2! * 29)
            }else if thirtys.contains(newStr2!){
                 newStr2 = newStr2! - todayMonth
                todayDate1 = todayDate1 + (newStr2! * 30)
            }else if thirtyones.contains(newStr2!){
                 newStr2 = newStr2! - todayMonth
                todayDate1 = todayDate1 + (newStr2! * 31)
            }
            
        }
        cell.noOfDaysLabel.text = String(todayDate1)
        if todayDate1 == 1{
            cell.dayLabel.text = "Day"
        }
        else{
            cell.dayLabel.text = "Days"
        }
        
        if indexPath.row == 0{
            cell.nextEventLabel.text = "Next Event"
        }else{
            cell.nextEventLabel.text = sortedCalendarModelArray[indexPath.row].dateForCell
        }
        
        cell.eventNameLabel.text = sortedCalendarModelArray[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        calendarTableView.deselectRow(at: indexPath, animated: true)
    }
}
