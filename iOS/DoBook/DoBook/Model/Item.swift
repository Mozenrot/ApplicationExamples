//
//  Item.swift
//  DoBook
//
//  Created by LeoChernyak on 02/05/2019.
//  Copyright © 2019 LeoChernyak. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    
    //relationships between Cathegory and Itmes
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
