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

    @NSManaged var id: Int32
    @NSManaged var name: String
    @NSManaged var skillProfs: SkillProfs?

    
    static func backgroundInit(context: NSManagedObjectContext){
        
        let bgEntity = NSEntityDescription.entityForName("Background", inManagedObjectContext: context)!
        let spEntity = NSEntityDescription.entityForName("SkillProfs", inManagedObjectContext: context)!
        
        let background1 = NSManagedObject(entity: bgEntity, insertIntoManagedObjectContext: context)
        let skillProfs1 = NSManagedObject(entity: spEntity, insertIntoManagedObjectContext: context)
        
        background1.setValue(1, forKey: "id")
        background1.setValue("Acolyte", forKey: "name");
        let skillProfInt1: Int32  = SkillProfs.relMask | SkillProfs.insMask;
        skillProfs1.setValue(Int(skillProfInt1), forKey: "profList");
        background1.setValue(skillProfs1, forKey: "skillProfs")
        
        let background2 = NSManagedObject(entity: bgEntity, insertIntoManagedObjectContext: context)
        let skillProfs2 = NSManagedObject(entity: spEntity, insertIntoManagedObjectContext: context)
        
        background2.setValue(2, forKey: "id")
        background2.setValue("Charlatan", forKey: "name");
        let skillProfInt2: Int32  = SkillProfs.decMask | SkillProfs.sleMask;
        skillProfs2.setValue(Int(skillProfInt2), forKey: "profList");
        background2.setValue(skillProfs2, forKey: "skillProfs")
        
        let background3 = NSManagedObject(entity: bgEntity, insertIntoManagedObjectContext: context)
        let skillProfs3 = NSManagedObject(entity: spEntity, insertIntoManagedObjectContext: context)
        
        background3.setValue(3, forKey: "id")
        background3.setValue("Criminal", forKey: "name");
        let skillProfInt3: Int32  = SkillProfs.decMask | SkillProfs.steMask;
        skillProfs3.setValue(Int(skillProfInt3), forKey: "profList");
        background3.setValue(skillProfs3, forKey: "skillProfs")
        
        let background4 = NSManagedObject(entity: bgEntity, insertIntoManagedObjectContext: context)
        let skillProfs4 = NSManagedObject(entity: spEntity, insertIntoManagedObjectContext: context)
        
        background4.setValue(4, forKey: "id")
        background4.setValue("Entertainer", forKey: "name");
        let skillProfInt4: Int32  = SkillProfs.acrMask | SkillProfs.prfMask;
        skillProfs4.setValue(Int(skillProfInt4), forKey: "profList");
        background4.setValue(skillProfs4, forKey: "skillProfs")
        
        let background5 = NSManagedObject(entity: bgEntity, insertIntoManagedObjectContext: context)
        let skillProfs5 = NSManagedObject(entity: spEntity, insertIntoManagedObjectContext: context)
        
        background5.setValue(5, forKey: "id")
        background5.setValue("Folk Hero", forKey: "name");
        let skillProfInt5: Int32  = SkillProfs.aniMask | SkillProfs.surMask;
        skillProfs5.setValue(Int(skillProfInt5), forKey: "profList");
        background5.setValue(skillProfs5, forKey: "skillProfs")
        
        let background6 = NSManagedObject(entity: bgEntity, insertIntoManagedObjectContext: context)
        let skillProfs6 = NSManagedObject(entity: spEntity, insertIntoManagedObjectContext: context)
        
        background6.setValue(6, forKey: "id")
        background6.setValue("Guild Artisan", forKey: "name");
        let skillProfInt6: Int32  = SkillProfs.insMask | SkillProfs.prsMask;
        skillProfs6.setValue(Int(skillProfInt6), forKey: "profList");
        background6.setValue(skillProfs6, forKey: "skillProfs")
        
        let background7 = NSManagedObject(entity: bgEntity, insertIntoManagedObjectContext: context)
        let skillProfs7 = NSManagedObject(entity: spEntity, insertIntoManagedObjectContext: context)
        
        background7.setValue(7, forKey: "id")
        background7.setValue("Hermit", forKey: "name");
        let skillProfInt7: Int32  = SkillProfs.medMask | SkillProfs.relMask;
        skillProfs7.setValue(Int(skillProfInt7), forKey: "profList");
        background7.setValue(skillProfs7, forKey: "skillProfs")
        
        let background8 = NSManagedObject(entity: bgEntity, insertIntoManagedObjectContext: context)
        let skillProfs8 = NSManagedObject(entity: spEntity, insertIntoManagedObjectContext: context)
        
        background8.setValue(8, forKey: "id")
        background8.setValue("Noble", forKey: "name");
        let skillProfInt8: Int32  = SkillProfs.hisMask | SkillProfs.prsMask;
        skillProfs8.setValue(Int(skillProfInt8), forKey: "profList");
        background8.setValue(skillProfs8, forKey: "skillProfs")
        
        let background9 = NSManagedObject(entity: bgEntity, insertIntoManagedObjectContext: context)
        let skillProfs9 = NSManagedObject(entity: spEntity, insertIntoManagedObjectContext: context)
        
        background9.setValue(9, forKey: "id")
        background9.setValue("Outlander", forKey: "name");
        let skillProfInt9: Int32  = SkillProfs.athMask | SkillProfs.surMask;
        skillProfs9.setValue(Int(skillProfInt9), forKey: "profList");
        background9.setValue(skillProfs9, forKey: "skillProfs")
        
        let background10 = NSManagedObject(entity: bgEntity, insertIntoManagedObjectContext: context)
        let skillProfs10 = NSManagedObject(entity: spEntity, insertIntoManagedObjectContext: context)
        
        background10.setValue(10, forKey: "id")
        background10.setValue("Sage", forKey: "name");
        let skillProfInt10: Int32  = SkillProfs.arcMask | SkillProfs.hisMask;
        skillProfs10.setValue(Int(skillProfInt10), forKey: "profList");
        background10.setValue(skillProfs10, forKey: "skillProfs")
        
        let background11 = NSManagedObject(entity: bgEntity, insertIntoManagedObjectContext: context)
        let skillProfs11 = NSManagedObject(entity: spEntity, insertIntoManagedObjectContext: context)
        
        background11.setValue(11, forKey: "id")
        background11.setValue("Sailor", forKey: "name");
        let skillProfInt11: Int32  = SkillProfs.athMask | SkillProfs.perMask;
        skillProfs11.setValue(Int(skillProfInt11), forKey: "profList");
        background11.setValue(skillProfs11, forKey: "skillProfs")
        
        let background12 = NSManagedObject(entity: bgEntity, insertIntoManagedObjectContext: context)
        let skillProfs12 = NSManagedObject(entity: spEntity, insertIntoManagedObjectContext: context)
        
        background12.setValue(12, forKey: "id")
        background12.setValue("Soldier", forKey: "name");
        let skillProfInt12: Int32  = SkillProfs.athMask | SkillProfs.intMask;
        skillProfs12.setValue(Int(skillProfInt12), forKey: "profList");
        background12.setValue(skillProfs12, forKey: "skillProfs")
        
        let background13 = NSManagedObject(entity: bgEntity, insertIntoManagedObjectContext: context)
        let skillProfs13 = NSManagedObject(entity: spEntity, insertIntoManagedObjectContext: context)
        
        background13.setValue(13, forKey: "id")
        background13.setValue("Urchin", forKey: "name");
        let skillProfInt13: Int32  = SkillProfs.sleMask | SkillProfs.steMask;
        skillProfs13.setValue(Int(skillProfInt13), forKey: "profList");
        background13.setValue(skillProfs13, forKey: "skillProfs")
        
        
        do{
            try context.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }//backgroundInit
}
