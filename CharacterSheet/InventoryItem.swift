//
//  InventoryItem.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 4/7/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import Foundation
import CoreData

class InventoryItem: NSManagedObject {

    ///id used to keep track of its order within inventory, and not its position globally
    @NSManaged var id: Int64
    @NSManaged var name: String
    @NSManaged var quantity: Double
    @NSManaged var details: String
    @NSManaged var inv_inventory: Inventory?
    ///Weight in pounds; letting -1 stand in for "no weight"
    @NSManaged var weight: Double

    func setInfoWithCore(core: InventoryItemCore){
        name = core.name
        details = core.details
        quantity = core.quantity
        
        if (core.weight == -1){
            weight = 0.0
        }
        else{
            weight = core.weight
        }
    }
    
}

struct InventoryItemCore{
    var name: String
    var details: String
    var quantity: Double
    var weight: Double
    
    init(){
        name = ""
        details = ""
        quantity = 1
        weight = -1
    }//init
}
