//
//  Inventory.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 4/7/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import Foundation
import CoreData


class Inventory: NSManagedObject {

    @NSManaged var gold: Int64
    @NSManaged var silver: Int64
    @NSManaged var copper: Int64
    @NSManaged var pchar: PCharacter
    @NSManaged var items: NSOrderedSet
    @NSManaged var weapons: NSOrderedSet
    @NSManaged var armor: NSOrderedSet

    
    
    //MARK: UITableView datasource helpers
    
    func getArmorAtIndex(index index: Int)->ArmorInventoryItem{
        return armor[index] as! ArmorInventoryItem
    }//getArmorAtIndex
    
    func getWeaponAtIndex(index index: Int)->WeaponInventoryItem{
        return weapons[index] as! WeaponInventoryItem
    }//getWeaponAtIndex
    
    func getItemAtIndex(index index: Int)->InventoryItem{
        return items[index] as! InventoryItem
    }//getItemAtIndex
    
    func getNumItems() -> Int{
        return items.count
    }//getNumItems
    
    func getNumWeapons() -> Int{
        return weapons.count
    }//getNumWeapons
    
    func getNumArmor() -> Int{
        return armor.count
    }//getNumArmor
    
}//Inventory
