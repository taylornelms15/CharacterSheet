//
//  Race.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 1/28/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import CoreData
import Foundation


class Race: NSManagedObject{

    @NSManaged var id: Int16
    @NSManaged var name: String?
    @NSManaged var strmod: Int16
    @NSManaged var dexmod: Int16
    @NSManaged var conmod: Int16
    @NSManaged var intmod: Int16
    @NSManaged var wismod: Int16
    @NSManaged var chamod: Int16
    @NSManaged var features: NSSet?
    
    func printShort()->NSString{
        return "\(id): " + name! + "\nstr:\(strmod)\ndex:\(dexmod)\ncon:\(conmod)\nint:\(intmod)\nwis:\(wismod)\ncha:\(chamod)\n"
    }//printShort
    
}

func racesInit(entity: NSEntityDescription, context: NSManagedObjectContext){
    
    let rfEntity = NSEntityDescription.entityForName("RaceFeature", inManagedObjectContext: context)!
    
    let race1 = NSManagedObject(entity: entity,
        insertIntoManagedObjectContext: context) as! Race
    
    
    race1.setValue(1, forKey: "id");
    race1.setValue("Hill Dwarf", forKey: "name");
    race1.setValue(0, forKey: "strmod");
    race1.setValue(0, forKey: "dexmod");
    race1.setValue(2, forKey: "conmod");
    race1.setValue(0, forKey: "intmod");
    race1.setValue(1, forKey: "wismod");
    race1.setValue(0, forKey: "chamod");
    
    let race2 = NSManagedObject(entity: entity,
        insertIntoManagedObjectContext: context) as! Race
    
    race2.setValue(2, forKey: "id");
    race2.setValue("Mountain Dwarf", forKey: "name");
    race2.setValue(2, forKey: "strmod");
    race2.setValue(0, forKey: "dexmod");
    race2.setValue(2, forKey: "conmod");
    race2.setValue(0, forKey: "intmod");
    race2.setValue(0, forKey: "wismod");
    race2.setValue(0, forKey: "chamod");
    
    let race3 = NSManagedObject(entity: entity,
        insertIntoManagedObjectContext: context) as! Race
    
    race3.setValue(3, forKey: "id");
    race3.setValue("High Elf", forKey: "name");
    race3.setValue(0, forKey: "strmod");
    race3.setValue(2, forKey: "dexmod");
    race3.setValue(0, forKey: "conmod");
    race3.setValue(1, forKey: "intmod");
    race3.setValue(0, forKey: "wismod");
    race3.setValue(0, forKey: "chamod");
    
    let race4 = NSManagedObject(entity: entity,
        insertIntoManagedObjectContext: context) as! Race
    
    race4.setValue(4, forKey: "id");
    race4.setValue("Wood Elf", forKey: "name");
    race4.setValue(0, forKey: "strmod");
    race4.setValue(2, forKey: "dexmod");
    race4.setValue(0, forKey: "conmod");
    race4.setValue(0, forKey: "intmod");
    race4.setValue(1, forKey: "wismod");
    race4.setValue(0, forKey: "chamod");
    
    let race5 = NSManagedObject(entity: entity,
        insertIntoManagedObjectContext: context) as! Race
    
    race5.setValue(5, forKey: "id");
    race5.setValue("Dark Elf", forKey: "name");
    race5.setValue(0, forKey: "strmod");
    race5.setValue(2, forKey: "dexmod");
    race5.setValue(0, forKey: "conmod");
    race5.setValue(0, forKey: "intmod");
    race5.setValue(0, forKey: "wismod");
    race5.setValue(1, forKey: "chamod");
    
    let race6 = NSManagedObject(entity: entity,
        insertIntoManagedObjectContext: context) as! Race
    
    race6.setValue(6, forKey: "id");
    race6.setValue("Lightfoot Halfling", forKey: "name");
    race6.setValue(0, forKey: "strmod");
    race6.setValue(2, forKey: "dexmod");
    race6.setValue(0, forKey: "conmod");
    race6.setValue(0, forKey: "intmod");
    race6.setValue(0, forKey: "wismod");
    race6.setValue(1, forKey: "chamod");
    
    let race7 = NSManagedObject(entity: entity,
        insertIntoManagedObjectContext: context) as! Race
    
    race7.setValue(7, forKey: "id");
    race7.setValue("Stout Halfling", forKey: "name");
    race7.setValue(0, forKey: "strmod");
    race7.setValue(2, forKey: "dexmod");
    race7.setValue(1, forKey: "conmod");
    race7.setValue(0, forKey: "intmod");
    race7.setValue(0, forKey: "wismod");
    race7.setValue(0, forKey: "chamod");
    
    let race8 = NSManagedObject(entity: entity,
        insertIntoManagedObjectContext: context) as! Race
    
    race8.setValue(8, forKey: "id");
    race8.setValue("Human", forKey: "name");
    race8.setValue(1, forKey: "strmod");
    race8.setValue(1, forKey: "dexmod");
    race8.setValue(1, forKey: "conmod");
    race8.setValue(1, forKey: "intmod");
    race8.setValue(1, forKey: "wismod");
    race8.setValue(1, forKey: "chamod");
    
    let race9 = NSManagedObject(entity: entity,
        insertIntoManagedObjectContext: context) as! Race
    
    race9.setValue(9, forKey: "id");
    race9.setValue("Dragonborn", forKey: "name");
    race9.setValue(2, forKey: "strmod");
    race9.setValue(0, forKey: "dexmod");
    race9.setValue(0, forKey: "conmod");
    race9.setValue(0, forKey: "intmod");
    race9.setValue(0, forKey: "wismod");
    race9.setValue(1, forKey: "chamod");
    
    let race10 = NSManagedObject(entity: entity,
        insertIntoManagedObjectContext: context) as! Race
    
    race10.setValue(10, forKey: "id");
    race10.setValue("Forest Gnome", forKey: "name");
    race10.setValue(0, forKey: "strmod");
    race10.setValue(1, forKey: "dexmod");
    race10.setValue(0, forKey: "conmod");
    race10.setValue(2, forKey: "intmod");
    race10.setValue(0, forKey: "wismod");
    race10.setValue(0, forKey: "chamod");
    
    let race11 = NSManagedObject(entity: entity,
        insertIntoManagedObjectContext: context) as! Race
    
    race11.setValue(11, forKey: "id");
    race11.setValue("Rock Gnome", forKey: "name");
    race11.setValue(0, forKey: "strmod");
    race11.setValue(0, forKey: "dexmod");
    race11.setValue(1, forKey: "conmod");
    race11.setValue(2, forKey: "intmod");
    race11.setValue(0, forKey: "wismod");
    race11.setValue(0, forKey: "chamod");
    
    let race12 = NSManagedObject(entity: entity,
        insertIntoManagedObjectContext: context) as! Race
    
    race12.setValue(12, forKey: "id");
    race12.setValue("Half-Elf", forKey: "name");
    race12.setValue(0, forKey: "strmod");
    race12.setValue(0, forKey: "dexmod");
    race12.setValue(0, forKey: "conmod");
    race12.setValue(1, forKey: "intmod");
    race12.setValue(1, forKey: "wismod");
    race12.setValue(2, forKey: "chamod");
    
    let race13 = NSManagedObject(entity: entity,
        insertIntoManagedObjectContext: context) as! Race
    
    race13.setValue(13, forKey: "id");
    race13.setValue("Half-Orc", forKey: "name");
    race13.setValue(2, forKey: "strmod");
    race13.setValue(0, forKey: "dexmod");
    race13.setValue(1, forKey: "conmod");
    race13.setValue(0, forKey: "intmod");
    race13.setValue(0, forKey: "wismod");
    race13.setValue(0, forKey: "chamod");
    
    let race14 = NSManagedObject(entity: entity,
        insertIntoManagedObjectContext: context) as! Race
    
    race14.setValue(14, forKey: "id");
    race14.setValue("Tiefling", forKey: "name");
    race14.setValue(0, forKey: "strmod");
    race14.setValue(0, forKey: "dexmod");
    race14.setValue(0, forKey: "conmod");
    race14.setValue(1, forKey: "intmod");
    race14.setValue(0, forKey: "wismod");
    race14.setValue(2, forKey: "chamod");

    let raceFeature1 = NSManagedObject(entity: rfEntity, insertIntoManagedObjectContext: context) as! RaceFeature
    raceFeature1.setValue(21, forKey: "id")
    raceFeature1.setValue("Darkvision 60ft", forKey: "name")
    raceFeature1.setValue("You have superior vision in dark and dim conditions. You can see in dim light within 60 feet of you as if it were bright light, and in darkness as if it were dim light (albeit without color vision).", forKey: "details")
    raceFeature1.races = Set<Race>(arrayLiteral: race1, race2, race3, race4, race10, race11, race12, race13, race14)
    
    let raceFeature2 = NSManagedObject(entity: rfEntity, insertIntoManagedObjectContext: context) as! RaceFeature
    raceFeature2.setValue(22, forKey: "id")
    raceFeature2.setValue("Dwarven Resilience", forKey: "name")
    raceFeature2.setValue("You have advantage on saving throws against poison, and you have resistance against poison damage.", forKey: "details")
    raceFeature2.races = Set<Race>(arrayLiteral: race1, race2)
    
    let raceFeature3 = NSManagedObject(entity: rfEntity, insertIntoManagedObjectContext: context) as! RaceFeature
    raceFeature3.setValue(23, forKey: "id")
    raceFeature3.setValue("Stonecunning", forKey: "name")
    raceFeature3.setValue("When you make a History check related to the origin of stonework, you are considered proficient and add double your proficiency bonus to the check.", forKey: "details")
    raceFeature3.races = Set<Race>(arrayLiteral: race1, race2)
    
    
    do{
        try context.save()
    }catch let error as NSError{
        print("Could not save \(error), \(error.userInfo)")
    }
    
}