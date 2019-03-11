//
//  Tool.swift
//  Junk Drawer
//
//  Created by Megan Brown on 3/10/19.
//  Copyright © 2019 Megan Brown. All rights reserved.
//

import Foundation
import RealmSwift

class Tool: Object {
    @objc dynamic var title = ""
    @objc dynamic var quantity = 1
    @objc dynamic var desc = ""
    
    @objc dynamic var expirationBoolean = false
    @objc dynamic var expirationDate: Date?
    @objc dynamic var reminderBoolean = false
    @objc dynamic var reminderDate: Date?
    
    // @objc dynamic var image = ??
    // @objc dynamic var tint = ??
    // @objc dynamic var location = ??
    
    let tags = List<Tag>()        // the children of this class are an array of type Tag
    var parentCategory = LinkingObjects(fromType: Drawer.self, property: "tools")    // parent is the Drawer class
}
