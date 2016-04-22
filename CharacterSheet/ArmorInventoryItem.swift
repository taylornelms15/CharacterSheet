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
    case Light, Medium, Heavy, Shield, Other
}

class ArmorInventoryItem: InventoryItem {

    @NSManaged var baseAC: Int16
    @NSManaged var armorTypeValue: Int16
    @NSManaged var inv_inventory_a: Inventory?
    @NSManaged var equipped: Bool
    
    var armorType: ArmorType{
        get{
            return ArmorType(rawValue: armorTypeValue)!
        }
        set{
            self.armorTypeValue = newValue.rawValue
        }
    }//armorType
    
    func setInfoWithCore(core: ArmorInventoryItemCore){
        name = core.name
        details = core.details
        baseAC = core.baseAC
        armorType = core.armorType
    }//setInfoWithCore

}//ArmorInventoryItem

struct ArmorInventoryItemCore{
    var name: String
    var details: String
    var baseAC: Int16
    var armorType: ArmorType
    
    init(){
        name = ""
        details = ""
        baseAC = 0
        armorType = ArmorType.Other
    }
}
