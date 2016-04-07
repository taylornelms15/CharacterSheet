//
//  ArmorInventoryItem.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 4/7/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import Foundation
import CoreData

enum ArmorType: Int16{
    case Light, Medium, Heavy, Shield
}

class ArmorInventoryItem: InventoryItem {

    @NSManaged var baseAC: Int16
    @NSManaged var armorTypeValue: Int16
    @NSManaged var inv_inventory_a: Inventory?
    
    var armorType: ArmorType{
        get{
            return ArmorType(rawValue: armorTypeValue)!
        }
        set{
            self.armorTypeValue = newValue.rawValue
        }
    }//armorType

}//ArmorInventoryItem
