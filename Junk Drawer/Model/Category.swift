//
//  Category.swift
//  Junk Drawer
//
//  Created by Megan Brown on 3/10/19.
//  Copyright © 2019 Megan Brown. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var title = ""
    @objc dynamic var image = ""   // image location, not actual image

    // @objc dynamic var tint = ??
    
    // the children of this class are an array of type Drawer or Tool
    @objc dynamic var drawerBoolean = true
    let drawers = List<Drawer>()
    let tools = List<Tool>()

}
