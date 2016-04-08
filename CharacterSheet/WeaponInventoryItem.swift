//
//  WeaponInventoryItem.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 4/7/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import Foundation
import CoreData

enum PhysicalDamageType: Int16{
    case Bludgeoning, Piercing, Slashing, Other
}

class WeaponInventoryItem: InventoryItem {

    @NSManaged var damageDieNum: Int16
    @NSManaged var damageDieType: Int16
    @NSManaged var damageTypeValue: Int16
    @NSManaged var finesse: Bool
    @NSManaged var inv_inventory_w: Inventory?
    @NSManaged var equipped: Bool

    var damageDice: (Int16, Int16){
        get{
            return (damageDieNum, damageDieType)
        }
        set{
            self.damageDieNum = newValue.0
            self.damageDieType = newValue.1
        }
    }//damageDice
    
    var damageType: PhysicalDamageType{
        get{
            return PhysicalDamageType(rawValue: self.damageTypeValue)!
        }
        set{
            self.damageTypeValue = newValue.rawValue
        }
    }//damageType
    
}//WeaponInventoryItem
