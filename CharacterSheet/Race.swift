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
    race12.setValue(0, forKey: "intmod");
    race12.setValue(0, forKey: "wismod");
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
    
    let raceFeature4 = NSManagedObject(entity: rfEntity, insertIntoManagedObjectContext: context) as! RaceFeature
    raceFeature4.setValue(24, forKey: "id")
    raceFeature4.setValue("Fey Ancestry", forKey: "name")
    raceFeature4.setValue("You have advantage on saving throws against being charmed, and magic can't put you to sleep.", forKey: "details")
    raceFeature4.races = Set<Race>(arrayLiteral: race3, race4, race5, race12)
    
    let raceFeature5 = NSManagedObject(entity: rfEntity, insertIntoManagedObjectContext: context) as! RaceFeature
    raceFeature5.setValue(25, forKey: "id")
    raceFeature5.setValue("Trance", forKey: "name")
    raceFeature5.setValue("Instead of sleeping, you can meditate deeply, remaining semiconscious, for 4 hours. You thereby gain the same benefit that a human does from 8 hours of sleep.", forKey: "details")
    raceFeature5.races = Set<Race>(arrayLiteral: race3, race4, race5)
    
    let raceFeature6 = NSManagedObject(entity: rfEntity, insertIntoManagedObjectContext: context) as! RaceFeature
    raceFeature6.setValue(26, forKey: "id")
    raceFeature6.setValue("Cantrip", forKey: "name")
    raceFeature6.setValue("You know one cantrip from the Wizard spell list of your choice, with Intelligence being your spellcasting ability for it.", forKey: "details")
    raceFeature6.races = Set<Race>(arrayLiteral: race3)
    
    let raceFeature7 = NSManagedObject(entity: rfEntity, insertIntoManagedObjectContext: context) as! RaceFeature
    raceFeature7.setValue(27, forKey: "id")
    raceFeature7.setValue("Extra Language", forKey: "name")
    raceFeature7.setValue("You know one additional language of your choice.", forKey: "details")
    raceFeature7.races = Set<Race>(arrayLiteral: race3)
    
    let raceFeature8 = NSManagedObject(entity: rfEntity, insertIntoManagedObjectContext: context) as! RaceFeature
    raceFeature8.setValue(28, forKey: "id")
    raceFeature8.setValue("Mask of the Wild", forKey: "name")
    raceFeature8.setValue("You may attempt to hide even when only lightly obscured by foliage, heavy rain, falling snow, mist, or other natural phenomena.", forKey: "details")
    raceFeature8.races = Set<Race>(arrayLiteral: race4)
    
    let raceFeature9 = NSManagedObject(entity: rfEntity, insertIntoManagedObjectContext: context) as! RaceFeature
    raceFeature9.setValue(29, forKey: "id")
    raceFeature9.setValue("Darkvision 120ft", forKey: "name")
    raceFeature9.setValue("You have superior vision in dark and dim conditions. You can see in dim light within 120 feet of you as if it were bright light, and in darkness as if it were dim light (albeit without color vision).", forKey: "details")
    raceFeature9.races = Set<Race>(arrayLiteral: race5)
    
    let raceFeature10 = NSManagedObject(entity: rfEntity, insertIntoManagedObjectContext: context) as! RaceFeature
    raceFeature10.setValue(30, forKey: "id")
    raceFeature10.setValue("Sunlight Sensitivity", forKey: "name")
    raceFeature10.setValue("You have disadvantage on attack rolls and Perception checks that rely on sight when you, the target of your attack, or that which you wish to perceive, is in direct sunlight.", forKey: "details")
    raceFeature10.races = Set<Race>(arrayLiteral: race5)
    
    let raceFeature11 = NSManagedObject(entity: rfEntity, insertIntoManagedObjectContext: context) as! RaceFeature
    raceFeature11.setValue(31, forKey: "id")
    raceFeature11.setValue("Drow Magic", forKey: "name")
    raceFeature11.setValue("You know the Dancing Lights cantrip. At level 3, you can cast Faerie Fire once per long rest, and may do the same with Darkness on reaching level 5. All these spells use Charisma as their spellcasting ability.", forKey: "details")
    raceFeature11.races = Set<Race>(arrayLiteral: race5)
    
    let raceFeature12 = NSManagedObject(entity: rfEntity, insertIntoManagedObjectContext: context) as! RaceFeature
    raceFeature12.setValue(32, forKey: "id")
    raceFeature12.setValue("Lucky", forKey: "name")
    raceFeature12.setValue("When you roll a 1 on the d20 for an attack roll, ability check, or saving throw, you may re-roll the die, and must use the new roll.", forKey: "details")
    raceFeature12.races = Set<Race>(arrayLiteral: race6, race7)
    
    let raceFeature13 = NSManagedObject(entity: rfEntity, insertIntoManagedObjectContext: context) as! RaceFeature
    raceFeature13.setValue(33, forKey: "id")
    raceFeature13.setValue("Brave", forKey: "name")
    raceFeature13.setValue("You have advantage on saving throws against being frightened.", forKey: "details")
    raceFeature13.races = Set<Race>(arrayLiteral: race6, race7)
    
    let raceFeature14 = NSManagedObject(entity: rfEntity, insertIntoManagedObjectContext: context) as! RaceFeature
    raceFeature14.setValue(34, forKey: "id")
    raceFeature14.setValue("Halfling Nimbleness", forKey: "name")
    raceFeature14.setValue("You can move through the space of any creature that is larger than you.", forKey: "details")
    raceFeature14.races = Set<Race>(arrayLiteral: race6, race7)
    
    let raceFeature15 = NSManagedObject(entity: rfEntity, insertIntoManagedObjectContext: context) as! RaceFeature
    raceFeature15.setValue(35, forKey: "id")
    raceFeature15.setValue("Naturally Stealthy", forKey: "name")
    raceFeature15.setValue("You can attempt to hide even when you are only obscured by a creature that is only slightly larger than you.", forKey: "details")
    raceFeature15.races = Set<Race>(arrayLiteral: race6)
    
    let raceFeature16 = NSManagedObject(entity: rfEntity, insertIntoManagedObjectContext: context) as! RaceFeature
    raceFeature16.setValue(36, forKey: "id")
    raceFeature16.setValue("Stout Resilience", forKey: "name")
    raceFeature16.setValue("You have advantage on saving throws against poison, and you have resistance against poison damage.", forKey: "details")
    raceFeature16.races = Set<Race>(arrayLiteral: race7)
    
    let raceFeature17 = NSManagedObject(entity: rfEntity, insertIntoManagedObjectContext: context) as! RaceFeature
    raceFeature17.setValue(37, forKey: "id")
    raceFeature17.setValue("Draconic Ancestry", forKey: "name")
    raceFeature17.setValue("You may choose a type of dragon as your ancestry. This determines the nature of your breath weapon and damage resistance.", forKey: "details")
    raceFeature17.races = Set<Race>(arrayLiteral: race9)
    
    let raceFeature18 = NSManagedObject(entity: rfEntity, insertIntoManagedObjectContext: context) as! RaceFeature
    raceFeature18.setValue(38, forKey: "id")
    raceFeature18.setValue("Breath Weapon", forKey: "name")
    raceFeature18.setValue("Once per short or long rest, you may use your breath weapon. The type and range of this varies based on your ancestry. Each creature in the area must make a saving throw, the DC for which is 8 plus your Constitution modifier plus your proficiency bonus, taking 2d6 damage on a failed save and half as much on a successful one. The damage increases to 3d6 at level 6 and 4d6 at level 11.", forKey: "details")
    raceFeature18.races = Set<Race>(arrayLiteral: race9)
    
    let raceFeature19 = NSManagedObject(entity: rfEntity, insertIntoManagedObjectContext: context) as! RaceFeature
    raceFeature19.setValue(39, forKey: "id")
    raceFeature19.setValue("Damage Resistance", forKey: "name")
    raceFeature19.setValue("You have resistance to the damage type associated with your ancestry.", forKey: "details")
    raceFeature19.races = Set<Race>(arrayLiteral: race9)
    
    let raceFeature20 = NSManagedObject(entity: rfEntity, insertIntoManagedObjectContext: context) as! RaceFeature
    raceFeature20.setValue(40, forKey: "id")
    raceFeature20.setValue("Gnome Cunning", forKey: "name")
    raceFeature20.setValue("You have advantage on all Intelligence, Wisdom, and Charisma saving throws against magic.", forKey: "details")
    raceFeature20.races = Set<Race>(arrayLiteral: race10, race11)
    
    let raceFeature21 = NSManagedObject(entity: rfEntity, insertIntoManagedObjectContext: context) as! RaceFeature
    raceFeature21.setValue(41, forKey: "id")
    raceFeature21.setValue("Natural Illusionist", forKey: "name")
    raceFeature21.setValue("You know the Minor Illusion cantrip, with Intelligence being your spellcasting ability for it.", forKey: "details")
    raceFeature21.races = Set<Race>(arrayLiteral: race10)
    
    let raceFeature22 = NSManagedObject(entity: rfEntity, insertIntoManagedObjectContext: context) as! RaceFeature
    raceFeature22.setValue(42, forKey: "id")
    raceFeature22.setValue("Speak with Small Beasts", forKey: "name")
    raceFeature22.setValue("You can communicate simple ideas with Small or smaller beasts.", forKey: "details")
    raceFeature22.races = Set<Race>(arrayLiteral: race10)
    
    let raceFeature23 = NSManagedObject(entity: rfEntity, insertIntoManagedObjectContext: context) as! RaceFeature
    raceFeature23.setValue(43, forKey: "id")
    raceFeature23.setValue("Artificer's Lore", forKey: "name")
    raceFeature23.setValue("Whenever you make a History check related to magic items, alchemical objects, or technological devices, you are considered proficient and add double your proficiency bonus to the check.", forKey: "details")
    raceFeature23.races = Set<Race>(arrayLiteral: race11)
    
    let raceFeature24 = NSManagedObject(entity: rfEntity, insertIntoManagedObjectContext: context) as! RaceFeature
    raceFeature24.setValue(44, forKey: "id")
    raceFeature24.setValue("Tinker", forKey: "name")
    raceFeature24.setValue("You may spend 1 hour and 10 gp worth of materials to construct a Tiny clockwork device (AC 5, 1 hp), that will cease working after 24 hours or when you dismantle it. You may have up to three active at once. You may make a Clockwork Toy, a Fire Starter, or a Music Box.", forKey: "details")
    raceFeature24.races = Set<Race>(arrayLiteral: race11)
    
    let raceFeature25 = NSManagedObject(entity: rfEntity, insertIntoManagedObjectContext: context) as! RaceFeature
    raceFeature25.setValue(45, forKey: "id")
    raceFeature25.setValue("Skill Versatility", forKey: "name")
    raceFeature25.setValue("You gain proficiency in two skills of your choice.", forKey: "details")
    raceFeature25.races = Set<Race>(arrayLiteral: race12)
    
    let raceFeature26 = NSManagedObject(entity: rfEntity, insertIntoManagedObjectContext: context) as! RaceFeature
    raceFeature26.setValue(46, forKey: "id")
    raceFeature26.setValue("Menacing", forKey: "name")
    raceFeature26.setValue("You gain proficiency in the Intimidation skill.", forKey: "details")
    raceFeature26.races = Set<Race>(arrayLiteral: race13)
    
    let raceFeature27 = NSManagedObject(entity: rfEntity, insertIntoManagedObjectContext: context) as! RaceFeature
    raceFeature27.setValue(47, forKey: "id")
    raceFeature27.setValue("Relentless Endurance", forKey: "name")
    raceFeature27.setValue("Once per long rest, when you are reduced to 0 hp but not killed outright, you may drop to 1 hp instead.", forKey: "details")
    raceFeature27.races = Set<Race>(arrayLiteral: race13)
    
    let raceFeature28 = NSManagedObject(entity: rfEntity, insertIntoManagedObjectContext: context) as! RaceFeature
    raceFeature28.setValue(48, forKey: "id")
    raceFeature28.setValue("Savage Attacks", forKey: "name")
    raceFeature28.setValue("When you score a critical hit with a melee weapon attack, you can roll one of the weapon's damage dice one additional time and add it to the damage of the critical hit.", forKey: "details")
    raceFeature28.races = Set<Race>(arrayLiteral: race13)
    
    let raceFeature29 = NSManagedObject(entity: rfEntity, insertIntoManagedObjectContext: context) as! RaceFeature
    raceFeature29.setValue(49, forKey: "id")
    raceFeature29.setValue("Hellish Resistance", forKey: "name")
    raceFeature29.setValue("You have resistance to fire damage.", forKey: "details")
    raceFeature29.races = Set<Race>(arrayLiteral: race14)
    
    let raceFeature30 = NSManagedObject(entity: rfEntity, insertIntoManagedObjectContext: context) as! RaceFeature
    raceFeature30.setValue(50, forKey: "id")
    raceFeature30.setValue("Infernal Legacy", forKey: "name")
    raceFeature30.setValue("You know the Thaumaturgy cantrip. At level 3, you can cast Hellish Rebuke as a 2nd-level spell once per long rest, and may do the same with Darkness on reaching level 5. All these spells use Charisma as their spellcasting ability.", forKey: "details")
    raceFeature30.races = Set<Race>(arrayLiteral: race14)
    
    do{
        try context.save()
    }catch let error as NSError{
        print("Could not save \(error), \(error.userInfo)")
    }
    
}