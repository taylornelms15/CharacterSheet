//
//  SpellList.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 3/26/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import Foundation
import CoreData


class SpellList: NSManagedObject {

    @NSManaged var spells: Set<Spell>
    @NSManaged var pclass: PClass? //Only exists for top-level spell lists
    
    //These arrays hold the names of spells per level for easy access
    var cantrips: [String]? = nil
    var lev1spells: [String]? = nil
    var lev2spells: [String]? = nil
    var lev3spells: [String]? = nil
    var lev4spells: [String]? = nil
    var lev5spells: [String]? = nil
    var lev6spells: [String]? = nil
    var lev7spells: [String]? = nil
    var lev8spells: [String]? = nil
    var lev9spells: [String]? = nil
    
    //MARK: Fetchers
    
    
    /**
     Gives a list of names of spells for the given level.
    - Parameter level: the level of the spells whose names you want
    - Returns: The array of spell names for the given level
    */
    func getSpellNamesPerLevel(level level: Int16) -> [String]{
        
        switch(level){
        case 0:
            if (cantrips != nil){
                return cantrips!
            }//extant name list
            else{
                updateSpellNamesPerLevel(level: level)
                return cantrips!
            }//empty name list
        case 1:
            if (lev1spells != nil){
                return lev1spells!
            }//extant name list
            else{
                updateSpellNamesPerLevel(level: level)
                return lev1spells!
            }//empty name list
        case 2:
            if (lev2spells != nil){
                return lev2spells!
            }//extant name list
            else{
                updateSpellNamesPerLevel(level: level)
                return lev2spells!
            }//empty name list
        case 3:
            if (lev3spells != nil){
                return lev3spells!
            }//extant name list
            else{
                updateSpellNamesPerLevel(level: level)
                return lev3spells!
            }//empty name list
        case 4:
            if (lev4spells != nil){
                return lev4spells!
            }//extant name list
            else{
                updateSpellNamesPerLevel(level: level)
                return lev4spells!
            }//empty name list
        case 5:
            if (lev5spells != nil){
                return lev5spells!
            }//extant name list
            else{
                updateSpellNamesPerLevel(level: level)
                return lev5spells!
            }//empty name list
        case 6:
            if (lev6spells != nil){
                return lev6spells!
            }//extant name list
            else{
                updateSpellNamesPerLevel(level: level)
                return lev6spells!
            }//empty name list
        case 7:
            if (lev7spells != nil){
                return lev7spells!
            }//extant name list
            else{
                updateSpellNamesPerLevel(level: level)
                return lev7spells!
            }//empty name list
        case 8:
            if (lev8spells != nil){
                return lev8spells!
            }//extant name list
            else{
                updateSpellNamesPerLevel(level: level)
                return lev8spells!
            }//empty name list
        case 9:
            if (lev9spells != nil){
                return lev9spells!
            }//extant name list
            else{
                updateSpellNamesPerLevel(level: level)
                return lev9spells!
            }//empty name list
        default:
            return []
        }//switch

    }//getSpellNamesPerLevel
    
