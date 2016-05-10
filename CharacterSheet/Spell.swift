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
    Returns a string representing the "V, S, M" block as needed, with the material involved
    Implemented in a succinct but virtually unreadable way, involving 5 ternary operators in a line.
    */
    func componentString()->String{
        return "\(verbalComponent ? "V" : "")\(verbalComponent && somaticComponent ? ", " : "")\(somaticComponent ? "S" : "")\(materialComponent && (verbalComponent || somaticComponent) ? ", " : "")\(materialComponent ? "M (\(material!))" : "")"
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
        spell1.details = "\tYou hurl a bubble of acid. Does 1d6 damage to either one creature in range, or two creatues in range within 5 feet of each other. Target must make a Dexterity saving throw, or else takes acid damage.\n\tDamage increases by 1d6 at 5th level, 11th level, and 17th level."
        
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
        spell8.details = "\tThis spell creates an undead servant. Choose a corpse or pile of bones of a Medium or Small humanoid within range. Your spell transforms this creature into a skeleton if starting with bones, or a zombie if starting with a corpse.\n\tOn each of your turns, you can use a bonus action to mentally command any creature you made with this spell if the creature is within 60 feet of you. If you control multiple creatures this way, you may issue commands to each of them. You may specify the creature's next action and movement, or issue a general command, such as to guard a particular chamber. Without a command, the creature only defends itself against hostile creatures.\n\tThe creature is under your control for 24 hours, at which point it stops obeying any command you have given it. You may use this spell again to re-assert control of up to four creatures for the next 24 hours.\n\tWhen using a higher spell slot, you animate or reassert control over two additional undead creatures per spell level. Each creature must come from a different set of remains."
        
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
        spell9.details = "\tObjects come to life at your command. Choose up to ten nonmagical objects within range that are not being worn or carried. Medium targets count for 2, Large objects count for 4, Huge targets count for 8, and you may not animate anything larger than Huge. Each target animates and becomes a creature under your control until the spell ends or it is reduced to 0hp.\n\tAs a bonus action, you can mentally command any creature you made this way within 500 feet of you. If you control multiple objects this way, you may issue commands to each of them. You may specify the object's next action and movement, or issue a general command, such as to guard a particular chamber. Without a command, the object only defends itself against hostile creatures.\n\tAn animated object is a construct with AC, hit points, attacks, Strength, and Dexterity determined by its size. Its Constitution is 10, its Intelligence and Wisdom are 3, and its Charisma is 1. It's speed is 30 feet, and if it has no legs or other means of locomotion, it has a flying speed of 30 feet and can hover. If it is securely attached to something, its speed is 0 feet. It has blindsight with a radius of 30 feet and is blind beyond that distance. When it drops to 0hp, it reverts to its non-animated form, and any excess damage is transferred to its original form.\n\tOn telling the object to attack, it can make a single melee attack against a creature within 5 feet, making a slam attack with an attack bonus and bludgeoning damage determined by its size.\n\tWhen using a higher spell slot, you can animate two additional objects per spell level."//TODO: add table of object stats
        
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
        spell12.details = "\tThis spell attracts or repels creatures of your choice. You target something within range, either a Huge or smaller object or a creature or an area no larger than a 200-foot cube. Then specify a kind of intelligent creature, such as red dragons, goblins, or vampires. You invest the target with an aura that attracts or repels the creatures for the duration. Choose antipathy or sympathy as the aura's effect.\n  \u{2022} Antipathy: The enchantment causes creatures of the kind you designated to feel an urge to leave the area and avoid the target. When such a creature can see the target or comes within 60 feet of it, the creature must either succeed on a Wisdom saving throw, or become frightened while the creature is in range.\n  \u{2022} Sympathy: The enchantment causes creatures of the kind you designated to feel an urge to approach the target while within 60 feet of it or able to see it. When such a creature can see the target or comes within 60 feet of it, the creature must either succeed on a Wisdom saving throw, or use its movement on each of its turns to enter the area or move within reach of the target.\n\tIf the target damages or otherwise harms an affected creature, the affected creature can make a Wisdom saving throw to end the effect.\n  \u{2022} Ending the Effect: if an affected creature ends its turn while not within 60 feet of the target or able to see it, the creature makes a Wisdom saving throw. On a successful save, the creature is no longer affected by the target and recognizes the prior feelings as magical. In addition, a creature affected by the spell is allowed another Wisdom saving throw every 24 hours while the spell persists./nA creature that makes a successful saving throw is immune to this spell's effects for 1 minute."
        
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
        spell13.details = "\tYou create an invisible, magical eye within range that hovers in the air for the duration.\n\tYou mentally receive visual information from the eye, which has normal vision and dark vision out to 30 feet. The eye can look in every direction.\n\tAs an action, you can move the eye up to 30 feet in any direction. There is no limit to how far away from you it can move, but it cannot enter another plane of existence or pass through solid barriers. The eye can pass through an opening as small as 1 inch in diameter."
        
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
        spell14.details = "\tYou create linked teleportation portals that remain open for the duration. Choose two points on the ground that you can see, one within 10 feet of you and one within 500 feet of you. A circular portal opens over each point, though fails to do so if it is in the space occupied by a creature.\n\tThe portals are two-dimensional glowing rings filled with mist, hovering over the ground and perpendicular to it at the points you choose, and visible only from one side.\n\tAny creature entering the portal on one end exits the other end as if they were adjacent. The mist that fills each portal blocks vision through it. On your turn, you may rotate the rings as a bonus action so that the active side faces in a different direction."
        
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
        spell15.details = "\tYou touch a closed door, window, gate, chest, or other entryway, and it becomes locked for the duration. You and any creatures you designate upon casting may open the object normally. You may also set a password that suppresses the spell for one minute when spoken within 5 feet of the object. The object is otherwise impassable until it is borken or the spell is dispelled or suppressed. Casting \"knock\" on the object suppresses the spell for 10 minutes.\n\tWhuke affected by this spell, the object is more difficult to break or force open; the DC to break it or pick any locks on it increases by 10."
        
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
        spell20.details = "\tLife-preserving energy radiates from you in an aura with a 30-foot radius. Until the spell ends, the aura moves with you. Each nonhostile creature in the aura (including yourself) has resistance to necrotic damage, and its hit point maximum can't be reduced. In addition, a nonhostile, living creature regains 1 hit point when it starts its turn in the aura with 0 hit points."
        
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
        spell21.details = "\tPurifying energy radiates from you in an aura with a 30-foot radius. Until the spell ends, the aura moves with you. Each nonhostile creature in the aura (including yourself) has resistance to poison damage, can't become diseased, and has advantage on savings throws against effects that cause any of the following conditions: blinded, charmed, deafened, frightened, paralyzed, poisoned, and stunned."
        
        let spell22: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell22.id = 22
        spell22.name = "Aura of Vitality"
        spell22.level = 3
        spell22.school = MagicSchool.Evocation
        spell22.ritual = false
        spell22.rangeType = RangeType.PSelf
        spell22.effectRange1 = 30
        spell22.effectRangeType = EffectRangeType.Sphere
        spell22.damageDice = (2, 6)
        spell22.componentBlock = (true, false, false)
        spell22.castingTime = "1 action"
        spell22.duration = "Concentration, up to 10 minutes"
        spell22.details = "\tHealing energy radiates from you in an aura with a 30-foot radius. Until the spell ends, the aura moves with you. You can use a bonus action to cause one creature in the aura (including yourself) to regain 2d6 hit points."
        
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
        spell31.details = "\tYou create a Large hand of shimmering, translucent force in an unoccupied space that you can see within range. The hand lasts for the spell's duration, and moves at your command, mimicking the movements of your own hand.\n\tThe hand is an object that has AC 20 and hit points equal to your hit point maximum. If it drops to 0 hit points, the spell ends. It has a Strength of 26 and a Dexterity of 10. The hand doesn't fill its space.\n\tWhen you cast the spell and as a bonus action on your subsequent turns, you can move the hand up to 60 feet and then cause one of the following effects with it:\n  \u{2022} Clenched Fist: The hand strikes one creature or object within 5 feet of it. Make a melee spell attack for the hand using your game statistics. On a hit, the target takes 4d8 force damage.\n  \u{2022} Forceful Hand: The hand attempts to push a creature within 5 feet of it in a direction you choose. Make a check with the hand's Strength contested by an Athletics check of the target. If the target is Medium or smaller, you have advantage. If you succeed, the hand pushes the target up to 5 feet plus a number of feet equal to fice times you spellcasting ability modifier. The hand moves with the target to remain within 5 feet of it.\n  \u{2022} Grasping Hand: The hand attempts to grapple a Huge or smaller creature within 5 feet of it. You use the hand's Strength score to resolve the grapple. If the target is Medium or smaller, you have advantage. While the hand is grappling the target, you can use a bonus action to have the hand crush it. When you do so, the target takes a bludgeoning damage equal to 2d6 plus your spellcasting ability modifier.\n  \u{2022} Interposing Hand: The hand interposes itself between you and a creature you choose until you give the hand a different command. The hand moves to stay between you and the target, providing you with half cover against the target. The target can't move through the hand's space if its Strength score is less than or equal to the hand's Strength score. If it's strength score is higher, it may move through the hand, but it is considered difficult terrain.\n\tWhen using a higher spell slot, the damage from Clenched Fist increases by 2d8 and the damage from Grasping Hand increases by 2d6 for each additional spell level."
        
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
        spell32.details = "\tYou create a wall of whirling, razor-sharp blades made of magical energy. The wall appears within range and lasts for the duration. You may make a straight wall that is 100 feet long, 20 feet high, and 5 feet thick, or you may make a ringed wall up to 60 feet in diameter, 20 feet high, and 5 feet thick. The wall provides three-quarters cover to creatures behind it, and its space is difficult terrain.\n\tWhen a creature enters the wall's area for the first time on a turn or starts its turn there, it must make a Dexterity saving throw. On a failed save, the creature takes 6d10 slashing damage, or half as much on a successful save."
        
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
        spell38.details = "\tRoll a d20 at the end of each of your turns for the duration of the spell. On a roll of 11 or higher, you vanish from your current plane of existence and appear in the Ethereal Plane. At the start of your next turn, and when the spell ends if you are on the Ethereal Plane, you return to an unoccupied space of your choice that you an see within 10 feet of the space you vanished from. If no unoccupied space is available within that range, you appear in the nearest unoccupied space (chosen at random if there are multiple). You can dismiss this spell as an action.\n\tWhile on the Ethereal Plane, you can see and hear the plane you originated from, which is cast in shades of gray, but are unable to see anything more than 60 feet away. You can only affect and be affected by other creatures on the Ethereal Plane, and cannot be perceived by creatures not on the Ethereal Plane."
        
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
        spell40.details = "\tThe next time you hit a creature with a weapon attack before this spell ends, your weapon gleams with astral radiance as you strike, and the attack deals an extra 2d6 radiant damage to the target. The target will also become visible if it is invisible, and the target sheds dim light in a 5 foot radius and can't become invisible until the spell ends.\n\tWhen using a higher spell slot, the extra damage increases by 1d6 for each additional spell level."
        
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
        spell42.details = "\tA storm cloud appears in the shape of a cylinder that is 10 feet tall with a 60 foot radius, centered on a point you can see 100 feet directly above you.\n\tWhen you cast the spell, choose a point you can see within range. A bolt of lightning flashes down to the point. Each creature within 5 feet of the point must make a Dexterity saving throw, taking 3d10 lightning damage on a failed save, or half that on a successful one. On each of your turns until the spell ends, you can use your action to call down lightning in this way again, on the same point or a different one.\n\tIf you are outdoors in stormy conditions when you cast this spell, the spell gives you control over the existing storm. Under such conditions, the spell's damage increases by 1d10.\n\tWhen using a higher spell slot, the damage increases by 1d10 for each additional spell level."
        
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
        spell43.details = "\tYou attempt to suppress strong emotions in a group of people. Each humanoid in a 20 foot radius sphere centered on a point you choose within range must make a Charisma saving throw; a creature can choose to fail this saving throw if it wishes. If a creature fails its saving throw, choose one of the following two effects.\n\tYou can suppress any effect causing a target to be charmed or frightened. When this spell ends, any suppressed effect resumes, provided that its duration has not expired in the meantime.\n\tAlternatively, you can make a target indifferent about creatures of your choice that it is hostile toward. This indifference ends if the target is attacked or harmed by a spell or if it witnesses any of its friends being harmed. When the spell ends, the creature becomes hostile again, unless the DM rules otherwise."
        
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
        spell44.details = "\tYou create a bolt of lightning that arcs toward a target of your choice that you can see within range. Three bolts then leap from that target to as many as three other targets, each of which must be within 30 feet of the first target. A target can be a creature or an object and can be targeted by only one of the bolts.\n\tA Target must make a Dexterity saving throw. The target takes 10d8 on a failed save and half that on a successful one.\n\tWhen using a higher spell slot, one additional bolt leaps from the first target to another target for each additional spell level."
        
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
        spell45.details = "\tYou attempt to charm a humanoid you can see within range. It must make a Wisdom saving throw, and does so with advantage if you or your companions are fighting it. If it fails the throw, it is charmed by you until the spell ends or until you or your companions do anything harmful to it. The charmed creature regards you as a friendly acquaintance. When the spell ends, the creature knows it was charmed by you.\n\tWhen using a higher spell slot, you can target one additional creature for each additional spell level, providing all creatures are within 30 feet of each other."
        
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
        spell48.details = "\tA sphere of negative energy ripples out in a 60-foot radius sphere from a point within range. Each creature must make a Constitution saving throw, taking 8d6 necrotic damage on a failed save and half as much on a successful one.\n\tWhen using a higher spell slot, the damage increases by 2d6 for each additional spell level."
        
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
        spell49.details = "\tDivine energy radiates from you, distorting and diffusing magical energy within 30 feet of you. Until the spell ends, the sphere moves with you, centered on you. For the duration, each friendly creature in the area (including you) has advantage on saving throws against spells and other magical effects. Additionally, when an affected creature succeeds on a saving throw made against a spell or magical effect that allows it to make a saving throw to take only half samage, it instead takes no damage if it succeeds on the saving throw."
        
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
        spell52.details = "\tYou fill the air with spinning daggers in a cube 5 feet on each side, centered on a point you choose within range. A creature takes 4d4 slashing damage when it enters the spell's area for the first time on a turn or starts its turn there.\n\tWhen using a higher spell slot, the damage increases by 2d4 for each additional spell level."
        
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
        spell53.details = "\tYou create a 20-foot radius sphere of poisonous, yellow-green fog centered on a point you choose within range, which spreads around corners and lasts for the duration of the spell or until strong wind disperses the fog. Its area is heavily obscured.\n\tWhen a creature enters the spell's area for the first time on a turn or starts its turn there, the creature must make a Constitution saving throw, taking 5d8 poison damage on a failed save or half as much on a successful one. Creatures are affected regardless of whether they are breathing in the fog.\n\tThe fog moves 10 feet away from you at the start of each of your turns, rolling along the surface of the ground. The vapors, being heavier than air, sink to the lowest level of the land, even pouring down openings.\n\tWhen using a higher-level spell slot, the damage increases by 1d8 for each additional spell level."
        
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
        spell54.details = "\tA dazzling array of flashing, colored light springs from your hand. Roll 6d10; the total is how many hit points of creatures this spell can affect. Creatures in a 15-foot cone originating from you are affected in ascending order of their current hit points (ignoring unconscious creatures and ones that cannot see).\n\tStarting with the lowest-hit-point creature, each creature is blinded until the spell ends, subtracting each creature's hit points from the total rolled before moving on to the next creature. A creature's hit points must be equal to or less than the remaining total to be affected.\n\tWhen using a higher-level spell slot, the roll increases by 2d10 for each additional spell level."
        
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
        spell55.details = "\tYou speak a one-word command to a creature you can see within range. The target must succeed on a Wisdom saving throw or follow the command on its next turn. This spell has no effect if the target is undead, if it doesn't understand your language, or if your command is directly harmful to it.\n\tHere are some typical commands and their effects. You may issue a different command if you wish; discuss the effects with your DM.\n  \u{2022} Approach: The target moved towards you by the shortest and most direct route, ending its turn if it moves within 5 feet of you.\n  \u{2022} Drop: The target drops whatever it is holding and then ends its turn.\n  \u{2022} Flee: The target spends its turn moving away from you by the fastest available means.\n  \u{2022} Grovel: The target falls prone and then ends its turn.\n  \u{2022} Halt: The target doesn't move and takes no actions. A flying creature stays aloft, provided that it is able to do so. If it must move to stay aloft, it flies the minimum distance needed to remain in the air.\n\tWhen using a higher spell slot, you can target one additional creature for each additional spell level, providing all creatures are within 30 feet of each other."
        
        let spell56: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell56.id = 56
        spell56.name = "Commune"
        spell56.level = 5
        spell56.school = MagicSchool.Divination
        spell56.ritual = true
        spell56.rangeType = RangeType.PSelf
        spell56.effectRangeType = EffectRangeType.Target
        spell56.componentBlock = (true, true, true)
        spell56.material = "incense and a vial of holy or unholy water"
        spell56.castingTime = "1 minute"
        spell56.duration = "1 minute"
        spell56.details = "\tYou contact your deity or a divine proxy and ask up to three questions that can be answered with a yes or no. You must ask your questions before the spell ends. You receive a correct answer for each question.\n\tDivine beings aren't necessarily omniscient, so you may receive \"unclear\" as an answer if a question pertains to information that lies beyond the deity's knowledge. In a case where a one-word answer could be misleading or contrary to the deity's interests, the DM might offer a short phrase as an answer instead.\n\tIf you cast the spell two or more times before finishing your next long rest, there is a cumulative 25 percent chance for each casting after the first that you get no answer. The DM makes this roll in secret."
        
        let spell57: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell57.id = 57
        spell57.name = "Commune with Nature"
        spell57.level = 5
        spell57.school = MagicSchool.Divination
        spell57.ritual = true
        spell57.rangeType = RangeType.PSelf
        spell57.effectRangeType = EffectRangeType.Target
        spell57.componentBlock = (true, true, false)
        spell57.castingTime = "1 minute"
        spell57.duration = "Instantaneous"
        spell57.details = "\tYou briefly become one with nature and gain knowledge of the surrounding territory. In the outdoors, the spell gives you knowledge of the land within 3 miles of you. In caves and other natural underground settings, the radius is limited to 300 feet. The spell doesn't function where nature has been replaced by construction, such as in dungeons and towns.\n\tYou instantly gain knowledge of up to three facts of your choices about any of the following subjects as they relate to the area:\n  \u{2022} terrain and bodies of water\n  \u{2022} prevalent plants, minerals, animals, or peoples\n  \u{2022} powerful celestials, fey, fiends, elementals, or undead\n  \u{2022} influence from other planes of existence\n  \u{2022} buildings\n\tFor example, you could determine the location of powerful undead in the area, the location of major sources of safe drinking water, and the location of any nearby towns."
        
        let spell58: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell58.id = 58
        spell58.name = "Compelled Duel"
        spell58.level = 1
        spell58.school = MagicSchool.Enchantment
        spell58.ritual = false
        spell58.range = 30
        spell58.rangeType = RangeType.Target
        spell58.effectRangeType = EffectRangeType.Target
        spell58.componentBlock = (true, false, false)
        spell58.castingTime = "1 bonus action"
        spell58.duration = "Concentration, up to 1 minute"
        spell58.details = "\tYou attempt to compel a creature into a duel. One creature that you can see within range must make a Wisdom saving throw. On a failed save, the creature is drawn to you, compelled by your divine demand. For the duration, it has disadvantage on attack rolls against creatures other than you, and must make a Wisdom saving throw each time it attempts to move to a space that is more than 30 feet away from you; if it succeeds on this saving throw, this spell doesn't restrict the target's movement for that turn.\n\tThe spell ends if you attack any other creature, if you cast a spell that targets a hostile creature other than the target, if a creature friendly to you damages the target or casts a harmful spell on it, or if you end your turn more than 30 feet away from the target."
        
        let spell59: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell59.id = 59
        spell59.name = "Comprehend Languages"
        spell59.level = 1
        spell59.school = MagicSchool.Divination
        spell59.ritual = true
        spell59.rangeType = RangeType.PSelf
        spell59.effectRangeType = EffectRangeType.Target
        spell59.componentBlock = (true, true, true)
        spell59.material = "a pinch of soot and salt"
        spell59.castingTime = "1 action"
        spell59.duration = "1 hour"
        spell59.details = "\tFor the duration, you understand the literal meaning of any spoken language that you hear. You also understand any written language that you see, but you must also be touching the surface on which the words are written. It takes about 1 minute to read one page of text.\n\tThis spell doesn't decode secret messages in a text or a glyph, such as an arcane sigil, that isn't part of a written language."
        
        let spell60: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell60.id = 60
        spell60.name = "Compulsion"
        spell60.level = 4
        spell60.school = MagicSchool.Enchantment
        spell60.ritual = false
        spell60.range = 30
        spell60.rangeType = RangeType.Target
        spell60.effectRangeType = EffectRangeType.Target
        spell60.componentBlock = (true, true, false)
        spell60.castingTime = "1 action"
        spell60.duration = "Concentration, up to 1 minute"
        spell60.details = "\tCreatures of your choice that you can see within range and that can hear you must make a Wisdom saving throw. A target automatically succeeds on this saving throw if it can't be charmed. On a failed save, a target is affected by this spell. Until the spell ends, you can use a bonus action on each of your turns to designate a direction that is horizontal to you. Each affected target must use as much of its movement as possible to move in that direction on its next turn. It can take its action before it moves. After moving in this way, it can make another Wisdom saving throw to try to end the effect.\n\tA target isn't compelled to move into an obviously deadly hazard, such as a fire or pit, but it will provoke opportunity attacks to move in the designated direction."
        
        let spell61: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell61.id = 61
        spell61.name = "Cone of Cold"
        spell61.level = 5
        spell61.school = MagicSchool.Evocation
        spell61.ritual = false
        spell61.rangeType = RangeType.PSelf
        spell61.effectRange1 = 60
        spell61.effectRangeType = EffectRangeType.Cone
        spell61.damageDice = (8, 8)
        spell61.componentBlock = (true, true, true)
        spell61.material = "A small crystal or glass cone"
        spell61.castingTime = "1 action"
        spell61.duration = "Instantaneous"
        spell61.details = "\tA blast of cold air erupts from your hands. Each creature in a 60-foot cone must make a Constitution saving throw. A creature takes 8d8 cold damage on a failed save, or half as much damage on a successful one.\n\tA creature killed by this spell becomes a frozen statue until it thaws.\n\tWhen using a higher spell slot, the damage increases by 1d8 for each additional spell level."
        
        let spell62: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell62.id = 62
        spell62.name = "Confusion"
        spell62.level = 4
        spell62.school = MagicSchool.Enchantment
        spell62.ritual = false
        spell62.range = 90
        spell62.rangeType = RangeType.Target
        spell62.effectRange1 = 10
        spell62.effectRangeType = EffectRangeType.Sphere
        spell62.componentBlock = (true, true, true)
        spell62.material = "three nut shells"
        spell62.castingTime = "1 action"
        spell62.duration = "Concentration, up to 1 minute"
        spell62.details = "\tEach creature in a 10-foott radius sphere centered on a point you choose must succeed on a Wisdom saving throw, or else be affected. Each affected target can't take reactions and must roll a d10 at the start of each of its turns to determine its behavior for that turn, the rolls leading to behavior as follows:\n  \u{2022} 1: The creature uses all its movement to move in a random direction. To determine the direction roll a d8 and assign a direction to each die face. The creature does not take an action this turn.\n  \u{2022} 2-6: The creature doesn't move or take actions this turn.\n  \u{2022} 7-8: The creature uses its action to make a melee attack against a randomly determined creature within its reach. If there is no creature within its reach, the creature does nothing this turn.\n  \u{2022} 9-10: The creature can act and move normally.\n\tAt the end of each of its turns, an affected target can make a Wisdom saving throw. If it succeeds, this effect ends for that target.\n\tWhen using a higher-level spell slot, the radius of the sphere increases by 5 feet for each additional spell level."
        
        let spell63: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell63.id = 63
        spell63.name = "Conjure Animals"
        spell63.level = 3
        spell63.school = MagicSchool.Conjuration
        spell63.ritual = false
        spell63.range = 60
        spell63.rangeType = RangeType.Target
        spell63.effectRangeType = EffectRangeType.Target
        spell63.componentBlock = (true, true, false)
        spell63.castingTime = "1 action"
        spell63.duration = "Concentration, up to 1 hour"
        spell63.details = "\tYou summon fey spirits that take the form of beasts and appear in unoccupied spaces that you can see within range. Choose one of the following options for what appears:\n  \u{2022} One beast of challenge rating 2 or lower\n  \u{2022} Two beasts of challenge rating 1 or lower\n  \u{2022} Four beasts of challenge rating 1/2 or lower\n  \u{2022} Eight beasts of challenge rating 1/4 or lower\n\tEach beast is also considered fey, and it disappears when it drops to 0hp or when the spell ends.\n\tThe summoned creatures are friendly to you and your companions. Roll initiative for them as a group, which has its own turns. They obey any verbal commands that you issue to them (which does not require an action from you). If you don't issue any commands to them, they defend themselves from hostile creatures, but otherwise take no actions.\n\tThe DM has the creatures' statistics.\n\tWhen using a higher-level spell slot: for each two additional spell levels, you summon another whole set of creatures."
        
        let spell64: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell64.id = 64
        spell64.name = "Conjure Barrage"
        spell64.level = 3
        spell64.school = MagicSchool.Conjuration
        spell64.ritual = false
        spell64.rangeType = RangeType.PSelf
        spell64.effectRange1 = 60
        spell64.effectRangeType = EffectRangeType.Cone
        spell64.damageDice = (3, 8)
        spell64.componentBlock = (true, true, true)
        spell64.material = "one piece of ammunition or a thrown weapon"
        spell64.castingTime = "1 action"
        spell64.duration = "Instantaneous"
        spell64.details = "\tYou throw a nonmagical weapon or fire a piece of nonmagical ammunition into the air to create a cone of identical weapons that shoot forward and then disappear. Each creature in a 60-foot cone must succeed on a Dexterity saving throw, taking 3d8 damage on a failed save or half as much on a successful one. The damage type is the same as that of the weapon or ammunition used as a component."
        
        let spell65: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell65.id = 65
        spell65.name = "Conjure Celestial"
        spell65.level = 7
        spell65.school = MagicSchool.Conjuration
        spell65.ritual = false
        spell65.range = 90
        spell65.rangeType = RangeType.Target
        spell65.effectRangeType = EffectRangeType.Target
        spell65.componentBlock = (true, true, false)
        spell65.castingTime = "1 minute"
        spell65.duration = "Concentration, up to 1 hour"
        spell65.details = "\tYou summon a celestial of challenge rating 4 or lower, which appears in an unoccupied space that you can see within range. The celestial disappears when it drops to 0hp or when the spell ends.\n\tThe celestial is friendly to you and your companions for the duration. Roll initiative for the celestial, which has its own turns. It obeys any verbal commands that you issue to it (no action required by you), as long as they don't violate its alignment. If you don't issue any commands to the celestial, it defends itself from hostile creatures but otherwise takes no actions.\n\tThe DM has the celestial's statistics.\n\tWhen using a higher-level spell slot: the challenge rating increases by 1 for each two additional spell levels."
        
        let spell66: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell66.id = 66
        spell66.name = "Conjure Elemental"
        spell66.level = 5
        spell66.school = MagicSchool.Conjuration
        spell66.ritual = false
        spell66.range = 90
        spell66.rangeType = RangeType.Target
        spell66.effectRangeType = EffectRangeType.Target
        spell66.componentBlock = (true, true, true)
        spell66.material = "burning incense for air, soft clay for earth, sulfur and phosphorous for fire, or water and sand for water"
        spell66.castingTime = "1 minute"
        spell66.duration = "Concentration, up to 1 hour"
        spell66.details = "\tYou call forth an elemental servant. Choose an area of air, earth, fire, or water that fills a 10-foot cube within range. An elemental of challenge level 5 or lower appropriate to the area you chose appears in an occupied space within 10 feet of it. For example, a fire elemental emerges from a bonfire, and an earth elemental rises up from the ground. The elemental disappears when it drops to 0hp or when the spell ends.\n\tThe elemental is friendly to you and your companions for the duration. Roll initiative for the elemental, which has its own turns. It obeys any verbal commands you issue to it (no action required by you). If you don't issue any commands to the elemental, it defends itself from hostile creatures but otherwise takes no actions.\n\tIf your concentration is broken, the elemental doesn't disappear. Instead, you lose control of the elemental, it becomes hostile toward you and your companions, and it might attack. An uncontrolled elemental can't be dismissed by you, and it disappears 1 hour after you summon it.\n\tThe DM has the elemental's statistics.\n\tWhen using a higher-level spell slot: the challenge rating increases by 1 for each additional spell level."
        
        let spell67: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell67.id = 67
        spell67.name = "Conjure Fey"
        spell67.level = 6
        spell67.school = MagicSchool.Conjuration
        spell67.ritual = false
        spell67.range = 90
        spell67.rangeType = RangeType.Target
        spell67.effectRangeType = EffectRangeType.Target
        spell67.componentBlock = (true, true, false)
        spell67.castingTime = "1 minute"
        spell67.duration = "Concentration, up to 1 hour"
        spell67.details = "\tYou summon a fey creature of challenge rating 6 or lower, or a fey spirit that takes the form of a beast of challenge rating 6 or lower. It appears in an unoccupied space that you can see within range. The fey creature disappears when it drops to 0hp or when the spell ends.\n\tThe fey creature is friendly to you and your companions for the duration. Roll initiative for the fey creature, which has its own turns. It obeys any verbal commands you issue to it (no action required by you). If you don't issue any commands to the fey creature, it defends itself from hostile creatures but otherwise takes no actions.\n\tIf your concentration is broken, the fey creature doesn't disappear. Instead, you lose control of the fey creature, it becomes hostile toward you and your companions, and it might attack. An uncontrolled fey creature can't be dismissed by you, and it disappears 1 hour after you summon it.\n\tThe DM has the fey creature's statistics.\n\tWhen using a higher-level spell slot: the challenge rating increases by 1 for each additional spell level."
        
        let spell68: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell68.id = 68
        spell68.name = "Conjure Minor Elementals"
        spell68.level = 4
        spell68.school = MagicSchool.Conjuration
        spell68.ritual = false
        spell68.range = 90
        spell68.rangeType = RangeType.Target
        spell68.effectRangeType = EffectRangeType.Target
        spell68.componentBlock = (true, true, false)
        spell68.castingTime = "1 minute"
        spell68.duration = "Concentration, up to 1 hour"
        spell68.details = "\tYou summon elementals that appear in unoccupied spaces that you can see within range. You choose one of the following options for what appears:\n  \u{2022} One elemental of challenge rating 2 or lower\n  \u{2022} Two elementals of challenge rating 1 or lower\n  \u{2022} Four elementals of challenge rating 1/2 or lower\n  \u{2022} Eight elementals of challenge rating 1/4 or lower\n\tAn elemental summoned by this spell disappears when it drops to 0hp or when the spell ends.\n\tThe summoned creatures are friendly to you and your companions. Roll initiative for them as a group, which has its own turns. They obey any verbal commands that you issue to them (which does not require an action from you). If you don't issue any commands to them, they defend themselves from hostile creatures, but otherwise take no actions.\n\tThe DM has the creatures' statistics.\n\tWhen using a higher-level spell slot: for each two additional spell levels, you summon another whole set of creatures."
        
        let spell69: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell69.id = 69
        spell69.name = "Conjure Volley"
        spell69.level = 5
        spell69.school = MagicSchool.Conjuration
        spell69.ritual = false
        spell69.range = 150
        spell69.rangeType = RangeType.Target
        spell69.effectRange1 = 40
        spell69.effectRange2 = 20
        spell69.effectRangeType = EffectRangeType.Cylinder
        spell69.damageDice = (8, 8)
        spell69.componentBlock = (true, true, true)
        spell69.material = "one piece of ammunition or one thrown weapon"
        spell69.castingTime = "1 action"
        spell69.duration = "Instantaneous"
        spell69.details = "\tYou fire a piece of nonmagical ammunition from a ranged weapon or throw a nonmagical weapon into the air and choose a point within range. Hundreds of duplicates of the ammunition or weapon fall in a volley from above and then disappear. Each creature ina  40-foot radius, 20-foot high cylinder centered on that point must make a Dexterity saving throw, taking 8d8 damage on a failed save and half as much on a successful one. The damage type is the same as that of the ammunition or weapon."
        
        let spell70: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell70.id = 70
        spell70.name = "Conjure Woodland Beings"
        spell70.level = 4
        spell70.school = MagicSchool.Conjuration
        spell70.ritual = false
        spell70.range = 60
        spell70.rangeType = RangeType.Target
        spell70.effectRangeType = EffectRangeType.Target
        spell70.componentBlock = (true, true, true)
        spell70.material = "one holly berry per creature summoned"
        spell70.castingTime = "1 action"
        spell70.duration = "Concentration, up to 1 hour"
        spell70.details = "\tYou summon fey ceatures that appear in unoccupied spaces that you can see within range. You choose one of the following options for what appears:\n  \u{2022} One fey creature of challenge rating 2 or lower\n  \u{2022} Two fey creatures of challenge rating 1 or lower\n  \u{2022} Four fey creatures of challenge rating 1/2 or lower\n  \u{2022} Eight fey creatures of challenge rating 1/4 or lower\n\tA creature summoned by this spell disappears when it drops to 0hp or when the spell ends.\n\tThe summoned creatures are friendly to you and your companions. Roll initiative for them as a group, which has its own turns. They obey any verbal commands that you issue to them (which does not require an action from you). If you don't issue any commands to them, they defend themselves from hostile creatures, but otherwise take no actions.\n\tThe DM has the creatures' statistics.\n\tWhen using a higher-level spell slot: for each two additional spell levels, you summon another whole set of creatures."
        
        let spell71: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell71.id = 71
        spell71.name = "Contact Other Plane"
        spell71.level = 5
        spell71.school = MagicSchool.Divination
        spell71.ritual = true
        spell71.rangeType = RangeType.PSelf
        spell71.effectRangeType = EffectRangeType.Target
        spell71.componentBlock = (true, false, false)
        spell71.castingTime = "1 minute"
        spell71.duration = "1 minute"
        spell71.details = "\tYou mentally contact a demigod, the spirit of a long-dead sage, or some other mysterious entity from another plane. Contacting this extraplanar intelligence can strain or even break your mind. When you cast this spell, make a DC 15 Intelligence saving throw. On a failute, you take 6d6 psychic damage and are insane until you finish a long rest. While insane, you can't take actions, can't understand what other creatures say, can't read, and speak only in gibberish. A greater restoration spell cast on you ends this effect.\n\tOn a successful save, you can ask the entity up to five questions. You must ask your questions before the spell ends. The DM answers each question with one word, such as \"yes,\" \"no,\" \"maybe,\" \"never,\" \"irrelevant,\" or \"unclear\" (if the entity doesn't know the answer to the question). If a one-word answer would be misleading, the DM might instead offer a short phrase as an answer."
        
        let spell72: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell72.id = 72
        spell72.name = "Contagion"
        spell72.level = 5
        spell72.school = MagicSchool.Necromancy
        spell72.ritual = false
        spell72.rangeType = RangeType.Touch
        spell72.effectRangeType = EffectRangeType.Target
        spell72.componentBlock = (true, true, false)
        spell72.castingTime = "1 action"
        spell72.duration = "7 days"
        spell72.details = "\tYour touch inflicts disease. Make a melee spell attack against a creature within your reach. On a hit, you afflict the creature with a disease of your choice from any of the ones described below.\n\tAt the end of the target's turns, it must make a Constitution saving throw. After failing three of these saving throws, the disease's effects last for the duration, and the creature stops making these saves. After succeeding on three of these saving throws, the creature recovers from the disease, and the spell ends.\n\tSince this spell induces a natural disease in its target, any effect that removes a disease or otherwise ameliorates a disease's effects apply to it.\n  \u{2022} Blinding Sickness: Pain grips the creature's mind, and its eyes turn milky white. The creature has disadvantage on Wisdom checks and Wisdom saving throws and is blinded.\n  \u{2022} Filth Fever: A raging fever sweeps through the creature's body. The creature has disadvantage on Strength checks, Strength saving throws, and attack rolls that use Strength.\n  \u{2022} Flesh Rot: The creature's flesh decays. The creature has disadvantage on Charisma checks and vulnerability to all damage.\n  \u{2022} Mindfire: The creature's mind becomes feverish. The creature has disadvantage on Intelligence checks and Intelligence saving throws, and the creature behaves as if under the effects of the confusion spell during combat.\n  \u{2022} Seizure: The creature is overcome with shaking. The creature has disadvantage on Dexterity checks, Dexterity saving throws, and attack rolls that use Dexterity.\n  \u{2022} Slimy Doom: The creature begins to bleed uncontrollably. The creature has disadvantage on Constitution checks and Constitution saving throws. In addition, whenever the creature takes damage, it is stunned until the end of its next turn."
        
        let spell73: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell73.id = 73
        spell73.name = "Contingency"
        spell73.level = 6
        spell73.school = MagicSchool.Evocation
        spell73.ritual = false
        spell73.rangeType = RangeType.PSelf
        spell73.effectRangeType = EffectRangeType.Target
        spell73.componentBlock = (true, true, true)
        spell73.material = "a statuette of yourselve carved from ivory and decorated with gems worth at least 1500 gp"
        spell73.castingTime = "10 minutes"
        spell73.duration = "10 days"
        spell73.details = "\tChoose a spell of 5th level or lower that you can cast, that has a casting time of 1 action, and that can target you. You cast that spell - called the contingent spell - as part of casting contingency, expending spell slots for both, but the contingent spell doesn't come into effect. Instead, it takes effect when a certain circumstance occurs. You describe that circumstance when you cast the two spells. For example, a contingency cast with water breathing might stipulate that water breathing comes into effect when you are engulfed in water or a similar liquid.\n\tThe contingent spell takes effect immediately after the circumstane is met for the first time, whether or not you want it to, and then contingency ends.\n\tThe contingent spell takes effect only on you, even if it can normally target others. You can use only one contingency spell at a time. If you cast this spell again, the effect of another contingency spell on you ends. Also, contingency ends on you if its material component is ever not on your person."
        
        let spell74: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell74.id = 74
        spell74.name = "Continual Flame"
        spell74.level = 2
        spell74.school = MagicSchool.Evocation
        spell74.ritual = false
        spell74.rangeType = RangeType.Touch
        spell74.effectRangeType = EffectRangeType.Target
        spell74.componentBlock = (true, true, true)
        spell74.material = "ruby dust worth 50 gp, which the spell consumes"
        spell74.castingTime = "1 action"
        spell74.duration = "Until dispelled"
        spell74.details = "\tA flame, equivalent in brightness to a torch, springs forth from an object that you can touch. The effect looks like a regular flame, but it creates no hear and doesn't use oxygen. A contunual flame can be covered or hidden but not smothered or quenched."
        
        let spell75: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell75.id = 75
        spell75.name = "Control Water"
        spell75.level = 4
        spell75.school = MagicSchool.Transmutation
        spell75.ritual = false
        spell75.range = 300
        spell75.rangeType = RangeType.Target
        spell75.effectRange1 = 100
        spell75.effectRangeType = EffectRangeType.Cube
        spell75.damageDice = (2, 8)
        spell75.componentBlock = (true, true, true)
        spell75.material = "a drop of water and a pinch of dust"
        spell75.castingTime = "1 action"
        spell75.duration = "Concentration, up to 10 minutes"
        spell75.details = "\tUntil the spell ends, you control any freestanding water inside an area you choose that is a cube up to 100 feet on a side. You can choose from any of the following effects when you cast this spell. As an action on your turn, you can repeat the same effect or choose a different one.\n  \u{2022} Flood: You cause the water level of all standing water in the area to rise by as much as 20 feet. If the area includes a shore, the flooding water spills over onto dry land. If you choose an area in a large body of water, you instead create a 20-foot tall wave that travels from one side of the area to the other and then crashes down. Any Huge or smaller vehicles caught in its path are carried with it to the other side, and have a 25 percent chance of capsizing.\n  \u{2022} Part Water: You cause water in he area to move apart and create a trench. The trench extends across the spell's area, and the separated water forms a wall to either side.\n  \u{2022} Redirect Flow: You cause flowing water in the area to move in a direction you choose, even if the water has to flow over obstacles, up walls, or in other unlikely directions. The water resumes its normal course of flow if it exits the affected area.\n  \u{2022} Whirlpool: This effect requires a body of water at least 50 feet square and 25 feet deep. You cause a whirlpool to form in the center of the area. It forms a vortex 5 feet wide at the base, up to 50 feet wide at the top, and 25 feet tall. Any creature or object in the area or within 10 feet is pulled in towards it. A creature can swim away from the vortex by making an Athletics saving throw against your spell save DC.\n\tWhen a creature enters the vortex for the first time on a turn or starts its turn there, it must make a Strength saving throw, taking 2d8 bludgeoning damage on a failed save and being caught in the vortex, and half as much damage and not being caught in the vortex on a successful one. A creature caught in the vortex may make take its action to try and swim away, but must succeed on an Athletics check, rolling with disadvantage. A creature takes 2d8 for every turn it starts in the vortex."
        
        let spell76: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell76.id = 76
        spell76.name = "Control Weather"
        spell76.level = 8
        spell76.school = MagicSchool.Transmutation
        spell76.ritual = false
        spell76.rangeType = RangeType.PSelf
        spell76.effectRange1 = 26400
        spell76.effectRangeType = EffectRangeType.Sphere
        spell76.componentBlock = (true, true, true)
        spell76.material = "burning incense and bits of earth and wood mixed in water"
        spell76.castingTime = "10 minutes"
        spell76.duration = "Concentration, up to 8 hours"
        spell76.details = "\tYou take control of the weather within 5 miles of you for the duration. You must be outdoors to cast this spell. Moving to a place where you don't have a clear path to the sky ends the spell early.\n\tWhen you cast the spell, you change the current weather conditions, which are determined by the DM based on the climate and season. You can change precipitation, temperature, and wind. It takes 1d4 x 10 minutes for the new conditions to take effect. Once they do so, you can change the conditions again. When the spell ends, the weather gradually returns to normal.\n\tWhen you change the weather conditions, you may modify the precipitation, temperature, or wind to be slightly more or less sever (or slightly hotter/colder for temperature)."
        //TODO: put in the weather tables?
        
        let spell77: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell77.id = 77
        spell77.name = "Cordon of Arrows"
        spell77.level = 2
        spell77.school = MagicSchool.Transmutation
        spell77.ritual = false
        spell77.range = 5
        spell77.rangeType = RangeType.Target
        spell77.effectRange1 = 30
        spell77.effectRangeType = EffectRangeType.Sphere
        spell77.damageDice = (1, 6)
        spell77.componentBlock = (true, true, true)
        spell77.material = "four or more arrows or bolts"
        spell77.castingTime = "1 action"
        spell77.duration = "8 hours"
        spell77.details = "\tYou plant four pieces of nonmagical ammunition - arrows or crossbow bolts - in the ground within range and lay magic upon them to protect an area. Until the spell ends, whenever a creature other than you comes within 30 feet of the ammunition for the first time on a turn or ends its turn there, one piece of ammunition flies up to strike it. The creature must succeed on a Dexterity saving throw or take 1d6 piercing damage. The piece of ammunition is then destroyed. The spell ends when no ammunition remains.\n\tWhen you cast this spell, you can designate any creatures you choose, and the spell ignores them.\n\tWhen using a higher-level spell slot, the amount of ammunition that can be affected increases by two per spell level."
        
        let spell78: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell78.id = 78
        spell78.name = "Counterspell"
        spell78.level = 3
        spell78.school = MagicSchool.Abjuration
        spell78.ritual = false
        spell78.range = 60
        spell78.rangeType = RangeType.Target
        spell78.effectRangeType = EffectRangeType.Target
        spell78.componentBlock = (false, true, false)
        spell78.castingTime = "1 reaction, which you take when you see a creature within 60 feet of you casting a spell"
        spell78.duration = "Instantaneous"
        spell78.details = "\tYou attempt to interrupt a creature in the process of casting a spell. If the creature is casting a spell of 3rd level or lower, its spell fails and has no effect. If it is casting a spell of 4th level or higher, make an ability check using your spellcasting ability. The DC equals 10 plus the spell's level. On a success, the creature's spell fails and has no effect.\n\tWhen using a higher level spell splot, the interrupted spell has no effect if its level is less than or equal to the spell slot you are using."
        
        let spell79: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell79.id = 79
        spell79.name = "Create Food and Water"
        spell79.level = 3
        spell79.school = MagicSchool.Conjuration
        spell79.ritual = false
        spell79.range = 30
        spell79.rangeType = RangeType.Target
        spell79.effectRangeType = EffectRangeType.Target
        spell79.componentBlock = (true, true, false)
        spell79.castingTime = "1 action"
        spell79.duration = "Instantaneous"
        spell79.details = "\tYou create 45 pounds of food and 30 gallons of water on the ground or in containers within range, enough to sustain up to fifteen humanoids or five steeds for 24 hours. The food is bland but nourishing, and spoils if uneated after 24 hours. The water is clean and doesn't go bad."
        
        let spell80: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell80.id = 80
        spell80.name = "Create or Destroy Water"
        spell80.level = 1
        spell80.school = MagicSchool.Transmutation
        spell80.ritual = false
        spell80.range = 30
        spell80.rangeType = RangeType.Target
        spell80.effectRangeType = EffectRangeType.Target
        spell80.componentBlock = (true, true, true)
        spell80.material = "a drop of water if creating water or a few grains of sand if destroying it"
        spell80.castingTime = "1 action"
        spell80.duration = "Instantaneous"
        spell80.details = "\tYou either create or destroy water.\n  \u{2022} Create water: You create up to 10 gallons of clean water within range in an open container. Alternatively, the water falls as rain in a 30-foot cube within range, extinguishing exposed flames in the area.\n  \u{2022} Destroy Water: You destroy up to 10 gallons of water in an open container within range. Alternatively, you destroy fog in a 30-foot cube within range.\n\tWhen using a higher-level spell slot, you create or destroy 10 additional gallons of water, or the size of the cube increases by 5 feet, for each additional spell level."
        
        let spell81: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell81.id = 81
        spell81.name = "Create Undead"
        spell81.level = 6
        spell81.school = MagicSchool.Necromancy
        spell81.ritual = false
        spell81.range = 10
        spell81.rangeType = RangeType.Target
        spell81.effectRangeType = EffectRangeType.Target
        spell81.componentBlock = (true, true, true)
        spell81.material = "one clay pot filled with grave dirt, one clay pot filled with brackish water, and one 150gp black onyx stone for each corpse"
        spell81.castingTime = "1 minute"
        spell81.duration = "Instantaneous"
        spell81.details = "\tYou can cast this spell only at night. Choose up to three corpses of Medium or Small humanoids within range. Each corpse becomes a ghoul under your control. (The DM has game statistics for these creatures.)\n\tAs a bonus action on each of your turns, you can mentally command any creature you animated with this spell if the creature is within 120 feet of you (if you control multiple creatures, you can command any or all of them at the same time, issuing the same command to each one). You decide what action the creature will take and where it will move during its next turn, or you can issue a general command, such as to guard a particular chamber or corridor. If you issue no commands, the creature only defends itself against hostile creatures. Once given an order, the creature continues to follow it until its task is complete.\n\tThe creature is under your control for 24 hours, after which it stops obeying any command you have given it. You may cast this spell again to extend the duration by 24 hours, reasserting control for up to three creatures instead of animating new ones.\n\tWhen using a higher-level spell slot: using a 7th-level spell slots allows you to control four ghouls, while an 8th-level slot allows you to control five ghouls or two ghasts or wights, and a 9th-level spell slot allows you to control six ghouls, three ghasts or wights, or two mummies."
        
        let spell82: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell82.id = 82
        spell82.name = "Creation"
        spell82.level = 5
        spell82.school = MagicSchool.Illusion
        spell82.ritual = false
        spell82.range = 30
        spell82.rangeType = RangeType.Target
        spell82.effectRangeType = EffectRangeType.Target
        spell82.componentBlock = (true, true, true)
        spell82.material = "a tiny piece of matter of the same type of the item you plan to create"
        spell82.castingTime = "1 minute"
        spell82.duration = "Special"
        spell82.details = "\tYou pull wisps of shadow material from the Shadowfell to create a nonliving object of vegetable matter within range: soft goods, rope, wood, or something similar. You can also create mineral objects. The object created must be no larger than a 5-foot cube, and the object must be of a form and material that you have seen before.\n\tThe duration depends on the object's material. If creating an object of multiple materials, use the shortest duration:\n  \u{2022} Vegetable Matter: 1 day\n  \u{2022} Stone or Crystal: 12 hours\n  \u{2022} Precious Metals: 1 hour\n  \u{2022} Gems: 10 minutes\n  \u{2022} Adamantite or Mithral: 1 minute\n\tUsing any material created by this spell as another spell's material component causes that spell to fail.\n\tWhen using a higher-level spell slot, the cube increases by 5 feet for each additional spell level."
        
        let spell83: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell83.id = 83
        spell83.name = "Crown of Madness"
        spell83.level = 2
        spell83.school = MagicSchool.Enchantment
        spell83.ritual = false
        spell83.range = 120
        spell83.rangeType = RangeType.Target
        spell83.effectRangeType = EffectRangeType.Target
        spell83.componentBlock = (true, true, false)
        spell83.castingTime = "1 action"
        spell83.duration = "Concentration, up to 1 minute"
        spell83.details = "\tYou cast this spell on a humanoid target you can see, which must succeed on a Wisdom saving throw or become charmed by you for the duration. While charmed, a twisted crown of jagged iron appears on its head, and a madness glows in its eyes.\n\tThe charmed target must use its action before moving on each of its turns to make a melee attack against a creature other than itself that you mentally choose. The target may act normally if you choose no creature or if none are within its reach.\n\tOn your subsequent turns, you must use your action to maintain control over the target, or the spell ends. Also, the target can make a Wisdom saving throw at the end of each of its turns, ending the spell on a successful save."
        
        let spell84: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell84.id = 84
        spell84.name = "Crusader's Mantle"
        spell84.level = 3
        spell84.school = MagicSchool.Evocation
        spell84.ritual = false
        spell84.rangeType = RangeType.PSelf
        spell84.effectRange1 = 30
        spell84.effectRangeType = EffectRangeType.Sphere
        spell84.damageDice = (1, 4)
        spell84.componentBlock = (true, false, false)
        spell84.castingTime = "1 action"
        spell84.duration = "Concentration, up to 1 minute"
        spell84.details = "\tHoly power radiates from you in an aura with a 30-foot radius, awakening boldness in friendly creatures. Until the spell ends, the aura moves with you, centered on you. While in the aura, each nonhostile creature in the aura (including you) deals an extra 1d4 radiant damage when it hits with a weapon attack."
        
        let spell85: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell85.id = 85
        spell85.name = "Cure Wounds"
        spell85.level = 1
        spell85.school = MagicSchool.Evocation
        spell85.ritual = false
        spell85.rangeType = RangeType.Touch
        spell85.effectRangeType = EffectRangeType.Target
        spell85.damageDice = (1, 8)
        spell85.componentBlock = (true, true, false)
        spell85.castingTime = "1 action"
        spell85.duration = "Instantaneous"
        spell85.details = "\tA creature you touch regains a number of hit points equal to 1d8 plus your spellcasting ability modifier. This spell has no effect on undead or constructs.\n\tWhen using a higher-level spell slot, the healing increases by 1d8 for each additional spell level."
        
        let spell86: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell86.id = 86
        spell86.name = "Dancing Lights"
        spell86.level = 0
        spell86.school = MagicSchool.Evocation
        spell86.ritual = false
        spell86.range = 120
        spell86.rangeType = RangeType.Target
        spell86.effectRangeType = EffectRangeType.Target
        spell86.componentBlock = (true, true, true)
        spell86.material = "a bit of phosphorus or wychwood, or a glowworm"
        spell86.castingTime = "1 action"
        spell86.duration = "Concentration, up to 1 minute"
        spell86.details = "\tYou create up to four torch-sized lights within range, making them appear as torches, lanterns, or glowing orbs that hover in the air for the duration. You can also combine the four lights into one glowing vaguely humanoid form of Medium size. Whichever form you choose, each light sheds dim light in a 10-foot radius.\n\tAs a bonus action on your turn, you can move the lights up to 60 feet to a new spot within range. A light must be within 20 feet of another light created by this spell, and a light winks out if it exceeds the spell's range."
        
        let spell87: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell87.id = 87
        spell87.name = "Darkness"
        spell87.level = 2
        spell87.school = MagicSchool.Evocation
        spell87.ritual = false
        spell87.range = 60
        spell87.rangeType = RangeType.Target
        spell87.effectRange1 = 15
        spell87.effectRangeType = EffectRangeType.Sphere
        spell87.componentBlock = (true, true, true)
        spell87.material = "bat fur and a drop of pitch or piece of coal"
        spell87.castingTime = "1 action"
        spell87.duration = "Concentration, up to 10 minutes"
        spell87.details = "\tMagical darkness spreads from a point you choose within range to fill a 15-foot-radius sphere for the duration. The darkness spreads around corners. A creature with darkvision can't see through this darkness, and nonmagical light can't illuminate it.\n\tIf the point you choose is on an object you are holding or one that isn't being worn or carried, the darkness emanates from the object and moves with it. Completely covering the source of the darkness with an opaque object, such as a bown or a helm, blocks the darkness.\n\tIf any of this spell's area overlaps with an area of light created by a spell of 2nd level or lower, the spell that created the light is dispelled."
        
        let spell88: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell88.id = 88
        spell88.name = "Darkvision"
        spell88.level = 2
        spell88.school = MagicSchool.Transmutation
        spell88.ritual = false
        spell88.rangeType = RangeType.Touch
        spell88.effectRangeType = EffectRangeType.Target
        spell88.componentBlock = (true, true, true)
        spell88.material = "either a pinch of dried carrot or an agate"
        spell88.castingTime = "1 action"
        spell88.duration = "1 hour"
        spell88.details = "\tYou touch a willing creature to grant it the ability to see in the dark. For the duration, that creature has darkvision out to a range of 60 feet."
        
        let spell89: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell89.id = 89
        spell89.name = "Daylight"
        spell89.level = 3
        spell89.school = MagicSchool.Evocation
        spell89.ritual = false
        spell89.range = 60
        spell89.rangeType = RangeType.Target
        spell89.effectRange1 = 60
        spell89.effectRangeType = EffectRangeType.Sphere
        spell89.componentBlock = (true, true, false)
        spell89.castingTime = "1 action"
        spell89.duration = "1 hour"
        spell89.details = "\tA 60-foot-radius sphere of light spreads out from a point you choose within range. The sphere is bright light and sheds dim light for an additional 60 feet.\n\tIf you chose a point on an object you are holding or one that isn't being worn or carried, the light shines from the object and moves with it. Completely covering the affected object with an opaque object, such as a bowl or a helm, blocks the light.\n\tIf any of this spell's area overlaps with an area of darkness created by a spell of 3rd level or lower, the spell that created the darkness is dispelled."
        
        let spell90: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell90.id = 90
        spell90.name = "Death Ward"
        spell90.level = 4
        spell90.school = MagicSchool.Abjuration
        spell90.ritual = false
        spell90.rangeType = RangeType.Touch
        spell90.effectRangeType = EffectRangeType.Target
        spell90.componentBlock = (true, true, false)
        spell90.castingTime = "1 action"
        spell90.duration = "8 hours"
        spell90.details = "\tYou touch a creature and grant it a measure of protection from death.\n\tThe first time the target would drop to 0hp as a result of taking damage, the target instead drops to 1hp, and the spell ends.\n\tIf the spell is still in effect when the target is subjected to an effect that would kill it instantaneously without dealing damage, that effect is instead negated against the target, and the spell ends."
        
        let spell91: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell91.id = 91
        spell91.name = "Delayed Blast Fireball"
        spell91.level = 7
        spell91.school = MagicSchool.Evocation
        spell91.ritual = false
        spell91.range = 150
        spell91.rangeType = RangeType.Target
        spell91.effectRange1 = 20
        spell91.effectRangeType = EffectRangeType.Sphere
        spell91.damageDice = (12, 6)
        spell91.componentBlock = (true, true, true)
        spell91.material = "a tiny ball of bat guano and sulfur"
        spell91.castingTime = "1 action"
        spell91.duration = "Concentration, up to 1 minute"
        spell91.details = "\tA beam of yellow light flashes from your pointing finger, then condenses to linger at a chosen point within range as a glowing bead for the duration. When the spell ends, either because your concentration is broken or because you decide to end it, the bead blossoms with a low roar into an explosion of flame that spreads around corners. Each creature in a 20-foot radius sphere centered on that point must make a Dexterity saving throw. A creature takes fire damage equal to the total accumulated damage on a failed save, or half as much damage on a successful one.\n\tThe spell's base damage is 12d6. If at the end of your turn the bead has not yet detonated, the damage increases by 1d6.\n\tIf the glowing bead is touched before the interval has expired, the creature touching it must make a Dexterity saving throw. On a failed save, the spell ends immediately, causing the bead to erupt in flame. On a successful save, the creature can throw the bead up to 40 feet. When it strikes a creature or solid object, the spell ends, and the beat explodes.\n\tThe fire damages objects in the area and ignites flammable objects that aren't being worn or carried.\n\tWhen using a higher-level spell slot, the base damage increases by 1d6 for each additional spell level."
        
        let spell92: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell92.id = 92
        spell92.name = "Demiplane"
        spell92.level = 8
        spell92.school = MagicSchool.Conjuration
        spell92.ritual = false
        spell92.range = 60
        spell92.rangeType = RangeType.Target
        spell92.effectRangeType = EffectRangeType.Target
        spell92.componentBlock = (false, true, false)
        spell92.castingTime = "1 action"
        spell92.duration = "1 hour"
        spell92.details = "\tYou create a shadowy door on a flat solid surface that you can see within range. The door is large enough to allow Medium creatures to pass through unhindered. When opened, the door leads to a demiplane that appears to be an empty room 30 feet in each dimension, made of wood or stone. When the spell ends, the door disappears, and any creatures or objects inside the demiplane remain trapped there, as the door also disappears from the other side.\n\tEach time you cast this spell, you can create a new demiplane, or have the shadowy door connect to a demiplane you created with a previous casting of this spell. Additionally, if you know the nature and contents of a demiplane created by a casting of this spell by another creature, you can have the shadowy door connect to its demiplane instead."
        
        let spell93: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell93.id = 93
        spell93.name = "Destructive Wave"
        spell93.level = 5
        spell93.school = MagicSchool.Evocation
        spell93.ritual = false
        spell93.rangeType = RangeType.PSelf
        spell93.effectRange1 = 30
        spell93.effectRangeType = EffectRangeType.Sphere
        spell93.damageDice = (10, 6)
        spell93.componentBlock = (true, false, false)
        spell93.castingTime = "1 action"
        spell93.duration = "Instantaneous"
        spell93.details = "\tYou strike the ground, creating a burst of divine energy that ripples outward from you. Each creature you choose within 30 feet of you must succeed on a Constitution saving throw or take 5d6 thunder damage, as well as 5d6 radiant or necrotic damage (your choice), and be knocked prone. A creature that succeeds on its saving throw takes half as much damage and isn't knocked prone."
        
        let spell94: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell94.id = 94
        spell94.name = "Detect Evil and Good"
        spell94.level = 1
        spell94.school = MagicSchool.Divination
        spell94.ritual = false
        spell94.rangeType = RangeType.PSelf
        spell94.effectRange1 = 30
        spell94.effectRangeType = EffectRangeType.Sphere
        spell94.componentBlock = (true, true, false)
        spell94.castingTime = "1 action"
        spell94.duration = "Concentration, up to 10 minutes"
        spell94.details = "\tFor the duration, you know if there is an aberration, celestial, fey, fiend, or undead within 30 feet of you, as well as where the creature is located. Similarly, you know if there is a place or object within 30 feet of you that has been magically consecrated or desecrated.\n\tThe spell can penetrate most barriers, but it is blocked by 1 foot of stone, 1 inch of common metal, a thin sheet of lead, or 3 feet of wood or dirt."
        
        let spell95: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell95.id = 95
        spell95.name = "Detect Magic"
        spell95.level = 1
        spell95.school = MagicSchool.Divination
        spell95.ritual = true
        spell95.rangeType = RangeType.PSelf
        spell95.effectRange1 = 30
        spell95.effectRangeType = EffectRangeType.Sphere
        spell95.componentBlock = (true, true, false)
        spell95.castingTime = "1 action"
        spell95.duration = "Concentration, up to 10 minutes"
        spell95.details = "\tFor the duration, you sense the presence of magic within 30 feet of you. If you sense magic in this way, you can use your action to see a faint aura around any visible creature or object in the area that bears magic, and you learn its school of magic, if any.\n\tThe spell can penetrate most barriers, but it is blocked by 1 foot of stone, 1 inch of common metal, a thin sheet of lead, or 3 feet of wood or dirt."
        
        let spell96: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell96.id = 96
        spell96.name = "Detect Poison and Disease"
        spell96.level = 1
        spell96.school = MagicSchool.Divination
        spell96.ritual = true
        spell96.rangeType = RangeType.PSelf
        spell96.effectRange1 = 30
        spell96.effectRangeType = EffectRangeType.Sphere
        spell96.componentBlock = (true, true, true)
        spell96.material = "a yew leaf"
        spell96.castingTime = "1 action"
        spell96.duration = "Concentration, up to 10 minutes"
        spell96.details = "\tFor the duration, you can sense the presence and location of poisons, poisonous creatures, and diseases within 30 feet of you. You also identify the kind of poison, poisonous creature, or disease in each case.\n\tThe spell can penetrate most barriers, but it is blocked by 1 foot of stone, 1 inch of common metal, a thin sheet of lead, or 3 feet of wood or dirt."
        
        let spell97: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell97.id = 97
        spell97.name = "Detect Thoughts"
        spell97.level = 2
        spell97.school = MagicSchool.Divination
        spell97.ritual = false
        spell97.rangeType = RangeType.PSelf
        spell97.effectRange1 = 30
        spell97.effectRangeType = EffectRangeType.Sphere
        spell97.componentBlock = (true, true, true)
        spell97.material = "a copper piece"
        spell97.castingTime = "1 action"
        spell97.duration = "Concentration, up to 1 minute"
        spell97.details = "\tFor the duration, you can read the thoughts of certain creatures. When you cast the spell and as your action on each turn until the spell ends, you can focus your mind on any one creature that you can see within 30 feet of you. If the creature you choose has an Intelligence of 3 or lower or doesn't speak any language, the creature is unaffected.\n\tYou initially learn the surface thoughts of the creature - what is most on its mind in that moment. As an action, you can either shift your attention to another creature's thoughts or attempt to probe deeper into the same creature's mind. If you probe deeper, the target must make a Wisdom saving throw. If it fails, you gain insight into its reasoning, emotional state, and something that looms large in its mind. If it succeeds, the spell ends. Either way, the target knows that you are probing into its mind, and unless you shift your attention to another creature's thoughts, the creature can use its action on its turn to make an Intelligence check contested by your Intelligence check; if it succeeds, the spell ends.\n\tQuestions verbally directed at the target creature naturally shape the course of its thoughts, so this spell is particularly effective as part of an interrogation.\n\tYou can also use this spell to detect the presence of thinking creatures you can't see. When you cast the spell, you can search for thoughts within 30 feet of you. The spell can penetrate barriers, but 2 feet of rok, 2 inches of any metal other than lead, or a thin sheet of lead blocks you. You can't detect a creature with an Intelligence of 3 or lower or one that doesn't speak any language.\n\tOnce you detect the presence of a creature in this way, you can read its thoughts for the rest of the duration as described above, even if you can't see it, but it must still be within range."
        
        let spell98: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell98.id = 98
        spell98.name = "Dimension Door"
        spell98.level = 4
        spell98.school = MagicSchool.Conjuration
        spell98.ritual = false
        spell98.range = 500
        spell98.rangeType = RangeType.Target
        spell98.effectRangeType = EffectRangeType.Target
        spell98.componentBlock = (true, false, false)
        spell98.castingTime = "1 action"
        spell98.duration = "Instantaneous"
        spell98.details = "\tYou teleport yourself from your current location to any other spot within range. You arrive at exactly the spot desired. It can be a place you can see, one you can visualize, or one you can describe by stating distance and direction, such as \"200 feet straight downward\" or \"upward to the northwest at a 45-degree angle, 300 feet.\"\n\tYou can bring along objects as long as their weight doesn't exceed what you can carry. You can also bring one willing creature of your size or smaller who is carrying gear up to its carrying capacity. The creature must be within 5 feet of you when you cast this spell.\n\tIf you would arrive in a place already occupied by an object or a creature, you and any creature traveling with you each take 4d6 force damage, and the spell fails to teleport you."
        
        let spell99: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell99.id = 99
        spell99.name = "Disguise Self"
        spell99.level = 1
        spell99.school = MagicSchool.Illusion
        spell99.ritual = false
        spell99.rangeType = RangeType.PSelf
        spell99.effectRangeType = EffectRangeType.Target
        spell99.componentBlock = (true, true, false)
        spell99.castingTime = "1 action"
        spell99.duration = "1 hour"
        spell99.details = "\tYou make yourself, plus your clothing, armor, weapons, and other inventory on your person, look different until the spell ends or until you use your action to dismiss it. You can seem 1 foot shorter or taller and can appear thin, fat, or somewhere in between. You can't change your body type, but other than that, the extent of the illusion is up to you.\n\tThe changes wrought by this spell fail to hold up to physical inspection; objects pass through additions to your person, and objects collide with subtractions to your person.\n\tTo discern that you are disguised, a creature can use an Investigation check against your spell save DC."
        
        let spell100: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell100.id = 100
        spell100.name = "Disintegrate"
        spell100.level = 6
        spell100.school = MagicSchool.Transmutation
        spell100.ritual = false
        spell100.range = 60
        spell100.rangeType = RangeType.Target
        spell100.effectRangeType = EffectRangeType.Target
        spell100.componentBlock = (true, true, true)
        spell100.damageDice = (10, 6)
        spell100.material = "a lodestone and a pinch of dust"
        spell100.castingTime = "1 action"
        spell100.duration = "Instantaneous"
        spell100.details = "\tA thin greeen ray springs from your pointing finger to a target that you can see within range. The target can be a creature, an object, or a creation of magical force.\n\tA creature targeted by this spell must make a Dexterity saving throw. On a failed save, the target takes 10d6 + 40 force damage. If this damage reduces the target to 0hp, it is disintegrated.\n\tA disintegrated creature and everything it is wearing or carrying, except magical items, are reduced to a pile of fine gray dust. The creature can be restored to life only by means of a True Resurrection or Wish spell.\n\tThis spell automatically disintegrates a Large or smaller nonmagical object or a creation of magical force. If the target is a Huge or larger object or creation of force, this spell disintegrates a 10-foot-cube portion of it. A magic item is unaffected by this spell.\n\tWhen using a higher-level spell slot, the damage increases by 3d6 for each additional spell level."
        
        let spell101: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell101.id = 101
        spell101.name = "Dispel Evil and Good"
        spell101.level = 5
        spell101.school = MagicSchool.Abjuration
        spell101.ritual = false
        spell101.rangeType = RangeType.PSelf
        spell101.effectRangeType = EffectRangeType.Target
        spell101.componentBlock = (true, true, true)
        spell101.material = "holy water or powdered silver and iron"
        spell101.castingTime = "1 action"
        spell101.duration = "Concentration, up to 1 minute"
        spell101.details = "\tShimmering energy surrounds and protects you from fey, undead, and creatures originating from beyond the Material Plane. For the duration, celestials, elementals, fey, fiends, and undead have disadvantage on attack rolls against you.\n\tYou can end the spell early by using either of the following special functions:\n  \u{2022} Break Enchantment: As your action, you touch a creature you can reach that is charmed, frightened, or possessed by a celestial, fey, fiend, or undead. The creature you touch is no longer charmed, frightened, or possessed by such creatures.\n\t  \u{2022} Dismissal: As your action, make a melee spell attack against a celestial, elemental, fey, fiend, or undead you can reach. On a hit, you attempt to drive the creature back to its home plane. The creature must succeed on a Charisma saving throw or be sent back to its home plane (if it isn't there already). If they aren't on their home plane, undead are sent to the Shadowfell, and fey are sent to the Feywild."
        
        let spell102: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell102.id = 102
        spell102.name = "Dispel Magic"
        spell102.level = 3
        spell102.school = MagicSchool.Abjuration
        spell102.ritual = false
        spell102.range = 120
        spell102.rangeType = RangeType.Target
        spell102.effectRangeType = EffectRangeType.Target
        spell102.componentBlock = (true, true, false)
        spell102.castingTime = "1 action"
        spell102.duration = "Instantaneous"
        spell102.details = "\tChoose any one creature, object, or magical effect within range. Any spell of 3rd level or lower on the target ends. For each spell of 4th level or higher on the target, make an ability check using your spellcasting ability. The DC equals 10 + the spell's level. On a succedssful check, the spell ends.\n\tWhen using a higher-level spell slot, you automatically end the effects of a spell on the target if the spell's level is equal to or less than the level of the spell slot you used."
        
        let spell103: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell103.id = 103
        spell103.name = "Dissonant Whispers"
        spell103.level = 1
        spell103.school = MagicSchool.Enchantment
        spell103.ritual = false
        spell103.range = 60
        spell103.rangeType = RangeType.Target
        spell103.effectRangeType = EffectRangeType.Target
        spell103.damageDice = (3, 6)
        spell103.componentBlock = (true, false, false)
        spell103.castingTime = "1 action"
        spell103.duration = "Instantaneous"
        spell103.details = "\tYou whisper a discordant melody that only one creature of your choice within range can hear, wracking it with terrible pain. The target must make a Wisdom saving throw. On a failed save, it takes 3d6 psychic damage and must immediately use its reaction, if available, to move as far as its speed allows away from you. The creature doesn't move into obviously dangerous ground, such as a fire or a pit. On a successful save, the target takes half as much damage and does not have to move away. A deafened creature automatically succeeds on the save.\n\tWhen using a higher-level spell slot, the damage increases by 1d6 for each additional spell level."
        
        let spell104: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell104.id = 104
        spell104.name = "Divination"
        spell104.level = 4
        spell104.school = MagicSchool.Divination
        spell104.ritual = true
        spell104.rangeType = RangeType.PSelf
        spell104.effectRangeType = EffectRangeType.Target
        spell104.componentBlock = (true, true, true)
        spell104.material = "incense and a sacrificial offering appropriate to your religion, together worth at least 25 gp, which the spell consumes"
        spell104.castingTime = "1 action"
        spell104.duration = "Instantaneous"
        spell104.details = "\tYour magic and an offering put you in contact with a god or a god's servants. You ask a single question concerning a specific goal, event, or activity to occur within 7 days. The DM offers a truthful reply, which may be a short phrase, cryptic rhyme, or an omen.\n\tThe spell doesn't take into account any possible circumstances that might change the outcome, such as the casting of additional spells or the loss or gain of a companion.\n\tIf you cast the spell two or more times before finishing your next long rest, there is a cumulative 25 percent chance for each casting after the first that you get a random reading. The DM makes this roll in secret."
        
        let spell105: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell105.id = 105
        spell105.name = "Divine Favor"
        spell105.level = 1
        spell105.school = MagicSchool.Evocation
        spell105.ritual = false
        spell105.rangeType = RangeType.PSelf
        spell105.effectRangeType = EffectRangeType.Target
        spell105.damageDice = (1, 4)
        spell105.componentBlock = (true, true, false)
        spell105.castingTime = "1 bonus action"
        spell105.duration = "Concentration, up to 1 minute"
        spell105.details = "\tYour prayer empowers you with divine radiance. Until the spell ends, your weapon attacks deal an extra 1d4 radiant damage on a hit."
        
        let spell106: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell106.id = 106
        spell106.name = "Divine Word"
        spell106.level = 7
        spell106.school = MagicSchool.Evocation
        spell106.ritual = false
        spell106.range = 30
        spell106.rangeType = RangeType.Target
        spell106.effectRangeType = EffectRangeType.Target
        spell106.componentBlock = (true, false, false)
        spell106.castingTime = "1 bonus action"
        spell106.duration = "Instantaneous"
        spell106.details = "\tYou utter a divine word, imbued with the power that shaped the world at the dawn of creation. Choose any number of creatures you can see within range. Each creature that can hear you must make a Charisma saving throw. On a failed save, a creature suffers an effect based on its current hit points:\n  \u{2022} 50hp or fewer: deafened for 1 minute\n  \u{2022} 40hp or fewer: deafened and blinded for 10 minutes\n  \u{2022} 30hp or fewer: blinded, deafened, and stunned for 1 hour\n  \u{2022} 20hp or fewer: killed instantly\n\tRegardless of its current hit points, a celestial, elemental, fey, or fiend that fails its save is forced back to its plane of origin (if it isn't there already) and can't return to your current plane for 24 hours by any means short of a Wish spell."
        
        let spell107: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell107.id = 107
        spell107.name = "Dominate Beast"
        spell107.level = 4
        spell107.school = MagicSchool.Enchantment
        spell107.ritual = false
        spell107.range = 60
        spell107.rangeType = RangeType.Target
        spell107.effectRangeType = EffectRangeType.Target
        spell107.componentBlock = (true, true, false)
        spell107.castingTime = "1 action"
        spell107.duration = "Concentration, up to 1 minute"
        spell107.details = "\tYou attempt to beguile a beast that you can see within range. It must succeed on a Wisdom saving throw or be charmed by you for the duration. If you or creatures that are friendly to you are fighting it, it has advantage on the saving throw.\n\tWhile the beast is charmed, you have a telepathic link with it as long as the two of you are on the same plane of existence. You can use this telepathic link to issue commands to the creature while you are conscious (no action required), which it does to the best of its ability. You can specify a simple and general course of action, such as \"Attack that creature,\" \"Run over there,\" or \"Fetch that object.\" If the creature completes the order and doesn't receive further direction from you, it defends and preserves itself to the best of its ability.\n\tYou can use your action to take total and precise control of the target. Until the end of your next turn, the creature takes only the actions you choose, and doesn't do anything that you don't allow it to do. During this time, you can also cause the creature to use a reaction, but this requires you to use your own reaction as well.\n\tEach time the target takes damage, it makes a new Wisdom saving throw against the spell. If the saving throw succeeds, the spell ends.\n\tWhen using a higher-level spell slot: at 5th level, the duration increases to 10 minutes; at 6th level, the duration increases to 1 hour; at 7th level or higher, the duration increases to 8 hours."
        
        let spell108: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell108.id = 108
        spell108.name = "Dominate Monster"
        spell108.level = 8
        spell108.school = MagicSchool.Enchantment
        spell108.ritual = false
        spell108.range = 60
        spell108.rangeType = RangeType.Target
        spell108.effectRangeType = EffectRangeType.Target
        spell108.componentBlock = (true, true, false)
        spell108.castingTime = "1 action"
        spell108.duration = "Concentration, up to 1 hour"
        spell108.details = "\tYou attempt to beguile a creature that you can see within range. It must succeed on a Wisdom saving throw or be charmed by you for the duration. If you or creatures that are friendly to you are fighting it, it has advantage on the saving throw.\n\tWhile the creature is charmed, you have a telepathic link with it as long as the two of you are on the same plane of existence. You can use this telepathic link to issue commands to the creature while you are conscious (no action required), which it does to the best of its ability. You can specify a simple and general course of action, such as \"Attack that creature,\" \"Run over there,\" or \"Fetch that object.\" If the creature completes the order and doesn't receive further direction from you, it defends and preserves itself to the best of its ability.\n\tYou can use your action to take total and precise control of the target. Until the end of your next turn, the creature takes only the actions you choose, and doesn't do anything that you don't allow it to do. During this time, you can also cause the creature to use a reaction, but this requires you to use your own reaction as well.\n\tEach time the target takes damage, it makes a new Wisdom saving throw against the spell. If the saving throw succeeds, the spell ends.\n\tWhen using a higher-level spell slot: at 9th level, the duration increases to 8 hours."
        
        let spell109: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell109.id = 109
        spell109.name = "Dominate Person"
        spell109.level = 5
        spell109.school = MagicSchool.Enchantment
        spell109.ritual = false
        spell109.range = 60
        spell109.rangeType = RangeType.Target
        spell109.effectRangeType = EffectRangeType.Target
        spell109.componentBlock = (true, true, false)
        spell109.castingTime = "1 action"
        spell109.duration = "Concentration, up to 1 minute"
        spell109.details = "\tYou attempt to beguile a humanoid that you can see within range. It must succeed on a Wisdom saving throw or be charmed by you for the duration. If you or creatures that are friendly to you are fighting it, it has advantage on the saving throw.\n\tWhile the target is charmed, you have a telepathic link with it as long as the two of you are on the same plane of existence. You can use this telepathic link to issue commands to the creature while you are conscious (no action required), which it does to the best of its ability. You can specify a simple and general course of action, such as \"Attack that creature,\" \"Run over there,\" or \"Fetch that object.\" If the creature completes the order and doesn't receive further direction from you, it defends and preserves itself to the best of its ability.\n\tYou can use your action to take total and precise control of the target. Until the end of your next turn, the creature takes only the actions you choose, and doesn't do anything that you don't allow it to do. During this time, you can also cause the creature to use a reaction, but this requires you to use your own reaction as well.\n\tEach time the target takes damage, it makes a new Wisdom saving throw against the spell. If the saving throw succeeds, the spell ends.\n\tWhen using a higher-level spell slot: at 6th level, the duration increases to 10 minutes; at 7th level, the duration increases to 1 hour; at 8th level or higher, the duration increases to 8 hours."
        
        let spell110: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell110.id = 110
        spell110.name = "Drawmij's Instant Summons"
        spell110.level = 6
        spell110.school = MagicSchool.Conjuration
        spell110.ritual = true
        spell110.rangeType = RangeType.Touch
        spell110.effectRangeType = EffectRangeType.Target
        spell110.componentBlock = (true, true, true)
        spell110.material = "a sapphire worth 1,000gp"
        spell110.castingTime = "1 minute"
        spell110.duration = "Until dispelled"
        spell110.details = "\tYou touch an object weighing 10 pounds or less whose longest dimension is 6 feet or less. The spell leaves an invisible mark on its surface and invisibly inscribes the name of the item on the sapphire you use as the material component. Each time you cast this spell, you must use a different sapphire.\n\tAt any time thereafter, you can use your action to speak the item's name and crush the sapphire. The item instantly appears in your hand regardless of physical or planar distances, and the spell ends.\n\tIf another creature is holding or carrying the item, crushing the sapphire doesn't transport the item to you, but instead you learn who the creature possessing the object is and roughly where that creature is located at that moment.\n\tDispel Magic or a similar effect successfully applied to the sapphire ends this spell's effect."
        
        let spell111: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell111.id = 111
        spell111.name = "Dream"
        spell111.level = 5
        spell111.school = MagicSchool.Illusion
        spell111.ritual = false
        spell111.range = 0//TODO: "special"
        spell111.rangeType = RangeType.Target
        spell111.effectRangeType = EffectRangeType.Target
        spell111.componentBlock = (true, true, true)
        spell111.material = "a handful of sand, a dab of ink, and a writing quill plucked from a sleeping bird"
        spell111.castingTime = "1 minute"
        spell111.duration = "8 hours"
        spell111.details = "\tThis spell shapes a creature's dreams. Choose a creature known to you as the target of this spell. The target must be on the same plane of existence as you. Creatures that don't sleep, such as elves, can't be contacted by this spell. You, or a willing creature you touch, enters a trance state, acting as a messenger. While in the trance, the messenger is aware of his or her surroundings, but can't take actions or move.\n\tIf the target is asleep, the messenger appears in the target's dreams and can converse with the target as long as it remains asleep, through the duration of the spell. The messenger can also shape the environment of the dream, creating landscapes, objects, and other images. The messenger can emerge from the trance at any time, ending the effect of the spell early. The target recalls the dream perfectly upon waking. If the target is awake when you cast the spell, the messenger knows it, and can either end the trance (and the spell) or wait for the target to fall asleep, at which point the messenger appears in the target's dreams.\n\tYou can make the messenger appear monstrous and terrifying to the target. If you do, the messenger can deliver a message of no more than 10 words and then the target must make a Wisdom saving throw. On a failed save, echoes of the phantasmal monstrosity spawn a nightmare that lasts the duration of the target's sleep and prevents the target from gaining any benefit from that rest. In addition, when the target wakes up, it takes 3d6 psychic damage.\n\tIf you have a body part, lock of hair, clipping from a nail, or similar portion of the target's body, the target makes its saving throw with disadvantage."
        
        let spell112: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell112.id = 112
        spell112.name = "Druidcraft"
        spell112.level = 0
        spell112.school = MagicSchool.Transmutation
        spell112.ritual = false
        spell112.range = 30
        spell112.rangeType = RangeType.Target
        spell112.effectRangeType = EffectRangeType.Target
        spell112.componentBlock = (true, true, false)
        spell112.castingTime = "1 action"
        spell112.duration = "Instantaneous"
        spell112.details = "\tWhispering to the spirits of nature, you create one of the following effects within range:\n  \u{2022} You create a tiny, harmless sensory effect that predicts what the weather will be at your location for the next 24 hours. The effect persists for 1 round.\n  \u{2022} You instantly make a flower blossom, a seed pod open, or a leaf bud bloom.\n  \u{2022} You create an instantaneous, harmless seonsory effect, such as falling leaves, a puff of wind, the sound of a small animal, or the faint odor of a skunk. The effect must fit in a 5-foot cube.\n  \u{2022} You instantly light or snuff out a candle, a torch, or a small campfire."
        
        let spell113: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell113.id = 113
        spell113.name = "Earthquake"
        spell113.level = 8
        spell113.school = MagicSchool.Evocation
        spell113.ritual = false
        spell113.range = 500
        spell113.rangeType = RangeType.Target
        spell113.effectRange1 = 100
        spell113.effectRangeType = EffectRangeType.Sphere
        spell113.damageDice = (5, 6)
        spell113.componentBlock = (true, true, true)
        spell113.material = "a pinch of dirt, a piece of rock, and a lump of clay"
        spell113.castingTime = "1 action"
        spell113.duration = "Concentration, up to 1 minute"
        spell113.details = "\tYou create a seismic disturbance at a point on the ground that you can see within range. For the duration, an intense tremor rips through the ground in a 100-foot-radius circle centered on that point and shakes creatures and structures in contact with the ground in that area.\n\tThe ground in the area becomes difficult terrain. Each creature on the ground that is concentrating must make a Constitution saving throw. On a failed save, the creature's concentration is broken.\n\tWhen you cast this spell and at the end of each turn you spend concentrating on it, each creature on the ground in the area must make a Dexterity saving throw. On a failed save, the creature is knocked prone.\n\tThis spell can have additional effects depending on the terrain in the area, as determined by the DM.\n  \u{2022} Fissures: Fissures open throughout the spell's area at the start of your next turn after you cast the spell. A total of 1d6 such fissures open in locations chosen by the DM. Each is 1d10x10 feet deep, 10 feet wide, and extends from one edge of the spell's area to the opposite side. A creature standing on a spot where a fissure opens must succeed on a Dexterity saving throw or fall in. A creature that successfully saves moves with the fissures edge as it opens.\n\tA fissure that opens beneath a structure causes it to automatically collapse.\n  \u{2022} Structures: The tremor deals 50 bludgeoning damage to any structure in contact with the ground in the area when you cast the spell and at the start of each of your turns until the spell ends. If a structure drops to 0hp, it collapses and potentially damages nearby creatures. A creature within half the distance of a structure's height must make a Dexterity saving throw. On a failed save, the creature takes 5d6 bludgeoning damage, is knocked prone, and is buried in the rubble, requiring a DC 20 Athletics check as an action to escape. The DM can adjust the DC higher or lower depending on the nature of the rubble. On a successful save, the creature takes half as much damage and doesn't fall prone or become buried."
        
        let spell114: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell114.id = 114
        spell114.name = "Eldritch Blast"
        spell114.level = 0
        spell114.school = MagicSchool.Evocation
        spell114.ritual = false
        spell114.range = 120
        spell114.rangeType = RangeType.Target
        spell114.effectRangeType = EffectRangeType.Target
        spell114.damageDice = (1, 10)
        spell114.componentBlock = (true, true, false)
        spell114.castingTime = "1 action"
        spell114.duration = "Instantaneous"
        spell114.details = "\tA beam of cracking energy streaks toward a creature within range. Make a ranged spell attack against the target. On a hit, the target takes 1d10 force damage.\n\tThe spell creates more than one beam when you reach higher levels: two beams at 5th level, three beams at 11th level, and four beams at 17th level. You can direct the beams at the same target or at different ones. Make a separate attack roll for each beam."
        
        let spell115: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell115.id = 115
        spell115.name = "Elemental Weapon"
        spell115.level = 3
        spell115.school = MagicSchool.Transmutation
        spell115.ritual = false
        spell115.rangeType = RangeType.Touch
        spell115.effectRangeType = EffectRangeType.Target
        spell115.damageDice = (1, 4)
        spell115.componentBlock = (true, true, false)
        spell115.castingTime = "1 action"
        spell115.duration = "Concentration, up to 1 hour"
        spell115.details = "\tA nonmagical weapon you touch becomes a magic weapon. Choose one of the following damage types: acid, cold, fire, lightning, or thunder. For the duration, the weapon has a +1 bonus to attack rolls and deals an extra 1d4 damage of the chosen type when it hits.\n\tWhen using a higher-level spell slot, the bonus to attack rolls increases by 1 and the extra damage increases by 1d4 for each two additional spell levels."
        
        let spell116: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell116.id = 116
        spell116.name = "Enhance Ability"
        spell116.level = 2
        spell116.school = MagicSchool.Transmutation
        spell116.ritual = false
        spell116.rangeType = RangeType.Touch
        spell116.effectRangeType = EffectRangeType.Target
        spell116.componentBlock = (true, true, true)
        spell116.material = "fur or a feather from a beast"
        spell116.castingTime = "1 action"
        spell116.duration = "Concentration, up to 1 hour"
        spell116.details = "\tYou touch a creature and bestow upon it a magical enhancement. Choose one of the following effects; the target gains that effect until the spell ends.\n  \u{2022} Bear's Endurance: The target has advantage on Constitution checks. It also gains 2d6 temporary hit points, which are lost when the spell ends.\n  \u{2022} Bull's Strength: The target has advantage on Strength checks, and his or her carrying capacity doubles.\n  \u{2022} Cat's Grace: The target has advantage on Dexterity checks. It also doesn't take damage from falling 20 feet or less if it isn't incapacitated.\n  \u{2022} Eagle's Splendor: The target has advantage on Charisma checks.\n  \u{2022} Fox's Cunning: The target has advantage on Intelligence checks.\n  \u{2022} Owl's Wisdom: The target has advantage on Wisdom checks.\n\tWhen using a higher-level spell slot, you can target an additional creature for each additional spell level."
        
        let spell117: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell117.id = 117
        spell117.name = "Enlarge/Reduce"
        spell117.level = 2
        spell117.school = MagicSchool.Transmutation
        spell117.ritual = false
        spell117.range = 30
        spell117.rangeType = RangeType.Target
        spell117.effectRangeType = EffectRangeType.Target
        spell117.componentBlock = (true, true, true)
        spell117.material = "a pinch of powdered iron"
        spell117.castingTime = "1 action"
        spell117.duration = "Concentration, up to 1 minute"
        spell117.details = "\tYou cause a creature or an object you can see within range to grow larger or smaller for the duration. Choose either a creature or an object that is neither worn nor carried. If the target is unwilling, it can make a Constitution saving throw. On a success, the spell has no effect.\n\tIf the target is a creature, everything it is wearing and carrying changes size with it. Any item dropped by an affected creature returns to normal size at once.\n  \u{2022} Enlarge: The target's size doubles in all dimensions, and its weight is multiplied by eight. This growth increases its size by one category. If there isn't enough room for the target to double its size, the creature or object attains the maximum possible size in the space available. Until the spell ends, the target has advantage on Strength checks and Strength saving throws. The target's weapons also grow to match its new size. While these weapons are enlarged, the target's attacks with them deal 1d4 extra damage.\n  \u{2022} Reduce: The target's size is halved in all dimensions, and its weight is reduced to one-eighth of normal. This reduction decreases its size by one category. Until the spell ends, the target also has disadvantage on Strength checks and Strength saving throws. The target's weapons also shrink to match its new size. While these weapons are reduced, the target's attacks with them deal 1d4 less damage (though will not reduce their damage below 1)."
        
        let spell118: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell118.id = 118
        spell118.name = "Ensnaring Strike"
        spell118.level = 1
        spell118.school = MagicSchool.Conjuration
        spell118.ritual = false
        spell118.rangeType = RangeType.PSelf
        spell118.effectRangeType = EffectRangeType.Target
        spell118.damageDice = (1, 6)
        spell118.componentBlock = (true, false, false)
        spell118.castingTime = "1 bonus action"
        spell118.duration = "Concentration, up to 1 minute"
        spell118.details = "\tThe next time you hit a creature with a weapon attack before this spell ends, a writhing mass of thorny vines appears at the point of impact, and the target must succeed on a Strength saving throw or be restrained by the magical vines until the spell ends. A Large or larger creature has advantage on this saving throw. If the target succeeds on the save, the vines shrivel away.\n\tWhile restrained by this spell, the target takes 1d6 piercing damage at the start of each of its turns. A creature restrained by the vines or one that can touch the creature can use its action to make a Strength check against your spell save DC. On a success, the target is freed.\n\tWhen using a higher-level spell slot, the damage increases by 1d6 for each additional spell level."
        
        let spell119: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell119.id = 119
        spell119.name = "Entangle"
        spell119.level = 1
        spell119.school = MagicSchool.Conjuration
        spell119.ritual = false
        spell119.range = 90
        spell119.rangeType = RangeType.Target
        spell119.effectRange1 = 20
        spell119.effectRangeType = EffectRangeType.Cube
        spell119.componentBlock = (true, true, false)
        spell119.castingTime = "1 action"
        spell119.duration = "Concentration, up to 1 minute"
        spell119.details = "\tGrasping weeds and vines sprout from the ground in a 20-foot square starting from a point within range. For the duration, these plants turn the ground in the area into difficult terrain.\n\tA creature in the area when you cast the spell must succeed on a Strength saving throw or be restrained by the entangling plants until the spell ends. A creature restrained by the plants can use its action to make a Strength check against your spell save DC. On a success, it frees itself.\n\tWhen the spell ends, the conjured plants wilt away."
        
        let spell120: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell120.id = 120
        spell120.name = "Enthrall"
        spell120.level = 2
        spell120.school = MagicSchool.Enchantment
        spell120.ritual = false
        spell120.range = 90
        spell120.rangeType = RangeType.Target
        spell120.effectRangeType = EffectRangeType.Target
        spell120.componentBlock = (true, true, false)
        spell120.castingTime = "1 action"
        spell120.duration = "1 minute"
        spell120.details = "\tYou weave a distracting string of words, causing creatures of your choice that you can see within range and that can hear you to make a Wisdom saving throw. Any creatures that can't be charmed automatically succeed this throw, and if you or your companions are fighting a creature, it has advantage on this throw. On a failed save, the target has disadvantage on Perception checks made to perceive any creature other than you until the spell ends or until the target can no longer hear you. The spell ends if you are incapacitated or can no longer speak."
        
        let spell121: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell121.id = 121
        spell121.name = "Etherealness"
        spell121.level = 7
        spell121.school = MagicSchool.Transmutation
        spell121.ritual = false
        spell121.rangeType = RangeType.PSelf
        spell121.effectRangeType = EffectRangeType.Target
        spell121.componentBlock = (true, true, false)
        spell121.castingTime = "1 action"
        spell121.duration = "Up to 8 hours"
        spell121.details = "\tYou step into the border regions of the Ethereal Plane, in the area where it overlaps with your current plane. You remain in the Border Ethereal for the duration or until you use your action to dismiss the spell. During this time, you can move in any direction. If you move up or down, every foot of movement costs an extra foot. You can see and hear the plane you originated from, but everything there looks gray, and you can't see anything more than 60 feet away.\n\tWhile on the Ethereal Plane, you can only affect and be affected by other creatures on that plane. Creatures that aren't on the Ethereal Plane can't perceive you and can't interact with you, unless a special ability or magic has given them the ability to do so.\n\tYou ignore all objects and effects that arent on the Ethereal Plane, allowing you to move through objects you perceive on the plane you originated from.\n\tWhen the spell ends, you immediately return to the plane you originated from in the spot you currently occupy. If you occupy the same spot as a solid object or creature when this happens, you are immediately shunted to the nearest unoccupied space that you can occupy and take force damage equal to twice the number of feet you are moved.\n\tThis spell has no effect if you cast it while you are on the Ethereal Plane or on a plane that doesn't border it, such as one of the Outer Planes.\n\tWhen using a higher-level spell slot, you may target up to three willing creatures (including you) for each additional spell level, providing they are all within 10 feet of you when you cast this spell."
        
        let spell122: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell122.id = 122
        spell122.name = "Evard's Black Tentacles"
        spell122.level = 4
        spell122.school = MagicSchool.Conjuration
        spell122.ritual = false
        spell122.range = 90
        spell122.rangeType = RangeType.Target
        spell122.effectRange1 = 20
        spell122.effectRangeType = EffectRangeType.Cube
        spell122.damageDice = (3, 6)
        spell122.componentBlock = (true, true, true)
        spell122.material = "a piece of tentacle from a giant octopus or a giant squid"
        spell122.castingTime = "1 action"
        spell122.duration = "Concentration, up to 1 minute"
        spell122.details = "\tSquirming, ebony tentacles fill a 20-foot square on the ground that you can see within range. For the duration, these tentacles turn the ground in the area into difficult terrain.\n\tWhen a creature enters the affected area for the first time on a turn or starts its turn there, the creature must succeed on a Dexterity saving throw or take 3d6 bludgeoning damage and be restrained by the tentacles until the spell ends. A creature that starts its turn in the area and is already restrained by the tentacles takes 3d6 bludgeoning damage.\n\tA creature restrained by the tentacles can use its action to make a Strength or Dexterity check (its choice) against your spell save DC. On a success, it frees itself."
        
        let spell123: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell123.id = 123
        spell123.name = "Expeditious Retreat"
        spell123.level = 1
        spell123.school = MagicSchool.Transmutation
        spell123.ritual = false
        spell123.rangeType = RangeType.PSelf
        spell123.effectRangeType = EffectRangeType.Target
        spell123.componentBlock = (true, true, true)
        spell123.material = "a piece of tentacle from a giant octopus or a giant squid"
        spell123.castingTime = "1 bonus action"
        spell123.duration = "Concentration, up to 10 minutes"
        spell123.details = "\tThis spell allows you to move at an incredible pace. When you cast this spell, and then as a bonus action on each of your turns until the spell ends, you can take the Dash action."
        
        let spell124: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell124.id = 124
        spell124.name = "Eyebite"
        spell124.level = 6
        spell124.school = MagicSchool.Necromancy
        spell124.ritual = false
        spell124.rangeType = RangeType.PSelf
        spell124.effectRange1 = 60
        spell124.effectRangeType = EffectRangeType.Sphere
        spell124.componentBlock = (true, true, false)
        spell124.castingTime = "1 action"
        spell124.duration = "Concentration, up to 1 minute"
        spell124.details = "\tFor the spell's duration, your eyes become an inky void imbued with dread power. One creature of your choice within 60 feet of you that you can see must succeed on a Wisdom saving throw or be affected by one of the following effects of your choice for the duration. On each of your turns until the spell ends, you can use your action to target another creature but can't target a creature again if it has succeeded on a saving throw against this casting of Eyebite.\n  \u{2022} Asleep: The target falls unconscious. It wakes up if it takes any damage or if another creature uses its action to shake the sleeper awake.\n  \u{2022} Panicked: The target is frightened of you. On each of its turns, the frightened creature must take the Dash action and move away from you by the safest and shortest available route, unless there is nowhere to move. If the target moves to a place at least 60 feet away from you where it can no longer see you, this effect ends.\n  \u{2022} Sickened: The target has disadvantage on attack rolls and ability checks. At the end of each of its turns, it can make another Wisdom saving throw. If it succeeds, the effect ends."
        
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