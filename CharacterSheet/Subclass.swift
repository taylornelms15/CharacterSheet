//
//  Subclass.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 4/30/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import Foundation
import CoreData


class Subclass: NSManagedObject {

    
    @NSManaged var id: Int16
    @NSManaged var name: String
    ///Format: as many as 20 arrays, each corresponding to a player level, containing id's of the spells that are free at that level
    @NSManaged var freeSpellLevelData: [[Int]]
    @NSManaged var freeSpellList: SpellList?
    @NSManaged var parentClass: PClass

    
    static func subClassesInit(context: NSManagedObjectContext){
        
        let subclassEntity = NSEntityDescription.entityForName("Subclass", inManagedObjectContext: context)!
        let spellListEntity = NSEntityDescription.entityForName("SpellList", inManagedObjectContext: context)!
        var spellNames: [String] = []
        var leveledSpellNames: [String: Int] = [:]
        var spellResults: [Spell] = []
        let spellFetch = NSFetchRequest(entityName: "Spell")
        
        let fetchRequest = NSFetchRequest(entityName: "PClass")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        var pclassResults: [PClass] = []
        do{
            try pclassResults = context.executeFetchRequest(fetchRequest) as! [PClass]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        //pclassResults is now the list of pclasses, sorted by id. (id - 1 is the array index)
    
        //MARK: Barbarian
        
        let subclass1: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        subclass1.id = 1
        subclass1.name = "Path of the Berserker"
        subclass1.parentClass = pclassResults[0]
        
        let subclass2: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        subclass2.id = 2
        subclass2.name = "Path of the Totem Warrior"
        subclass2.parentClass = pclassResults[0]
        
        //MARK: Bard
        
        let subclass3: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        subclass3.id = 3
        subclass3.name = "College of Lore"
        subclass3.parentClass = pclassResults[1]
        
        let subclass4: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        subclass4.id = 4
        subclass4.name = "College of Valor"
        subclass4.parentClass = pclassResults[1]
        
        //MARK: Cleric
        
        let subclass5: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        let subclass5Spells: SpellList = NSManagedObject(entity: spellListEntity, insertIntoManagedObjectContext: context) as! SpellList
        subclass5.id = 5
        subclass5.name = "Knowledge Domain"
        subclass5.parentClass = pclassResults[2]
        subclass5.freeSpellLevelData = [ [],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[] ] //20 empty arrays (level 1 through 20)
        
        spellNames = ["Command", "Identify", "Augury", "Suggestion", "Nondetection", "Speak with Dead", "Arcane Eye", "Confusion", "Legend Lore", "Scrying"]
        leveledSpellNames = ["Command": 1, "Identify" : 1, "Augury" : 3, "Suggestion" : 3, "Nondetection" : 5, "Speak with Dead" : 5, "Arcane Eye" : 7,
                             "Confusion" : 7, "Legend Lore" : 9, "Scrying" : 9]
        
        spellFetch.predicate = NSPredicate(format: "name IN %@", spellNames)
        spellFetch.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true), NSSortDescriptor(key: "id", ascending: true)]//sort by level, then by id
        