    /**
     Modifies the spell names for a certain level. Pulls from the list of spells.
    - Parameter level: the level of the spells whose names you will update
    */
    func updateSpellNamesPerLevel(level level: Int16){
        var nameArray: [String] = []
        
        switch(level){
        case 0:
            let spellArray: [Spell] = getSpellsForLevel(level: level)
            for a in spellArray{
                nameArray.append(a.name)
            }
            cantrips = nameArray
        case 1:
            let spellArray: [Spell] = getSpellsForLevel(level: level)
            for a in spellArray{
                nameArray.append(a.name)
            }
            lev1spells = nameArray
        case 2:
            let spellArray: [Spell] = getSpellsForLevel(level: level)
            for a in spellArray{
                nameArray.append(a.name)
            }
            lev2spells = nameArray
        case 3:
            let spellArray: [Spell] = getSpellsForLevel(level: level)
            for a in spellArray{
                nameArray.append(a.name)
            }
            lev3spells = nameArray
        case 4:
            let spellArray: [Spell] = getSpellsForLevel(level: level)
            for a in spellArray{
                nameArray.append(a.name)
            }
            lev4spells = nameArray
        case 5:
            let spellArray: [Spell] = getSpellsForLevel(level: level)
            for a in spellArray{
                nameArray.append(a.name)
            }
            lev5spells = nameArray
        case 6:
            let spellArray: [Spell] = getSpellsForLevel(level: level)
            for a in spellArray{
                nameArray.append(a.name)
            }
            lev6spells = nameArray
        case 7:
            let spellArray: [Spell] = getSpellsForLevel(level: level)
            for a in spellArray{
                nameArray.append(a.name)
            }
            lev7spells = nameArray
        case 8:
            let spellArray: [Spell] = getSpellsForLevel(level: level)
            for a in spellArray{
                nameArray.append(a.name)
            }
            lev8spells = nameArray
        case 9:
            let spellArray: [Spell] = getSpellsForLevel(level: level)
            for a in spellArray{
                nameArray.append(a.name)
            }
            lev9spells = nameArray
        default:
            break
        }//switch

    }//updateSpellNamesPerLevel
    
    /**
      Takes in a level, and returns the items in the spell list that are spells of that level.
     - Parameter level: the level of spells to look for
     - Returns: The array of spells in this list of the given level
     */
    func getSpellsForLevel(level level: Int16)->[Spell]{
        
        let levelPredicate: NSPredicate = NSPredicate(format: "level == %d", level)
        let idDescriptor: NSSortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        
        let subSet: NSSet = (spells as NSSet).filteredSetUsingPredicate(levelPredicate)
        let subArray: [AnyObject] = subSet.sortedArrayUsingDescriptors([idDescriptor])
        
        return (subArray as! [Spell])

    }//getSpellsforLevel
    
    //MARK: setters
    
