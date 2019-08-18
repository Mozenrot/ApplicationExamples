//
//  Transaction.swift
//  Pay_Check_LevCherniak
//
//  Created by LeoChernyak on 04/06/2019.
//  Copyright © 2019 LeoChernyak. All rights reserved.
//

import Foundation
import RealmSwift


class Transaction: Object {
    
   @objc dynamic var amount : Double = 0.0
   @objc dynamic var currency : String? = ""
   @objc dynamic var sku : String? = ""
   @objc dynamic var currencyGBP : String? = ""
   @objc dynamic var amountGBP : Double = 0.0
    
    
    
     var parentCategory = LinkingObjects(fromType: Product.self, property: "transactions")
    
}
