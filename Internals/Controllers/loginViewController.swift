//
//  loginViewController.swift
//  Internals
//
//  Created by Sarvad shetty on 5/31/18.
//  Copyright © 2018 Sarvad shetty. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseDatabase
import SwiftyJSON
import SwiftKeychainWrapper

class loginViewController: UIViewController, UITextFieldDelegate {

    //MARK:IBOutlets
    @IBOutlet weak var registrationTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    //MARK:Variables
    var registrationNumber:String?
    var password:String?
    var recievedPass:String?
    var recievedReg:String?
    var realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK:Setting delegates
        registrationTextField.delegate = self
        passwordTextField.delegate = self
        observeNotification()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let a = KeychainWrapper.standard.string(forKey: "regno"){
            print(a)
            performSegue(withIdentifier: "goToView", sender: nil)
        }
    }
    
    
    //MARK:IBActions
    @IBAction func loginInTapped(_ sender: UIButton) {
        registrationNumber = registrationTextField.text!
        password = passwordTextField.text
        retrievePassword(reg: registrationNumber)
        
    }
    
    //MARK:Textfield properties
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == registrationTextField {
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    private func observeNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardShow(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: -120, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    @objc func keyboardWillHide(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }

    
    
    //MARK:Functions
    func retrievePassword(reg:String?){
        var pass:String = ""
        var regis:String = ""
        let regIDReference = Database.database().reference().child("userProfile").child(reg!)
        regIDReference.observe(.value) { (snapshot) in
            if let data = snapshot.value as? Dictionary<String,AnyObject> {
                let jsonData = JSON(data)
                print(jsonData)
                 pass = jsonData["password"].stringValue
                 regis = jsonData["regno"].stringValue
                self.passwordCheck(reg: regis, pass: pass, data: jsonData)
            }
            
        }
        
    }
    
    func passwordCheck(reg:String,pass:String,data:JSON){
        if registrationNumber == reg && password == pass {
            //login status
            KeychainWrapper.standard.set(registrationNumber!, forKey: "regno")
            save(data: data)
            performSegue(withIdentifier: "goToView", sender: nil)
        }
        else{
            registrationTextField.text = ""
            passwordTextField.text = ""
            let alert = UIAlertController(title: "Error", message: "Invalid Credentials", preferredStyle: .alert)
            let action = UIAlertAction(title: "Done", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func save(data:JSON){
        let loginModelObject = LoginModel()
        loginModelObject.name = data["name"].stringValue
        loginModelObject.password = data["password"].stringValue
        loginModelObject.registrationNo = data["regno"].stringValue
        loginModelObject.team = data["team"].stringValue
        loginModelObject.role = data["role"].stringValue
        
        //Saving to realm
        do{
            try? realm.write {
                realm.add(loginModelObject)
            }
        }            }

}





