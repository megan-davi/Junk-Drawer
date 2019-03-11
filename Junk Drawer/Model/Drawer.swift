//
//  Drawer.swift
//  Junk Drawer
//
//  Created by Megan Brown on 3/10/19.
//  Copyright © 2019 Megan Brown. All rights reserved.
//

import Foundation
import RealmSwift

class Drawer: Object {
    @objc dynamic var title = ""
    
    // @objc dynamic var tint = ??
    // @objc dynamic var location = ??
    
    let tools = List<Tool>()        // the children of this class are an array of type Tool
    var parentCategory = LinkingObjects(fromType: Category.self, property: "drawers")    // parent is the Category class
}
