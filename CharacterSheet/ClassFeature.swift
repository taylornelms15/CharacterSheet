//
//  ClassFeature.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 5/10/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import Foundation
import CoreData


class ClassFeature: Feature {

    @NSManaged var level: Int16
    @NSManaged var pclass: PClass?
    @NSManaged var subclass: Subclass?
    @NSManaged var lowerVariants: Set<ClassFeature>?
    @NSManaged var higherVariants: Set<ClassFeature>?
    @NSManaged var childChoiceList: ClassFeatureChoiceList?
    @NSManaged var parentChoiceList: ClassFeatureChoiceList?
    
    
    //TODO: make id's make sense for all this
    
    static func classFeatureInit(context: NSManagedObjectContext){
        
        let cfEntity: NSEntityDescription = NSEntityDescription.entityForName("ClassFeature", inManagedObjectContext: context)!
        let cfclEntity: NSEntityDescription = NSEntityDescription.entityForName("ClassFeatureChoiceList", inManagedObjectContext: context)!
        
        let fetchRequest = NSFetchRequest(entityName: "PClass")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        let fetchRequest2 = NSFetchRequest(entityName: "Subclass")
        fetchRequest2.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        var classResults: [PClass] = []
        var subclassResults: [Subclass] = []
        do{
            try classResults = context.executeFetchRequest(fetchRequest) as! [PClass]
            try subclassResults = context.executeFetchRequest(fetchRequest2) as! [Subclass]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
        
        //MARK: Barbarian
        
        let classFeature1: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature1.id = 201
        classFeature1.name = "Unarmored Defense"
        classFeature1.level = 1
        classFeature1.pclass = classResults[0]
        classFeature1.details = "\tWhile you are not wearing any armor, your Armor Class equals 10 + your Dexterity modifier + your Constitution modifier. You can use a shield and still gain this benefit."
        
        let classFeature2: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature2.id = 202
        classFeature2.name = "Rage"
        classFeature2.level = 1
        classFeature2.pclass = classResults[0]
        classFeature2.details = "\tIn battle, you fight with primal ferocity. On your turn, you may enter a rage as a bonus action.\n\tWhile raging, you gain the following benefits if you aren't weaking heavy armor:\n  \u{2022} You have advantage on Strength checks and Strength saving throws\n  \u{2022} When you make a melee weapon attack using Strength, you gain a bonus to the damage roll that increases with your barbarian level. (+2 at level 1, +3 at level 9, and +4 at level 16.)\n  \u{2022} You have resistance to bludgeoning, piercing, and slashing damage.\n\tIf you are able to cast spells, you can't cast them or concentrate on them while raging.\n\tYour rage lasts for 1 minute. It ends early if you are knocked unconscious or if your turn ends and you haven't attacked a hostile creature since your last turn or taken damage since then. You can also end your rage on your turn as a bonus action.\n\tYou may rage a certain number of times per long rest according to your Barbarian level:\n  \u{2022} 1: 2 rages\n  \u{2022} 3: 3 rages\n  \u{2022} 6: 4 rages\n  \u{2022} 12: 5 rages\n  \u{2022} 17: 6 rages\n  \u{2022} 20: unlimited rages"
        
        let classFeature3: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature3.id = 203
        classFeature3.name = "Reckless Attack"
        classFeature3.level = 2
        classFeature3.pclass = classResults[0]
        classFeature3.details = "\tYou can throw aside all concern for defense to attack with fierce desperation. When you make your first attack on your turn, you can decide to attack recklessly. Doing so gives you advantage on melee weapon attack rolls using Strength during this turn, but attack rolls against you have advantage until your next turn."
        
        let classFeature4: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature4.id = 204
        classFeature4.name = "Danger Sense"
        classFeature4.level = 2
        classFeature4.pclass = classResults[0]
        classFeature4.details = "\tYou have an uncanny sense of when things nearby aren't as they should be, giving you an edge when you dodge away from danger.\n\tYou have advantage on Dexterity saving throws against effects that you can see, such as traps and spells. To gain this benefit, you can't be blinded, deafened, or incapacitated."
        
        let classFeature5: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature5.id = 205
        classFeature5.name = "Frenzy"
        classFeature5.level = 3
        classFeature5.subclass = subclassResults[0]//Path of the Berserker
        classFeature5.details = "\tYou can go into a frenzy when you rage. If you do so, for the duration of your rage you can make a single melee weapon attack as a bonus action on each of your turns after this one. When your rage ends, you suffer one level of exhaustion."
        
        let classFeature6: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature6.id = 206
        classFeature6.name = "Spirit Seeker"
        classFeature6.level = 3
        classFeature6.subclass = subclassResults[1]//Path of the Totem Warrior
        classFeature6.details = "\tYours is a path that seeks attunement with the natural world, giving you a kinship with beasts. You have the ability to cast the Beast Sense and Speak With Animals spells, but only as rituals."
        
        let classFeature7: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature7.id = 207
        classFeature7.name = "Ability Score Improvement"
        classFeature7.level = 4
        classFeature7.pclass = classResults[0]
        classFeature7.details = "\tYou can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can't increase an ability score above 20 using this feature."
        
        let classFeature8: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature8.id = 208
        classFeature8.name = "Ability Score Improvement (2)"
        classFeature8.level = 8
        classFeature8.pclass = classResults[0]
        classFeature8.details = "\tYou can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can't increase an ability score above 20 using this feature."
        classFeature8.lowerVariants!.insert(classFeature7)
        
        let classFeature9: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature9.id = 209
        classFeature9.name = "Ability Score Improvement (3)"
        classFeature9.level = 12
        classFeature9.pclass = classResults[0]
        classFeature9.details = "\tYou can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can't increase an ability score above 20 using this feature."
        classFeature9.lowerVariants!.insert(classFeature7)
        classFeature9.lowerVariants!.insert(classFeature8)
        
        let classFeature10: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature10.id = 210
        classFeature10.name = "Ability Score Improvement (4)"
        classFeature10.level = 16
        classFeature10.pclass = classResults[0]
        classFeature10.details = "\tYou can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can't increase an ability score above 20 using this feature."
        classFeature10.lowerVariants!.insert(classFeature7)
        classFeature10.lowerVariants!.insert(classFeature8)
        classFeature10.lowerVariants!.insert(classFeature9)
        
        let classFeature11: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature11.id = 211
        classFeature11.name = "Extra Attack"
        classFeature11.level = 5
        classFeature11.pclass = classResults[0]
        classFeature11.details = "\tYou can attack twice, instead of once, whenever you take the Attack action on your turn."
        
        let classFeature12: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature12.id = 212
        classFeature12.name = "Fast Movement"
        classFeature12.level = 5
        classFeature12.pclass = classResults[0]
        classFeature12.details = "\tYour speed increases by 10 feet while you aren't wearng heavy armor."
        
        let classFeature13: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature13.id = 213
        classFeature13.name = "Mindless Rage"
        classFeature13.level = 6
        classFeature13.subclass = subclassResults[0]//Path of the Berserker
        classFeature13.details = "\tYou can't be charmed or frightened while raging. If you are charmed or frightened when you enter your rage, the effect is suspended for the duration of the rage."
        
        //Oops, did this bit out of order
        
        let classFeatureChoiceList1: ClassFeatureChoiceList = NSManagedObject(entity: cfclEntity, insertIntoManagedObjectContext: context) as! ClassFeatureChoiceList
        classFeatureChoiceList1.id = 1
        classFeatureChoiceList1.name = "Totem Spirit Animal"
        
        let classFeature14: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature14.id = 214
        classFeature14.name = "Totem Spirit"
        classFeature14.level = 3
        classFeature14.subclass = subclassResults[1]//Path of the Totem Warrior
        classFeature14.details = "\tYou choose a totem spirit and gain its feature. You must make or acquire a physical totem object - an amulet or similar adornment - that incorporates fur ot feathers, claws, teeth, or bones of the totem animal. At your option, you also gain minor physical attributes that ae reminiscent of your totem spirit.\n\tYour totem animal might be an animal related to those listed here but more appropriate to your homeland."
        classFeature14.childChoiceList = classFeatureChoiceList1
        
        let classFeature15: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature15.id = 215
        classFeature15.name = "Bear Totem Spirit"
        classFeature15.level = 3
        classFeature15.details = "\tWhile raging, you have resistance to all damage except psychic damage. The spirit of the bear makes you touch enough to stand up to any punishment."
        classFeature15.parentChoiceList = classFeatureChoiceList1
        
        let classFeature16: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature16.id = 216
        classFeature16.name = "Eagle Totem Spirit"
        classFeature16.level = 3
        classFeature16.details = "\tWhile you're raging and aren't wearing heavy armor, other creatures have disadvantage on opportunity attack rolls against you, and you can use the Dash action as a bonus action on your turn. The spirit of the eagle makes you into a predator who can weave through the fray with ease."
        classFeature16.parentChoiceList = classFeatureChoiceList1
        
        let classFeature17: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature17.id = 217
        classFeature17.name = "Wolf Totem Spirit"
        classFeature17.level = 3
        classFeature17.details = "\tWhile you're raging, your friends have advantage on melee attack rolls against any creature within 5 feet of you that is hostile to you. The spirit of the wold makes you a leader of hunters."
        classFeature17.parentChoiceList = classFeatureChoiceList1
        
        let classFeatureChoiceList2: ClassFeatureChoiceList = NSManagedObject(entity: cfclEntity, insertIntoManagedObjectContext: context) as! ClassFeatureChoiceList
        classFeatureChoiceList2.id = 2
        classFeatureChoiceList2.name = "Beast Aspect"
        
        let classFeature18: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature18.id = 218
        classFeature18.name = "Aspect of the Beast"
        classFeature18.level = 6
        classFeature18.subclass = subclassResults[1]//Path of the Totem Warrior
        classFeature18.details = "\tYou have a magical benefit based on the totem animal of your choice. You can choose the same animal you selected at 3rd level or a different one."
        classFeature18.childChoiceList = classFeatureChoiceList2
        
        let classFeature19: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature19.id = 219
        classFeature19.name = "Bear Aspect"
        classFeature19.level = 6
        classFeature19.details = "\tYou gain the might of a bear. Your carrying capacity (including maximum load and maximum lift) is doubled, and you have advantage on Strength checks made to push, pull, lift, or break objects."
        classFeature19.parentChoiceList = classFeatureChoiceList2
        
        let classFeature20: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature20.id = 220
        classFeature20.name = "Eagle Aspect"
        classFeature20.level = 6
        classFeature20.details = "\tYou gain the eyesight of an eagle. You can see up to 1 mile away with no difficulty, able to discern even fine details as though looking at something no more than 100 feet away from you. Additionally, dim light doesn't impose disadvantage on your Perception checks."
        classFeature20.parentChoiceList = classFeatureChoiceList2
        
        let classFeature21: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature21.id = 221
        classFeature21.name = "Wolf Aspect"
        classFeature21.level = 6
        classFeature21.details = "\tYou gain the hunting sensibilities of a wolf. You can track other creatures while traveling at a fast pace, and you can move stealthily while traveling at a normal pace."
        classFeature21.parentChoiceList = classFeatureChoiceList2
        
        let classFeature22: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature22.id = 222
        classFeature22.name = "Feral Instinct"
        classFeature22.level = 7
        classFeature22.pclass = classResults[0]
        classFeature22.details = "\tYour instincts are so honed that you have advantage on initiative rolls.\n\tAdditionally, if you are surprised at the beginning of combat and aren't incapacitated, you can act normally on your first turn, but only if you enter your rage before doing anything else on that turn."
        
        let classFeature23: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature23.id = 223
        classFeature23.name = "Brutal Critical"
        classFeature23.level = 9
        classFeature23.pclass = classResults[0]
        classFeature23.details = "\tYou can roll one additional weapon damage die when determining the extra damage for a critical hit with a melee attack."
        
        let classFeature24: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature24.id = 224
        classFeature24.name = "Brutal Critical (2)"
        classFeature24.level = 13
        classFeature24.pclass = classResults[0]
        classFeature24.details = "\tYou can roll two additional weapon damage dice when determining the extra damage for a critical hit with a melee attack."
        classFeature24.lowerVariants?.insert(classFeature23)
        
        let classFeature25: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature25.id = 225
        classFeature25.name = "Brutal Critical (3)"
        classFeature25.level = 17
        classFeature25.pclass = classResults[0]
        classFeature25.details = "\tYou can roll three additional weapon damage dice when determining the extra damage for a critical hit with a melee attack."
        classFeature25.lowerVariants!.insert(classFeature23)
        classFeature25.lowerVariants!.insert(classFeature24)
        
        let classFeature26: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature26.id = 226
        classFeature26.name = "Intimidating Presence"
        classFeature26.level = 10
        classFeature26.subclass = subclassResults[0]//Path of the Berserker
        classFeature26.details = "\tYou can use your action to frighten someone with your menacing presence. When you do so, choose one creature that you can see within 30 feet of you. If the creature can see or hear you, it must succeed on a Wisdom saving throw (DC equal to 8 + your proficiency bonus + your Charisma modifier) or be frightened of you until the end of your next turn. On subsequent turns, you can use your action to extend the duration of this effect on the frightened creature until the end of your next turn. This effect ends if the creature ends its turn out of line of sight or more than 60 feet away from you."
        
        let classFeature27: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature27.id = 227
        classFeature27.name = "Spirit Walker"
        classFeature27.level = 10
        classFeature27.subclass = subclassResults[1]//Path of the Totem Warrior
        classFeature27.details = "\tYou can cast the Commune with Nature spell, but only as a ritual. When you do so, a spiritual version of one of the animals you chose for Totem Spirit or Aspect of the Beast appears to you to convey the information you seek."
        
        let classFeature28: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature28.id = 228
        classFeature28.name = "Retaliation"
        classFeature28.level = 14
        classFeature28.subclass = subclassResults[0]//Path of the Berserker
        classFeature28.details = "\tWhen you take damage from a creature that is within 5 feet of you, you can use your reaction to make a melee weapon attack against that creature."
        
        let classFeatureChoiceList3: ClassFeatureChoiceList = NSManagedObject(entity: cfclEntity, insertIntoManagedObjectContext: context) as! ClassFeatureChoiceList
        classFeatureChoiceList3.id = 3
        classFeatureChoiceList3.name = "Totemic Attunement"
        
        let classFeature29: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature29.id = 229
        classFeature29.name = "Totemic Attunement"
        classFeature29.level = 14
        classFeature29.subclass = subclassResults[1]//Path of the Totem Warrior
        classFeature29.details = "\tYou gain a magical benefit based on a totem animal of your choice. You can choose the same animal you selected previously or a different one."
        classFeature29.childChoiceList = classFeatureChoiceList3
        
        let classFeature30: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature30.id = 230
        classFeature30.name = "Bear Attunement"
        classFeature30.level = 14
        classFeature30.details = "\tWhile you're raging, any creature within 5 feet of you that's hostile to you has disadvantage on attack rolls against targets other than you or another character with this feature. An enemy is immune to this effect if it can't see or hear you or if it can't be frightened."
        classFeature30.parentChoiceList = classFeatureChoiceList3
        
        let classFeature31: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature31.id = 231
        classFeature31.name = "Eagle Attunement"
        classFeature31.level = 14
        classFeature31.details = "\tWhile raging, you have a flying speed equal to your current walking speed. This benefit works only in short bursts; you fall if you end your turn in the air and nothing else is holding you aloft."
        classFeature31.parentChoiceList = classFeatureChoiceList3
        
        let classFeature32: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature32.id = 232
        classFeature32.name = "Wolf Attunement"
        classFeature32.level = 14
        classFeature32.details = "\tWhile you're raging, you can use a bonus action on your turn to knock a Large or smaller creature prone when you hit it with a melee weapon attack."
        classFeature32.parentChoiceList = classFeatureChoiceList3
        
        let classFeature33: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature33.id = 233
        classFeature33.name = "Persistent Rage"
        classFeature33.level = 15
        classFeature33.pclass = classResults[0]
        classFeature33.details = "\tYour rage is so feirce that it ends early only if you fall unconscious or if you choose to end it."
        
        let classFeature34: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature34.id = 234
        classFeature34.name = "Indomitable Might"
        classFeature34.level = 18
        classFeature34.pclass = classResults[0]
        classFeature34.details = "\tIf your total for a Strength check is less than your Strength score, you can use that score in place of the total."
        
        let classFeature35: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature35.id = 235
        classFeature35.name = "Primal Champion"
        classFeature35.level = 20
        classFeature35.pclass = classResults[0]
        classFeature35.details = "\tYou embody the power of the wilds. Your Strength and Constitution scores increase by 4. Your maximum for those scores is now 24."

        
        
        
        
        
        
        //Placeholder class features (1 per class or subclass)
        
        let classFeature102: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature102.id = 302
        classFeature102.name = "Bardic Inspiration"
        classFeature102.level = 1
        classFeature102.pclass = classResults[1]
        classFeature102.details = "\tYou can inspire others through stirring words or music. To do so, you use a bonus action on your turn to choose one creature other than yourself within 60 feet of you who can hear you. That creature gains one Bardic Inspiration die, a d6.\n\tOnce within the next 10 minutes, the creature can roll the die and add the number rolled to one ability check, attack roll, or saving throw it makes. The creature can wait until after it rolls the d20 before deciding to use the Bardic Inspiration die, but must decide before the DM says whether the roll succeeds or fails. Once the Bardic Inspiration die is rolled, it is lost. A creature can have only one Bardic Inspiration die at a time.\n\tYou can use this feature a number of times equal to your Charisma modifier (a minimum of once). You regain any expended uses when you finish a long rest."
        
        //Note: will have spells (?) associated with it
        let classFeature103: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature103.id = 303
        classFeature103.name = "Channel Divinity"
        classFeature103.level = 2
        classFeature103.pclass = classResults[2]
        classFeature103.details = "\tYou gain the ability to channel divine energy directly from your deity, using that energy to fuel magical effects. You start with two such effects: Turn Undead and an effect determined by your domain. Some domains grant you additional effects as you advance in levels, as noted in the domain description.\n\tWhen you use your Channel Divinity, you choose which effect to creatre. You must then finish a short or long rest to use your Channel Divinity again.\n\tSome Channel Divinity effects require saving throws. When you use such an effect from this class, the DC equals your cleric spell save DC."
        
        let classFeature104: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature104.id = 304
        classFeature104.name = "Druidic"
        classFeature104.level = 1
        classFeature104.pclass = classResults[3]
        classFeature104.details = "\tYou know Druidic, the secret language of druids. You can speak the language and use it to leave hidden messages. You and others who know this language automatically spot such a message. Others spot the message's presence with a successful DC 15 Perception check but can't decipher it without magic."
        
        let classFeature105: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature105.id = 305
        classFeature105.name = "Second Wind"
        classFeature105.level = 1
        classFeature105.pclass = classResults[4]
        classFeature105.details = "\tYou have a limited well of stamina that you can draw on to protect yourself from harm. On your turn, you can use a bonus action to regain hit points equal to 1d10 + your fighter level. Once you use this feature, you must finish a short or long rest before you can use it again."
        
        let classFeature106: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature106.id = 306
        classFeature106.name = "Unarmored Defense"
        classFeature106.level = 1
        classFeature106.pclass = classResults[5]
        classFeature106.details = "\tWhile you are wearing no armor and not wielding a shield, your AC equals 10 + your Dexterity modifier + your Wisdom modifier."
        
        let classFeature107: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature107.id = 307
        classFeature107.name = "Divine Sense"
        classFeature107.level = 1
        classFeature107.pclass = classResults[6]
        classFeature107.details = "\tThe presence of strong evil registers on your senses like a noxious odor, and powerful good rings like heavenly music in your ears. As an action, you can open your awareness to detect such forces. Until the end of your next turn, you know the location of any celestial, fiend, or undead within 60 feet of you that is not behind total cover. You know the type (celestial, fiend, or undead) of any being whose presence you sense, but not its identity. Within the same radius, you also detect the presence of any place or object that has been consecrated or desecrated, as with the Hallow spell.\n\tYou can use this feature a number of times equal to 1 + your Charisma modifier. When you finish a long rest, you regain all expended uses."
        
        let classFeature108: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature108.id = 308
        classFeature108.name = "Favored Enemy"
        classFeature108.level = 1
        classFeature108.pclass = classResults[7]
        classFeature108.details = "\tYou have significant experience studying, tracking, hunting, and even talking to a certain type of enemy.\n\tChoose a type of favored enemy: aberrations, beasts, celestials, constructs, dragons, elementals, fey, fiends, giants, monstrosities, oozes, plants, or undead. Alternatively, you can select two races of humanoid (such as gnolls and orcs) as favored enemies.\n\tYou have advantage on Survival checks to track your favored enemies, as well as on Intelligence checks to recall information about them.\n\tWhen you gain this feature, you also learn one language of your choice that is spoken by your favored enemies, if they speak one at all."
        
        let classFeature109: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature109.id = 309
        classFeature109.name = "Expertise"
        classFeature109.level = 1
        classFeature109.pclass = classResults[8]
        classFeature109.details = "\tChoose two of your skill proficiencies, or one of your skill proficiencies and your proficiency with thieves' tools. Your proficiency bonus is doubled for any ability check you make that uses either of the chosen proficiencies."
        
        let classFeature1010: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature1010.id = 310
        classFeature1010.name = "Ability Score Improvement"
        classFeature1010.level = 4
        classFeature1010.pclass = classResults[9]
        classFeature1010.details = "\tYou can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can't increase an ability score above 20 using this feature."
        
        let classFeature1011: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature1011.id = 311
        classFeature1011.name = "Ability Score Improvement"
        classFeature1011.level = 4
        classFeature1011.pclass = classResults[10]
        classFeature1011.details = "\tYou can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can't increase an ability score above 20 using this feature."
        
        let classFeature1012: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature1012.id = 312
        classFeature1012.name = "Arcane Recovery"
        classFeature1012.level = 1
        classFeature1012.pclass = classResults[11]
        classFeature1012.details = "\tYou have learned to regain some of your magical energy by studying your spellbook. Once per day when you finish a short rest, you can choose expended spell slots to recover. The spell slots can have a combined level that is equal to or less than half your wizard level (rounded up), and none of the slots can be 6th level or higher."
        

        
        do{
            try context.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }//classFeatureInit
    
}//ClassFeature

class ClassFeatureChoiceList: NSManagedObject{
    
    @NSManaged var id: Int64
    @NSManaged var name: String
    @NSManaged var features: Set<ClassFeature>
    @NSManaged var parentFeatures: Set<ClassFeature>
    
    
}//ClassFeatureChoiceList
