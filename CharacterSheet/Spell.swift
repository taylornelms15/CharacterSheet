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
                return "Self (\(effectRange1)x\(effectRange1)x\(effectRange1)-ft Cube)"
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
                return "\(range) ft (\(effectRange1)x\(effectRange1)x\(effectRange1)-ft Cube)"
            }//effectRangeType
        case RangeType.Touch:
            return "Touch"
        }//rangeType
    }//rangeStringf
    
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
        spell1.details = "You hurl a bubble of acid. Does damage to either one creature in range, or two creatues in range within 5 ft of each other. Target must make a Dexterity saving throw, or else takes acid damage.\nDamage increases by 1d6 at 5th level, 11th level, and 17th level."
        
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
        spell2.details = "Choose up to three creatures within range. Their hit point maximum and current hit points increase by 5 for the duration.\nWhen using a higher spell slot, the hit point increase is 5 more per spell level."
        
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
        spell3.details = "Choose a door, window, or an area within range no larger than a 20-ft cube. Until the spell ends, an alarm alerts you whenever a Tiny or larger creature touches or enters the warded area. You may exclude creatures from the alarm, and decide whether it is mental or audible.\nA mental alerm alerts you with a ping in your mind if you are within 1 mile of the warded area, and awakens you if you are sleeping.\nAn audible alarm produces the sound of a hand bell for 10 seconds within 60 feet."
        
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
        spell4.details = "You assume a different form. When you cast the spell, choose one of the options, the effects of which last for the duration. While the spell is active, you can switch between options as an action.\nAquatic Adaptation: You sprout gills and grow webbing between your fingers. You can breathe underwater and gain a swimming speed equal to your walking speed.\nChange Appearance: You transform your appearance. You decide what you look like, including how you sound, racial appearance, and distinguishing characteristics. You are limited to looking roughly the same size, and your basic shape remains the same. You may, as an action, change your appearance again.\nNatural Weapons: You grow claws, fangs, spines, horns, or a different natural weapon of your choice. Your unarmed strikes deal 1d6 damage, and you are proficient in them. Additionally, this weapon is magic and you have a +1 bonus to attack and damage rolls with it."
        
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
        spell5.details = "You convince a beast that you mean it no harm. This spell fails if the beast's Intelligence is 4 or higher, or if the beast succeeds a Wisdom saving throw. This spell ends if you or one of your companions harms the beast.\nWhen using a higher spell slot, you may charm one additional beast per spell level."
        
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
        spell6.details = "Choose a Tiny beast in range, such as a squirrel, blue jay, or bat. You specify a location you have visited, and a recipient who matches a general description. You speak a message of up to 25 words. The animal travels for the duration of the spell to the target, covering about 50 miles for a flying animal or 25 miles for other animals.\nWhen the messenger arrives, it delivers the message to the creature you described, replicating the sound of your voice. It speaks only to a creature matching the description you gave.\nWhen using a higher spell slot, the duration increases by 48 hours per spell level."
        
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
        spell7.details = "Choose any number of willing creatures that you can see within range. You transform each into the form of a Large or smaller beast with a challenge rating of 4 or lower. On subsequent turns, you can use your action to transform affected creatures into new forms.\nThe transformation lasts for the duration for each target, or until the target drops to 0hp or dies. You may choose different forms for each target. Each target's statistics are replaced temporarily by those of the chosen beast, though they retain their alignment, Intelligence, Wisdom, and Charisma scores. It assumes the target beast's hit points, and reverts to its former hit points on transforming back. If the target is reverting after dropping below 0hp, it takes any damage in excess of what its beast form took prior to death. The target is unable to speak or cast spells, and is limited in the actions it can take by its new form.\nThe target's gear melds into their new form, and while they do not lose any gear, they cannot benefit from it."
        
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
        spell8.details = "This spell creates an undead servant. Choose a corpse or pile of bones of a Medium or Small humanoid within range. Your spell transforms this creature into a skeleton if starting with bones, or a zombie if starting with a corpse.\nOn each of your turns, you can use a bonus action to mentally command any creature you made with this spell if the creature is within 60 ft of you. If you control multiple creatures this way, you may issue commands to each of them. You may specify the creature's next action and movement, or issue a general command, such as to guard a particular chamber. Without a command, the creature only defends itself against hostile creatures.\nThe creature is under your control for 24 hours, at which point it stops obeying any command you have given it. You may use this spell again to re-assert control of up to four creatures for the next 24 hours.\nWhen using a higher spell slot, you animate or reassert control over two additional undead creatures per spell level. Each creature must come from a different set of remains."
        
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
        spell9.details = "Objects come to life at your command. Choose up to ten nonmagical objects within range that are not being worn or carried. Medium targets count for 2, Large objects count for 4, Huge targets count for 8, and you may not animate anything larger than Huge. Each target animates and becomes a creature under your control until the spell ends or it is reduced to 0hp.\nAs a bonus action, you can mentally command any creature you made this way within 500 ft of you. If you control multiple objects this way, you may issue commands to each of them. You may specify the object's next action and movement, or issue a general command, such as to guard a particular chamber. Without a command, the object only defends itself against hostile creatures.\nAn animated object is a construct with AC, hit points, attacks, Strength, and Dexterity determined by its size. Its Constitution is 10, its Intelligence and Wisdom are 3, and its Charisma is 1. It's speed is 30 ft, and if it has no legs or other means of locomotion, it has a flying speed of 30 ft and can hover. If it is securely attached to something, its speed is 0 ft. It has blindsight with a radius of 30 ft and is blind beyond that distance. When it drops to 0hp, it reverts to its non-animated form, and any excess damage is transferred to its original form.\nOn telling the object to attack, it can make a single melee attack against a creature within 5 ft, making a slam attack with an attack bonus and bludgeoning damage determined by its size.\nWhen using a higher spell slot, you can animate two additional objects per spell level."//TODO: add table of object stats
        
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
        spell10.details = "A shimmering barrier extends out from you and moves with you, remaining centered on you and hedging out creatures other than undead and constructs.\nThe barrier prevents an affected creature from passing or reaching through, but the creature may still cast spells or make attacks with ranged or reach weapons through the barrier.\nIf you move so that an affected creature is forced to pass through the barrier, the spell ends."
        
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
        spell11.details = "An invisible sphere of antimagic surrounds you. Within the sphere, spells cannot be cast, summoned creatures disappear, and magic items become mundane. Until the spell ends, the sphere moves with you, centered on you.\nSpells and other magical effects, except those created by an artifact or deity, are suppressed in the sphere and cannot protrude into it. A slot expended to cast a suppressed spell is consumed. While a spell is suppressed, it does not function, but the time it spends suppressed counts against its duration."
        
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
        spell12.details = "This spell attracts or repels creatures of your choice. You target something within range, either a Huge or smaller object or a creature or an area no larger than a 200-ft cube. Then specify a kind of intelligent creature, such as red dragons, goblins, or vampires. You invest the target with an aura that attracts or repels the creatures for the duration. Choose antipathy or sympathy as the aura's effect.\nAntipathy: The enchantment causes creatures of the kind you designated to feel an urge to leave the area and avoid the target. When such a creature can see the target or comes within 60 ft of it, the creature must either succeed on a Wisdom saving throw, or become frightened while the creature is in range.\nSympathy: The enchantment causes creatures of the kind you designated to feel an urge to approach the target while within 60 feet of it or able to see it. When such a creature can see the target or comes within 60 ft of it, the creature must either succeed on a Wisdom saving throw, or use its movement on each of its turns to enter the area or move within reach of the target.\nIf the target damages or otherwise harms an affected creature, the affected creature can make a Wisdom saving throw to end the effect.\nEnding the Effect: if an affected creature ends its turn while not within 60 feet of the target or able to see it, the creature makes a Wisdom saving throw. On a successful save, the creature is no longer affected by the target and recognizes the prior feelings as magical. In addition, a creature affected by the spell is allowed another Wisdom saving throw every 24 hours while the spell persists./nA creature that makes a successful saving throw is immune to this spell's effects for 1 minute."
        
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
        spell13.details = "You create an invisible, magical eye within range that hovers in the air for the duration.\nYou mentally receive visual information from the eye, which has normal vision and dark vision out to 30 ft. The eye can look in every direction.\nAs an action, you can move the eye up to 30 ft in any direction. There is no limit to how far away from you it can move, but it cannot enter another plane of existence or pass through solid barriers. The eye can pass through an opening as small as 1 inch in diameter."
        
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
        spell14.details = "You create linked teleportation portals that remain open for the duration. Choose two points on the ground that you can see, one within 10 ft of you and one within 500 ft of you. A circular portal opens over each point, though fails to do so if it is in the space occupied by a creature.\nThe portals are two-dimensional glowing rings filled with mist, hovering over the ground and perpendicular to it at the points you choose, and visible only from one side.\nAny creature entering the portal on one end exits the other end as if they were adjacent. The mist that fills each portal blocks vision through it. On your turn, you may rotate the rings as a bonus action so that the active side faces in a different direction."
        
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
        spell15.details = "You touch a closed door, window, gate, chest, or other entryway, and it becomes locked for the duration. You and any creatures you designate upon casting may open the object normally. You may also set a password that suppresses the spell for one minute when spoken within 5 ft of the object. The object is otherwise impassable until it is borken or the spell is dispelled or suppressed. Casting \"knock\" on the object suppresses the spell for 10 minutes.\nWhuke affected by this spell, the object is more difficult to break or force open; the DC to break it or pick any locks on it increases by 10."
        
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
        spell16.details = "A protective magical force surrounds you, manifesting as a spectral frost that covers you and your gear. You gain 5 temporary hit points for the duration. If a creature hits you with a melee attack while you have these hit points, the creature takes 5 cold damage.\nWhen using a higher spell slot, both the temporary hit points and the cold damage increase by 5 for each additional spell level."
        
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
        spell17.details = "You invoke the power of Hadar, the Dark Hunger. Tendrils of dark energy erupt from you and batter all creatures within range. Each creature must make a Strength saving throw. On a failed save, each target takes 2d6 necrotic damage, and cannot take reactions until its next turn. On a successful save, the creature takes half this damage, but suffers no other ill effects.\nWhen using a higher spell slot, the damage increases by 1d6 for each additional spell level."
        
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
        spell18.details = "You and up to eight willing creatures within range project your astral bodies into the Astral Plane (the spell fails and the casting is wasted if you are already on that plane). The material body you leave behind is unconscious and in a state of suspended animation; it doesn't need food or air and doesn't age.\nYour astral body resembles your mortal form in almost every way, replicating your game statistics and possessions. The principal difference is the adoption of a silvery cord that extends from between your shoulder blades and trails behind you, fading to invisibility after 1 foot. This cord is your tether to your material body. As long as the tether remains intact, you can find your way home. If the cord is cut - something that can happen only when an effect specifically states that it does - your soul and body are separated, killing you instantly.\nYour astral form can freely travel through the Astral Plane and can pass through portals there leading to any other plane. If you enter a new plane or return to the plane you were on when casting this spell, your body and possessions are transported along the silver cord, allowing you to re-enter your mody as you enter the new plane. Your astral form is a separate incarnation. Any damage or other effects that apply to it have no effect on your physical body, nor do they persist when you return to it.\nThe spell ends for you and your companions when you use your action to dismiss it. When the spell ends, the affected creature returns to its physical body, and it awakens.\nThe spell might also end early for you or one of your companions. A successful Dispel Magic spell used against an astral or physical body ends the spell for that creature. If a creature's original body or its astral form drops to 0 hit points, the spell ends for that creature. If the spell ends and the silver cord is intact, the cord pulls the creature's astral form back to its body, ending its state of suspended animation.\nIf you are returned to your body prematurely, your companions remain in their astral forms and must find their own way back to their bodies, usually by dropping to 0 hit points."
        
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
        spell19.details = "By casting gem-inlaid sticks, rolling dragon bones, laying out cards, or employing some other divining tool, you receive an omen from an otherworldly entity about the results of a specific course of action that you plan to take within the next 30 minutes. The DM chooses from the following possible omens:\nWeal, for good results\nWoe, for bad results\nWeal and Woe, for both good and bad results\nNothing, for results that are neither good nor bad\nThe spell doesn't take into account any possible circumstances that might change the outcome, such as the casting of additional spells or the loss or gain of a companion.\nIf you cast the spell two or more times before completing your next long rest, there is a cumulative 25% chance for each casting after the first that you get a random reading. The DM makes this roll in secret."
        
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
        spell20.details = "Life-preserving energy radiates from you in an aura with a 30-ft radius. Until the spell ends, the aura moves with you. Each nonhostile creature in the aura (including yourself) has resistance to necrotic damage, and its hit point maximum can't be reduced. In addition, a nonhostile, living creature regains 1 hit point when it starts its turn in the aura with 0 hit points."
        
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
        spell21.details = "Purifying energy radiates from you in an aura with a 30-ft radius. Until the spell ends, the aura moves with you. Each nonhostile creature in the aura (including yourself) has resistance to poison damage, can't become diseased, and has advantage on savings throws against effects that cause any of the following conditions: blinded, charmed, deafened, frightened, paralyzed, poisoned, and stunned."
        
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
        spell22.details = "Healing energy radiates from you in an aura with a 30-ft radius. Until the spell ends, the aura moves with you. You can use a bonus action to cause one creature in the aura (including yourself) to regain 2d6 hit points."
        
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
        spell23.details = "After spending the casting time tracing magical pathways within a precious gemstone, you touch a Huge or smaller beast or plant. The target must have either no Intelligence score or an Intelligence of 3 or less. The target gains an Intelligence of 10. The target also gains the ability to speak one language you know. If the target is a plant, it gains the ability to move its limbs, roots, vines, creepers, and so forth, and it gains senses similar to a human's. Your DM chooses statistics appropriate for the awakened plant.\nThe awakened beast or plant is charmed by you for 30 days or until you or your companions do anything harmful to it. When the charmed condition ends, the awakened creature chooses whether to remain friendly to you, based on how you treated it while it was charmed."
        
        let spell24: Spell = NSManagedObject(entity: spellEntity, insertIntoManagedObjectContext: context) as! Spell
        spell24.id = 24
        spell24.name = "Bane"
        spell24.level = 1
        spell24.school = MagicSchool.Enchantment
        spell24.ritual = false
        spell24.range = 30
        spell24.rangeType = RangeType.Target
        spell24.effectRangeType = EffectRangeType.Target
        spell24.componentBlock = (true, false, true)
        spell24.material = "a drop of blood"
        spell24.castingTime = "1 action"
        spell24.duration = "Concentration, up to 1 minute"
        spell24.details = "Up to three creatures of your choice in range must make Charisma saving throws. Whenever a target that fails this saving throw makes an attack roll or a saving throw before the spell ends, the target must roll a d4 and subtract the number rolled from the attack roll or saving throw.\nWhen using a higher spell slot, you can target one additional creature for each additional spell level."
        
        
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