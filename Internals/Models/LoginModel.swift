//
//  LoginModel.swift
//  Internals
//
//  Created by Sarvad shetty on 5/31/18.
//  Copyright © 2018 Sarvad shetty. All rights reserved.
//

import Foundation
import RealmSwift


class LoginModel:Object{
    @objc dynamic var registrationNo:String?
    @objc dynamic var password:String?
    @objc dynamic var team:String?
    @objc dynamic var name:String?
    @objc dynamic var role:String?
}
