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
    @NSManaged var items: NSMutableOrderedSet
    @NSManaged var weapons: NSMutableOrderedSet
    @NSManaged var armor: NSMutableOrderedSet

    
    func addArmorItem(item: ArmorInventoryItem){
        let count = armor.count
        item.id = Int64(count)
        armor.insertObject(item, atIndex: count)
        //Note: I'm not sure why I have to put both relationships in (direct and inverse);
        //Best I can figure, it's that swift still isn't terribly hip with subclassing of to-many relationships, and how they're represented.
        //That said, this should still work out pretty well.
        item.inv_inventory_a = self
        
        do{
            try item.managedObjectContext!.save()
        }
        catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }//addArmorItem
    
    func addWeaponItem(item: WeaponInventoryItem){
        
        let count = weapons.count
        item.id = Int64(count)
        weapons.insertObject(item, atIndex: count)
        item.inv_inventory_w = self
        
        do{
            try item.managedObjectContext!.save()
        }
        catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }//addWeaponItem
    
    func addItem(item: InventoryItem){
        
        let count = items.count
        item.id = Int64(count)
        items.insertObject(item, atIndex: count)
        item.inv_inventory = self
        
        do{
            try item.managedObjectContext!.save()
        }
        catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }//addWeaponItem
    
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
