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
    @NSManaged var alignment: Int16
    @NSManaged var currHp: Int64
    @NSManaged var maxHp: Int64
    @NSManaged var armorClass: Int64
    
    @NSManaged var race: Race?
    @NSManaged var pclass: PClass?
    @NSManaged var skillProfs: SkillProfs
    @NSManaged var background: Background?
    @NSManaged var featureList: FeatureList?
    @NSManaged var traitList: TraitList
    @NSManaged var spellLists: Set<PersonalSpellList>
    @NSManaged var inventory: Inventory
    @NSManaged var subclass: Subclass?
    @NSManaged var otherNotes: OtherNotesStrings
    
    var ascores: AScores = AScores();
    
    static let alignmentTable: [Int16: String] = [
        Int16(0): "",
        Int16(1): "Lawful Good",
        Int16(2): "Lawful Neutral",
        Int16(3): "Lawful Evil",
        Int16(4): "Neutral Good",
        Int16(5): "Neutral Neutral",
        Int16(6): "Neutral Evil",
        Int16(7): "Chaotic Good",
        Int16(8): "Chaotic Neutral",
        Int16(9): "Chaotic Evil"
    ]
    
    
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
    
    /**
     Placeholder function. Will expand when I begin to explore multiclassing.
     */
    func getLevel(forClass pclass: PClass?)->Int16{
        return level
    }//getLevel
    
    static func getAlignmentStringLong(code: Int16)->String{
        return PCharacter.alignmentTable[code]!
    }

    static func getAlignmentStringShort(code: Int16)->String{
        switch (code){
        case 1:
            return "LG"
        case 2:
            return "LN"
        case 3:
            return "LE"
        case 4:
            return "NG"
        case 5:
            return "NN"
        case 6:
            return "NE"
        case 7:
            return "CG"
        case 8:
            return "CN"
        case 9:
            return "CE"
        default:
            return ""
        }
    }//getAlignmentStringShort
    
    static func getAlignmentCode(name: String)->Int16{
        
        switch (name){
        case "Lawful Good":
            return 1
        case "Lawful Neutral":
            return 2
        case "Lawful Evil":
            return 3
        case "Neutral Good":
            return 4
        case "Neutral Neutral":
            return 5
        case "Neutral Evil":
            return 6
        case "Chaotic Good":
            return 7
        case "Chaotic Neutral":
            return 8
        case "Chaotic Evil":
            return 9
        default:
            return 0
        }

    }//getAlignmentCode
    
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
        
        featureList!.subtractAllClassFeatures()
        featureList!.buildClassFeatures(fromClass: newClass, usingSubclass: subclass)
        
        if (subclass == nil || newClass.subClasses.contains(subclass!) == false){
            changeSubclassTo(nil)
        }//if we have no subclass, or the new class doesn't contain our current subclass, clear our subclass
        
    }//changeClassTo
    
    func changeSubclassTo(newSubclass: Subclass?){
        
        let currentPersonalSpellList: PersonalSpellList? = getCurrentPersonalSpellList()
        
        if (pclass!.name! == currentPersonalSpellList?.getPClassName()){
            currentPersonalSpellList?.changeSubclassFrom(subclass, toNewSubclass: newSubclass, atLevel: level)
        }//verifying we're switching subclasses within a class
        
        featureList!.changeSubclass(from: subclass, toNewSubclass: newSubclass)
        
        subclass = newSubclass
        
    }//changeSubclassTo
    
    func changeSubclassWithNameTo(newSubclassName: String){
        
        if (newSubclassName == "None"){
            changeSubclassTo(nil)
        }
            
        else{
            
            let context = self.managedObjectContext!
            let fetchRequest = NSFetchRequest(entityName: "Subclass")
            fetchRequest.predicate = NSPredicate(format: "name = %@", newSubclassName)
            var results: [Subclass] = []
            do{
                try results = context.executeFetchRequest(fetchRequest) as! [Subclass]
            }catch let error as NSError{
                print("Could not fetch \(error), \(error.userInfo)")
            }
            
            changeSubclassTo(results[0])
            
        }
        
    }//changesubclassTo
    
    func buildClassFeatures(context context: NSManagedObjectContext){
        
        if (pclass != nil){
            featureList!.subtractAllClassFeatures()
            featureList!.buildClassFeatures(fromClass: pclass!, usingSubclass: subclass)
        }//if there's a class
        
        do{
            try context.save()
        }catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }//buildClassFeatures
    
    func getCurrentPersonalSpellList()->PersonalSpellList?{
        let currentPclassId: Int16 = pclass!.id
        
        for spellList in spellLists{
            if (spellList.pclassId == currentPclassId){
                return spellList
            }//if id match
        }//for each personal spell list in our set of them
        
        return nil
        
    }//getCurrentPersonalSpellList
    
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
    
    func changeAlignmentTo(newAlignment: Int16){
        
        alignment = newAlignment
        
    }//changeAlignmentTo
    
    /**
    This returns the Spell Save DC and Spell Attack Mod for the character
    - Returns: A tuple with two ints. The first is the Spell Save DC, the second is the Spell Attack Mod
    */
    func getSpellDCandMod()->(Int, Int){
        
        var myDC: Int = 0
        var myMod: Int = 0
        
        switch (pclass!.name!){
        case "Bard":
            myDC = 8 + getProfBonus() + ascores.getChaMod()
            myMod = getProfBonus() + ascores.getChaMod()
        case "Cleric":
            myDC = 8 + getProfBonus() + ascores.getWisMod()
            myMod = getProfBonus() + ascores.getWisMod()
        case "Druid":
            myDC = 8 + getProfBonus() + ascores.getWisMod()
            myMod = getProfBonus() + ascores.getWisMod()
        case "Paladin":
            myDC = 8 + getProfBonus() + ascores.getChaMod()
            myMod = getProfBonus() + ascores.getChaMod()
        case "Sorcerer":
            myDC = 8 + getProfBonus() + ascores.getChaMod()
            myMod = getProfBonus() + ascores.getChaMod()
        case "Warlock":
            myDC = 8 + getProfBonus() + ascores.getChaMod()
            myMod = getProfBonus() + ascores.getChaMod()
        case "Wizard":
            myDC = 8 + getProfBonus() + ascores.getIntMod()
            myMod = getProfBonus() + ascores.getIntMod()
        default:
            break
        }
        
        return (myDC, myMod)
    }//getSpellDCandMod
    
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
        myCharacter.setValue(0, forKey: "alignment")
        myCharacter.setValue(0, forKey: "currHp")
        myCharacter.setValue(0, forKey: "maxHp")

        let featureList1 = NSManagedObject(entity: NSEntityDescription.entityForName("FeatureList",
            inManagedObjectContext:context)!, insertIntoManagedObjectContext: context)
        let skillProfs1 = NSManagedObject(entity: NSEntityDescription.entityForName("SkillProfs",
            inManagedObjectContext:context)!, insertIntoManagedObjectContext: context)
        skillProfs1.setValue(0, forKey: "profList")
        let traitList1 = NSManagedObject(entity: NSEntityDescription.entityForName("TraitList",
            inManagedObjectContext:context)!, insertIntoManagedObjectContext: context)
        let inventory1 = NSManagedObject(entity: NSEntityDescription.entityForName("Inventory",
            inManagedObjectContext:context)!, insertIntoManagedObjectContext: context)
        let otherNotes1 = NSManagedObject(entity: NSEntityDescription.entityForName("OtherNotesStrings",
            inManagedObjectContext:context)!, insertIntoManagedObjectContext: context)
        
        let featureSpellList1 = NSManagedObject(entity: NSEntityDescription.entityForName("SpellList",
            inManagedObjectContext:context)!, insertIntoManagedObjectContext: context)
        featureList1.setValue(featureSpellList1, forKey: "spellList")

        
        myCharacter.setValue(skillProfs1, forKey: "SkillProfs")
        myCharacter.setValue(featureList1, forKey: "featureList")
        myCharacter.setValue(traitList1, forKey: "traitList")
        myCharacter.setValue(inventory1, forKey: "inventory")
        myCharacter.setValue(otherNotes1, forKey: "otherNotes")
        
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
    let traitList1 = NSManagedObject(entity: NSEntityDescription.entityForName("TraitList",
        inManagedObjectContext:context)!, insertIntoManagedObjectContext: context)
    let inventory1 = NSManagedObject(entity: NSEntityDescription.entityForName("Inventory",
        inManagedObjectContext:context)!, insertIntoManagedObjectContext: context)
    let otherNotes1 = NSManagedObject(entity: NSEntityDescription.entityForName("OtherNotesStrings",
        inManagedObjectContext:context)!, insertIntoManagedObjectContext: context)
    
    let featureSpellList1 = NSManagedObject(entity: NSEntityDescription.entityForName("SpellList",
        inManagedObjectContext:context)!, insertIntoManagedObjectContext: context)
    featureList1.setValue(featureSpellList1, forKey: "spellList")
    
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
    character1.setValue(traitList1, forKey: "traitList")
    character1.setValue(0, forKey: "alignment")
    character1.setValue(0, forKey: "currHp")
    character1.setValue(0, forKey: "maxHp")
    character1.setValue(inventory1, forKey: "inventory")
    character1.setValue(otherNotes1, forKey: "otherNotes")

    
    do{
        try context.save()
    }catch let error as NSError{
        print("Could not save \(error), \(error.userInfo)")
    }
    
}//characterInit