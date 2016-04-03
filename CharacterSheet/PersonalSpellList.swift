//
//  PersonalSpellList.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 3/28/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import Foundation
import CoreData


class PersonalSpellList: SpellList {

    @NSManaged var wasFreeSet: NSMutableSet
    @NSManaged var preparedSet: NSMutableSet
    @NSManaged var pcharacter: PCharacter?
    @NSManaged var pclassId: Int16
    @NSManaged var spellSlotStructure: NSMutableArray
    /*
        The structure for spellSlotStructure is as a one-dimensional array of Ints.
        Indeces 0-8: available slots for levels 1-9
        Indeces 9-17: used slots for levels 1-9
        Should be modified only through defined functions
    */


    static func makePersonalSpellList(forPChar pchar: PCharacter, withPClass pclass: PClass, inManagedObjectContext context: NSManagedObjectContext) -> PersonalSpellList{
        
        let spellListEntity = NSEntityDescription.entityForName("PersonalSpellList", inManagedObjectContext: context)!
        
        let resultList: PersonalSpellList = NSManagedObject(entity: spellListEntity, insertIntoManagedObjectContext: context) as! PersonalSpellList
        
        resultList.pclassId = pclass.id
        resultList.pcharacter = pchar;
        
        resultList.spellSlotStructure = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        
        return resultList
        
    }//makePersonalSpellList
    
    func getPClassName()->String{
        switch (pclassId){
        case 1:
            return "Barbarian"
        case 2:
            return "Bard"
        case 3:
            return "Cleric"
        case 4:
            return "Druid"
        case 5:
            return "Fighter"
        case 6:
            return "Monk"
        case 7:
            return "Paladin"
        case 8:
            return "Ranger"
        case 9:
            return "Rogue"
        case 10:
            return "Sorcerer"
        case 11:
            return "Warlock"
        case 12:
            return "Wizard"
        default:
            return ""
        }//switch

    }//getPClassName
    
    //MARK: slot-modifying functions
    
    func getSlotsAvailableForLevel(level level: Int16) -> Int{
        return spellSlotStructure.objectAtIndex(Int(level) - 1) as! Int
    }//getSlotsAvailableForLevel
    
    func setSlotsAvailableForLevel(slots slots: Int, level: Int16){
        spellSlotStructure.insertObject(slots, atIndex: Int(level) - 1)
    }//setSlotsAvailableForLevel
    
    func getSlotsExpendedForLevel(level level: Int16) -> Int{
        return spellSlotStructure.objectAtIndex(Int(level) + 8) as! Int
    }//getSlotsExpendedForLevel
    
    func setSlotsExpendedForLevel(slots slots: Int, level: Int16){
        spellSlotStructure.insertObject(slots, atIndex: Int(level) + 8)
    }//setSlotsExpendedForLevel
    
    func incrementSlotsExpendedForLevel(level level: Int16){
        let oldSlots: Int = getSlotsExpendedForLevel(level: level)
        if (oldSlots >= getSlotsAvailableForLevel(level: level)){
            return
        }//if at max
        else{
            setSlotsExpendedForLevel(slots: oldSlots + 1, level: level)
        }//else
    }//incSlotsExpendedForLevel
    
    func decrementSlotsExpendedForLevel(level level: Int16){
        let oldSlots: Int = getSlotsExpendedForLevel(level: level)
        if (oldSlots <= 0){
            return
        }//if at 0
        else{
            setSlotsExpendedForLevel(slots: oldSlots - 1, level: level)
        }//else
    }//decrementSlotsExpendedForLevel
    
    //MARK: spell-marking functions
    
    func toggleSpellFreedom(spell: Spell){
        if (isSpellFree(spell)){
            markAsNotFree(spell)
        }
        else{
            markAsFree(spell)
        }
    }
    func isSpellFree(spell: Spell) -> Bool {
        return wasFreeSet.containsObject(Int(spell.id))
    }
    func markAsFree(spell: Spell){
        wasFreeSet.addObject(Int(spell.id))
    }
    func markAsNotFree(spell: Spell){
        wasFreeSet.removeObject(Int(spell.id))
    }
    func toggleSpellPrepared(spell: Spell){
        if (isSpellPrepared(spell)){
            markAsPrepared(spell)
        }
        else{
            markAsNotPrepared(spell)
        }
    }
    func isSpellPrepared(spell: Spell) -> Bool {
        return preparedSet.containsObject(Int(spell.id))
    }
    func markAsPrepared(spell: Spell){
        preparedSet.addObject(Int(spell.id))
    }
    func markAsNotPrepared(spell: Spell){
        preparedSet.removeObject(Int(spell.id))
    }
    
}//PersonalSpellList