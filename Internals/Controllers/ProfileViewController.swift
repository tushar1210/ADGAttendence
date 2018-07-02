//
//  ViewController.swift
//  Internals
//
//  Created by Sarvad shetty on 5/15/18.
//  Copyright © 2018 Sarvad shetty. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SwiftyJSON
import RealmSwift
import SwiftKeychainWrapper
import TableViewReloadAnimation

class ProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    //MARK:IBOutlets
    @IBOutlet weak var subViewProfile: UIView!
    @IBOutlet weak var subView2: UIView!
    @IBOutlet weak var profileCircle: UIView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var circularProgress: UIView!
    @IBOutlet weak var progressGradValue: UIView!
    @IBOutlet weak var profileTableView: UITableView!
    
    //MARK:Variables
    let shapeLayer = CAShapeLayer()
    var loginModelArray:Results<LoginModel>?
    var realm = try! Realm()
    
    //MARK:Dummy data
    var progressBarValue = 78.0 / 100.0
    var profileWorkArray = [ProfileWork]()
    var registrationNo:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Login status
        guard let valueAvail = KeychainWrapper.standard.string(forKey: "regno") else{ return }
        registrationNo = valueAvail
        
        //View Properties
        subView2.layer.cornerRadius = 18
        subView2.clipsToBounds = true
        subView2.layer.masksToBounds = false
        subView2.layer.shadowOffset = CGSize(width: 0, height: 3)
        subView2.layer.shadowRadius = 3
        subView2.layer.shadowOpacity = 0.16
        
        //profile circle properties
        profileCircle.layer.cornerRadius = profileCircle.frame.width/2
        profileCircle.clipsToBounds = true
        profileCircle.layer.borderWidth = 1
        profileCircle.layer.borderColor = UIColor(displayP3Red: 112.0/255.0, green: 112.0/255.0, blue: 112.0/255.0, alpha: 0.13).cgColor
        

        
        //circular progress properties
        let centery = circularProgress.layer.bounds.midY - 1
        let centerx = circularProgress.layer.bounds.midX - 1
        let center = CGPoint(x: centerx, y: centery)
        let circularPath = UIBezierPath(arcCenter: center, radius: 45, startAngle: -0.5 * CGFloat.pi, endAngle: 1.5 * CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 8
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.strokeEnd = 0
        
        
        //added a gradient stroke fill
        let gradient = CAGradientLayer()
        gradient.frame = circularProgress.bounds
        gradient.colors = [ColorHelper.shared.gradient1.cgColor, ColorHelper.shared.gradient2.cgColor]
        gradient.mask = shapeLayer
        circularProgress.layer.addSublayer(gradient)
        circularProgressAni(to_value: CGFloat(progressBarValue))
        
        //adding gradient to progress value
        let gradient2 = CAGradientLayer()
        // gradient colors in order which they will visually appear
        gradient2.colors = [ColorHelper.shared.gradient1.cgColor, ColorHelper.shared.gradient2.cgColor]
        // Gradient from left to right
        gradient2.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient2.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient2.frame = progressGradValue.bounds
        progressGradValue.layer.addSublayer(gradient2)
        let label = UILabel(frame: progressGradValue.bounds)
        label.text = "\(78)"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        progressGradValue.addSubview(label)
        progressGradValue.mask = label
        
        //MARK:Tableview properties
        profileTableView.separatorStyle = .none
        
        print(registrationNo)
        
        //MARK:Loading data
        getData()
        loadData()

    }
    
    //MARK:Functions
    fileprivate func circularProgressAni(to_value:CGFloat = 1.0){
        let basicAni = CABasicAnimation(keyPath: "strokeEnd")
        basicAni.toValue = to_value
        basicAni.duration = 2
        basicAni.fillMode = kCAFillModeForwards
        basicAni.isRemovedOnCompletion = false
        shapeLayer.add(basicAni, forKey: "basicAni")
    }
    
    func getData(){
        loginModelArray = realm.objects(LoginModel.self)
        profileName.text = loginModelArray![0].name
        roleLabel.text = loginModelArray![0].role
        teamLabel.text = loginModelArray![0].team
    }
    
    //MARK:Tableview functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileWorkArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = profileTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as!
            ProfileTableViewCell
        
        //setting up cell content propertiess
        cell.cellView.layer.cornerRadius = 14
        cell.cellView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cell.cellView.layer.shadowRadius = 3
        cell.cellView.layer.shadowOpacity = 0.16
        cell.cellOption.layer.cornerRadius = cell.cellOption.frame.width/2
        cell.cellOption.clipsToBounds = true
        cell.aboutLabel.text = profileWorkArray[indexPath.row].about
        cell.organisationLabel.text = profileWorkArray[indexPath.row].organisation
        cell.taskLabel.text = profileWorkArray[indexPath.row].task
    
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        profileTableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    //MARK:Networking methods
    func loadData(){
        Database.database().reference().child("userProfile").child(registrationNo!).child("work").observe(.value) { (snapshot) in
            if let data = snapshot.value as? Dictionary<String,AnyObject>{
                let jsonData = JSON(data)
            let dataKeys = data.keys
                for i in dataKeys{
                    let newObject = ProfileWork(about: jsonData[i]["about"].stringValue, taskValue: jsonData[i]["taskValue"].doubleValue, task: jsonData[i]["task"].stringValue, organisation: jsonData[i]["organisation"].stringValue)
                    self.profileWorkArray.append(newObject)
                }
                self.profileTableView.reloadData(
                    with: .simple(duration: 0.45, direction: .left(useCellsFrame: true),
                                  constantDelay: 0))
            }
        }
    }

}

