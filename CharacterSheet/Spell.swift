//
//  Spell.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 3/25/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import Foundation
import CoreData

/**
The different schools of magic
*/
enum MagicSchool: Int16 {
    case Abjuration, Conjuration, Divination, Enchantment, Evocation, Illusion, Necromancy, Transmutation
}//MagicSchool

enum RangeType: Int16 {
    case PSelf, Touch, Target
}

enum EffectRangeType: Int16{
    case Target, Line, Cone, Cube, Sphere, Cylinder
}

class Spell: NSManagedObject {

    //MARK: Variables
    
    @NSManaged var id: Int64
    @NSManaged var name: String
    @NSManaged var details: String
    @NSManaged var level: Int16//note: 0 is cantrip
    @NSManaged private var schoolValue: Int16//enum
    @NSManaged var ritual: Bool
    @NSManaged var range: Int64
    @NSManaged private var rangeTypeValue: Int16//enum
    @NSManaged var effectRange1: Int64
    @NSManaged var effectRange2: Int64
    @NSManaged private var effectRangeTypeValue: Int16//enum
    @NSManaged var damageDieNum: Int16
    @NSManaged var damageDieType: Int16
    @NSManaged var verbalComponent: Bool
    @NSManaged var somaticComponent: Bool
    @NSManaged var materialComponent: Bool
    @NSManaged var material: String?
    //TODO: Casting Time, Duration (proper encoding)
    @NSManaged var castingTime: String?
    @NSManaged var duration: String?

    var school: MagicSchool{
        get{
            return MagicSchool(rawValue: self.schoolValue)!
        }
        set{
            self.schoolValue = newValue.rawValue
        }
    }//school
    
    var rangeType: RangeType{
        get{
            return RangeType(rawValue: self.rangeTypeValue)!
        }
        set{
            self.rangeTypeValue = newValue.rawValue
        }
    }//rangeType
    
    var effectRangeType: EffectRangeType{
        get{
            return EffectRangeType(rawValue: self.effectRangeTypeValue)!
        }
        set{
            self.effectRangeTypeValue = newValue.rawValue
        }
    }//effectRangeType

    override var description: String{
        get{
            let results = "\(name)\nid: \(id)\nLevel \(level) \(school) Spell\nRange: \(rangeString())\n\(details)"
            
            return results
        }
    }//toString
    
    var componentBlock: (Bool, Bool, Bool){
        get{
            return (verbalComponent, somaticComponent, materialComponent)
        }
        set{
            self.verbalComponent = newValue.0
            self.somaticComponent = newValue.1
            self.materialComponent = newValue.2
        }
    }//componentBlock
    
    var damageDice: (Int16, Int16){
        get{
            return (damageDieNum, damageDieType)
        }
        set{
            self.damageDieNum = newValue.0
            self.damageDieType = newValue.1
        }
    }//damageDice
    
    func damageString()->String{
        if (damageDieNum != 0){
            return "\(damageDieNum)d\(damageDieType)"
        }
        else{
            return ""
        }
    }//damageString
    
    func rangeString()->String{
        switch(rangeType){
        case RangeType.PSelf:
            switch (effectRangeType){
            case EffectRangeType.Target:
                return "Self"
            case EffectRangeType.Line:
                return "Self (\(effectRange1)-ft long, \(effectRange2)-ft wide Line)"
            case EffectRangeType.Cone:
                return "Self (\(effectRange1)-ft Cone)"
            case EffectRangeType.Sphere:
                return "Self (\(effectRange1)-ft radius Sphere)"
            case EffectRangeType.Cylinder:
                return "Self (\(effectRange1)-ft radius, \(effectRange2)-ft long Cylinder)"
            case EffectRangeType.Cube:
                return "Self (\(effectRange1)-ft Cube)"
            }//effectRangeType
        case RangeType.Target:
            switch (effectRangeType){
            case EffectRangeType.Target:
                return "\(range) ft"
            case EffectRangeType.Line:
                return "\(range) ft (\(effectRange1)-ft long, \(effectRange2)-ft wide Line)"
            case EffectRangeType.Cone:
                return "\(range) ft (\(effectRange1)-ft Cone)"
            case EffectRangeType.Sphere:
                return "\(range) ft (\(effectRange1)-ft radius Sphere)"
            case EffectRangeType.Cylinder:
                return "\(range) ft (\(effectRange1)-ft radius, \(effectRange2)-ft long Cylinder)"
            case EffectRangeType.Cube:
                return "\(range) ft (\(effectRange1)-ft Cube)"
            }//effectRangeType
        case RangeType.Touch:
            return "Touch"
        }//rangeType
    }//rangeString
    
    /**
    Returns a string representing the "V, S, M" block as needed.
    Implemented in a succinct but virtually unreadable way, involving 5 ternary operators in a line.
    
    */
    func componentString()->String{
        return "\(verbalComponent ? "V" : "")\(verbalComponent && somaticComponent ? ", " : "")\(somaticComponent ? "S" : "")\(materialComponent && (verbalComponent || somaticComponent) ? ", " : "")\(materialComponent ? "M" : "")"
    }//componentString
    
    func levelTypeString()->String{
        var results: String = ""
        if (level == 0){
            results = "\(school) Cantrip"
        }//if cantrip
        else{
            results = "Level \(level) \(school)"
        }
        if (ritual){
            results.appendContentsOf(" (ritual)")
        }
        return results
    }//levelTypeString
    
