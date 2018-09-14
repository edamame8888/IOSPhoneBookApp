//
//  PhoneBookData.swift
//  PhoneBookApp
//
//  Created by 今枝弘貴 on 2018/09/13.
//  Copyright © 2018年 K.Imaeda. All rights reserved.
//

import Foundation
import RealmSwift

class PhoneBookData : Object{
    
    // SchemaVersion 0
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var kanaFirstName = ""
    @objc dynamic var kanaFamilyName = ""
    @objc dynamic var firstName = ""
    @objc dynamic var familyName = ""
    @objc dynamic var tel = ""
    @objc dynamic var memo = ""
    
}
