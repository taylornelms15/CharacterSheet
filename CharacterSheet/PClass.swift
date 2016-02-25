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

    /*
        A note on saving throw and primary ability values:
        I'm doing a bastard form of encoding these.
        1-6 corresponds to str-cha, in the normal order
        value%10 is the first relevant ability score
        value/10 is the possible second relevant ability score
    */
 
    
    static func classesInit(entity: NSEntityDescription, context: NSManagedObjectContext){
        
        let class1 = NSManagedObject(entity: entity, insertIntoManagedObjectContext: context)
        
        class1.setValue(1, forKey: "id")
        class1.setValue("Barbarian", forKey: "name")
        class1.setValue(12, forKey: "hitDie")
        class1.setValue(13, forKey: "saveThrows")
        class1.setValue(1, forKey: "primAbil")
        
        let class2 = NSManagedObject(entity: entity, insertIntoManagedObjectContext: context)
        
        class2.setValue(2, forKey: "id")
        class2.setValue("Bard", forKey: "name")
        class2.setValue(8, forKey: "hitDie")
        class2.setValue(26, forKey: "saveThrows")
        class2.setValue(6, forKey: "primAbil")
        
        let class3 = NSManagedObject(entity: entity, insertIntoManagedObjectContext: context)
        
        class3.setValue(3, forKey: "id")
        class3.setValue("Cleric", forKey: "name")
        class3.setValue(8, forKey: "hitDie")
        class3.setValue(56, forKey: "saveThrows")
        class3.setValue(5, forKey: "primAbil")
        
        let class4 = NSManagedObject(entity: entity, insertIntoManagedObjectContext: context)
        
        class4.setValue(4, forKey: "id")
        class4.setValue("Druid", forKey: "name")
        class4.setValue(8, forKey: "hitDie")
        class4.setValue(45, forKey: "saveThrows")
        class4.setValue(5, forKey: "primAbil")
        
        let class5 = NSManagedObject(entity: entity, insertIntoManagedObjectContext: context)
        
        class5.setValue(5, forKey: "id")
        class5.setValue("Fighter", forKey: "name")
        class5.setValue(10, forKey: "hitDie")
        class5.setValue(13, forKey: "saveThrows")
        class5.setValue(12, forKey: "primAbil")
        
        let class6 = NSManagedObject(entity: entity, insertIntoManagedObjectContext: context)
        
        class6.setValue(6, forKey: "id")
        class6.setValue("Monk", forKey: "name")
        class6.setValue(8, forKey: "hitDie")
        class6.setValue(12, forKey: "saveThrows")
        class6.setValue(25, forKey: "primAbil")
        
        let class7 = NSManagedObject(entity: entity, insertIntoManagedObjectContext: context)
        
        class7.setValue(7, forKey: "id")
        class7.setValue("Paladin", forKey: "name")
        class7.setValue(10, forKey: "hitDie")
        class7.setValue(56, forKey: "saveThrows")
        class7.setValue(16, forKey: "primAbil")
        
        let class8 = NSManagedObject(entity: entity, insertIntoManagedObjectContext: context)
        
        class8.setValue(8, forKey: "id")
        class8.setValue("Ranger", forKey: "name")
        class8.setValue(10, forKey: "hitDie")
        class8.setValue(12, forKey: "saveThrows")
        class8.setValue(25, forKey: "primAbil")
        
        let class9 = NSManagedObject(entity: entity, insertIntoManagedObjectContext: context)
        
        class9.setValue(9, forKey: "id")
        class9.setValue("Rogue", forKey: "name")
        class9.setValue(8, forKey: "hitDie")
        class9.setValue(24, forKey: "saveThrows")
        class9.setValue(2, forKey: "primAbil")
        
        let class10 = NSManagedObject(entity: entity, insertIntoManagedObjectContext: context)
        
        class10.setValue(10, forKey: "id")
        class10.setValue("Sorcerer", forKey: "name")
        class10.setValue(6, forKey: "hitDie")
        class10.setValue(36, forKey: "saveThrows")
        class10.setValue(6, forKey: "primAbil")
        
        let class11 = NSManagedObject(entity: entity, insertIntoManagedObjectContext: context)
        
        class11.setValue(11, forKey: "id")
        class11.setValue("Warlock", forKey: "name")
        class11.setValue(8, forKey: "hitDie")
        class11.setValue(56, forKey: "saveThrows")
        class11.setValue(6, forKey: "primAbil")
        
        let class12 = NSManagedObject(entity: entity, insertIntoManagedObjectContext: context)
        
        class12.setValue(12, forKey: "id")
        class12.setValue("Wizard", forKey: "name")
        class12.setValue(6, forKey: "hitDie")
        class12.setValue(45, forKey: "saveThrows")
        class12.setValue(4, forKey: "primAbil")
        
        do{
            try context.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }//classesInit
}

