//
//  PersonalSpellList.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 3/28/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import Foundation
import CoreData


enum SpellSlotTableType{
    case Caster//Bard, Cleric, Druid, Sorcerer, Wizard
    case Warlock//Warlock
    case SemiCaster//Paladin, Ranger
    case BarelyCaster//Fighter, Rogue
    case NonCaster//Barbarian, Monk
}//SpellSlotTableType

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
    
    static let nonCasterSpellSlotTable: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    
    static let casterSpellSlotTable: [[Int]] =
        [
            [2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 1
            [3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 2
            [4, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 3
            [4, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 4
            [4, 3, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 5
            [4, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 6
            [4, 3, 3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 7
            [4, 3, 3, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 8
            [4, 3, 3, 3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 9
            [4, 3, 3, 3, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 10
            [4, 3, 3, 3, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 11
            [4, 3, 3, 3, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 12
            [4, 3, 3, 3, 2, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 13
            [4, 3, 3, 3, 2, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 14
            [4, 3, 3, 3, 2, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 15
            [4, 3, 3, 3, 2, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 16
            [4, 3, 3, 3, 2, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 17
            [4, 3, 3, 3, 3, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 18
            [4, 3, 3, 3, 3, 2, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 19
            [4, 3, 3, 3, 3, 2, 2, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0] //level 20
        ]
    static let warlockSpellSlotTable: [[Int]] =
    [
        [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 1
        [2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 2
        [0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 3
        [0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 4
        [0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 5
        [0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 6
        [0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 7
        [0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 8
        [0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 9
        [0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 10
        [0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 11
        [0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 12
        [0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 13
        [0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 14
        [0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 15
        [0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 16
        [0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 17
        [0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 18
        [0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 19
        [0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] //level 20
    ]
    static let semiCasterSpellSlotTable: [[Int]] =
    [
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 1
        [2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 2
        [3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 3
        [3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 4
        [4, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 5
        [4, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 6
        [4, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 7
        [4, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 8
        [4, 3, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 9
        [4, 3, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 10
        [4, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 11
        [4, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 12
        [4, 3, 3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 13
        [4, 3, 3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 14
        [4, 3, 3, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 15
        [4, 3, 3, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 16
        [4, 3, 3, 3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 17
        [4, 3, 3, 3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 18
        [4, 3, 3, 3, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 19
        [4, 3, 3, 3, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] //level 20
    ]
    static let barelyCasterSpellSlotTable: [[Int]] =
    [
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 1
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 2
        [2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 3
        [3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 4
        [3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 5
        [3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 6
        [3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 7
        [4, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 8
        [4, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 9
        [4, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 10
        [4, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 11
        [4, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 12
        [4, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 13
        [4, 3, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 14
        [4, 3, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 15
        [4, 3, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 16
        [4, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 17
        [4, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 18
        [4, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],//level 19
        [4, 3, 3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] //level 20
    ]


    static func makePersonalSpellList(forPChar pchar: PCharacter, withPClass pclass: PClass, inManagedObjectContext context: NSManagedObjectContext) -> PersonalSpellList{
        
        let spellListEntity = NSEntityDescription.entityForName("PersonalSpellList", inManagedObjectContext: context)!
        
        let resultList: PersonalSpellList = NSManagedObject(entity: spellListEntity, insertIntoManagedObjectContext: context) as! PersonalSpellList
        
        resultList.pclassId = pclass.id
        resultList.pcharacter = pchar;
        
        resultList.spellSlotStructure = NSMutableArray(array: PersonalSpellList.nonCasterSpellSlotTable)
        resultList.updateSpellSlotsForCharLevel(level: pchar.level, withClassId: pclass.id)
        
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
    
    func updateSpellSlotsForCharLevel(level level: Int16, withClassId: Int16){
        var tableType: SpellSlotTableType = SpellSlotTableType.Caster//temp
        
        switch(withClassId){
        case 1://Barbarian
            tableType = SpellSlotTableType.NonCaster
        case 2://Bard
            tableType = SpellSlotTableType.Caster
        case 3://Cleric
            tableType = SpellSlotTableType.Caster
        case 4://Druid
            tableType = SpellSlotTableType.Caster
        case 5://Fighter
            tableType = SpellSlotTableType.BarelyCaster
        case 6://Monk
            tableType = SpellSlotTableType.NonCaster
        case 7://Paladin
            tableType = SpellSlotTableType.SemiCaster
        case 8://Ranger
            tableType = SpellSlotTableType.SemiCaster
        case 9://Rogue
            tableType = SpellSlotTableType.BarelyCaster
        case 10://Sorcerer
            tableType = SpellSlotTableType.Caster
        case 11://Warlock
            tableType = SpellSlotTableType.Warlock
        case 12://Wizard
            tableType = SpellSlotTableType.Caster
        default:
            break
        }//switch class id
        
        switch(tableType){
        case SpellSlotTableType.Caster:
            updateSpellSlotsAvailableWithSlotTable(PersonalSpellList.casterSpellSlotTable[level - 1])
        case SpellSlotTableType.Warlock:
            updateSpellSlotsAvailableWithSlotTable(PersonalSpellList.warlockSpellSlotTable[level - 1])
        case SpellSlotTableType.SemiCaster:
            updateSpellSlotsAvailableWithSlotTable(PersonalSpellList.semiCasterSpellSlotTable[level - 1])
        case SpellSlotTableType.BarelyCaster:
            updateSpellSlotsAvailableWithSlotTable(PersonalSpellList.barelyCasterSpellSlotTable[level - 1])
        case SpellSlotTableType.NonCaster:
            spellSlotStructure = NSMutableArray(array: PersonalSpellList.nonCasterSpellSlotTable)
        }//switch tableType
        
    }//updateSpellSlotsForCharLevel
    
    func updateSpellSlotsAvailableWithSlotTable(tableRow: [Int]){
        
        for (var i = 0; i < 9; i++){
            spellSlotStructure[i] = tableRow[i]
            if (spellSlotStructure[i + 9] as! Int > spellSlotStructure[i] as! Int){
                spellSlotStructure[i + 9] = spellSlotStructure[i]
            }//if expended now exceeds max
        }//for
        
    }//updatSpellSlotsAvailablewithSlotTable
    
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