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

    static let mainArmorArray: [ArmorType] = [ArmorType.Light, ArmorType.Medium, ArmorType.Heavy]
    
    @NSManaged var gold: Int64
    @NSManaged var silver: Int64
    @NSManaged var copper: Int64
    @NSManaged var pchar: PCharacter
    @NSManaged var items: NSMutableOrderedSet
    @NSManaged var weapons: NSMutableOrderedSet
    @NSManaged var armor: NSMutableOrderedSet

    //MARK: Adding functions
    
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
    
    //MARK: modification functions
    
    func changeName(item: InventoryItem, newName: String){
        item.name = newName
        
        do{
            let context = self.managedObjectContext!
            try context.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }//changeName
    
    func changeDetails(item: InventoryItem, newDetails: String){
        item.details = newDetails
        do{
            let context = self.managedObjectContext!
            try context.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }//changeDetails
    
    func changeArmorBaseAC(armorItem: ArmorInventoryItem, newBaseAC: Int){
        armorItem.baseAC = Int16(newBaseAC)
        do{
            let context = self.managedObjectContext!
            try context.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }//changeArmorBaseAC
    
    func changeWeaponDamageDice(weaponItem: WeaponInventoryItem, newDamageDice: (Int?, Int?)){
        
        if (newDamageDice.0 != nil){
            weaponItem.damageDice = (Int16(newDamageDice.0!), weaponItem.damageDice.1)
        }//if we got a new damage dice number
        if (newDamageDice.1 != nil){
            weaponItem.damageDice = (weaponItem.damageDice.0, Int16(newDamageDice.1!))
        }//if we got a new damage dice type
        
        do{
            let context = self.managedObjectContext!
            try context.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }//changeWeaponDamageDice
    
    func changeItemQuantity(item: InventoryItem, newQuantity: Double){
        
        item.quantity = newQuantity
        
        do{
            let context = self.managedObjectContext!
            try context.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }//changeItemQuantity
    
    func changeItemWeight(item: InventoryItem, newWeight: Double){
        
        item.weight = newWeight
        
        do{
            let context = self.managedObjectContext!
            try context.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }//changeItemWeight
    
    func changeArmorItemType(armorItem: ArmorInventoryItem, newType: ArmorType){
        
        let prevType: ArmorType = armorItem.armorType
        
        //potential equipped clashes
        if (armorItem.equipped == true){
            
            if (prevType != ArmorType.Shield && newType == ArmorType.Shield){
                let equippedSet = getEquippedShields()
                for shield in equippedSet{
                    shield.equipped = false
                }//for all equipped shields
            }//if it wasn't a shield but is now, then un-equip all other shields
            if (Inventory.mainArmorArray.contains(prevType) == false && Inventory.mainArmorArray.contains(newType)){
                let equippedSet = getEquippedMainArmor()
                for mainArmor in equippedSet{
                    mainArmor.equipped = false
                }//for all equipped main armor
            }//if it wasn't a main armor type but is now, then un-equip all other main armor
            
        }//if
        
        //change the armor type
        armorItem.armorType = newType
        
        do{
            let context = self.managedObjectContext!
            try context.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }//changeArmorItemType
    
    func changeWeaponItemType(weaponItem: WeaponInventoryItem, newType: PhysicalDamageType){
        weaponItem.damageType = newType
        
        do{
            let context = weaponItem.managedObjectContext!
            try context.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }//changeWeaponItemType
    
    func setArmorEquipped(armorItem: ArmorInventoryItem, equipped: Bool){
        
        switch (armorItem.armorType){
        case ArmorType.Light, ArmorType.Medium, ArmorType.Heavy://main armor
            if (equipped == true){
                for a in getEquippedMainArmor(){
                    a.equipped = false
                }//un-equip all other main armor
            }//if equipping
            armorItem.equipped = equipped
        case ArmorType.Shield://shield
            if (equipped == true){
                for a in getEquippedShields(){
                    a.equipped = false
                }//un-equip all other shields
            }//if equipping
            armorItem.equipped = equipped
        case ArmorType.Other://other
            armorItem.equipped = equipped
        }//switch
        
        do{
            let context = self.managedObjectContext!
            try context.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }//setArmorEquipped
    
    //MARK: Equipped helper functions
    
    func getEquippedMainArmor()->[ArmorInventoryItem]{
        var results: [ArmorInventoryItem] = []
        
        for i in armor{
            let a = i as! ArmorInventoryItem
            if (a.equipped && Inventory.mainArmorArray.contains(a.armorType)){
                results.append(a)
            }//if
        }//for all armor
        
        return results
    }//getEquippedMainArmor
    
    func getEquippedShields()->[ArmorInventoryItem]{
        var results: [ArmorInventoryItem] = []
        
        for i in armor{
            let a = i as! ArmorInventoryItem
            if (a.equipped && a.armorType == ArmorType.Shield){
                results.append(a)
            }//if
        }//for all armor
        
        return results
    }//getEquippedShields
    
    func getEquippedOtherArmor()->[ArmorInventoryItem]{
        var results: [ArmorInventoryItem] = []
        
        for i in armor{
            let a = i as! ArmorInventoryItem
            if (a.equipped && a.armorType == ArmorType.Other){
                results.append(a)
            }//if
        }//for all armor
        
        return results
    }//getEquippedOtherArmor
    
    //MARK: Bonus computations
    
    func computeArmorClass()->Int16{
        
        var mainArmorContribution: Int16 = 0
        var shieldContribution: Int16 = 0
        var otherContribution: Int16 = 0
        
        let equippedMain = getEquippedMainArmor()
        let equippedShields = getEquippedShields()
        let equippedOther = getEquippedOtherArmor()
        
        if (equippedMain.count != 0){
            switch (equippedMain[0].armorType){
            case ArmorType.Light:
                let dexMod: Int16 = Int16(pchar.ascores.getDexMod())
                mainArmorContribution = equippedMain[0].baseAC + dexMod
            case ArmorType.Medium:
                var dexMod: Int16 = Int16(pchar.ascores.getDexMod())
                dexMod = (dexMod > 2) ? 2 : dexMod
                mainArmorContribution = equippedMain[0].baseAC + dexMod
            case ArmorType.Heavy:
                mainArmorContribution = equippedMain[0].baseAC
            default:
                mainArmorContribution = 0
            }
        }//if armored
        else{
            let dexMod: Int16 = Int16(pchar.ascores.getDexMod())
            if (pchar.pclass == nil){
                mainArmorContribution = 10 + dexMod
            }
            else if (pchar.pclass!.name! == "Barbarian"){
                let conMod: Int16 = Int16(pchar.ascores.getConMod())
                mainArmorContribution = 10 + dexMod + conMod
            }//if barbarian unarmored
            else if (pchar.pclass!.name! == "Monk"){
                let wisMod: Int16 = Int16(pchar.ascores.getWisMod())
                mainArmorContribution = 10 + dexMod + wisMod
            }//if monk unarmored
            else if (pchar.pclass!.name! == "Sorcerer" && pchar.subclass?.name == "Draconic Bloodline"){
                mainArmorContribution = 13 + dexMod
            }//if sorcerer unarmored
            //TODO: when dealing with subclass, make this draconic sorcerer only
            else{
                mainArmorContribution = 10 + dexMod
            }//regular unarmored
        }//if unarmored
        
        //TODO: consider limiting shields to a +2
        if (equippedShields.count != 0){
            shieldContribution = equippedShields[0].baseAC
        }
        
        if (equippedOther.count != 0){
            for otherArmor in equippedOther{
                otherContribution += otherArmor.baseAC
            }
        }//if
        
        return mainArmorContribution + shieldContribution + otherContribution
    }//computeArmorClass
    
    func computeMeleeBonus()->Int16{
        let strMod = pchar.ascores.getStrMod()
        let profBonus = pchar.getProfBonus()
        
        return Int16(strMod + profBonus)
    }//computeMeleeBonus
    
    func computeRangedBonus()->Int16{
        let dexMod = pchar.ascores.getDexMod()
        let profBonus = pchar.getProfBonus()
        
        return Int16(dexMod + profBonus)
    }//computeRangedBonus
    
    func computePackWeight()->Double{
        
        var totalWeight: Double = 0.0
        
        for i in items{
            let a: InventoryItem = i as! InventoryItem
            
            if (a.weight >= 0){
                totalWeight += a.weight
            }//if
            
        }//for each pack item
        
        return totalWeight
        
    }//computePackWeight
    
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
