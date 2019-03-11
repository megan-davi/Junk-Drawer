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
    
    // @objc dynamic var image = ??
    // @objc dynamic var tint = ??
    
    @objc dynamic var drawerBoolean = true
    let drawers = List<Drawer>()        // the children of this class are an array of type Drawer

}