    func addSpell(spell spell: Spell){
        spells.insert(spell)
        
        
        
    }
    
    
    static func spellListInit(context: NSManagedObjectContext){
        
        let spellListEntity = NSEntityDescription.entityForName("SpellList", inManagedObjectContext: context)!
        let classFetch = NSFetchRequest(entityName: "PClass")
        let spellFetch = NSFetchRequest(entityName: "Spell")
        var spellNames: [String] = []

        //Bard
        let spellList1: SpellList = NSManagedObject(entity: spellListEntity, insertIntoManagedObjectContext: context) as! SpellList
        spellNames =
            [
                "Blade Ward", "Dancing Lights", "Friends", "Light", "Mage Hand", "Mending", "Message", "Minor Illusion", "Prestidigitation",
                "True Strike", "Vicious Mockery", "Animal Friendship", "Bane", "Charm Person", "Comprehend Languages", "Cure Wounds", "Detect Magic",
                "Disguise Self", "Dissonant Whispers", "Faerie Fire", "Feather Fall", "Healing Word", "Heroism", "Identify", "Illusory Script",
                "Longstrider", "Silent Image", "Sleep", "Speak with Animals", "Tasha's Hideous Laughter", "Thunderwave", "Unseen Servant",
                "Animal Messenger", "Blindness/Deafness", "Calm Emotions", "Cloud of Daggers", "Crown of Madness", "Detect Thoughts", "Enhance Ability",
                "Enthrall", "Heat Metal", "Hold Person", "Invisibility", "Knock", "Lesser Restoration", "Locate Animals or Plants", "Locate Object",
                "Magic Mouth", "Phantasmal Force", "See Invisibility", "Shatter", "Silence", "Suggestion", "Zone of Truth", "Bestow Curse",
                "Clairvoyance", "Dispel Magic", "Fear", "Feign Death", "Glyph of Warding", "Hypnotic Pattern", "Leomund's Tiny Hut", "Major Image",
                "Nondetection", "Plant Growth", "Sending", "Speak with Dead", "Speak with Plants", "Stinking Cloud", "Tongues", "Compulsion",
                "Confusion", "Dimension Door", "Freedom of Movement", "Greater Invisibility", "Hallucinatory Terrain", "Locate Creature",
                "Polymorph", "Animate Objects", "Awaken", "Dominate Person", "Dream", "Geas", "Greater Restoration", "Hold Monster", "Legend Lore",
                "Mass Cure Wounds", "Mislead", "Modify Memory", "Planar Binding", "Raise Dead", "Scrying", "Seeming", "Teleporation Circle",
                "Eyebite", "Find the Path", "Guards and Wards", "Mass Suggestion", "Otto's Irresistable Dance", "Programmed Illusion", "True Seeing",
                "Etherealness", "Forcecage", "Mirage Arcane", "Mordenkainen's Magnificent Mansion", "Mordenkainen's Sword", "Project Image", "Regenerate",
                "Resurrection", "Symbol", "Teleport", "Dominate Monster", "Feeblemind", "Glibness", "Mind Blank", "Power Word Stun",
                "Foresight", "Power Word Heal", "Power Word Kill", "True Polymorph"
            ]
        classFetch.predicate = NSPredicate(format: "name = %@", "Bard");
        spellFetch.predicate = NSPredicate(format: "name IN %@", spellNames)
        spellFetch.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true), NSSortDescriptor(key: "id", ascending: true)]//sort by level, then by id
        var classResults: [PClass] = []
        var spellResults: [Spell] = []
        do{
            classResults = try context.executeFetchRequest(classFetch) as! [PClass]
            spellResults = try context.executeFetchRequest(spellFetch) as! [Spell]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }//classResults[0] is the Bard class, spellResults[0] are the bard spells
        spellList1.pclass = classResults[0]
        
        for (var i = 0; i < spellResults.count; i++){
            spellList1.spells.insert(spellResults[i])
        }
        
        //Cleric
        let spellList2: SpellList = NSManagedObject(entity: spellListEntity, insertIntoManagedObjectContext: context) as! SpellList
        spellNames =
            [
                "Guidance", "Light", "Mending", "Resistance", "Sacred Flame", "Spare the Dying", "Thaumaturgy", "Bane", "Bless", "Command", "Create or Destroy Water",
                "Cure Wounds", "Detect Evil and Good", "Detect Magic", "Detect Poison and Disease", "Guiding Bolt", "Healing Word", "Inflict Wounds",
                "Protection from Evil and Good", "Purify Food and Drink", "Sanctuary", "Shield of Faith", "Aid", "Augury", "Blindness/Deafness", "Calm Emotions",
                "Continual Flame", "Enhance Ability", "Find Traps", "Gentle Repose", "Hold Person", "Lesser Restoration", "Locate Object",
                "Prayer of Healing", "Protection from Poison", "Silence", "Spiritual Weapon", "Warding Bond", "Zone of Truth", "Animate Dead", "Beacon of Hope",
                "Bestow Curse", "Clairvoyance", "Create Food and Water", "Daylight", "Dispel Magic", "Feign Death", "Glyph of Warding", "Magic Circle",
                "Mass Healing Word", "Meld into Stone", "Protection from Energy", "Remove Curse", "Revivify", "Sending", "Speak with Dead", "Spirit Guardians",
                "Tongues", "Water Walk", "Banishment", "Control Water", "Death Ward", "Divination", "Freedom of Movement", "Guardian of Faith", "Locate Creature",
                "Stone Shape", "Commune", "Contagion", "Dispel Evil and Good", "Flame Strike", "Geas", "Greater Restoration", "Hallow", "Insect Plague", "Legend Lore",
                "Mass Cure Wounds", "Planar Binding", "Raise Dead", "Scrying", "Blade Barrier", "Create Undead", "Find the Path", "Forbiddance", "Harm", "Heal",
                "Heroes' Feast", "Planar Ally", "True Seeing", "Word of Recall", "Conjure Celestial", "Divine Word", "Etherealness", "Fire Storm", "Plane Shift",
                "Regenerate", "Resurrection", "Symbol", "Antimagic Field", "Control Weather", "Earthquake", "Holy Aura", "Astral Projection", "Gate", "Mass Heal",
                "True Resurrection"
            ]
        classFetch.predicate = NSPredicate(format: "name = %@", "Cleric");
        spellFetch.predicate = NSPredicate(format: "name IN %@", spellNames)
        spellFetch.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true), NSSortDescriptor(key: "id", ascending: true)]//sort by level, then by id
        classResults = []
        spellResults = []
        do{
            classResults = try context.executeFetchRequest(classFetch) as! [PClass]
            spellResults = try context.executeFetchRequest(spellFetch) as! [Spell]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }//classResults[0] is the Cleric class, spellResults[0] are the Cleric spells
        spellList2.pclass = classResults[0]
        
        for (var i = 0; i < spellResults.count; i++){
            spellList2.spells.insert(spellResults[i])
        }
        
        //Druid
        let spellList3: SpellList = NSManagedObject(entity: spellListEntity, insertIntoManagedObjectContext: context) as! SpellList
        spellNames =
            [
                "Druidcraft", "Guidance", "Mending", "Poison Spray", "Produce Flame", "Resistance", "Shillelagh", "Thorn Whip", "Animal Friendship",
                "Charm Person", "Create or Destroy Water", "Cure Wounds", "Detect Magic", "Detect Poison and Disease", "Entangle", "Faerie Fire", "Fog Cloud",
                "Goodberry", "Healing Word", "Jump", "Longstrider", "Purify Food and Drink", "Speak with Animals", "Thunderwave", "Animal Messenger", "Barkskin",
                "Beast Sense", "Darkvision", "Enhance Ability", "Find Traps", "Flame Blade", "Flaming Sphere", "Gust of Wind", "Heat Metal", "Hold Person",
                "Lesser Restoration", "Locate Animals or Plants", "Locate Object", "Moonbeam", "Pass without Trace", "Protection from Poison", "Spike Growth",
                "Call Lightning", "Conjure Animals", "Daylight", "Dispel Magic", "Feign Death", "Meld into Stone", "Plant Growth", "Protection from Energy",
                "Sleet Storm", "Speak with Plants", "Water Breathing", "Water Walk", "Wind Wall", "Blight", "Confusion", "Conjure Minor Elementals",
                "Conjure Woodland Beings", "Control Water", "Dominate Beast", "Freedom of Movement", "Giant Insect", "Grasping Vine", "Hallucinatory Terrain",
                "Ice Storm", "Locate Creature", "Polymorph", "Stone Shape", "Stoneskin", "Wall of Fire", "Antilife Shell", "Awaken", "Commune with Nature",
                "Conjure Elemental", "Contagion", "Geas", "Greater Restoration", "Insect Plague", "Mass Cure Wounds", "Planar Binding", "Reincarnate",
                "Scrying", "Tree Stride", "Wall of Stone", "Conjure Fey", "Find the Path", "Heal", "Heroes' Feast", "Move Earth", "Sunbeam", "Transport via Plants",
                "Wall of Thorns", "Wind Walk", "Fire Storm", "Mirage Arcane", "Plane Shift", "Regenerate", "Reverse Gravity", "Animal Shapes", "Antipathy/Sympath",
                "Control Weather", "Earthquake", "Feeblemind", "Sunburst", "Tsunami", "Foresight", "Shapechange", "Storm of Vengeance", "True Resurrection"
            ]
        classFetch.predicate = NSPredicate(format: "name = %@", "Druid");
        spellFetch.predicate = NSPredicate(format: "name IN %@", spellNames)
        spellFetch.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true), NSSortDescriptor(key: "id", ascending: true)]//sort by level, then by id
        classResults = []
        spellResults = []
        do{
            classResults = try context.executeFetchRequest(classFetch) as! [PClass]
            spellResults = try context.executeFetchRequest(spellFetch) as! [Spell]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }//classResults[0] is the Druid class, spellResults[0] are the Druid spells
        spellList3.pclass = classResults[0]
        
        for (var i = 0; i < spellResults.count; i++){
            spellList3.spells.insert(spellResults[i])
        }
        
        //Paladin
        let spellList4: SpellList = NSManagedObject(entity: spellListEntity, insertIntoManagedObjectContext: context) as! SpellList
        spellNames =
            [
                "Bless", "Command", "Compelled Duel", "Detect Evil and Good", "Detect Magic", "Detect Poison and Disease", "Divine Favor", "Heroism",
                "Protection from Evil and Good", "Purify Food and Drink", "Searing Smite", "Shield of Faith", "Thunderous Smite", "Wrathful Smite",
                "Aid", "Branding Smite", "Find Steed", "Lesser Restoration", "Locate Object", "Magic Weapon", "Protection from Poison", "Zone of Truth",
                "Aura of Vitality", "Blinding Smite", "Create Food and Water", "Crusader's Mantle", "Daylight", "Dispel Magic", "Elemental Weapon",
                "Magic Circle", "Remove Curse", "Revivify", "Aura of Life", "Aura of Purity", "Banishment", "Death Ward", "Locate Creature", "Staggering Smite",
                "Banishing Smite", "Circle of Power", "Destructive Wave", "Dispel Evil and Good", "Geas", "Raise Dead"
            ]
        classFetch.predicate = NSPredicate(format: "name = %@", "Paladin");
        spellFetch.predicate = NSPredicate(format: "name IN %@", spellNames)
        spellFetch.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true), NSSortDescriptor(key: "id", ascending: true)]//sort by level, then by id
        classResults = []
        spellResults = []
        do{
            classResults = try context.executeFetchRequest(classFetch) as! [PClass]
            spellResults = try context.executeFetchRequest(spellFetch) as! [Spell]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }//classResults[0] is the Paladin class, spellResults[0] are the Paladin spells
        spellList4.pclass = classResults[0]
        
        for (var i = 0; i < spellResults.count; i++){
            spellList4.spells.insert(spellResults[i])
        }
        
        //Ranger
        let spellList5: SpellList = NSManagedObject(entity: spellListEntity, insertIntoManagedObjectContext: context) as! SpellList
        spellNames =
            [
                "Alarm", "Animal Friendship", "Cure Wounds", "Detect Magic", "Detect Poison and Disease", "Ensnaring Strike", "Fog Cloud", "Goodberry",
                "Hail of Thorns", "Hunter's Mark", "Jump", "Longstrider", "Speak with Animals", "Animal Messenger", "Barkskin", "Beast Sense", "Cordon of Arrows",
                "Darkvision", "Find Traps", "Lesser Restoration", "Locate Animals or Plants", "Locate Object", "Pass without Trace", "Protection from Poison",
                "Silence", "Spike Growth", "Conjure Animals", "Conjure Barrage", "Daylight", "Lightning Arrow", "Nondetection", "Plant Growth",
                "Protection from Energy", "Speak with Plants", "Water Breathing", "Water Walk", "Wind Wall", "Conjure Woodland Beings", "Freedom of Movement",
                "Grasping Vine", "Locate Creature", "Stoneskin", "Commune with Nature", "Conjure Volley", "Swift Quiver", "Tree Stride"
            ]
        classFetch.predicate = NSPredicate(format: "name = %@", "Ranger");
        spellFetch.predicate = NSPredicate(format: "name IN %@", spellNames)
        spellFetch.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true), NSSortDescriptor(key: "id", ascending: true)]//sort by level, then by id
        classResults = []
        spellResults = []
        do{
            classResults = try context.executeFetchRequest(classFetch) as! [PClass]
            spellResults = try context.executeFetchRequest(spellFetch) as! [Spell]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }//classResults[0] is the Ranger class, spellResults[0] are the Ranger spells
        spellList5.pclass = classResults[0]
        
        for (var i = 0; i < spellResults.count; i++){
            spellList5.spells.insert(spellResults[i])
        }
        
        //Sorcerer
        let spellList6: SpellList = NSManagedObject(entity: spellListEntity, insertIntoManagedObjectContext: context) as! SpellList
        spellNames =
            [
                "Acid Splash", "Blade Ward", "Chill Touch", "Dancing Lights", "Fire Bolt", "Friends", "Light", "Mage Hand", "Mending", "Message", "Minor Illusion",
                "Poison Spray", "Prestidigitation", "Ray of Frost", "Shocking Grasp", "True Strike", "Burning Hands", "Charm Person", "Chromatic Orb", "Color Spray",
                "Comprehend Languages", "Detect Magic", "Disguise Self", "Expeditious Retreat", "False Life", "Feather Fall", "Fog Cloud", "Jump", "Mage Armor",
                "Magic Missile", "Ray of Sickness", "Shield", "Silent Image", "Sleep", "Thunderwave", "Witch Bolt", "Alter Self", "Blindness/Deafness",
                "Blur", "Cloud of Daggers", "Crown of Madness", "Darkness", "Darkvision", "Detect Thoughts", "Enhance Ability", "Enlarge/Reduce", "Gust of Wind",
                "Hold Person", "Invisibility", "Knock", "Levitate", "Mirror Image", "Misty Step", "Phantasmal Force", "Scorching Ray", "See Invisibility",
                "Shatter", "Spider Climb", "Suggestion", "Web", "Blink", "Clairvoyance", "Counterspell", "Daylight", "Dispel Magic", "Fear", "Fireball",
                "Fly", "Gaseous Form", "Haste", "Hypnotic Pattern", "Lighting Bolt", "Major Image", "Protection from Energy", "Sleet Storm", "Slow",
                "Stinking Cloud", "Tongues", "Water Breathing", "Water Walk", "Banishment", "Blight", "Confusion", "Dimension Door", "Dominate Beast",
                "Greater Invisibility", "Ice Storm", "Polymorph", "Stoneskin", "Wall of Fire", "Animate Objects", "Cloudkill", "Cone of Cold",
                "Creation", "Dominate Person", "Hold Monster", "Insect Plague", "Seeming", "Telekinesis", "Teleportation Circle", "Wall of Stone",
                "Arcane Gate", "Chain Lightning", "Circle of Death", "Disintegrate", "Eyebite", "Globe of Invulnerability", "Mass Suggestion", "Move Earth",
                "Sunbeam", "True Seeing", "Delayed Blast Fireball", "Etherealness", "Finger of Death", "Fire Storm", "Plane Shift", "Prismatic Spray",
                "Reverse Gravity", "Teleport", "Dominate Monster", "Earthquake", "Incendiary Cloud", "Power Word Stun", "Sunburst", "Gate", "Meteor Swarm",
                "Power Word Kill", "Time Stop", "Wish"
        ]
        classFetch.predicate = NSPredicate(format: "name = %@", "Sorcerer");
        spellFetch.predicate = NSPredicate(format: "name IN %@", spellNames)
        spellFetch.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true), NSSortDescriptor(key: "id", ascending: true)]//sort by level, then by id
        classResults = []
        spellResults = []
        do{
            classResults = try context.executeFetchRequest(classFetch) as! [PClass]
            spellResults = try context.executeFetchRequest(spellFetch) as! [Spell]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }//classResults[0] is the Sorcerer class, spellResults[0] are the Sorcerer spells
        spellList6.pclass = classResults[0]
        
        for (var i = 0; i < spellResults.count; i++){
            spellList6.spells.insert(spellResults[i])
        }
        
        //Warlock
        let spellList7: SpellList = NSManagedObject(entity: spellListEntity, insertIntoManagedObjectContext: context) as! SpellList
        spellNames =
            [
                "Blade Ward", "Chill Touch", "Eldritch Blast", "Friends", "Mage Hand", "Minor Illusion", "Poison Spray", "Prestidigitation", "True Strike",
                "Armor of Agathys", "Arms of Hadar", "Charm Person", "Comprehend Languages", "Expeditious Retreat", "Hellish Rebuke", "Hex",
                "Illusory Script", "Protection from Evil and Good", "Unseen Servant", "Witch Bolt", "Cloud of Daggers", "Crown of Madness", "Darkness",
                "Enthrall", "Hold Person", "Invisibility", "Mirror Image", "Misty Step", "Ray of Enfeeblement", "Shatter", "Spider Climb", "Suggestion",
                "Counterspell", "Dispel Magic", "Fear", "Fly", "Gaseous Form", "Hunger of Hadar", "Hypnotic Pattern", "Magic Circle", "Major Image",
                "Remove Curse", "Tongues", "Vampiric Touch", "Banishment", "Blight", "Dimension Door", "Hallucinatory Terrain", "Contact Other Plane", "Dream",
                "Hold Monster", "Scrying", "Arcane Gate", "Circle of Death", "Conjure Fey", "Create Undead", "Eyebite", "Flesh to Stone", "Mass Suggestion",
                "True Seeing", "Etherealness", "Finger of Death", "Forcecage", "Plane Shift", "Demiplane", "Dominate Monster", "feeblemind", "Glibness",
                "Power Word Stun", "Astral Projection", "Foresight", "Imprisonment", "Power Word Kill", "True Polymorph"
            ]
        classFetch.predicate = NSPredicate(format: "name = %@", "Warlock");
        spellFetch.predicate = NSPredicate(format: "name IN %@", spellNames)
        spellFetch.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true), NSSortDescriptor(key: "id", ascending: true)]//sort by level, then by id
        classResults = []
        spellResults = []
        do{
            classResults = try context.executeFetchRequest(classFetch) as! [PClass]
            spellResults = try context.executeFetchRequest(spellFetch) as! [Spell]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }//classResults[0] is the Warlock class, spellResults[0] are the Warlock spells
        spellList7.pclass = classResults[0]
        
        for (var i = 0; i < spellResults.count; i++){
            spellList7.spells.insert(spellResults[i])
        }
        
        //Warlock
        let spellList8: SpellList = NSManagedObject(entity: spellListEntity, insertIntoManagedObjectContext: context) as! SpellList
        spellNames =
            [
                "Acid Splash", "Blade Ward", "Chill Touch", "Dancing Lights", "Fire Bolt", "Friends", "Light", "Mage Hand", "Mending", "Message", "Minor Illusion",
                "Poison Spray", "Prestidigitation", "Ray of Frost", "Shocking Grasp", "True Strike", "Alarm", "Burning Hands", "Charm Person",
                "Chromatic Orb", "Color Spray", "Comprehend Languages", "Detect Magic", "Disguise Self", "Expeditious Retreat", "False Life", "Feather Fall",
                "Find Familiar", "Fog Cloud", "Grease", "Indentify", "Illusory Script", "Jump", "Longstrider", "Mage Armor", "Magic Missile",
                "Protection from Evil and Good", "Ray of Sickness", "Shield", "Silent Image", "Sleep", "Tasha's Hideous Laughter", "Tenser's Floating Disk",
                "Thunderwave", "Unseen Servant", "Witch Bolt", "Alter Self", "Arcane Lock", "Blindness/Deafness", "Blur", "Cloud of Daggers", "Continual Flame",
                "Crown of Madness", "Darkness", "Darkvision", "Detect Thoughts", "Enlarge/Reduce", "Flaming Sphere", "Gentle Repose", "Gust of Wind",
                "Hold Person", "Invisibility", "Knock", "Levitate", "Locate Object", "Magic Mouth", "Magic Weapon", "Melf's Acid Arrow", "Mirror Image",
                "Misty Step", "Nystul's Magic Aura", "Phantasmal Force", "Ray of Enfeeblement", "Rope Trick", "Scorching Ray", "See Invisibility", "Shatter",
                "Spider Climb", "Suggestion", "Web", "Animate Dead", "Bestow Curse", "Blink", "Clairvoyance", "Counterspell", "Dispel Magic", "Fear", "Feign Death",
                "Fireball", "Fly", "Gaseous Form", "Glyph of Warding", "Haste", "Hypnotic Pattern", "Leomund's Tiny Hut", "Lightning Bolt", "Magic Circle",
                "Major Image", "Nondetection", "Phantom Steed", "Protection from Energy", "Remove Curse", "Sending", "Sleet Storm", "Slow", "Stinking Cloud",
                "Tongues", "Vampiric Touch", "Water Breathing", "Arcane Eye", "Banishment", "Blight", "Confusion", "Conjure Minor Elementals", "Control Water",
                "Dimension Door", "Evard's Black Tentacles", "Fabricate", "Fire Shield", "Greater Invisibility", "Hallucinatory Terrain", "Ice Storm",
                "Leomund's Secret Chest", "Locate Creature", "Mordenkainen's Faithful Hound", "Mordenkainen's Private Sanctum", "Otiluke's Resilient Sphere",
                "Phantasmal Killer", "Polymorph", "Stone Shape", "Stoneskin", "Wall of Fire", "Animate Objects", "Bigby's Hand", "Cloudkill", "Cone of Cold",
                "Conjure Elemental", "Contact Other Plane", "Creation", "Dominate Person", "Dream", "Geas", "Hold Monster", "Legend Lore", "Mislead", "Modify Memory",
                "Passwall", "Planar Binding", "Rary's Telepathic Bond", "Scrying", "Seeming", "Telekinesis", "Teleporation Circle", "Wall of Force", "Wall of Stone",
                "Arcane Gate", "Chain Lightning", "Circle of Death", "Contingency", "Create Undead", "Disintegrate", "Drawmij's Instant Summons", "Eyebite",
                "Flesh to Stone", "Globe of Invulnerability", "Guards and Wards", "Magic Jar", "Mass Suggestion", "Move Earth", "Otiluke's Freezing Sphere",
                "Otto's Irresistable Dance", "Programmed Illusion", "Sunbeam", "True Seeing", "Wall of Ice", "Delayed Blast Fireball", "Etherealness",
                "Finger of Death", "Forcecage", "Mirage Arcane", "Mordenkainen's Magnificent Mansion", "Mordenkainen's Sword", "Plane Shift",
                "Prismatic Spray", "Project Image", "Reverse Gravity", "Sequester", "Simulacrum", "Symbol", "Teleport", "Antimagic Field",
                "Antipathy/Sympathy", "Clone", "Control Weather", "Demiplane", "Dominate Monster", "Feeblemind", "Incendiary Cloud", "Maze", "Mind Blank",
                "Power Word Stun", "Sunburst", "Telepathy", "Astral Projection", "Foresight", "Gate", "Imprisonment", "Meteor Swarm", "Power Word Kill",
                "Prismatic Wall", "Shapechange", "Time Stop", "True Polymorph", "Weird", "Wish"
            ]
        classFetch.predicate = NSPredicate(format: "name = %@", "Wizard");
        spellFetch.predicate = NSPredicate(format: "name IN %@", spellNames)
        spellFetch.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true), NSSortDescriptor(key: "id", ascending: true)]//sort by level, then by id
        classResults = []
        spellResults = []
        do{
            classResults = try context.executeFetchRequest(classFetch) as! [PClass]
            spellResults = try context.executeFetchRequest(spellFetch) as! [Spell]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }//classResults[0] is the Wizard class, spellResults[0] are the Wizard spells
        spellList8.pclass = classResults[0]
        
        for (var i = 0; i < spellResults.count; i++){
            spellList8.spells.insert(spellResults[i])
        }
        
        
    }//spellListInit
    
}//SpellList
