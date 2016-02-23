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

}

func backgroundInit(context: NSManagedObjectContext){
    
    let bgEntity = NSEntityDescription.entityForName("Background", inManagedObjectContext: context)!
    let spEntity = NSEntityDescription.entityForName("SkillProfs", inManagedObjectContext: context)!
    
    let background1 = NSManagedObject(entity: bgEntity, insertIntoManagedObjectContext: context)
    let skillProfs1 = NSManagedObject(entity: spEntity, insertIntoManagedObjectContext: context)
    
    background1.setValue(1, forKey: "id")
    background1.setValue("Acolyte", forKey: "name");
    let skillProfInt1  = 0b00000000000000000000010100000000 //rel, ins
    skillProfs1.setValue(skillProfInt1, forKey: "profList")
    background1.setValue(skillProfs1, forKey: "skillProfs")
    
    
    
    
    do{
        try context.save()
    }catch let error as NSError{
        print("Could not save \(error), \(error.userInfo)")
    }
    
}//backgroundInit
