//
//  Background.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 2/22/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import Foundation
import CoreData

class Background: NSManagedObject {

    @NSManaged var id: Int16
    @NSManaged var name: String
    @NSManaged var skillProfs: SkillProfs?
    @NSManaged var features: NSSet?
    @NSManaged var traitList: TraitList?

    
    static func backgroundInit(context: NSManagedObjectContext){
        
        let bgEntity = NSEntityDescription.entityForName("Background", inManagedObjectContext: context)!
        let spEntity = NSEntityDescription.entityForName("SkillProfs", inManagedObjectContext: context)!
        let bgfEntity = NSEntityDescription.entityForName("BackgroundFeature", inManagedObjectContext: context)!
        
        let background1 = NSManagedObject(entity: bgEntity, insertIntoManagedObjectContext: context)
        let skillProfs1 = NSManagedObject(entity: spEntity, insertIntoManagedObjectContext: context)
        let backgroundFeature1 = NSManagedObject(entity: bgfEntity, insertIntoManagedObjectContext: context)
        
        background1.setValue(1, forKey: "id")
        background1.setValue("Acolyte", forKey: "name");
        let skillProfInt1: Int32  = SkillProfs.relMask | SkillProfs.insMask;
        skillProfs1.setValue(Int(skillProfInt1), forKey: "profList");
        background1.setValue(skillProfs1, forKey: "skillProfs")
        backgroundFeature1.setValue(1, forKey: "id")
        backgroundFeature1.setValue("Shelter of the Faithful", forKey: "name")
        backgroundFeature1.setValue("Free healing and care at temples and shrines of your faith. You may also call upon priests of your temple for assistance.", forKey: "details")
        backgroundFeature1.setValue(background1, forKey: "background")
        
        let background2 = NSManagedObject(entity: bgEntity, insertIntoManagedObjectContext: context)
        let skillProfs2 = NSManagedObject(entity: spEntity, insertIntoManagedObjectContext: context)
        let backgroundFeature2 = NSManagedObject(entity: bgfEntity, insertIntoManagedObjectContext: context)
        
        background2.setValue(2, forKey: "id")
        background2.setValue("Charlatan", forKey: "name");
        let skillProfInt2: Int32  = SkillProfs.decMask | SkillProfs.sleMask;
        skillProfs2.setValue(Int(skillProfInt2), forKey: "profList");
        background2.setValue(skillProfs2, forKey: "skillProfs")
        backgroundFeature2.setValue(2, forKey: "id")
        backgroundFeature2.setValue("False Identity", forKey: "name")
        backgroundFeature2.setValue("You have created a second identity with all necessary documentation and relationships. You may also forge documents if you have seen previous examples of them.", forKey: "details")
        backgroundFeature2.setValue(background2, forKey: "background")
        
        let background3 = NSManagedObject(entity: bgEntity, insertIntoManagedObjectContext: context)
        let skillProfs3 = NSManagedObject(entity: spEntity, insertIntoManagedObjectContext: context)
        let backgroundFeature3 = NSManagedObject(entity: bgfEntity, insertIntoManagedObjectContext: context)
        
        background3.setValue(3, forKey: "id")
        background3.setValue("Criminal", forKey: "name");
        let skillProfInt3: Int32  = SkillProfs.decMask | SkillProfs.steMask;
        skillProfs3.setValue(Int(skillProfInt3), forKey: "profList");
        background3.setValue(skillProfs3, forKey: "skillProfs")
        backgroundFeature3.setValue(3, forKey: "id")
        backgroundFeature3.setValue("Criminal Contact", forKey: "name")
        backgroundFeature3.setValue("You have a reliable contact who is your liason to a criminal network, and you know how to get messages to and from your contact.", forKey: "details")
        backgroundFeature3.setValue(background3, forKey: "background")
        
        let background4 = NSManagedObject(entity: bgEntity, insertIntoManagedObjectContext: context)
        let skillProfs4 = NSManagedObject(entity: spEntity, insertIntoManagedObjectContext: context)
        let backgroundFeature4 = NSManagedObject(entity: bgfEntity, insertIntoManagedObjectContext: context)
        
        background4.setValue(4, forKey: "id")
        background4.setValue("Entertainer", forKey: "name");
        let skillProfInt4: Int32  = SkillProfs.acrMask | SkillProfs.prfMask;
        skillProfs4.setValue(Int(skillProfInt4), forKey: "profList");
        background4.setValue(skillProfs4, forKey: "skillProfs")
        backgroundFeature4.setValue(4, forKey: "id")
        backgroundFeature4.setValue("By Popular Demand", forKey: "name")
        backgroundFeature4.setValue("You can always find a place to perform, where you will receive free lodging and food, provided you perform every night. People you meet who recognize you from this activity tend to like you.", forKey: "details")
        backgroundFeature4.setValue(background4, forKey: "background")
        
        let background5 = NSManagedObject(entity: bgEntity, insertIntoManagedObjectContext: context)
        let skillProfs5 = NSManagedObject(entity: spEntity, insertIntoManagedObjectContext: context)
        let backgroundFeature5 = NSManagedObject(entity: bgfEntity, insertIntoManagedObjectContext: context)
        
        background5.setValue(5, forKey: "id")
        background5.setValue("Folk Hero", forKey: "name");
        let skillProfInt5: Int32  = SkillProfs.aniMask | SkillProfs.surMask;
        skillProfs5.setValue(Int(skillProfInt5), forKey: "profList");
        background5.setValue(skillProfs5, forKey: "skillProfs")
        backgroundFeature5.setValue(5, forKey: "id")
        backgroundFeature5.setValue("Rustic Hospitality", forKey: "name")
        backgroundFeature5.setValue("You can find a place to hide, rest, or recuperate among commoners, having been one of them. They will sheild you from the law or others searching for you, but will not lay down their lives for you.", forKey: "details")
        backgroundFeature5.setValue(background5, forKey: "background")
        
        let background6 = NSManagedObject(entity: bgEntity, insertIntoManagedObjectContext: context)
        let skillProfs6 = NSManagedObject(entity: spEntity, insertIntoManagedObjectContext: context)
        let backgroundFeature6 = NSManagedObject(entity: bgfEntity, insertIntoManagedObjectContext: context)
        
        background6.setValue(6, forKey: "id")
        background6.setValue("Guild Artisan", forKey: "name");
        let skillProfInt6: Int32  = SkillProfs.insMask | SkillProfs.prsMask;
        skillProfs6.setValue(Int(skillProfInt6), forKey: "profList");
        background6.setValue(skillProfs6, forKey: "skillProfs")
        backgroundFeature6.setValue(6, forKey: "id")
        backgroundFeature6.setValue("Guild Membership", forKey: "name")
        backgroundFeature6.setValue("Your guild members will provide you with lodging and food if necessary, and may take advantage of some of your guild's political power.", forKey: "details")
        backgroundFeature6.setValue(background6, forKey: "background")

        
        let background7 = NSManagedObject(entity: bgEntity, insertIntoManagedObjectContext: context)
        let skillProfs7 = NSManagedObject(entity: spEntity, insertIntoManagedObjectContext: context)
        let backgroundFeature7 = NSManagedObject(entity: bgfEntity, insertIntoManagedObjectContext: context)
        
        background7.setValue(7, forKey: "id")
        background7.setValue("Hermit", forKey: "name");
        let skillProfInt7: Int32  = SkillProfs.medMask | SkillProfs.relMask;
        skillProfs7.setValue(Int(skillProfInt7), forKey: "profList");
        background7.setValue(skillProfs7, forKey: "skillProfs")
        backgroundFeature7.setValue(7, forKey: "id")
        backgroundFeature7.setValue("Discovery", forKey: "name")
        backgroundFeature7.setValue("The quiet seclusion of your hermitage gave you access to a unique and powerful discovery, the nature of which is dependent upon the nature of your seclusion.", forKey: "details")
        backgroundFeature7.setValue(background7, forKey: "background")
        
        let background8 = NSManagedObject(entity: bgEntity, insertIntoManagedObjectContext: context)
        let skillProfs8 = NSManagedObject(entity: spEntity, insertIntoManagedObjectContext: context)
        let backgroundFeature8 = NSManagedObject(entity: bgfEntity, insertIntoManagedObjectContext: context)
        
        background8.setValue(8, forKey: "id")
        background8.setValue("Noble", forKey: "name");
        let skillProfInt8: Int32  = SkillProfs.hisMask | SkillProfs.prsMask;
        skillProfs8.setValue(Int(skillProfInt8), forKey: "profList");
        background8.setValue(skillProfs8, forKey: "skillProfs")
        backgroundFeature8.setValue(8, forKey: "id")
        backgroundFeature8.setValue("Position of Privilege", forKey: "name")
        backgroundFeature8.setValue("People are inclined to think the best of you. You are welcome in high society, and the common folk make efforts to please you. You may also secure an audience with a local noble.", forKey: "details")
        backgroundFeature8.setValue(background8, forKey: "background")

        
        let background9 = NSManagedObject(entity: bgEntity, insertIntoManagedObjectContext: context)
        let skillProfs9 = NSManagedObject(entity: spEntity, insertIntoManagedObjectContext: context)
        let backgroundFeature9 = NSManagedObject(entity: bgfEntity, insertIntoManagedObjectContext: context)
        
        background9.setValue(9, forKey: "id")
        background9.setValue("Outlander", forKey: "name");
        let skillProfInt9: Int32  = SkillProfs.athMask | SkillProfs.surMask;
        skillProfs9.setValue(Int(skillProfInt9), forKey: "profList");
        background9.setValue(skillProfs9, forKey: "skillProfs")
        backgroundFeature9.setValue(9, forKey: "id")
        backgroundFeature9.setValue("Wanderer", forKey: "name")
        backgroundFeature9.setValue("You have an excellent memory for maps, geography, and terrain. You may also find food and fresh water for yourself and up to five other people each day, provided the land offers access to them.", forKey: "details")
        backgroundFeature9.setValue(background9, forKey: "background")
        
        let background10 = NSManagedObject(entity: bgEntity, insertIntoManagedObjectContext: context)
        let skillProfs10 = NSManagedObject(entity: spEntity, insertIntoManagedObjectContext: context)
        let backgroundFeature10 = NSManagedObject(entity: bgfEntity, insertIntoManagedObjectContext: context)
        
        background10.setValue(10, forKey: "id")
        background10.setValue("Sage", forKey: "name");
        let skillProfInt10: Int32  = SkillProfs.arcMask | SkillProfs.hisMask;
        skillProfs10.setValue(Int(skillProfInt10), forKey: "profList");
        background10.setValue(skillProfs10, forKey: "skillProfs")
        backgroundFeature10.setValue(10, forKey: "id")
        backgroundFeature10.setValue("Researcher", forKey: "name")
        backgroundFeature10.setValue("If you do not know a piece of lore, you often know where to obtain it. Generally, it will come from a library, university, another sage, or some other learned creature. The exact source is up to the DM's discretion.", forKey: "details")
        backgroundFeature10.setValue(background10, forKey: "background")
        
        let background11 = NSManagedObject(entity: bgEntity, insertIntoManagedObjectContext: context)
        let skillProfs11 = NSManagedObject(entity: spEntity, insertIntoManagedObjectContext: context)
        let backgroundFeature11 = NSManagedObject(entity: bgfEntity, insertIntoManagedObjectContext: context)
        
        background11.setValue(11, forKey: "id")
        background11.setValue("Sailor", forKey: "name");
        let skillProfInt11: Int32  = SkillProfs.athMask | SkillProfs.perMask;
        skillProfs11.setValue(Int(skillProfInt11), forKey: "profList");
        background11.setValue(skillProfs11, forKey: "skillProfs")
        backgroundFeature11.setValue(11, forKey: "id")
        backgroundFeature11.setValue("Ship's Passage", forKey: "name")
        backgroundFeature11.setValue("You may secure free passage on a ship for yourself and your companions, through your previous sailing connections. The schedule is indeterminate, and both you and your companions are expected to assist the crew during the voyage.", forKey: "details")
        backgroundFeature11.setValue(background11, forKey: "background")

        
        let background12 = NSManagedObject(entity: bgEntity, insertIntoManagedObjectContext: context)
        let skillProfs12 = NSManagedObject(entity: spEntity, insertIntoManagedObjectContext: context)
        let backgroundFeature12 = NSManagedObject(entity: bgfEntity, insertIntoManagedObjectContext: context)
        
        background12.setValue(12, forKey: "id")
        background12.setValue("Soldier", forKey: "name");
        let skillProfInt12: Int32  = SkillProfs.athMask | SkillProfs.intMask;
        skillProfs12.setValue(Int(skillProfInt12), forKey: "profList");
        background12.setValue(skillProfs12, forKey: "skillProfs")
        backgroundFeature12.setValue(12, forKey: "id")
        backgroundFeature12.setValue("Military Rank", forKey: "name")
        backgroundFeature12.setValue("Soldiers loyal to your former military organization still recognize the authority and influence from your previous rank. You may also usually gain access to friendly encampments and fortresses where your rank is recognized.", forKey: "details")
        backgroundFeature12.setValue(background12, forKey: "background")

        
        let background13 = NSManagedObject(entity: bgEntity, insertIntoManagedObjectContext: context)
        let skillProfs13 = NSManagedObject(entity: spEntity, insertIntoManagedObjectContext: context)
        let backgroundFeature13 = NSManagedObject(entity: bgfEntity, insertIntoManagedObjectContext: context)
        
        background13.setValue(13, forKey: "id")
        background13.setValue("Urchin", forKey: "name");
        let skillProfInt13: Int32  = SkillProfs.sleMask | SkillProfs.steMask;
        skillProfs13.setValue(Int(skillProfInt13), forKey: "profList");
        background13.setValue(skillProfs13, forKey: "skillProfs")
        backgroundFeature13.setValue(13, forKey: "id")
        backgroundFeature13.setValue("City Secrets", forKey: "name")
        backgroundFeature13.setValue("You know the secret patterns to cities and can find passages through urban areas that others might miss. You may also, when not in combat, travel with your companions from one point in the city to another at double speed.", forKey: "details")
        backgroundFeature13.setValue(background13, forKey: "background")

        
        
        do{
            try context.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }//backgroundInit
}
