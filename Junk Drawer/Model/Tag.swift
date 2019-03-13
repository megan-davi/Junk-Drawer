//
//  TagCollectionViewCell.swift
//  Junk Drawer
//
//  Created by Megan Brown on 3/10/19.
//  Copyright © 2019 Megan Brown. All rights reserved.
//

import Foundation
import RealmSwift

class Tag: Object {
    @objc dynamic var title = ""
    
    // @objc dynamic var tint = ??

    var parentCategory = LinkingObjects(fromType: Tool.self, property: "tags")    // parent is the Tool class
}
