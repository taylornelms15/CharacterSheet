//
//  PClass.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 2/16/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import Foundation
import CoreData

class PClass: NSManagedObject {

    @NSManaged var id: Int16
    @NSManaged var name: String?
    @NSManaged var hitDie: Int16
    @NSManaged var saveThrows: Int16
    @NSManaged var primAbil: Int16
    @NSManaged var spellList: SpellList
    @NSManaged var subclassIdentifierName: String
    @NSManaged var subClasses: Set<Subclass>
    @NSManaged var features: Set<ClassFeature>

    /*
        A note on saving throw and primary ability values:
        I'm doing a bastard form of encoding these.
        1-6 corresponds to str-cha, in the normal order
        value%10 is the first relevant ability score
        value/10 is the possible second relevant ability score
    */
 
    func hitDieLabel()->String{
        
        return "Hit Die: 1d\(hitDie)"

    }//hitDieLabel
    
    func getRelevantSpellList(atLevel level: Int, inManagedContext context: NSManagedObjectContext, withSubclass: Subclass?)->SpellList{
        
        let slEntity = NSEntityDescription.entityForName("SpellList", inManagedObjectContext: context)!
        var resultList: SpellList? = nil
        
        switch(name!){
        case "Bard":
            return self.spellList
        case "Cleric":
            return self.spellList
        case "Druid":
            return self.spellList
        case "Fighter"://filter based on level and subclass
            resultList = NSManagedObject(entity: slEntity, insertIntoManagedObjectContext: context) as? SpellList
            
            if (withSubclass != nil && withSubclass!.name == "Eldritch Knight" && level >= 3){
                
                resultList!.setSpellsTo(otherlist: self.spellList)//start with base (Wizard) list
                
                if (level < 8){
                    
                    for spell in resultList!.spells{
                        if (spell.level > 0 && spell.school != MagicSchool.Evocation && spell.school != MagicSchool.Abjuration){
                            resultList?.removeSpell(spell: spell)
                        }//if it's not an abjuration or evocation non-cantrip
                    }//for each spell in our resulting list
                    
                }//if under level 8, filter this shit

            }//if we're an eldritch knight of at least 3rd level
            
        case "Paladin":
            return self.spellList
        case "Ranger":
            return self.spellList
        case "Rogue"://filter based on level and subclass
            resultList = NSManagedObject(entity: slEntity, insertIntoManagedObjectContext: context) as? SpellList
            
            if (withSubclass != nil && withSubclass!.name == "Arcane Trickster" && level >= 3){
                
                resultList!.setSpellsTo(otherlist: self.spellList)//start with base (Wizard) list
                
                if (level < 8){
                    
                    for spell in resultList!.spells{
                        if (spell.level > 0 && spell.school != MagicSchool.Illusion && spell.school != MagicSchool.Enchantment){
                            resultList?.removeSpell(spell: spell)
                        }//if it's not an illusion or enchantment non-cantrip
                    }//for each spell in our resulting list
                    
                }//if under level 8, filter this shit
                
            }//if we're an arcane trickster of at least 3rd level
            
        case "Sorcerer":
            return self.spellList
        case "Warlock"://add sublass options
            resultList = NSManagedObject(entity: slEntity, insertIntoManagedObjectContext: context) as? SpellList
            
            resultList!.setSpellsTo(otherlist: self.spellList)
            
            if (withSubclass != nil){
                let subClassList: SpellList = withSubclass!.freeSpellList!
                resultList!.appendContentsOf(otherList: subClassList)
            }//if we have a subclass, put its spells in our options
            
        case "Wizard":
            return self.spellList
        default:
            break
        }
        
        resultList!.temporary = true//so it gets cleaned up after we exit the addSpellVc
        
        do{
            try context.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return resultList!
        
    }//getRelevantSpellList
    
    static func classesInit(entity: NSEntityDescription, context: NSManagedObjectContext){
        
        let class1 = NSManagedObject(entity: entity, insertIntoManagedObjectContext: context)
        
        class1.setValue(1, forKey: "id")
        class1.setValue("Barbarian", forKey: "name")
        class1.setValue(12, forKey: "hitDie")
        class1.setValue(13, forKey: "saveThrows")
        class1.setValue(1, forKey: "primAbil")
        class1.setValue("Primal Path", forKey: "subclassIdentifierName")
        
        let class2 = NSManagedObject(entity: entity, insertIntoManagedObjectContext: context)
        
        class2.setValue(2, forKey: "id")
        class2.setValue("Bard", forKey: "name")
        class2.setValue(8, forKey: "hitDie")
        class2.setValue(26, forKey: "saveThrows")
        class2.setValue(6, forKey: "primAbil")
        class2.setValue("Bard College", forKey: "subclassIdentifierName")
        
        let class3 = NSManagedObject(entity: entity, insertIntoManagedObjectContext: context)
        
        class3.setValue(3, forKey: "id")
        class3.setValue("Cleric", forKey: "name")
        class3.setValue(8, forKey: "hitDie")
        class3.setValue(56, forKey: "saveThrows")
        class3.setValue(5, forKey: "primAbil")
        class3.setValue("Divine Domain", forKey: "subclassIdentifierName")
        
        let class4 = NSManagedObject(entity: entity, insertIntoManagedObjectContext: context)
        
        class4.setValue(4, forKey: "id")
        class4.setValue("Druid", forKey: "name")
        class4.setValue(8, forKey: "hitDie")
        class4.setValue(45, forKey: "saveThrows")
        class4.setValue(5, forKey: "primAbil")
        class4.setValue("Druid Circle", forKey: "subclassIdentifierName")
        
        let class5 = NSManagedObject(entity: entity, insertIntoManagedObjectContext: context)
        
        class5.setValue(5, forKey: "id")
        class5.setValue("Fighter", forKey: "name")
        class5.setValue(10, forKey: "hitDie")
        class5.setValue(13, forKey: "saveThrows")
        class5.setValue(12, forKey: "primAbil")
        class5.setValue("Martial Archetype", forKey: "subclassIdentifierName")
        
        let class6 = NSManagedObject(entity: entity, insertIntoManagedObjectContext: context)
        
        class6.setValue(6, forKey: "id")
        class6.setValue("Monk", forKey: "name")
        class6.setValue(8, forKey: "hitDie")
        class6.setValue(12, forKey: "saveThrows")
        class6.setValue(25, forKey: "primAbil")
        class6.setValue("Monastic Tradition", forKey: "subclassIdentifierName")
        
        let class7 = NSManagedObject(entity: entity, insertIntoManagedObjectContext: context)
        
        class7.setValue(7, forKey: "id")
        class7.setValue("Paladin", forKey: "name")
        class7.setValue(10, forKey: "hitDie")
        class7.setValue(56, forKey: "saveThrows")
        class7.setValue(16, forKey: "primAbil")
        class7.setValue("Sacred Oath", forKey: "subclassIdentifierName")
        
        let class8 = NSManagedObject(entity: entity, insertIntoManagedObjectContext: context)
        
        class8.setValue(8, forKey: "id")
        class8.setValue("Ranger", forKey: "name")
        class8.setValue(10, forKey: "hitDie")
        class8.setValue(12, forKey: "saveThrows")
        class8.setValue(25, forKey: "primAbil")
        class8.setValue("Ranger Archetype", forKey: "subclassIdentifierName")
        
        let class9 = NSManagedObject(entity: entity, insertIntoManagedObjectContext: context)
        
        class9.setValue(9, forKey: "id")
        class9.setValue("Rogue", forKey: "name")
        class9.setValue(8, forKey: "hitDie")
        class9.setValue(24, forKey: "saveThrows")
        class9.setValue(2, forKey: "primAbil")
        class9.setValue("Rogueish Archetype", forKey: "subclassIdentifierName")
        
        let class10 = NSManagedObject(entity: entity, insertIntoManagedObjectContext: context)
        
        class10.setValue(10, forKey: "id")
        class10.setValue("Sorcerer", forKey: "name")
        class10.setValue(6, forKey: "hitDie")
        class10.setValue(36, forKey: "saveThrows")
        class10.setValue(6, forKey: "primAbil")
        class10.setValue("Sorcerous Origin", forKey: "subclassIdentifierName")
        
        let class11 = NSManagedObject(entity: entity, insertIntoManagedObjectContext: context)
        
        class11.setValue(11, forKey: "id")
        class11.setValue("Warlock", forKey: "name")
        class11.setValue(8, forKey: "hitDie")
        class11.setValue(56, forKey: "saveThrows")
        class11.setValue(6, forKey: "primAbil")
        class11.setValue("Otherworldly Patron", forKey: "subclassIdentifierName")
        
        let class12 = NSManagedObject(entity: entity, insertIntoManagedObjectContext: context)
        
        class12.setValue(12, forKey: "id")
        class12.setValue("Wizard", forKey: "name")
        class12.setValue(6, forKey: "hitDie")
        class12.setValue(45, forKey: "saveThrows")
        class12.setValue(4, forKey: "primAbil")
        class12.setValue("Arcane Tradition", forKey: "subclassIdentifierName")
        
        do{
            try context.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }//classesInit
}