        do{
            spellResults = try context.executeFetchRequest(spellFetch) as! [Spell]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        for i in 0..<spellResults.count{
            subclass5Spells.spells.insert(spellResults[i])
            let levelIndex: Int = leveledSpellNames[spellResults[i].name]! - 1
            subclass5.freeSpellLevelData[levelIndex].append(Int(spellResults[i].id))
        }//for
        
        subclass5.freeSpellList = subclass5Spells
        
        let subclass6: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        let subclass6Spells: SpellList = NSManagedObject(entity: spellListEntity, insertIntoManagedObjectContext: context) as! SpellList
        subclass6.id = 6
        subclass6.name = "Life Domain"
        subclass6.parentClass = pclassResults[2]
        subclass6.freeSpellLevelData = [ [],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[] ] //20 empty arrays (level 1 through 20)
        
        spellNames = ["Bless", "Cure Wounds", "Lesser Restoration", "Spiritual Weapon", "Beacon of Hope", "Revivify", "Death Ward", "Guardian of Faith", "Mass Cure Wounds", "Raise Dead"]
        leveledSpellNames = ["Bless": 1, "Cure Wounds" : 1, "Lesser Restoration" : 3, "Spiritual Weapon" : 3, "Beacon of Hope" : 5, "Revivify" : 5, "Death Ward" : 7,
                             "Guardian of Faith" : 7, "Mass Cure Wounds" : 9, "Raise Death" : 9]
        
        spellFetch.predicate = NSPredicate(format: "name IN %@", spellNames)
        spellFetch.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true), NSSortDescriptor(key: "id", ascending: true)]//sort by level, then by id
        
        do{
            spellResults = try context.executeFetchRequest(spellFetch) as! [Spell]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        for i in 0..<spellResults.count{
            subclass6Spells.spells.insert(spellResults[i])
            let levelIndex: Int = leveledSpellNames[spellResults[i].name]! - 1
            subclass6.freeSpellLevelData[levelIndex].append(Int(spellResults[i].id))
        }//for
        
        subclass6.freeSpellList = subclass6Spells
        
        let subclass7: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        let subclass7Spells: SpellList = NSManagedObject(entity: spellListEntity, insertIntoManagedObjectContext: context) as! SpellList
        subclass7.id = 7
        subclass7.name = "Light Domain"
        subclass7.parentClass = pclassResults[2]
        subclass7.freeSpellLevelData = [ [],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[] ] //20 empty arrays (level 1 through 20)
        
        spellNames = ["Burning Hands", "Faerie Fire", "Flaming Sphere", "Scorching Ray", "Daylight", "Fireball", "Guardian of Faith", "Wall of Fire", "Flame Strike", "Scrying"]
        leveledSpellNames = ["Burning Hands": 1, "Faerie Fire" : 1, "Flaming Sphere" : 3, "Scorching Ray" : 3, "Daylight" : 5, "Fireball" : 5, "Guardian of Faith" : 7,
                             "Wall of Fire" : 7, "Flame Strike" : 9, "Scrying" : 9]
        
        spellFetch.predicate = NSPredicate(format: "name IN %@", spellNames)
        spellFetch.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true), NSSortDescriptor(key: "id", ascending: true)]//sort by level, then by id
        
        do{
            spellResults = try context.executeFetchRequest(spellFetch) as! [Spell]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        for i in 0..<spellResults.count{
            subclass7Spells.spells.insert(spellResults[i])
            let levelIndex: Int = leveledSpellNames[spellResults[i].name]! - 1
            subclass7.freeSpellLevelData[levelIndex].append(Int(spellResults[i].id))
        }//for
        
        subclass7.freeSpellList = subclass7Spells
        
        let subclass8: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        let subclass8Spells: SpellList = NSManagedObject(entity: spellListEntity, insertIntoManagedObjectContext: context) as! SpellList
        subclass8.id = 8
        subclass8.name = "Nature Domain"
        subclass8.parentClass = pclassResults[2]
        subclass8.freeSpellLevelData = [ [],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[] ] //20 empty arrays (level 1 through 20)
        
        spellNames = ["Animal Friendship", "Speak with Animals", "Barkskin", "Spike Growth", "Plant Growth", "Wind Wall", "Dominate Beast", "Grasping Vine", "Insect Plague", "Tree Stride"]
        leveledSpellNames = ["Animal Friendship": 1, "Speak with Animals" : 1, "Barkskin" : 3, "Spike Growth" : 3, "Plant Growth" : 5, "Wind Wall" : 5,
                             "Dominate Beast" : 7, "Grasping Vine" : 7, "Insect Plague" : 9, "Tree Stride" : 9]
        
        spellFetch.predicate = NSPredicate(format: "name IN %@", spellNames)
        spellFetch.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true), NSSortDescriptor(key: "id", ascending: true)]//sort by level, then by id
        
        do{
            spellResults = try context.executeFetchRequest(spellFetch) as! [Spell]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        for i in 0..<spellResults.count{
            subclass8Spells.spells.insert(spellResults[i])
            let levelIndex: Int = leveledSpellNames[spellResults[i].name]! - 1
            subclass8.freeSpellLevelData[levelIndex].append(Int(spellResults[i].id))
        }//for
        
        subclass8.freeSpellList = subclass8Spells
        
        let subclass9: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        let subclass9Spells: SpellList = NSManagedObject(entity: spellListEntity, insertIntoManagedObjectContext: context) as! SpellList
        subclass9.id = 9
        subclass9.name = "Tempest Domain"
        subclass9.parentClass = pclassResults[2]
        subclass9.freeSpellLevelData = [ [],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[] ] //20 empty arrays (level 1 through 20)
        
        spellNames = ["Fog Cloud", "Thunderwave", "Gust of Wind", "Shatter", "Call Lightning", "Sleet Storm", "Control Water", "Ice Storm", "Destructive Wave", "Insect Plague"]
        leveledSpellNames = ["Fog Cloud": 1, "Thunderwave" : 1, "Gust of Wind" : 3, "Shatter" : 3, "Call Lightning" : 5, "Sleet Storm" : 5,
                             "Control Water" : 7, "Ice Storm" : 7, "Destructive Wave" : 9, "Insect Plague" : 9]
        
        spellFetch.predicate = NSPredicate(format: "name IN %@", spellNames)
        spellFetch.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true), NSSortDescriptor(key: "id", ascending: true)]//sort by level, then by id
        
        do{
            spellResults = try context.executeFetchRequest(spellFetch) as! [Spell]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        for i in 0..<spellResults.count{
            subclass9Spells.spells.insert(spellResults[i])
            let levelIndex: Int = leveledSpellNames[spellResults[i].name]! - 1
            subclass9.freeSpellLevelData[levelIndex].append(Int(spellResults[i].id))
        }//for
        
        subclass9.freeSpellList = subclass9Spells
        
        let subclass10: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        let subclass10Spells: SpellList = NSManagedObject(entity: spellListEntity, insertIntoManagedObjectContext: context) as! SpellList
        subclass10.id = 10
        subclass10.name = "Trickery Domain"
        subclass10.parentClass = pclassResults[2]
        subclass10.freeSpellLevelData = [ [],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[] ] //20 empty arrays (level 1 through 20)
        
        spellNames = ["Charm Person", "Disguise Self", "Mirror Image", "Pass Without Trace", "Blink", "Dispel Magic", "Dimension Door", "Polymorph", "Dominate Person", "Modify Memory"]
        leveledSpellNames = ["Charm Person": 1, "Disguise Self" : 1, "Mirror Image" : 3, "Pass Without Trace" : 3, "Blink" : 5, "Dispel Magic" : 5,
                             "Dimension Door" : 7, "Polymorph" : 7, "Dominate Person" : 9, "Modify Memory" : 9]
        
        spellFetch.predicate = NSPredicate(format: "name IN %@", spellNames)
        spellFetch.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true), NSSortDescriptor(key: "id", ascending: true)]//sort by level, then by id
        
        do{
            spellResults = try context.executeFetchRequest(spellFetch) as! [Spell]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        for i in 0..<spellResults.count{
            subclass10Spells.spells.insert(spellResults[i])
            let levelIndex: Int = leveledSpellNames[spellResults[i].name]! - 1
            subclass10.freeSpellLevelData[levelIndex].append(Int(spellResults[i].id))
        }//for
        
        subclass10.freeSpellList = subclass10Spells
        
        let subclass11: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        let subclass11Spells: SpellList = NSManagedObject(entity: spellListEntity, insertIntoManagedObjectContext: context) as! SpellList
        subclass11.id = 11
        subclass11.name = "War Domain"
        subclass11.parentClass = pclassResults[2]
        subclass11.freeSpellLevelData = [ [],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[] ] //20 empty arrays (level 1 through 20)
        
        spellNames = ["Divine Favor", "Shield of Faith", "Magic Weapon", "Spiritual Weapon", "Crusader's Mantle", "Spirit Guardians", "Freedom of Movement", "Stoneskin", "Flame Strike", "Hold Monster"]
        leveledSpellNames = ["Divine Favor": 1, "Shield of Faith" : 1, "Magic Weapon" : 3, "Spiritual Weapon" : 3, "Crusader's Mantle" : 5, "Spirit Guardians" : 5,
                             "Freedom of Movement" : 7, "Stoneskin" : 7, "Flame Strike" : 9, "Hold Monster" : 9]
        
        spellFetch.predicate = NSPredicate(format: "name IN %@", spellNames)
        spellFetch.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true), NSSortDescriptor(key: "id", ascending: true)]//sort by level, then by id
        
        do{
            spellResults = try context.executeFetchRequest(spellFetch) as! [Spell]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        for i in 0..<spellResults.count{
            subclass11Spells.spells.insert(spellResults[i])
            let levelIndex: Int = leveledSpellNames[spellResults[i].name]! - 1
            subclass11.freeSpellLevelData[levelIndex].append(Int(spellResults[i].id))
        }//for
        
        subclass11.freeSpellList = subclass11Spells
        
        //MARK: Druid
        
        let subclass12: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        subclass12.id = 12
        subclass12.name = "Circle of the Moon"
        subclass12.parentClass = pclassResults[3]
        
        let subclass13: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        let subclass13Spells: SpellList = NSManagedObject(entity: spellListEntity, insertIntoManagedObjectContext: context) as! SpellList
        subclass13.id = 13
        subclass13.name = "Circle of the Land: Arctic"
        subclass13.parentClass = pclassResults[3]
        subclass13.freeSpellLevelData = [ [],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[] ] //20 empty arrays (level 1 through 20)
        
        spellNames = ["Hold Person", "Spike Growth", "Sleet Storm", "Slow", "Freedom of Movement", "Ice Storm", "Commune with Nature", "Cone of Cold"]
        leveledSpellNames = ["Hold Person" : 3, "Spike Growth" : 3, "Sleet Storm" : 5, "Slow" : 5,
                             "Freedom of Movement" : 7, "Ice Storm" : 7, "Commune with Nature" : 9, "Cone of Cold" : 9]
        
        spellFetch.predicate = NSPredicate(format: "name IN %@", spellNames)
        spellFetch.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true), NSSortDescriptor(key: "id", ascending: true)]//sort by level, then by id
        
        do{
            spellResults = try context.executeFetchRequest(spellFetch) as! [Spell]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        for i in 0..<spellResults.count{
            subclass13Spells.spells.insert(spellResults[i])
            let levelIndex: Int = leveledSpellNames[spellResults[i].name]! - 1
            subclass13.freeSpellLevelData[levelIndex].append(Int(spellResults[i].id))
        }//for
        
        subclass13.freeSpellList = subclass13Spells
        
        let subclass14: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        let subclass14Spells: SpellList = NSManagedObject(entity: spellListEntity, insertIntoManagedObjectContext: context) as! SpellList
        subclass14.id = 14
        subclass14.name = "Circle of the Land: Coast"
        subclass14.parentClass = pclassResults[3]
        subclass14.freeSpellLevelData = [ [],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[] ] //20 empty arrays (level 1 through 20)
        
        spellNames = ["Mirror Image", "Misty Step", "Water Breathing", "Water Walk", "Control Water", "Freedom of Movement", "Conjure Elemental", "Scrying"]
        leveledSpellNames = ["Mirror Image" : 3, "Misty Step" : 3, "Water Breathing" : 5, "Water Walk" : 5,
                             "Control Water" : 7, "Freedom of Movement" : 7, "Conjure Elemental" : 9, "Scrying" : 9]
        
        spellFetch.predicate = NSPredicate(format: "name IN %@", spellNames)
        spellFetch.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true), NSSortDescriptor(key: "id", ascending: true)]//sort by level, then by id
        
        do{
            spellResults = try context.executeFetchRequest(spellFetch) as! [Spell]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        for i in 0..<spellResults.count{
            subclass14Spells.spells.insert(spellResults[i])
            let levelIndex: Int = leveledSpellNames[spellResults[i].name]! - 1
            subclass14.freeSpellLevelData[levelIndex].append(Int(spellResults[i].id))
        }//for
        
        subclass14.freeSpellList = subclass14Spells
        
        let subclass15: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        let subclass15Spells: SpellList = NSManagedObject(entity: spellListEntity, insertIntoManagedObjectContext: context) as! SpellList
        subclass15.id = 15
        subclass15.name = "Circle of the Land: Desert"
        subclass15.parentClass = pclassResults[3]
        subclass15.freeSpellLevelData = [ [],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[] ] //20 empty arrays (level 1 through 20)
        
        spellNames = ["Blur", "Silence", "Create Food and Water", "Protection from Energy", "Blight", "Hallucinatory Terrain", "Insect Plague", "Wall of Stone"]
        leveledSpellNames = ["Blur" : 3, "Silence" : 3, "Create Food and Water" : 5, "Protection from Energy" : 5,
                             "Blight" : 7, "Hallucinatory Terrain" : 7, "Insect Plague" : 9, "Wall of Stone" : 9]
        
        spellFetch.predicate = NSPredicate(format: "name IN %@", spellNames)
        spellFetch.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true), NSSortDescriptor(key: "id", ascending: true)]//sort by level, then by id
        
        do{
            spellResults = try context.executeFetchRequest(spellFetch) as! [Spell]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        for i in 0..<spellResults.count{
            subclass15Spells.spells.insert(spellResults[i])
            let levelIndex: Int = leveledSpellNames[spellResults[i].name]! - 1
            subclass15.freeSpellLevelData[levelIndex].append(Int(spellResults[i].id))
        }//for
        
        subclass15.freeSpellList = subclass15Spells
        
        let subclass16: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        let subclass16Spells: SpellList = NSManagedObject(entity: spellListEntity, insertIntoManagedObjectContext: context) as! SpellList
        subclass16.id = 16
        subclass16.name = "Circle of the Land: Forest"
        subclass16.parentClass = pclassResults[3]
        subclass16.freeSpellLevelData = [ [],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[] ] //20 empty arrays (level 1 through 20)
        
        spellNames = ["Barkskin", "Spider Climb", "Call Lightning", "Plant Growth", "Divination", "Freedom of Movement", "Commune with Nature", "Tree Stride"]
        leveledSpellNames = ["Barkskin" : 3, "Spider Climb" : 3, "Call Lightning" : 5, "Plant Growth" : 5,
                             "Divination" : 7, "Freedom of Movement" : 7, "Commune with Nature" : 9, "Tree Stride" : 9]
        
        spellFetch.predicate = NSPredicate(format: "name IN %@", spellNames)
        spellFetch.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true), NSSortDescriptor(key: "id", ascending: true)]//sort by level, then by id
        
        do{
            spellResults = try context.executeFetchRequest(spellFetch) as! [Spell]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        for i in 0..<spellResults.count{
            subclass16Spells.spells.insert(spellResults[i])
            let levelIndex: Int = leveledSpellNames[spellResults[i].name]! - 1
            subclass16.freeSpellLevelData[levelIndex].append(Int(spellResults[i].id))
        }//for
        
        subclass16.freeSpellList = subclass16Spells
        
        let subclass17: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        let subclass17Spells: SpellList = NSManagedObject(entity: spellListEntity, insertIntoManagedObjectContext: context) as! SpellList
        subclass17.id = 17
        subclass17.name = "Circle of the Land: Grassland"
        subclass17.parentClass = pclassResults[3]
        subclass17.freeSpellLevelData = [ [],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[] ] //20 empty arrays (level 1 through 20)
        
        spellNames = ["Invisibility", "Pass Without Trace", "Daylight", "Haste", "Divination", "Freedom of Movement", "Dream", "Insect Plague"]
        leveledSpellNames = ["Invisibility" : 3, "Pass Without Trace" : 3, "Daylight" : 5, "Haste" : 5,
                             "Divination" : 7, "Freedom of Movement" : 7, "Dream" : 9, "Insect Plague" : 9]
        
        spellFetch.predicate = NSPredicate(format: "name IN %@", spellNames)
        spellFetch.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true), NSSortDescriptor(key: "id", ascending: true)]//sort by level, then by id
        
        do{
            spellResults = try context.executeFetchRequest(spellFetch) as! [Spell]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        for i in 0..<spellResults.count{
            subclass17Spells.spells.insert(spellResults[i])
            let levelIndex: Int = leveledSpellNames[spellResults[i].name]! - 1
            subclass17.freeSpellLevelData[levelIndex].append(Int(spellResults[i].id))
        }//for
        
        subclass17.freeSpellList = subclass17Spells
        
        let subclass18: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        let subclass18Spells: SpellList = NSManagedObject(entity: spellListEntity, insertIntoManagedObjectContext: context) as! SpellList
        subclass18.id = 18
        subclass18.name = "Circle of the Land: Mountain"
        subclass18.parentClass = pclassResults[3]
        subclass18.freeSpellLevelData = [ [],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[] ] //20 empty arrays (level 1 through 20)
        
        spellNames = ["Spider Climb", "Spike Growth", "Lightning Bolt", "Meld into Stone", "Stone Shape", "Stoneskin", "Passwall", "Wall of Stone"]
        leveledSpellNames = ["Spider Climb" : 3, "Spike Growth" : 3, "Lightning Bolt" : 5, "Meld into Stone" : 5,
                             "Stone Shape" : 7, "Stoneskin" : 7, "Passwall" : 9, "Wall of Stone" : 9]
        
        spellFetch.predicate = NSPredicate(format: "name IN %@", spellNames)
        spellFetch.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true), NSSortDescriptor(key: "id", ascending: true)]//sort by level, then by id
        
        do{
            spellResults = try context.executeFetchRequest(spellFetch) as! [Spell]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        for i in 0..<spellResults.count{
            subclass18Spells.spells.insert(spellResults[i])
            let levelIndex: Int = leveledSpellNames[spellResults[i].name]! - 1
            subclass18.freeSpellLevelData[levelIndex].append(Int(spellResults[i].id))
        }//for
        
        subclass18.freeSpellList = subclass18Spells
        
        let subclass19: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        let subclass19Spells: SpellList = NSManagedObject(entity: spellListEntity, insertIntoManagedObjectContext: context) as! SpellList
        subclass19.id = 19
        subclass19.name = "Circle of the Land: Swamp"
        subclass19.parentClass = pclassResults[3]
        subclass19.freeSpellLevelData = [ [],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[] ] //20 empty arrays (level 1 through 20)
        
        spellNames = ["Darkness", "Melf's Acid Arrow", "Water Walk", "Stinking Cloud", "Freedom of Movement", "Locate Creature", "Insect Plague", "Scrying"]
        leveledSpellNames = ["Darkness" : 3, "Melf's Acid Arrow" : 3, "Water Walk" : 5, "Stinking Cloud" : 5,
                             "Freedom of Movement" : 7, "Locate Creature" : 7, "Insect Plague" : 9, "Scrying" : 9]
        
        spellFetch.predicate = NSPredicate(format: "name IN %@", spellNames)
        spellFetch.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true), NSSortDescriptor(key: "id", ascending: true)]//sort by level, then by id
        
        do{
            spellResults = try context.executeFetchRequest(spellFetch) as! [Spell]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        for i in 0..<spellResults.count{
            subclass19Spells.spells.insert(spellResults[i])
            let levelIndex: Int = leveledSpellNames[spellResults[i].name]! - 1
            subclass19.freeSpellLevelData[levelIndex].append(Int(spellResults[i].id))
        }//for
        
        subclass19.freeSpellList = subclass19Spells
        
        let subclass20: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        let subclass20Spells: SpellList = NSManagedObject(entity: spellListEntity, insertIntoManagedObjectContext: context) as! SpellList
        subclass20.id = 20
        subclass20.name = "Circle of the Land: Underdark"
        subclass20.parentClass = pclassResults[3]
        subclass20.freeSpellLevelData = [ [],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[] ] //20 empty arrays (level 1 through 20)
        
        spellNames = ["Spider Climb", "Web", "Gaseous Form", "Stinking Cloud", "Greater Invisibility", "Stone Shape", "Cloudkill", "Insect Plague"]
        leveledSpellNames = ["Spider Climb" : 3, "Web" : 3, "Gaseous Form" : 5, "Stinking Cloud" : 5,
                             "Greater Invisibility" : 7, "Stone Shape" : 7, "Cloudkill" : 9, "Insect Plague" : 9]
        
        spellFetch.predicate = NSPredicate(format: "name IN %@", spellNames)
        spellFetch.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true), NSSortDescriptor(key: "id", ascending: true)]//sort by level, then by id
        
        do{
            spellResults = try context.executeFetchRequest(spellFetch) as! [Spell]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        for i in 0..<spellResults.count{
            subclass20Spells.spells.insert(spellResults[i])
            let levelIndex: Int = leveledSpellNames[spellResults[i].name]! - 1
            subclass20.freeSpellLevelData[levelIndex].append(Int(spellResults[i].id))
        }//for
        
        subclass20.freeSpellList = subclass20Spells
        
        //MARK: Fighter
        
        let subclass21: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        subclass21.id = 21
        subclass21.name = "Champion"
        subclass21.parentClass = pclassResults[4]
        
        let subclass22: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        subclass22.id = 22
        subclass22.name = "Battle Master"
        subclass22.parentClass = pclassResults[4]
        
        let subclass23: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        subclass23.id = 23
        subclass23.name = "Eldritch Knight"
        subclass23.parentClass = pclassResults[4]
        
        //MARK: Monk
        
        let subclass24: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        subclass24.id = 24
        subclass24.name = "Way of the Open Hand"
        subclass24.parentClass = pclassResults[5]
        
        let subclass25: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        subclass25.id = 25
        subclass25.name = "Way of Shadow"
        subclass25.parentClass = pclassResults[5]
        
        let subclass26: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        subclass26.id = 26
        subclass26.name = "Way of the Four Elements"
        subclass26.parentClass = pclassResults[5]
        
        //MARK: Paladin

        let subclass27: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        let subclass27Spells: SpellList = NSManagedObject(entity: spellListEntity, insertIntoManagedObjectContext: context) as! SpellList
        subclass27.id = 27
        subclass27.name = "Oath of Devotion"
        subclass27.parentClass = pclassResults[6]
        subclass27.freeSpellLevelData = [ [],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[] ] //20 empty arrays (level 1 through 20)
        
        spellNames = ["Protection from Evil and Good", "Sanctuary", "Lesser Restoration", "Zone of Truth",
                      "Beacon of Hope", "Dispel Magic", "Freedom of Movement", "Guardian of Faith",
                      "Commune", "Flame Strike"]
        leveledSpellNames = ["Protection from Evil and Good" : 3, "Sanctuary" : 3, "Lesser Restoration" : 5, "Zone of Truth" : 5,
                             "Beacon of Hope" : 9, "Dispel Magic" : 9, "Freedom of Movement" : 13, "Guardian of Faith" : 13,
                             "Commune" : 17, "Flame Strike" : 17]
        
        spellFetch.predicate = NSPredicate(format: "name IN %@", spellNames)
        spellFetch.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true), NSSortDescriptor(key: "id", ascending: true)]//sort by level, then by id
        
        do{
            spellResults = try context.executeFetchRequest(spellFetch) as! [Spell]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        for i in 0..<spellResults.count{
            subclass27Spells.spells.insert(spellResults[i])
            let levelIndex: Int = leveledSpellNames[spellResults[i].name]! - 1
            subclass27.freeSpellLevelData[levelIndex].append(Int(spellResults[i].id))
        }//for
        
        subclass27.freeSpellList = subclass27Spells
        
        let subclass28: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        let subclass28Spells: SpellList = NSManagedObject(entity: spellListEntity, insertIntoManagedObjectContext: context) as! SpellList
        subclass28.id = 28
        subclass28.name = "Oath of the Ancients"
        subclass28.parentClass = pclassResults[6]
        subclass28.freeSpellLevelData = [ [],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[] ] //20 empty arrays (level 1 through 20)
        
        spellNames = ["Ensnaring Strike", "Speak with Animals", "Misty Step", "Moonbeam",
                      "Plant Growth", "Protection from Energy", "Ice Storm", "Stoneskin",
                      "Commune with Nature", "Tree Stride"]
        leveledSpellNames = ["Ensnaring Strike" : 3, "Speak with Animals" : 3, "Misty Step" : 5, "Moonbeam" : 5,
                             "Plant Growth" : 9, "Protection from Energy" : 9, "Ice Storm" : 13, "Stoneskin" : 13,
                             "Commune with Nature" : 17, "Tree Stride" : 17]
        
        spellFetch.predicate = NSPredicate(format: "name IN %@", spellNames)
        spellFetch.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true), NSSortDescriptor(key: "id", ascending: true)]//sort by level, then by id
        
        do{
            spellResults = try context.executeFetchRequest(spellFetch) as! [Spell]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        for i in 0..<spellResults.count{
            subclass28Spells.spells.insert(spellResults[i])
            let levelIndex: Int = leveledSpellNames[spellResults[i].name]! - 1
            subclass28.freeSpellLevelData[levelIndex].append(Int(spellResults[i].id))
        }//for
        
        subclass28.freeSpellList = subclass28Spells
        
        let subclass29: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        let subclass29Spells: SpellList = NSManagedObject(entity: spellListEntity, insertIntoManagedObjectContext: context) as! SpellList
        subclass29.id = 29
        subclass29.name = "Oath of Vengeance"
        subclass29.parentClass = pclassResults[6]
        subclass29.freeSpellLevelData = [ [],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[] ] //20 empty arrays (level 1 through 20)
        
        spellNames = ["Bane", "Hunter's Mark", "Hold Person", "Misty Step",
                      "Haste", "Protection from Energy", "Banishment", "Dimension Door",
                      "Hold Monster", "Scrying"]
        leveledSpellNames = ["Bane" : 3, "Hunter's Mark" : 3, "Hold Person" : 5, "Misty Step" : 5,
                             "Haste" : 9, "Protection from Energy" : 9, "Banishment" : 13, "Dimension Door" : 13,
                             "Hold Monster" : 17, "Scrying" : 17]
        
        spellFetch.predicate = NSPredicate(format: "name IN %@", spellNames)
        spellFetch.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true), NSSortDescriptor(key: "id", ascending: true)]//sort by level, then by id
        
        do{
            spellResults = try context.executeFetchRequest(spellFetch) as! [Spell]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        for i in 0..<spellResults.count{
            subclass29Spells.spells.insert(spellResults[i])
            let levelIndex: Int = leveledSpellNames[spellResults[i].name]! - 1
            subclass29.freeSpellLevelData[levelIndex].append(Int(spellResults[i].id))
        }//for
        
        subclass29.freeSpellList = subclass29Spells
        
        //MARK: Ranger
        
        let subclass30: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        subclass30.id = 30
        subclass30.name = "Hunter"
        subclass30.parentClass = pclassResults[7]
        
        let subclass31: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        subclass31.id = 31
        subclass31.name = "Beast Master"
        subclass31.parentClass = pclassResults[7]
        
        //MARK: Rogue
        
        let subclass32: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        subclass32.id = 32
        subclass32.name = "Thief"
        subclass32.parentClass = pclassResults[8]
        
        let subclass33: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        subclass33.id = 33
        subclass33.name = "Assassin"
        subclass33.parentClass = pclassResults[8]
        
        let subclass34: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        subclass34.id = 34
        subclass34.name = "Arcane Trickster"
        subclass34.parentClass = pclassResults[8]
        
        //MARK: Sorcerer
        
        let subclass35: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        subclass35.id = 35
        subclass35.name = "Draconic Bloodline"
        subclass35.parentClass = pclassResults[9]
        
        let subclass36: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        subclass36.id = 36
        subclass36.name = "Wild Magic"
        subclass36.parentClass = pclassResults[9]
        
        //MARK: Warlock
        
        let subclass37: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        let subclass37Spells: SpellList = NSManagedObject(entity: spellListEntity, insertIntoManagedObjectContext: context) as! SpellList
        subclass37.id = 37
        subclass37.name = "The Archfey"
        subclass37.parentClass = pclassResults[10]
        
        spellNames = ["Faerie Fire", "Sleep", "Calm Emotions", "Phantasmal Force",
                      "Blink", "Plant Growth", "Dominate Beast", "Greater Invisibility",
                      "Dominate Person", "Seeming"]
        
        spellFetch.predicate = NSPredicate(format: "name IN %@", spellNames)
        spellFetch.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true), NSSortDescriptor(key: "id", ascending: true)]//sort by level, then by id
        
        do{
            spellResults = try context.executeFetchRequest(spellFetch) as! [Spell]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        for i in 0..<spellResults.count{
            subclass37Spells.spells.insert(spellResults[i])
        }//for
        
        subclass37.freeSpellList = subclass37Spells
        
        let subclass38: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        let subclass38Spells: SpellList = NSManagedObject(entity: spellListEntity, insertIntoManagedObjectContext: context) as! SpellList
        subclass38.id = 38
        subclass38.name = "The Fiend"
        subclass38.parentClass = pclassResults[10]
        
        spellNames = ["Burning Hands", "Command", "Blindness/Deafness", "Scorching Ray",
                      "Fireball", "Stinking Cloud", "Fire Shield", "Wall of Fire",
                      "Flame Strike", "Hallow"]
        
        spellFetch.predicate = NSPredicate(format: "name IN %@", spellNames)
        spellFetch.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true), NSSortDescriptor(key: "id", ascending: true)]//sort by level, then by id
        
        do{
            spellResults = try context.executeFetchRequest(spellFetch) as! [Spell]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        for i in 0..<spellResults.count{
            subclass38Spells.spells.insert(spellResults[i])
        }//for
        
        subclass38.freeSpellList = subclass38Spells
        
        let subclass39: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        let subclass39Spells: SpellList = NSManagedObject(entity: spellListEntity, insertIntoManagedObjectContext: context) as! SpellList
        subclass39.id = 39
        subclass39.name = "The Great Old One"
        subclass39.parentClass = pclassResults[10]
        
        spellNames = ["Dissonant Whispers", "Tasha's Hideous Laughter", "Detect Thoughts", "Phantasmal Force",
                      "Clairvoyance", "Sending", "Dominate Beast", "Evard's Black Tentacles",
                      "Dominate Person", "Telekinesis"]
        
        spellFetch.predicate = NSPredicate(format: "name IN %@", spellNames)
        spellFetch.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true), NSSortDescriptor(key: "id", ascending: true)]//sort by level, then by id
        
        do{
            spellResults = try context.executeFetchRequest(spellFetch) as! [Spell]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        for i in 0..<spellResults.count{
            subclass39Spells.spells.insert(spellResults[i])
        }//for
        
        subclass39.freeSpellList = subclass39Spells
        
        //MARK: Wizard
        
        let subclass40: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        subclass40.id = 40
        subclass40.name = "School of Abjuration"
        subclass40.parentClass = pclassResults[11]
        
        let subclass41: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        subclass41.id = 41
        subclass41.name = "School of Conjuration"
        subclass41.parentClass = pclassResults[11]
        
        let subclass42: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        subclass42.id = 42
        subclass42.name = "School of Divination"
        subclass42.parentClass = pclassResults[11]
        
        let subclass43: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        subclass43.id = 43
        subclass43.name = "School of Enchantment"
        subclass43.parentClass = pclassResults[11]
        
        let subclass44: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        subclass44.id = 44
        subclass44.name = "School of Evocation"
        subclass44.parentClass = pclassResults[11]
        
        let subclass45: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        subclass45.id = 45
        subclass45.name = "School of Illusion"
        subclass45.parentClass = pclassResults[11]
        
        let subclass46: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        subclass46.id = 46
        subclass46.name = "School of Necromancy"
        subclass46.parentClass = pclassResults[11]
        
        let subclass47: Subclass = NSManagedObject(entity: subclassEntity, insertIntoManagedObjectContext: context) as! Subclass
        subclass47.id = 47
        subclass47.name = "School of Transmutation"
        subclass47.parentClass = pclassResults[11]

        
        
    }//subClassesInit
    
}//Subclass

