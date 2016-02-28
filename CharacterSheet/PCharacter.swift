//
//  Character.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 2/16/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import CoreData
import Foundation

class PCharacter: NSManagedObject{
    
    @NSManaged var id: Int16
    @NSManaged var name: String?
    @NSManaged var level: Int16
    @NSManaged var str: Int16
    @NSManaged var dex: Int16
    @NSManaged var con: Int16
    @NSManaged var intl: Int16
    @NSManaged var wis: Int16
    @NSManaged var cha: Int16
    @NSManaged var race: Race?
    @NSManaged var pclass: PClass?
    @NSManaged var skillProfs: SkillProfs
    @NSManaged var background: Background?
    @NSManaged var featureList: FeatureList?
    
    var ascores: AScores = AScores();
    
    func updateAScores(){
        ascores = AScores(str: Int(str), dex: Int(dex), con: Int(con), intl: Int(intl), wis: Int(wis), cha: Int(cha));
    }//updateAScores
    
    func getProfBonus()->Int{
        if (level < 5) {return 2}
        if (level < 9) {return 3}
        if (level < 13) {return 4}
        if (level < 17) {return 5}
        return 6
    }//getProfBonus
    
    func changeRaceTo(newRace: Race){
        
        //remove previous racial bonuses
        if (race != nil){
            ascores.subValues(
                Int(race!.strmod),
                dexmod: Int(race!.dexmod),
                conmod: Int(race!.conmod),
                intmod: Int(race!.intmod),
                wismod: Int(race!.wismod),
                chamod: Int(race!.chamod))
            for feat in race!.features!.allObjects as! [Feature]{
                featureList!.subtractFeature(feat)
            }//for all
        }//if
        
        //set new race
        race = newRace;
        
        //add racial bonuses
        ascores.addValues(Int(race!.strmod), dexmod: Int(race!.dexmod),
            conmod: Int(race!.conmod), intmod: Int(race!.intmod),
                wismod: Int(race!.wismod), chamod: Int(race!.chamod))
        for feat in race!.features!.allObjects as! [Feature]{
            featureList!.addFeature(feat)
        }//for all
        
        
        //make the values right
        str = Int16(ascores.getStr())
        dex = Int16(ascores.getDex())
        con = Int16(ascores.getCon())
        intl = Int16(ascores.getInt())
        wis = Int16(ascores.getWis())
        cha = Int16(ascores.getCha())
        
    }//changeRaceTo
    
    func changeClassTo(newClass: PClass){
        
        pclass = newClass
        
    }//changeClassTo
    
    func changeBackgroundTo(newBackground: Background){
        
        //remove previous background proficiencies
        if (background != nil){
            skillProfs.subtractSkillProfs(background!.skillProfs!)
            for feat in background!.features!.allObjects as! [Feature]{
                featureList!.subtractFeature(feat)
            }//for all
        }//if
        
        background = newBackground
        skillProfs.addSkillProfs(background!.skillProfs!)
        let newFeatList: [Feature] = newBackground.features!.allObjects as! [Feature]
        for feat in newFeatList{
            _ = feat.name
            featureList!.addFeature(feat)
        }//for all

        
    }//changeBackgroundTo
    
    
    static func createBlankCharacter(context: NSManagedObjectContext)->PCharacter{
        
        let entity = NSEntityDescription.entityForName("PCharacter", inManagedObjectContext: context)!
        
        let fetchRequest = NSFetchRequest(entityName: "PCharacter");
        fetchRequest.predicate = NSPredicate(format: "id==max(id)")
        var results: [PCharacter] = [];
        do{
            results = try context.executeFetchRequest(fetchRequest) as! [PCharacter]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
        let highestId: Int = Int(results[0].id)
        
        let myCharacter: PCharacter = NSManagedObject(entity: entity, insertIntoManagedObjectContext: context) as! PCharacter
        myCharacter.setValue((highestId + 1), forKey: "id")
        myCharacter.setValue("Name", forKey: "name");
        myCharacter.setValue(1, forKey: "level");
        myCharacter.setValue(10, forKey: "str");
        myCharacter.setValue(10, forKey: "dex");
        myCharacter.setValue(10, forKey: "con");
        myCharacter.setValue(10, forKey: "intl");
        myCharacter.setValue(10, forKey: "wis");
        myCharacter.setValue(10, forKey: "cha");

        let featureList1 = NSManagedObject(entity: NSEntityDescription.entityForName("FeatureList",
            inManagedObjectContext:context)!, insertIntoManagedObjectContext: context)
        let skillProfs1 = NSManagedObject(entity: NSEntityDescription.entityForName("SkillProfs",
            inManagedObjectContext:context)!, insertIntoManagedObjectContext: context)
        skillProfs1.setValue(0, forKey: "profList")
        
        myCharacter.setValue(skillProfs1, forKey: "SkillProfs")
        myCharacter.setValue(featureList1, forKey: "featureList")
        
        
        do{
            try context.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return myCharacter
        
    }//createBlankCharacter
    
}//character

func characterInit(entity: NSEntityDescription, context: NSManagedObjectContext){
    
    let character1 = NSManagedObject(entity: entity, insertIntoManagedObjectContext: context)
    let skillProfs1 = NSManagedObject(entity: NSEntityDescription.entityForName("SkillProfs",
        inManagedObjectContext:context)!, insertIntoManagedObjectContext: context)
    let featureList1 = NSManagedObject(entity: NSEntityDescription.entityForName("FeatureList",
        inManagedObjectContext:context)!, insertIntoManagedObjectContext: context)
    skillProfs1.setValue(0, forKey: "profList")
    
    
    character1.setValue(1, forKey: "id");
    character1.setValue("Jason", forKey: "name");
    character1.setValue(1, forKey: "level");
    character1.setValue(10, forKey: "str");
    character1.setValue(10, forKey: "dex");
    character1.setValue(10, forKey: "con");
    character1.setValue(10, forKey: "intl");
    character1.setValue(10, forKey: "wis");
    character1.setValue(10, forKey: "cha");
    character1.setValue(skillProfs1, forKey: "SkillProfs")
    character1.setValue(featureList1, forKey: "featureList")
    
    let character2 = NSManagedObject(entity: entity, insertIntoManagedObjectContext: context)
    let skillProfs2 = NSManagedObject(entity: NSEntityDescription.entityForName("SkillProfs",
        inManagedObjectContext:context)!, insertIntoManagedObjectContext: context)
    let featureList2 = NSManagedObject(entity: NSEntityDescription.entityForName("FeatureList",
        inManagedObjectContext:context)!, insertIntoManagedObjectContext: context)
    skillProfs2.setValue(0, forKey: "profList")
    
    
    character2.setValue(2, forKey: "id");
    character2.setValue("Ricky", forKey: "name");
    character2.setValue(4, forKey: "level");
    character2.setValue(10, forKey: "str");
    character2.setValue(12, forKey: "dex");
    character2.setValue(10, forKey: "con");
    character2.setValue(14, forKey: "intl");
    character2.setValue(10, forKey: "wis");
    character2.setValue(10, forKey: "cha");
    character2.setValue(skillProfs2, forKey: "SkillProfs")
    character2.setValue(featureList2, forKey: "featureList")
    
    do{
        try context.save()
    }catch let error as NSError{
        print("Could not save \(error), \(error.userInfo)")
    }
    
}//characterInit