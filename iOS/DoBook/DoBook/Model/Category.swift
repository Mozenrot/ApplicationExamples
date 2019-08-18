//
//  Category.swift
//  DoBook
//
//  Created by LeoChernyak on 02/05/2019.
//  Copyright © 2019 LeoChernyak. All rights reserved.
//

import Foundation
import RealmSwift


class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    
    //relationships between Cathegory and Itmes
    let items = List<Item>()
}