    static func spellsInit(context: NSManagedObjectContext){
        
        let spellEntity = NSEntityDescription.entityForName("Spell", inManagedObjectContext: context)!
        
        let spell1: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell1.id = 1
        spell1.name = "Acid Splash"
        spell1.level = 0
        spell1.school = MagicSchool.Conjuration
        spell1.ritual = false
        spell1.range = 60
        spell1.rangeType = RangeType.Target
        spell1.effectRangeType = EffectRangeType.Target
        spell1.damageDice = (1, 6)
        spell1.componentBlock = (true, true, false)
        spell1.castingTime = "1 action"
        spell1.duration = "Instantaneous"
        spell1.details = "\t\tYou hurl a bubble of acid. Does 1d6 damage to either one creature in range, or two creatues in range within 5 ft of each other. Target must make a Dexterity saving throw, or else takes acid damage.\n\tDamage increases by 1d6 at 5th level, 11th level, and 17th level."
        
        let spell2: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell2.id = 2
        spell2.name = "Aid"
        spell2.level = 2
        spell2.school = MagicSchool.Abjuration
        spell2.ritual = false
        spell2.range = 30
        spell2.rangeType = RangeType.Target
        spell2.effectRangeType = EffectRangeType.Target
        spell2.componentBlock = (true, true, true)
        spell2.material = "a tiny strip of white cloth"
        spell2.castingTime = "1 action"
        spell2.duration = "8 hours"
        spell2.details = "\tChoose up to three creatures within range. Their hit point maximum and current hit points increase by 5 for the duration.\n\tWhen using a higher spell slot, the hit point increase is 5 more per spell level."
        
        let spell3: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell3.id = 3
        spell3.name = "Alarm"
        spell3.level = 1
        spell3.school = MagicSchool.Abjuration
        spell3.ritual = true
        spell3.range = 30
        spell3.rangeType = RangeType.Target
        spell3.effectRange1 = 20
        spell3.effectRangeType = EffectRangeType.Cube
        spell3.componentBlock = (true, true, true)
        spell3.material = "a tiny bell and a piece of fine silver wire"
        spell3.castingTime = "1 minute"
        spell3.duration = "8 hours"
        spell3.details = "\tChoose a door, window, or an area within range no larger than a 20-ft cube. Until the spell ends, an alarm alerts you whenever a Tiny or larger creature touches or enters the warded area. You may exclude creatures from the alarm, and decide whether it is mental or audible.\n\tA mental alerm alerts you with a ping in your mind if you are within 1 mile of the warded area, and awakens you if you are sleeping.\n\tAn audible alarm produces the sound of a hand bell for 10 seconds within 60 feet."
        
        let spell4: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell4.id = 4
        spell4.name = "Alter Self"
        spell4.level = 2
        spell4.school = MagicSchool.Transmutation
        spell4.ritual = false
        spell4.rangeType = RangeType.PSelf
        spell4.effectRange1 = 20
        spell4.effectRangeType = EffectRangeType.Target
        spell4.componentBlock = (true, true, false)
        spell4.castingTime = "1 action"
        spell4.duration = "Concentration, up to 1 hour"
        spell4.details = "\tYou assume a different form. When you cast the spell, choose one of the options, the effects of which last for the duration. While the spell is active, you can switch between options as an action.\n  \u{2022} Aquatic Adaptation: You sprout gills and grow webbing between your fingers. You can breathe underwater and gain a swimming speed equal to your walking speed.\n  \u{2022} Change Appearance: You transform your appearance. You decide what you look like, including how you sound, racial appearance, and distinguishing characteristics. You are limited to looking roughly the same size, and your basic shape remains the same. You may, as an action, change your appearance again.\n  \u{2022} Natural Weapons: You grow claws, fangs, spines, horns, or a different natural weapon of your choice. Your unarmed strikes deal 1d6 damage, and you are proficient in them. Additionally, this weapon is magic and you have a +1 bonus to attack and damage rolls with it."
        
        let spell5: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell5.id = 5
        spell5.name = "Animal Friendship"
        spell5.level = 1
        spell5.school = MagicSchool.Enchantment
        spell5.ritual = false
        spell5.range = 30
        spell5.rangeType = RangeType.Target
        spell5.effectRangeType = EffectRangeType.Target
        spell5.componentBlock = (true, true, true)
        spell5.material = "a morsel of food"
        spell5.castingTime = "1 action"
        spell5.duration = "24 hours"
        spell5.details = "\tYou convince a beast that you mean it no harm. This spell fails if the beast's Intelligence is 4 or higher, or if the beast succeeds a Wisdom saving throw. This spell ends if you or one of your companions harms the beast.\n\tWhen using a higher spell slot, you may charm one additional beast per spell level."
        
        let spell6: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell6.id = 6
        spell6.name = "Animal Messenger"
        spell6.level = 2
        spell6.school = MagicSchool.Enchantment
        spell6.ritual = true
        spell6.range = 30
        spell6.rangeType = RangeType.Target
        spell6.effectRangeType = EffectRangeType.Target
        spell6.componentBlock = (true, true, true)
        spell6.material = "a morsel of food"
        spell6.castingTime = "1 action"
        spell6.duration = "24 hours"
        spell6.details = "\tChoose a Tiny beast in range, such as a squirrel, blue jay, or bat. You specify a location you have visited, and a recipient who matches a general description. You speak a message of up to 25 words. The animal travels for the duration of the spell to the target, covering about 50 miles for a flying animal or 25 miles for other animals.\n\tWhen the messenger arrives, it delivers the message to the creature you described, replicating the sound of your voice. It speaks only to a creature matching the description you gave.\n\tWhen using a higher spell slot, the duration increases by 48 hours per spell level."
        
        let spell7: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell7.id = 7
        spell7.name = "Animal Shapes"
        spell7.level = 8
        spell7.school = MagicSchool.Transmutation
        spell7.ritual = false
        spell7.range = 30
        spell7.rangeType = RangeType.Target
        spell7.effectRangeType = EffectRangeType.Target
        spell7.componentBlock = (true, true, false)
        spell7.castingTime = "1 action"
        spell7.duration = "Concentration, up to 24 hours"
        spell7.details = "\tChoose any number of willing creatures that you can see within range. You transform each into the form of a Large or smaller beast with a challenge rating of 4 or lower. On subsequent turns, you can use your action to transform affected creatures into new forms.\n\tThe transformation lasts for the duration for each target, or until the target drops to 0hp or dies. You may choose different forms for each target. Each target's statistics are replaced temporarily by those of the chosen beast, though they retain their alignment, Intelligence, Wisdom, and Charisma scores. It assumes the target beast's hit points, and reverts to its former hit points on transforming back. If the target is reverting after dropping below 0hp, it takes any damage in excess of what its beast form took prior to death. The target is unable to speak or cast spells, and is limited in the actions it can take by its new form.\n\tThe target's gear melds into their new form, and while they do not lose any gear, they cannot benefit from it."
        
        let spell8: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell8.id = 8
        spell8.name = "Animate Dead"
        spell8.level = 3
        spell8.school = MagicSchool.Necromancy
        spell8.ritual = false
        spell8.range = 10
        spell8.rangeType = RangeType.Target
        spell8.effectRangeType = EffectRangeType.Target
        spell8.componentBlock = (true, true, true)
        spell8.material = "a drop of blood, a piece of flesh, and a pinch of bone dust"
        spell8.castingTime = "1 minute"
        spell8.duration = "Instantaneous"
        spell8.details = "\tThis spell creates an undead servant. Choose a corpse or pile of bones of a Medium or Small humanoid within range. Your spell transforms this creature into a skeleton if starting with bones, or a zombie if starting with a corpse.\n\tOn each of your turns, you can use a bonus action to mentally command any creature you made with this spell if the creature is within 60 ft of you. If you control multiple creatures this way, you may issue commands to each of them. You may specify the creature's next action and movement, or issue a general command, such as to guard a particular chamber. Without a command, the creature only defends itself against hostile creatures.\n\tThe creature is under your control for 24 hours, at which point it stops obeying any command you have given it. You may use this spell again to re-assert control of up to four creatures for the next 24 hours.\n\tWhen using a higher spell slot, you animate or reassert control over two additional undead creatures per spell level. Each creature must come from a different set of remains."
        
        let spell9: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell9.id = 9
        spell9.name = "Animate Objects"
        spell9.level = 5
        spell9.school = MagicSchool.Transmutation
        spell9.ritual = false
        spell9.range = 120
        spell9.rangeType = RangeType.Target
        spell9.effectRangeType = EffectRangeType.Target
        spell9.componentBlock = (true, true, false)
        spell9.castingTime = "1 action"
        spell9.duration = "Concentration, up to 1 minute"
        spell9.details = "\tObjects come to life at your command. Choose up to ten nonmagical objects within range that are not being worn or carried. Medium targets count for 2, Large objects count for 4, Huge targets count for 8, and you may not animate anything larger than Huge. Each target animates and becomes a creature under your control until the spell ends or it is reduced to 0hp.\n\tAs a bonus action, you can mentally command any creature you made this way within 500 ft of you. If you control multiple objects this way, you may issue commands to each of them. You may specify the object's next action and movement, or issue a general command, such as to guard a particular chamber. Without a command, the object only defends itself against hostile creatures.\n\tAn animated object is a construct with AC, hit points, attacks, Strength, and Dexterity determined by its size. Its Constitution is 10, its Intelligence and Wisdom are 3, and its Charisma is 1. It's speed is 30 ft, and if it has no legs or other means of locomotion, it has a flying speed of 30 ft and can hover. If it is securely attached to something, its speed is 0 ft. It has blindsight with a radius of 30 ft and is blind beyond that distance. When it drops to 0hp, it reverts to its non-animated form, and any excess damage is transferred to its original form.\n\tOn telling the object to attack, it can make a single melee attack against a creature within 5 ft, making a slam attack with an attack bonus and bludgeoning damage determined by its size.\n\tWhen using a higher spell slot, you can animate two additional objects per spell level."//TODO: add table of object stats
        
        let spell10: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell10.id = 10
        spell10.name = "Antilife Shell"
        spell10.level = 5
        spell10.school = MagicSchool.Abjuration
        spell10.ritual = false
        spell10.rangeType = RangeType.PSelf
        spell10.effectRange1 = 10
        spell10.effectRangeType = EffectRangeType.Sphere
        spell10.componentBlock = (true, true, false)
        spell10.castingTime = "1 action"
        spell10.duration = "Concentration, up to 1 hour"
        spell10.details = "\tA shimmering barrier extends out from you and moves with you, remaining centered on you and hedging out creatures other than undead and constructs.\n\tThe barrier prevents an affected creature from passing or reaching through, but the creature may still cast spells or make attacks with ranged or reach weapons through the barrier.\n\tIf you move so that an affected creature is forced to pass through the barrier, the spell ends."
        
        let spell11: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell11.id = 11
        spell11.name = "Antimagic Field"
        spell11.level = 8
        spell11.school = MagicSchool.Abjuration
        spell11.ritual = false
        spell11.rangeType = RangeType.PSelf
        spell11.effectRange1 = 10
        spell11.effectRangeType = EffectRangeType.Sphere
        spell11.componentBlock = (true, true, true)
        spell11.material = "a pinch of powdered iron or iron filings"
        spell11.castingTime = "1 action"
        spell11.duration = "Concentration, up to 1 hour"
        spell11.details = "\tAn invisible sphere of antimagic surrounds you. Within the sphere, spells cannot be cast, summoned creatures disappear, and magic items become mundane. Until the spell ends, the sphere moves with you, centered on you.\n\tSpells and other magical effects, except those created by an artifact or deity, are suppressed in the sphere and cannot protrude into it. A slot expended to cast a suppressed spell is consumed. While a spell is suppressed, it does not function, but the time it spends suppressed counts against its duration."
        
        let spell12: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell12.id = 12
        spell12.name = "Antipathy/Sympathy"
        spell12.level = 8
        spell12.school = MagicSchool.Enchantment
        spell12.ritual = false
        spell12.range = 60
        spell12.rangeType = RangeType.Target
        spell12.effectRangeType = EffectRangeType.Target
        spell12.componentBlock = (true, true, true)
        spell12.material = "either a lump of alum soaked in vinegar for the antipathy effect or a drop of honey for the sympathy effect"
        spell12.castingTime = "1 hour"
        spell12.duration = "10 days"
        spell12.details = "\tThis spell attracts or repels creatures of your choice. You target something within range, either a Huge or smaller object or a creature or an area no larger than a 200-ft cube. Then specify a kind of intelligent creature, such as red dragons, goblins, or vampires. You invest the target with an aura that attracts or repels the creatures for the duration. Choose antipathy or sympathy as the aura's effect.\n  \u{2022} Antipathy: The enchantment causes creatures of the kind you designated to feel an urge to leave the area and avoid the target. When such a creature can see the target or comes within 60 ft of it, the creature must either succeed on a Wisdom saving throw, or become frightened while the creature is in range.\n  \u{2022} Sympathy: The enchantment causes creatures of the kind you designated to feel an urge to approach the target while within 60 feet of it or able to see it. When such a creature can see the target or comes within 60 ft of it, the creature must either succeed on a Wisdom saving throw, or use its movement on each of its turns to enter the area or move within reach of the target.\n\tIf the target damages or otherwise harms an affected creature, the affected creature can make a Wisdom saving throw to end the effect.\n  \u{2022} Ending the Effect: if an affected creature ends its turn while not within 60 feet of the target or able to see it, the creature makes a Wisdom saving throw. On a successful save, the creature is no longer affected by the target and recognizes the prior feelings as magical. In addition, a creature affected by the spell is allowed another Wisdom saving throw every 24 hours while the spell persists./nA creature that makes a successful saving throw is immune to this spell's effects for 1 minute."
        
        let spell13: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell13.id = 13
        spell13.name = "Arcane Eye"
        spell13.level = 4
        spell13.school = MagicSchool.Divination
        spell13.ritual = false
        spell13.range = 30
        spell13.rangeType = RangeType.Target
        spell13.effectRangeType = EffectRangeType.Target
        spell13.componentBlock = (true, true, true)
        spell13.material = "a bit of bat fur"
        spell13.castingTime = "1 action"
        spell13.duration = "Concentration, up to 1 hour"
        spell13.details = "\tYou create an invisible, magical eye within range that hovers in the air for the duration.\n\tYou mentally receive visual information from the eye, which has normal vision and dark vision out to 30 ft. The eye can look in every direction.\n\tAs an action, you can move the eye up to 30 ft in any direction. There is no limit to how far away from you it can move, but it cannot enter another plane of existence or pass through solid barriers. The eye can pass through an opening as small as 1 inch in diameter."
        
        let spell14: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell14.id = 14
        spell14.name = "Arcane Gate"
        spell14.level = 6
        spell14.school = MagicSchool.Conjuration
        spell14.ritual = false
        spell14.range = 500
        spell14.rangeType = RangeType.Target
        spell14.effectRange1 = 5
        spell14.effectRange2 = 0
        spell14.effectRangeType = EffectRangeType.Cylinder
        spell14.componentBlock = (true, true, false)
        spell14.castingTime = "1 action"
        spell14.duration = "Concentration, up to 10 minutes"
        spell14.details = "\tYou create linked teleportation portals that remain open for the duration. Choose two points on the ground that you can see, one within 10 ft of you and one within 500 ft of you. A circular portal opens over each point, though fails to do so if it is in the space occupied by a creature.\n\tThe portals are two-dimensional glowing rings filled with mist, hovering over the ground and perpendicular to it at the points you choose, and visible only from one side.\n\tAny creature entering the portal on one end exits the other end as if they were adjacent. The mist that fills each portal blocks vision through it. On your turn, you may rotate the rings as a bonus action so that the active side faces in a different direction."
        
        let spell15: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell15.id = 15
        spell15.name = "Arcane Lock"
        spell15.level = 2
        spell15.school = MagicSchool.Abjuration
        spell15.ritual = false
        spell15.range = 0
        spell15.rangeType = RangeType.Touch
        spell15.effectRangeType = EffectRangeType.Target
        spell15.componentBlock = (true, true, true)
        spell15.material = "gold dust worth at least 25 gp, which the spell consumes"
        spell15.castingTime = "1 action"
        spell15.duration = "Until dispelled"
        spell15.details = "\tYou touch a closed door, window, gate, chest, or other entryway, and it becomes locked for the duration. You and any creatures you designate upon casting may open the object normally. You may also set a password that suppresses the spell for one minute when spoken within 5 ft of the object. The object is otherwise impassable until it is borken or the spell is dispelled or suppressed. Casting \"knock\" on the object suppresses the spell for 10 minutes.\n\tWhuke affected by this spell, the object is more difficult to break or force open; the DC to break it or pick any locks on it increases by 10."
        
        let spell16: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell16.id = 16
        spell16.name = "Armor of Agathys"
        spell16.level = 1
        spell16.school = MagicSchool.Abjuration
        spell16.ritual = false
        spell16.rangeType = RangeType.PSelf
        spell16.effectRangeType = EffectRangeType.Target
        spell16.componentBlock = (true, true, true)
        spell16.material = "a cup of water"
        spell16.castingTime = "1 action"
        spell16.duration = "1 hour"
        spell16.details = "\tA protective magical force surrounds you, manifesting as a spectral frost that covers you and your gear. You gain 5 temporary hit points for the duration. If a creature hits you with a melee attack while you have these hit points, the creature takes 5 cold damage.\n\tWhen using a higher spell slot, both the temporary hit points and the cold damage increase by 5 for each additional spell level."
        
        let spell17: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell17.id = 17
        spell17.name = "Arms of Hadar"
        spell17.level = 1
        spell17.school = MagicSchool.Conjuration
        spell17.ritual = false
        spell17.rangeType = RangeType.PSelf
        spell17.effectRange1 = 10
        spell17.effectRangeType = EffectRangeType.Sphere
        spell17.damageDice = (2, 6)
        spell17.componentBlock = (true, true, false)
        spell17.castingTime = "1 action"
        spell17.duration = "Instantaneous"
        spell17.details = "\tYou invoke the power of Hadar, the Dark Hunger. Tendrils of dark energy erupt from you and batter all creatures within range. Each creature must make a Strength saving throw. On a failed save, each target takes 2d6 necrotic damage, and cannot take reactions until its next turn. On a successful save, the creature takes half this damage, but suffers no other ill effects.\n\tWhen using a higher spell slot, the damage increases by 1d6 for each additional spell level."
        
        let spell18: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell18.id = 18
        spell18.name = "Astral Projection"
        spell18.level = 9
        spell18.school = MagicSchool.Necromancy
        spell18.ritual = false
        spell18.range = 10
        spell18.rangeType = RangeType.Target
        spell18.effectRangeType = EffectRangeType.Target
        spell18.componentBlock = (true, true, false)
        spell18.material = "for each creature you affect with this spell, you must provide one jacinth worth at least 1000gp and one ornately carved bar of silver worth at least 100gp, all of which the spell consumes"
        spell18.castingTime = "1 hour"
        spell18.duration = "Special"
        spell18.details = "\tYou and up to eight willing creatures within range project your astral bodies into the Astral Plane (the spell fails and the casting is wasted if you are already on that plane). The material body you leave behind is unconscious and in a state of suspended animation; it doesn't need food or air and doesn't age.\n\tYour astral body resembles your mortal form in almost every way, replicating your game statistics and possessions. The principal difference is the adoption of a silvery cord that extends from between your shoulder blades and trails behind you, fading to invisibility after 1 foot. This cord is your tether to your material body. As long as the tether remains intact, you can find your way home. If the cord is cut - something that can happen only when an effect specifically states that it does - your soul and body are separated, killing you instantly.\n\tYour astral form can freely travel through the Astral Plane and can pass through portals there leading to any other plane. If you enter a new plane or return to the plane you were on when casting this spell, your body and possessions are transported along the silver cord, allowing you to re-enter your mody as you enter the new plane. Your astral form is a separate incarnation. Any damage or other effects that apply to it have no effect on your physical body, nor do they persist when you return to it.\n\tThe spell ends for you and your companions when you use your action to dismiss it. When the spell ends, the affected creature returns to its physical body, and it awakens.\n\tThe spell might also end early for you or one of your companions. A successful Dispel Magic spell used against an astral or physical body ends the spell for that creature. If a creature's original body or its astral form drops to 0 hit points, the spell ends for that creature. If the spell ends and the silver cord is intact, the cord pulls the creature's astral form back to its body, ending its state of suspended animation.\n\tIf you are returned to your body prematurely, your companions remain in their astral forms and must find their own way back to their bodies, usually by dropping to 0 hit points."
        
        let spell19: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell19.id = 19
        spell19.name = "Augury"
        spell19.level = 2
        spell19.school = MagicSchool.Divination
        spell19.ritual = true
        spell19.rangeType = RangeType.PSelf
        spell19.effectRangeType = EffectRangeType.Target
        spell19.componentBlock = (true, true, false)
        spell19.material = "specially marked sticks, bones, or similar tokens worth at least 25gp"
        spell19.castingTime = "1 minute"
        spell19.duration = "Instantaneous"
        spell19.details = "\tBy casting gem-inlaid sticks, rolling dragon bones, laying out cards, or employing some other divining tool, you receive an omen from an otherworldly entity about the results of a specific course of action that you plan to take within the next 30 minutes. The DM chooses from the following possible omens:\n  \u{2022} Weal, for good results\n  \u{2022} Woe, for bad results\n  \u{2022} Weal and Woe, for both good and bad results\n  \u{2022} Nothing, for results that are neither good nor bad\n\tThe spell doesn't take into account any possible circumstances that might change the outcome, such as the casting of additional spells or the loss or gain of a companion.\n\tIf you cast the spell two or more times before completing your next long rest, there is a cumulative 25% chance for each casting after the first that you get a random reading. The DM makes this roll in secret."
        
        let spell20: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell20.id = 20
        spell20.name = "Aura of Life"
        spell20.level = 4
        spell20.school = MagicSchool.Abjuration
        spell20.ritual = false
        spell20.rangeType = RangeType.PSelf
        spell20.effectRange1 = 30
        spell20.effectRangeType = EffectRangeType.Sphere
        spell20.componentBlock = (true, false, false)
        spell20.castingTime = "1 action"
        spell20.duration = "Concentration, up to 10 minutes"
        spell20.details = "\tLife-preserving energy radiates from you in an aura with a 30-ft radius. Until the spell ends, the aura moves with you. Each nonhostile creature in the aura (including yourself) has resistance to necrotic damage, and its hit point maximum can't be reduced. In addition, a nonhostile, living creature regains 1 hit point when it starts its turn in the aura with 0 hit points."
        
        let spell21: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell21.id = 21
        spell21.name = "Aura of Purity"
        spell21.level = 4
        spell21.school = MagicSchool.Abjuration
        spell21.ritual = false
        spell21.rangeType = RangeType.PSelf
        spell21.effectRange1 = 30
        spell21.effectRangeType = EffectRangeType.Sphere
        spell21.componentBlock = (true, false, false)
        spell21.castingTime = "1 action"
        spell21.duration = "Concentration, up to 10 minutes"
        spell21.details = "\tPurifying energy radiates from you in an aura with a 30-ft radius. Until the spell ends, the aura moves with you. Each nonhostile creature in the aura (including yourself) has resistance to poison damage, can't become diseased, and has advantage on savings throws against effects that cause any of the following conditions: blinded, charmed, deafened, frightened, paralyzed, poisoned, and stunned."
        
        let spell22: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell22.id = 22
        spell22.name = "Aura of Vitality"
        spell22.level = 3
        spell22.school = MagicSchool.Evocation
        spell22.ritual = false
        spell22.rangeType = RangeType.PSelf
        spell22.effectRange1 = 30
        spell22.effectRangeType = EffectRangeType.Sphere
        spell22.componentBlock = (true, false, false)
        spell22.castingTime = "1 action"
        spell22.duration = "Concentration, up to 10 minutes"
        spell22.details = "\tHealing energy radiates from you in an aura with a 30-ft radius. Until the spell ends, the aura moves with you. You can use a bonus action to cause one creature in the aura (including yourself) to regain 2d6 hit points."
        
        let spell23: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell23.id = 23
        spell23.name = "Awaken"
        spell23.level = 5
        spell23.school = MagicSchool.Transmutation
        spell23.ritual = false
        spell23.rangeType = RangeType.Touch
        spell23.effectRangeType = EffectRangeType.Target
        spell23.componentBlock = (true, true, true)
        spell23.material = "an agate worth at least 1000gp, which the spell consumes"
        spell23.castingTime = "8 hours"
        spell23.duration = "Instantaneous"
        spell23.details = "\tAfter spending the casting time tracing magical pathways within a precious gemstone, you touch a Huge or smaller beast or plant. The target must have either no Intelligence score or an Intelligence of 3 or less. The target gains an Intelligence of 10. The target also gains the ability to speak one language you know. If the target is a plant, it gains the ability to move its limbs, roots, vines, creepers, and so forth, and it gains senses similar to a human's. Your DM chooses statistics appropriate for the awakened plant.\n\tThe awakened beast or plant is charmed by you for 30 days or until you or your companions do anything harmful to it. When the charmed condition ends, the awakened creature chooses whether to remain friendly to you, based on how you treated it while it was charmed."
        
        let spell24: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell24.id = 24
        spell24.name = "Bane"
        spell24.level = 1
        spell24.school = MagicSchool.Enchantment
        spell24.ritual = false
        spell24.range = 30
        spell24.rangeType = RangeType.Target
        spell24.effectRangeType = EffectRangeType.Target
        spell24.componentBlock = (true, true, true)
        spell24.material = "a drop of blood"
        spell24.castingTime = "1 action"
        spell24.duration = "Concentration, up to 1 minute"
        spell24.details = "\tUp to three creatures of your choice in range must make Charisma saving throws. Whenever a target that fails this saving throw makes an attack roll or a saving throw before the spell ends, the target must roll a d4 and subtract the number rolled from the attack roll or saving throw.\n\tWhen using a higher spell slot, you can target one additional creature for each additional spell level."
        
        let spell25: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell25.id = 25
        spell25.name = "Banishing Smite"
        spell25.level = 5
        spell25.school = MagicSchool.Abjuration
        spell25.ritual = false
        spell25.rangeType = RangeType.PSelf
        spell25.effectRangeType = EffectRangeType.Target
        spell25.damageDice = (5, 10)
        spell25.componentBlock = (true, false, false)
        spell25.castingTime = "1 bonus action"
        spell25.duration = "Concentration, up to 1 minute"
        spell25.details = "\tThe next time you hit a creature with a weapon attack before this spell ends, your weapon crackles with force, and the attack deals an extra 5d10 force damage to the target. Additionally, if this attack reduces the target to 50 hit points or fewer, you banish it. If the target is native to a different plane of existence than the one you'e on, the target disappears, returning to its home plane. If the target is native to the plane you're on, the creature vanishes into a harmless demiplane. While there, the target is incapacitated. It remains there until the spell ends, at which point the target reappears in the space it left, or in the nearest unoccupied space if that space is occupied."
        
        let spell26: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell26.id = 26
        spell26.name = "Banishment"
        spell26.level = 4
        spell26.school = MagicSchool.Abjuration
        spell26.ritual = false
        spell26.range = 60
        spell26.rangeType = RangeType.Target
        spell26.effectRangeType = EffectRangeType.Target
        spell26.componentBlock = (true, true, true)
        spell26.material = "an item distasteful to the target"
        spell26.castingTime = "1 action"
        spell26.duration = "Concentration, up to 1 minute"
        spell26.details = "\tYou attempt to send one creature that you can see within range to another plane of existence. The target must succeed on a Charisma saving throw or be banished.\n\tIf the target is native to a different plane of existence than the one you'e on, the target disappears, returning to its home plane. If the target is native to the plane you're on, the creature vanishes into a harmless demiplane. While there, the target is incapacitated. It remains there until the spell ends, at which point the target reappears in the space it left, or in the nearest unoccupied space if that space is occupied.\n\tIf the target is native to a different plane of existence than the one you're on, the target is banished with a faint popping noise, returning to its home plane. If the spell ends before 1 minute has passed, the target reappears in the same space it left or in the nearest unoccupied space if that space is occupied. Otherwise, the target doesn't return.\n\tWhen using a higher spell slot, you can target one additional creature for each additional spell level."
        
        let spell27: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell27.id = 27
        spell27.name = "Barkskin"
        spell27.level = 2
        spell27.school = MagicSchool.Transmutation
        spell27.ritual = false
        spell27.rangeType = RangeType.Touch
        spell27.effectRangeType = EffectRangeType.Target
        spell27.componentBlock = (true, true, true)
        spell27.material = "a handful of oak bark"
        spell27.castingTime = "1 action"
        spell27.duration = "Concentration, up to 1 hour"
        spell27.details = "\tYou touch a willing creature. Until the spell ends, the target's skin has a rough, bark-like appearance, and the target's AC can't be less than 16, regardless of what kind of armor it's wearing."
        
        let spell28: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell28.id = 28
        spell28.name = "Beacon of Hope"
        spell28.level = 3
        spell28.school = MagicSchool.Abjuration
        spell28.ritual = false
        spell28.range = 30
        spell28.rangeType = RangeType.Target
        spell28.effectRangeType = EffectRangeType.Target
        spell28.componentBlock = (true, true, false)
        spell28.castingTime = "1 action"
        spell28.duration = "Concentration, up to 1 minute"
        spell28.details = "\tThis spell bestows hope and vitality. Choose any number of creatures within range. For the duration, each target has advantage on Wisdom saving throws and death saving throws, and regains the maximum number of hit points possible from any healing."
        
        let spell29: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell29.id = 29
        spell29.name = "Beast Sense"
        spell29.level = 2
        spell29.school = MagicSchool.Divination
        spell29.ritual = true
        spell29.rangeType = RangeType.Touch
        spell29.effectRangeType = EffectRangeType.Target
        spell29.componentBlock = (false, true, false)
        spell29.castingTime = "1 action"
        spell29.duration = "Concentration, up to 1 hour"
        spell29.details = "\tYou touch a willing beast. For the duration of the spell, you can use your action to see through the beast's eyes and hear what it hears, and continue to do so until you use your action to return to your normal senses. When perceiving through the beast's senses, you gain the benefits of any special senses possessed by that creature, though you are blinded and deafened to your own surroundings."
        
        let spell30: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell30.id = 30
        spell30.name = "Bestow Curse"
        spell30.level = 3
        spell30.school = MagicSchool.Necromancy
        spell30.ritual = false
        spell30.rangeType = RangeType.Touch
        spell30.effectRangeType = EffectRangeType.Target
        spell30.componentBlock = (true, true, false)
        spell30.castingTime = "1 action"
        spell30.duration = "Concentration, up to 1 minute"
        spell30.details = "\tYou touch a creature, and that creature must succeed on a Wisdom saving throw or become cursed for the duration of the spell. Choose the nature of the curse from the following options:\n  \u{2022} Choose one ability score. While cursed, the target has disadvantage on ability checks and saving throws made with that ability score.\n  \u{2022} While cursed, the target has disadvantage on attack rolls against you.\n  \u{2022} While cursed, the target must make a Wisdom saving throw at the start of each of its turns. If it fails, it wastes its action that turn doing nothing.\n  \u{2022} While the target is cursed, your attacks and spells deal an extra 1d8 necrotic damage to the target.\n\tA Remove Curse spell ends this effect. At the DM's discretion, you may choose an alternative curse effect, but it should be no more powerful than those described above.\n\tWhen using a higher spell slot: the duration is concentration up to 10 minutes using a 4th-level slot, 8 hours using a 5th-level slot, 24 hours using a 7th-level slot, and until it is dispelled for a 9th-level slot."
        
        let spell31: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell31.id = 31
        spell31.name = "Bigby's Hand"
        spell31.level = 5
        spell31.school = MagicSchool.Evocation
        spell31.ritual = false
        spell31.range = 120
        spell31.rangeType = RangeType.Target
        spell31.effectRangeType = EffectRangeType.Target
        spell31.componentBlock = (true, true, true)
        spell31.material = "An eggshell and a snakeskin glove"
        spell31.castingTime = "1 action"
        spell31.duration = "Concentration, up to 1 minute"
        spell31.details = "\tYou create a Large hand of shimmering, translucent force in an unoccupied space that you can see within range. The hand lasts for the spell's duration, and moves at your command, mimicking the movements of your own hand.\n\tThe hand is an object that has AC 20 and hit points equal to your hit point maximum. If it drops to 0 hit points, the spell ends. It has a Strength of 26 and a Dexterity of 10. The hand doesn't fill its space.\n\tWhen you cast the spell and as a bonus action on your subsequent turns, you can move the hand up to 60 feet and then cause one of the following effects with it:\n  \u{2022} Clenched Fist: The hand strikes one creature or object within 5 ft of it. Make a melee spell attack for the hand using your game statistics. On a hit, the target takes 4d8 force damage.\n  \u{2022} Forceful Hand: The hand attempts to push a creature within 5 ft of it in a direction you choose. Make a check with the hand's Strength contested by an Athletics check of the target. If the target is Medium or smaller, you have advantage. If you succeed, the hand pushes the target up to 5 ft plus a number of feet equal to fice times you spellcasting ability modifier. The hand moves with the target to remain within 5 ft of it.\n  \u{2022} Grasping Hand: The hand attempts to grapple a Huge or smaller creature within 5 ft of it. You use the hand's Strength score to resolve the grapple. If the target is Medium or smaller, you have advantage. While the hand is grappling the target, you can use a bonus action to have the hand crush it. When you do so, the target takes a bludgeoning damage equal to 2d6 plus your spellcasting ability modifier.\n  \u{2022} Interposing Hand: The hand interposes itself between you and a creature you choose until you give the hand a different command. The hand moves to stay between you and the target, providing you with half cover against the target. The target can't move through the hand's space if its Strength score is less than or equal to the hand's Strength score. If it's strength score is higher, it may move through the hand, but it is considered difficult terrain.\n\tWhen using a higher spell slot, the damage from Clenched Fist increases by 2d8 and the damage from Grasping Hand increases by 2d6 for each additional spell level."
        
        let spell32: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell32.id = 32
        spell32.name = "Blade Barrier"
        spell32.level = 6
        spell32.school = MagicSchool.Evocation
        spell32.ritual = false
        spell32.range = 90
        spell32.rangeType = RangeType.Target
        spell32.effectRangeType = EffectRangeType.Target
        spell32.damageDice = (6, 10)
        spell32.componentBlock = (true, true, false)
        spell32.castingTime = "1 action"
        spell32.duration = "Concentration, up to 10 minutes"
        spell32.details = "\tYou create a wall of whirling, razor-sharp blades made of magical energy. The wall appears within range and lasts for the duration. You may make a straight wall that is 100 ft long, 20 ft high, and 5 ft thick, or you may make a ringed wall up to 60 ft in diameter, 20 ft high, and 5 ft thick. The wall provides three-quarters cover to creatures behind it, and its space is difficult terrain.\n\tWhen a creature enters the wall's area for the first time on a turn or starts its turn there, it must make a Dexterity saving throw. On a failed save, the creature takes 6d10 slashing damage, or half as much on a successful save."
        
        let spell33: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell33.id = 33
        spell33.name = "Blade Ward"
        spell33.level = 0
        spell33.school = MagicSchool.Abjuration
        spell33.ritual = false
        spell33.rangeType = RangeType.PSelf
        spell33.effectRangeType = EffectRangeType.Target
        spell33.componentBlock = (true, true, false)
        spell33.castingTime = "1 action"
        spell33.duration = "1 round"
        spell33.details = "\tYou extend your hand a trace a sigil of warding in the air. Until the end of your next turn, you have resistance against bludgeoning, piercing, and slashing damage dealt by weapon attacks."
        
        let spell34: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell34.id = 34
        spell34.name = "Bless"
        spell34.level = 1
        spell34.school = MagicSchool.Enchantment
        spell34.ritual = false
        spell34.range = 30
        spell34.rangeType = RangeType.Target
        spell34.effectRangeType = EffectRangeType.Target
        spell34.componentBlock = (true, true, true)
        spell34.material = "a sprinkling of holy water"
        spell34.castingTime = "1 action"
        spell34.duration = "Concentration, up to 1 minute"
        spell34.details = "\tYou bless up to three creatures of your choice within range. Whenever a target makes an attack roll or a saving throw before the spell ends, the target can roll a d4 and add the number rolled to the attack roll or saving throw.\n\tWhen using a higher spell slot, you can target one additional creature for each additional spell level."
        
        let spell35: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell35.id = 35
        spell35.name = "Blight"
        spell35.level = 4
        spell35.school = MagicSchool.Necromancy
        spell35.ritual = false
        spell35.range = 30
        spell35.rangeType = RangeType.Target
        spell35.effectRangeType = EffectRangeType.Target
        spell35.damageDice = (8, 8)
        spell35.componentBlock = (true, true, false)
        spell35.castingTime = "1 action"
        spell35.duration = "Instantaneous"
        spell35.details = "\tNecromantic energy washes over a creature of your choice that you can see within range. The target makes a Constitution saving throw, taking 8d8 damage on a failed save and half as much on a successful save. This spell has no effect on undead or constructs.\n\tIf you target a plant creature or a magical plant, it makes the saving throw with disadvantage, and takes maximum damage from it.\n\tIf you target a nonmagical plant that is not a creature, it withers and dies.\n\tWhen using a higher spell slot, the damage increases by 1d8 for each additional spell level."
        
        let spell36: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell36.id = 36
        spell36.name = "Blinding Smite"
        spell36.level = 3
        spell36.school = MagicSchool.Evocation
        spell36.ritual = false
        spell36.rangeType = RangeType.PSelf
        spell36.effectRangeType = EffectRangeType.Target
        spell36.damageDice = (3, 8)
        spell36.componentBlock = (true, false, false)
        spell36.castingTime = "1 bonus action"
        spell36.duration = "Concentration, up to 1 minute"
        spell36.details = "\tThe next time you hit a creature with a melee weapon attack before this spell ends, your weapon flares with bright light, and the attack deals an extra 3d8 radiant damage to the target. Additionally, the target must succeed a Constitution saving throw or be blinded until the spell ends.\n\tA creature blinded by this spell makes another Constitution saving throw at the end of each of its turns. On a successful save, it is no longer blinded."
        
        let spell37: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell37.id = 37
        spell37.name = "Blindness/Deafness"
        spell37.level = 2
        spell37.school = MagicSchool.Necromancy
        spell37.ritual = false
        spell37.range = 30
        spell37.rangeType = RangeType.Target
        spell37.effectRangeType = EffectRangeType.Target
        spell37.componentBlock = (true, false, false)
        spell37.castingTime = "1 action"
        spell37.duration = "1 minute"
        spell37.details = "\tYou can blind or deafen a foe. Choose one creature in range to make a Constitution saving throw. If it fails the target is either blinded or deafened (your choice) for the duration. At the end of each of its turns, it may make a Constitution saving throw. On a successful saving throw, the spell ends.\n\tWhen using a higher spell slot, you may target one additional creature for each additional spell level."
        
        let spell38: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell38.id = 38
        spell38.name = "Blink"
        spell38.level = 3
        spell38.school = MagicSchool.Transmutation
        spell38.ritual = false
        spell38.rangeType = RangeType.PSelf
        spell38.effectRangeType = EffectRangeType.Target
        spell38.componentBlock = (true, true, false)
        spell38.castingTime = "1 action"
        spell38.duration = "1 minute"
        spell38.details = "\tRoll a d20 at the end of each of your turns for the duration of the spell. On a roll of 11 or higher, you vanish from your current plane of existence and appear in the Ethereal Plane. At the start of your next turn, and when the spell ends if you are on the Ethereal Plane, you return to an unoccupied space of your choice that you an see within 10 ft of the space you vanished from. If no unoccupied space is available within that range, you appear in the nearest unoccupied space (chosen at random if there are multiple). You can dismiss this spell as an action.\n\tWhile on the Ethereal Plane, you can see and hear the plane you originated from, which is cast in shades of gray, but are unable to see anything more than 60 ft away. You can only affect and be affected by other creatures on the Ethereal Plane, and cannot be perceived by creatures not on the Ethereal Plane."
        
        let spell39: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell39.id = 39
        spell39.name = "Blur"
        spell39.level = 2
        spell39.school = MagicSchool.Illusion
        spell39.ritual = false
        spell39.rangeType = RangeType.PSelf
        spell39.effectRangeType = EffectRangeType.Target
        spell39.componentBlock = (true, false, false)
        spell39.castingTime = "1 action"
        spell39.duration = "Concentration, up to 1 minute"
        spell39.details = "\tYour body becomes blurred, shifting and wavering to all who can see you. For the duration, any creature has disadvantage on attack rolls against you. An attacker is immune to this effect if it doesn't rely on sight, as with blindsight, or can see through illusions, as with truesight."
        
        let spell40: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell40.id = 40
        spell40.name = "Branding Smite"
        spell40.level = 2
        spell40.school = MagicSchool.Evocation
        spell40.ritual = false
        spell40.rangeType = RangeType.PSelf
        spell40.effectRangeType = EffectRangeType.Target
        spell40.damageDice = (2, 6)
        spell40.componentBlock = (true, false, false)
        spell40.castingTime = "1 bonus action"
        spell40.duration = "Concentration, up to 1 minute"
        spell40.details = "\tThe next time you hit a creature with a weapon attack before this spell ends, your weapon gleams with astral radiance as you strike, and the attack deals an extra 2d6 radiant damage to the target. The target will also become visible if it is invisible, and the target sheds dim light in a 5 ft radius and can't become invisible until the spell ends.\n\tWhen using a higher spell slot, the extra damage increases by 1d6 for each additional spell level."
        
        let spell41: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell41.id = 41
        spell41.name = "Burning Hands"
        spell41.level = 1
        spell41.school = MagicSchool.Evocation
        spell41.ritual = false
        spell41.rangeType = RangeType.PSelf
        spell41.effectRange1 = 15
        spell41.effectRangeType = EffectRangeType.Cone
        spell41.damageDice = (3, 6)
        spell41.componentBlock = (true, true, false)
        spell41.castingTime = "1 action"
        spell41.duration = "Instantaneous"
        spell41.details = "\tA thin sheet of flames shoots forth from your fingertips. Each creature in range must make a Dexterity saving throw, taking 3d6 on a failed save or half as much on a successful save.\n\tThe fire ignites flammable objects in the area that aren't being worn or carried.\n\tWhen using a higher spell slot, the damage increases by 1d6 for each additional spell level."
        
        let spell42: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell42.id = 42
        spell42.name = "Call Lightning"
        spell42.level = 3
        spell42.school = MagicSchool.Conjuration
        spell42.ritual = false
        spell42.range = 120
        spell42.rangeType = RangeType.Target
        spell42.effectRange1 = 60
        spell42.effectRange2 = 10
        spell42.effectRangeType = EffectRangeType.Cylinder
        spell42.damageDice = (3, 10)
        spell42.componentBlock = (true, true, false)
        spell42.castingTime = "1 action"
        spell42.duration = "Concentration, up to 10 minutes"
        spell42.details = "\tA storm cloud appears in the shape of a cylinder that is 10 ft tall with a 60 ft radius, centered on a point you can see 100 ft directly above you.\n\tWhen you cast the spell, choose a point you can see within range. A bolt of lightning flashes down to the point. Each creature within 5 ft of the point must make a Dexterity saving throw, taking 3d10 lightning damage on a failed save, or half that on a successful one. On each of your turns until the spell ends, you can use your action to call down lightning in this way again, on the same point or a different one.\n\tIf you are outdoors in stormy conditions when you cast this spell, the spell gives you control over the existing storm. Under such conditions, the spell's damage increases by 1d10.\n\tWhen using a higher spell slot, the damage increases by 1d10 for each additional spell level."
        
        let spell43: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell43.id = 43
        spell43.name = "Calm Emotions"
        spell43.level = 2
        spell43.school = MagicSchool.Enchantment
        spell43.ritual = false
        spell43.range = 60
        spell43.rangeType = RangeType.Target
        spell43.effectRange1 = 20
        spell43.effectRangeType = EffectRangeType.Sphere
        spell43.componentBlock = (true, true, false)
        spell43.castingTime = "1 action"
        spell43.duration = "Instantaneous"
        spell43.details = "\tYou attempt to suppress strong emotions in a group of people. Each humanoid in a 20 ft radius sphere centered on a point you choose within range must make a Charisma saving throw; a creature can choose to fail this saving throw if it wishes. If a creature fails its saving throw, choose one of the following two effects.\n\tYou can suppress any effect causing a target to be charmed or frightened. When this spell ends, any suppressed effect resumes, provided that its duration has not expired in the meantime.\n\tAlternatively, you can make a target indifferent about creatures of your choice that it is hostile toward. This indifference ends if the target is attacked or harmed by a spell or if it witnesses any of its friends being harmed. When the spell ends, the creature becomes hostile again, unless the DM rules otherwise."
        
        let spell44: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell44.id = 44
        spell44.name = "Chain Lightning"
        spell44.level = 6
        spell44.school = MagicSchool.Evocation
        spell44.ritual = false
        spell44.range = 150
        spell44.rangeType = RangeType.Target
        spell44.effectRangeType = EffectRangeType.Target
        spell44.damageDice = (10, 8)
        spell44.componentBlock = (true, true, true)
        spell44.material = "a bit of fur; a piece of amber, glass, or a crystal rod; and three silver pins"
        spell44.castingTime = "1 action"
        spell44.duration = "Instantaneous"
        spell44.details = "\tYou create a bolt of lightning that arcs toward a target of your choice that you can see within range. Three bolts then leap from that target to as many as three other targets, each of which must be within 30 ft of the first target. A target can be a creature or an object and can be targeted by only one of the bolts.\n\tA Target must make a Dexterity saving throw. The target takes 10d8 on a failed save and half that on a successful one.\n\tWhen using a higher spell slot, one additional bolt leaps from the first target to another target for each additional spell level."
        
        let spell45: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell45.id = 45
        spell45.name = "Charm Person"
        spell45.level = 1
        spell45.school = MagicSchool.Enchantment
        spell45.ritual = false
        spell45.range = 30
        spell45.rangeType = RangeType.Target
        spell45.effectRangeType = EffectRangeType.Target
        spell45.componentBlock = (true, true, false)
        spell45.castingTime = "1 action"
        spell45.duration = "1 hour"
        spell45.details = "\tYou attempt to charm a humanoid you can see within range. It must make a Wisdom saving throw, and does so with advantage if you or your companions are fighting it. If it fails the throw, it is charmed by you until the spell ends or until you or your companions do anything harmful to it. The charmed creature regards you as a friendly acquaintance. When the spell ends, the creature knows it was charmed by you.\n\tWhen using a higher spell slot, you can target one additional creature for each additional spell level, providing all creatures are within 30ft of each other."
        
        let spell46: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell46.id = 46
        spell46.name = "Chill Touch"
        spell46.level = 0
        spell46.school = MagicSchool.Necromancy
        spell46.ritual = false
        spell46.range = 120
        spell46.rangeType = RangeType.Target
        spell46.effectRangeType = EffectRangeType.Target
        spell46.damageDice = (1, 8)
        spell46.componentBlock = (true, true, false)
        spell46.castingTime = "1 action"
        spell46.duration = "1 round"
        spell46.details = "\tYou create a ghostly, skeletal hand in the space of a creature within range. Make a ranged spell attack to assail the creature with the chill of the grave. On a hit, the target takes 1d8 necrotic damage, and it can't regain hit points until the start of your next turn. Until then, the hand clings to the target.\n\tIf you hit an undead target, it also has disadvantage on attack rolls against you until the end of your next turn.\n\tThis spell's damage increases to 2d8 at 5th level, 3d8 at 11th level, and 4d8 at 17th level."
        
        let spell47: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell47.id = 47
        spell47.name = "Chromatic Orb"
        spell47.level = 1
        spell47.school = MagicSchool.Evocation
        spell47.ritual = false
        spell47.range = 90
        spell47.rangeType = RangeType.Target
        spell47.effectRangeType = EffectRangeType.Target
        spell47.damageDice = (3, 8)
        spell47.componentBlock = (true, true, true)
        spell47.material = "a diamond worth at least 50gp"
        spell47.castingTime = "1 action"
        spell47.duration = "Instantaneous"
        spell47.details = "\tYou hurl a 4-in diameter sphere of energy at a creature you can see within range. You choose acid, cold, fire, lightning, poison, or thunder for the type of orb you create, and make a ranged spell attack. On a hit, the target takes 3d8 damage of the type you choose.\n\tWhen using a higher spell slot, the damage increases by 1d8 for each additional spell level."
        
        let spell48: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell48.id = 48
        spell48.name = "Circle of Death"
        spell48.level = 6
        spell48.school = MagicSchool.Necromancy
        spell48.ritual = false
        spell48.range = 150
        spell48.rangeType = RangeType.Target
        spell48.effectRange1 = 60
        spell48.effectRangeType = EffectRangeType.Sphere
        spell48.damageDice = (8, 6)
        spell48.componentBlock = (true, true, true)
        spell48.material = "the powder of a crushed black pearl worth at least 500gp"
        spell48.castingTime = "1 action"
        spell48.duration = "Instantaneous"
        spell48.details = "\tA sphere of negative energy ripples out in a 60-ft radius sphere from a point within range. Each creature must make a Constitution saving throw, taking 8d6 necrotic damage on a failed save and half as much on a successful one.\n\tWhen using a higher spell slot, the damage increases by 2d6 for each additional spell level."
        
        let spell49: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell49.id = 49
        spell49.name = "Circle of Power"
        spell49.level = 5
        spell49.school = MagicSchool.Abjuration
        spell49.ritual = false
        spell49.rangeType = RangeType.PSelf
        spell49.effectRange1 = 30
        spell49.effectRangeType = EffectRangeType.Sphere
        spell49.damageDice = (8, 6)
        spell49.componentBlock = (true, false, false)
        spell49.castingTime = "1 action"
        spell49.duration = "Concentration, up to 10 minutes"
        spell49.details = "\tDivine energy radiates from you, distorting and diffusing magical energy within 30 ft of you. Until the spell ends, the sphere moves with you, centered on you. For the duration, each friendly creature in the area (including you) has advantage on saving throws against spells and other magical effects. Additionally, when an affected creature succeeds on a saving throw made against a spell or magical effect that allows it to make a saving throw to take only half samage, it instead takes no damage if it succeeds on the saving throw."
        
        let spell50: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell50.id = 50
        spell50.name = "Clairvoyance"
        spell50.level = 3
        spell50.school = MagicSchool.Divination
        spell50.ritual = false
        spell50.range = 5280
        spell50.rangeType = RangeType.PSelf
        spell50.effectRangeType = EffectRangeType.Target
        spell50.componentBlock = (true, true, true)
        spell50.castingTime = "10 minutes"
        spell50.duration = "Concentration, up to 10 minutes"
        spell50.details = "\tYou create an invisible sensor within range in a location familiar to you or in an obvious location that is unfamiliar to you. The sensor remains in place for the duration, and it can't be attacked or otherwise interacted with.\n\tWhen you cast the spell, you choose seeing or hearing. You can use the chosen sense through the sensor as if you were in its space. As your action, you can switch between seeing and hearing.\n\tA creature that can see the sensor (such as a creature benefiting from See Invisibility or truesight) sees a luminous, intangible orb about the size of your fist."
        
        let spell51: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell51.id = 51
        spell51.name = "Clone"
        spell51.level = 8
        spell51.school = MagicSchool.Necromancy
        spell51.ritual = false
        spell51.rangeType = RangeType.Touch
        spell51.effectRangeType = EffectRangeType.Target
        spell51.componentBlock = (true, true, true)
        spell51.material = "a diamond worth at least 1000gp and at least 1 cubic inch of flesh of the creature that is to be cloned, which the spell consumes, and a vessel worth at least 2000gp that has a sealable lid and is large enough to hold a Medium creature, such as a huge urn, coffin, mud-filled cyst in the ground, or crystal container filled with salt water"
        spell51.castingTime = "1 hour"
        spell51.duration = "Instantaneous"
        spell51.details = "\tThis spell grows an inert duplicate of a living creature as a safeguard against death. This clone forms inside a sealed vessel and grows to ful size and maturity after 120 days; you can also choose to have the clone be a younger version of the same creature. It remains inert and endures indefinitely, as long as its vessel remains undisturbed.\n\tAt any time after the clone matures, if the original creature dies, its soul transfers to the clone, provided that the soul is free and willing to return. The clone is physically identical to the original and has the same personality, memories, and abilities, but none of the original's equipment. The original creature's physical remains, if they still exist, become inert and can't thereafter be restored to life, since the creature's soul is elsewhere."
        
        let spell52: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell52.id = 52
        spell52.name = "Cloud of Daggers"
        spell52.level = 2
        spell52.school = MagicSchool.Conjuration
        spell52.ritual = false
        spell52.range = 60
        spell52.rangeType = RangeType.Touch
        spell52.effectRange1 = 5
        spell52.effectRangeType = EffectRangeType.Cube
        spell52.damageDice = (4, 4)
        spell52.componentBlock = (true, true, true)
        spell52.material = "a sliver of glass"
        spell52.castingTime = "1 action"
        spell52.duration = "Concentration, up to 1 minute"
        spell52.details = "\tYou fill the air with spinning daggers in a cube 5 ft on each side, centered on a point you choose within range. A creature takes 4d4 slashing damage when it enters the spell's area for the first time on a turn or starts its turn there.\n\tWhen using a higher spell slot, the damage increases by 2d4 for each additional spell level."
        
        let spell53: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell53.id = 53
        spell53.name = "Cloudkill"
        spell53.level = 5
        spell53.school = MagicSchool.Conjuration
        spell53.ritual = false
        spell53.range = 120
        spell53.rangeType = RangeType.Touch
        spell53.effectRange1 = 20
        spell53.effectRangeType = EffectRangeType.Sphere
        spell53.damageDice = (5, 8)
        spell53.componentBlock = (true, true, false)
        spell53.castingTime = "1 action"
        spell53.duration = "Concentration, up to 10 minutes"
        spell53.details = "\tYou create a 20-ft radius sphere of poisonous, yellow-green fog centered on a point you choose within range, which spreads around corners and lasts for the duration of the spell or until strong wind disperses the fog. Its area is heavily obscured.\n\tWhen a creature enters the spell's area for the first time on a turn or starts its turn there, the creature must make a Constitution saving throw, taking 5d8 poison damage on a failed save or half as much on a successful one. Creatures are affected regardless of whether they are breathing in the fog.\n\tThe fog moves 10 ft away from you at the start of each of your turns, rolling along the surface of the ground. The vapors, being heavier than air, sink to the lowest level of the land, even pouring down openings.\n\tWhen using a higher-level spell slot, the damage increases by 1d8 for each additional spell level."
        
        let spell54: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell54.id = 54
        spell54.name = "Color Spray"
        spell54.level = 1
        spell54.school = MagicSchool.Illusion
        spell54.ritual = false
        spell54.rangeType = RangeType.PSelf
        spell54.effectRange1 = 15
        spell54.effectRangeType = EffectRangeType.Cone
        spell54.componentBlock = (true, true, true)
        spell54.material = "a pinch of powder or sand that is colored red, yellow, and blue"
        spell54.castingTime = "1 action"
        spell54.duration = "1 round"
        spell54.details = "\tA dazzling array of flashing, colored light springs from your hand. Roll 6d10; the total is how many hit points of creatures this spell can affect. Creatures in a 15-ft cone originating from you are affected in ascending order of their current hit points (ignoring unconscious creatures and ones that cannot see).\n\tStarting with the lowest-hit-point creature, each creature is blinded until the spell ends, subtracting each creature's hit points from the total rolled before moving on to the next creature. A creature's hit points must be equal to or less than the remaining total to be affected.\n\tWhen using a higher-level spell slot, the roll increases by 2d10 for each additional spell level."
        
        let spell55: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell55.id = 55
        spell55.name = "Command"
        spell55.level = 1
        spell55.school = MagicSchool.Enchantment
        spell55.ritual = false
        spell55.range = 60
        spell55.rangeType = RangeType.Target
        spell55.effectRangeType = EffectRangeType.Target
        spell55.componentBlock = (true, false, false)
        spell55.castingTime = "1 action"
        spell55.duration = "1 round"
        spell55.details = "\tYou speak a one-word command to a creature you can see within range. The target must succeed on a Wisdom saving throw or follow the command on its next turn. This spell has no effect if the target is undead, if it doesn't understand your language, or if your command is directly harmful to it.\n\tHere are some typical commands and their effects. You may issue a different command if you wish; discuss the effects with your DM.\n  \u{2022} Approach: The target moved towards you by the shortest and most direct route, ending its turn if it moves within 5 ft of you.\n  \u{2022} Drop: The target drops whatever it is holding and then ends its turn.\n  \u{2022} Flee: The target spends its turn moving away from you by the fastest available means.\n  \u{2022} Grovel: The target falls prone and then ends its turn.\n  \u{2022} Halt: The target doesn't move and takes no actions. A flying creature stays aloft, provided that it is able to do so. If it must move to stay aloft, it flies the minimum distance needed to remain in the air.\n\tWhen using a higher spell slot, you can target one additional creature for each additional spell level, providing all creatures are within 30ft of each other."
        
        SpellList.spellListInit(context)
        
        do{
            try context.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }//spellsInit
    
}//Spell

/*
Sample Spell Values

id: 1
name: Lightning Bolt
details:
A stroke of lightning blasts out from a direction you choose. Each creature in its area must make a Dexterity saving throw, taking half damage if they succeed.
The lightning ignites flammable objects that aren't being worn or carried.
level: 3
school: Evocation
ritual: false
range:0             //all self/touch is 0 range
rangeType: PSelf    //casts on self (where lightning begins)
effectRange1: 100   //ft
effectRange2: 5     //ft
effectRangeType: Line
damageDieNum: 8
damageDieType: 6    //d6
verbalComponent: true
somaticComponent: true
materialComponent: true
material: a bit of fur and a rod of amber, crystal, or glass
castingTime: 1 action
duration: Instantaneous

id: 2
name: Fire Bolt
details:
You hurl a mote of fire at a creature or object. Make a ranged spell attack. On hit, the target takes fire damage. A flammable object hit by this spell ignites if not being worn or carried.
level: 0            //cantrip
school: Evocation
ritual: false
range: 120          //ft
rangeType: Target
effectRange1: 0     //all target effect ranges are 0
effectRange2: 0     //all target effect ranges are 0
effectRangeType: Target
damageDieNum: 1
damageDieType: 10   //d10
verbalComponent: true
somaticComponent: true
materialComponent: false
material: nil
castingTime: 1 action
duration: Instantaneous
*/