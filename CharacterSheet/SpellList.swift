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
    @NSManaged var pclass: PClass?

    /**
     * Takes in a level, and returns the items in the spell list that are spells of that level.
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
        }//classResults[0] is the Bard class, spellResults[0] are the bard spells
        spellList2.pclass = classResults[0]
        
        for (var i = 0; i < spellResults.count; i++){
            spellList2.spells.insert(spellResults[i])
        }
        
        
        
    }//spellListInit
    
}//SpellList
