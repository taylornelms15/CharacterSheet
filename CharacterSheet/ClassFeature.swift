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
        classFeature1.pclass = classResults[0] //Barbarian
        classFeature1.details = "\tWhile you are not wearing any armor, your Armor Class equals 10 + your Dexterity modifier + your Constitution modifier. You can use a shield and still gain this benefit."
        
        let classFeature2: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature2.id = 202
        classFeature2.name = "Rage"
        classFeature2.level = 1
        classFeature2.pclass = classResults[0] //Barbarian
        classFeature2.details = "\tIn battle, you fight with primal ferocity. On your turn, you may enter a rage as a bonus action.\n\tWhile raging, you gain the following benefits if you aren't weaking heavy armor:\n  \u{2022} You have advantage on Strength checks and Strength saving throws\n  \u{2022} When you make a melee weapon attack using Strength, you gain a bonus to the damage roll that increases with your barbarian level. (+2 at level 1, +3 at level 9, and +4 at level 16.)\n  \u{2022} You have resistance to bludgeoning, piercing, and slashing damage.\n\tIf you are able to cast spells, you can't cast them or concentrate on them while raging.\n\tYour rage lasts for 1 minute. It ends early if you are knocked unconscious or if your turn ends and you haven't attacked a hostile creature since your last turn or taken damage since then. You can also end your rage on your turn as a bonus action.\n\tYou may rage a certain number of times per long rest according to your Barbarian level:\n  \u{2022} 1: 2 rages\n  \u{2022} 3: 3 rages\n  \u{2022} 6: 4 rages\n  \u{2022} 12: 5 rages\n  \u{2022} 17: 6 rages\n  \u{2022} 20: unlimited rages"
        
        let classFeature3: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature3.id = 203
        classFeature3.name = "Reckless Attack"
        classFeature3.level = 2
        classFeature3.pclass = classResults[0] //Barbarian
        classFeature3.details = "\tYou can throw aside all concern for defense to attack with fierce desperation. When you make your first attack on your turn, you can decide to attack recklessly. Doing so gives you advantage on melee weapon attack rolls using Strength during this turn, but attack rolls against you have advantage until your next turn."
        
        let classFeature4: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature4.id = 204
        classFeature4.name = "Danger Sense"
        classFeature4.level = 2
        classFeature4.pclass = classResults[0] //Barbarian
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
        classFeature7.name = "Ability Score Improvement (1)"
        classFeature7.level = 4
        classFeature7.pclass = classResults[0] //Barbarian
        classFeature7.details = "\tYou can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can't increase an ability score above 20 using this feature."
        
        let classFeature8: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature8.id = 208
        classFeature8.name = "Ability Score Improvement (2)"
        classFeature8.level = 8
        classFeature8.pclass = classResults[0] //Barbarian
        classFeature8.details = "\tYou can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can't increase an ability score above 20 using this feature."
        classFeature8.lowerVariants!.insert(classFeature7)
        
        let classFeature9: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature9.id = 209
        classFeature9.name = "Ability Score Improvement (3)"
        classFeature9.level = 12
        classFeature9.pclass = classResults[0] //Barbarian
        classFeature9.details = "\tYou can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can't increase an ability score above 20 using this feature."
        classFeature9.lowerVariants!.insert(classFeature7)
        classFeature9.lowerVariants!.insert(classFeature8)
        
        let classFeature10: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature10.id = 210
        classFeature10.name = "Ability Score Improvement (4)"
        classFeature10.level = 16
        classFeature10.pclass = classResults[0] //Barbarian
        classFeature10.details = "\tYou can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can't increase an ability score above 20 using this feature."
        classFeature10.lowerVariants!.insert(classFeature7)
        classFeature10.lowerVariants!.insert(classFeature8)
        classFeature10.lowerVariants!.insert(classFeature9)
        
        let classFeature11: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature11.id = 211
        classFeature11.name = "Extra Attack"
        classFeature11.level = 5
        classFeature11.pclass = classResults[0] //Barbarian
        classFeature11.details = "\tYou can attack twice, instead of once, whenever you take the Attack action on your turn."
        
        let classFeature12: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature12.id = 212
        classFeature12.name = "Fast Movement"
        classFeature12.level = 5
        classFeature12.pclass = classResults[0] //Barbarian
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
        classFeature22.pclass = classResults[0] //Barbarian
        classFeature22.details = "\tYour instincts are so honed that you have advantage on initiative rolls.\n\tAdditionally, if you are surprised at the beginning of combat and aren't incapacitated, you can act normally on your first turn, but only if you enter your rage before doing anything else on that turn."
        
        let classFeature23: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature23.id = 223
        classFeature23.name = "Brutal Critical"
        classFeature23.level = 9
        classFeature23.pclass = classResults[0] //Barbarian
        classFeature23.details = "\tYou can roll one additional weapon damage die when determining the extra damage for a critical hit with a melee attack."
        
        let classFeature24: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature24.id = 224
        classFeature24.name = "Brutal Critical (2)"
        classFeature24.level = 13
        classFeature24.pclass = classResults[0] //Barbarian
        classFeature24.details = "\tYou can roll two additional weapon damage dice when determining the extra damage for a critical hit with a melee attack."
        classFeature24.lowerVariants?.insert(classFeature23)
        
        let classFeature25: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature25.id = 225
        classFeature25.name = "Brutal Critical (3)"
        classFeature25.level = 17
        classFeature25.pclass = classResults[0] //Barbarian
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
        classFeature33.pclass = classResults[0] //Barbarian
        classFeature33.details = "\tYour rage is so feirce that it ends early only if you fall unconscious or if you choose to end it."
        
        let classFeature34: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature34.id = 234
        classFeature34.name = "Indomitable Might"
        classFeature34.level = 18
        classFeature34.pclass = classResults[0] //Barbarian
        classFeature34.details = "\tIf your total for a Strength check is less than your Strength score, you can use that score in place of the total."
        
        let classFeature35: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature35.id = 235
        classFeature35.name = "Primal Champion"
        classFeature35.level = 20
        classFeature35.pclass = classResults[0] //Barbarian
        classFeature35.details = "\tYou embody the power of the wilds. Your Strength and Constitution scores increase by 4. Your maximum for those scores is now 24."

        //MARK: Bard
        
        let classFeature36: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature36.id = 236
        classFeature36.name = "Bardic Inspiration (d6)"
        classFeature36.level = 1
        classFeature36.pclass = classResults[1] //Bard
        classFeature36.details = "\tYou can inspire others through stirring words or music. To do so, you use a bonus action on your turn to choose one creature other than yourself within 60 feet of you who can hear you. That creature gains one Bardic Inspiration die, a d6.\n\tOnce within the next 10 minutes, the creature can roll the die and add the number rolled to one ability check, attack roll, or saving throw it makes. The creature can wait until after it rolls the d20 before deciding to use the Bardic Inspiration die, but must decide before the DM says whether the roll succeeds or fails. Once the Bardic Inspiration die is rolled, it is lost. A creature can have only one Bardic Inspiration die at a time.\n\tYou can use this feature a number of times equal to your Charisma modifier (a minimum of once). You regain any expended uses when you finish a long rest."
        
        let classFeature37: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature37.id = 237
        classFeature37.name = "Bardic Inspiration (d8)"
        classFeature37.level = 5
        classFeature37.pclass = classResults[1] //Bard
        classFeature37.details = "\tYou can inspire others through stirring words or music. To do so, you use a bonus action on your turn to choose one creature other than yourself within 60 feet of you who can hear you. That creature gains one Bardic Inspiration die, a d8.\n\tOnce within the next 10 minutes, the creature can roll the die and add the number rolled to one ability check, attack roll, or saving throw it makes. The creature can wait until after it rolls the d20 before deciding to use the Bardic Inspiration die, but must decide before the DM says whether the roll succeeds or fails. Once the Bardic Inspiration die is rolled, it is lost. A creature can have only one Bardic Inspiration die at a time.\n\tYou can use this feature a number of times equal to your Charisma modifier (a minimum of once). You regain any expended uses when you finish a long rest."
        classFeature37.lowerVariants!.insert(classFeature36)
        
        let classFeature38: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature38.id = 238
        classFeature38.name = "Bardic Inspiration (d10)"
        classFeature38.level = 10
        classFeature38.pclass = classResults[1] //Bard
        classFeature38.details = "\tYou can inspire others through stirring words or music. To do so, you use a bonus action on your turn to choose one creature other than yourself within 60 feet of you who can hear you. That creature gains one Bardic Inspiration die, a d10.\n\tOnce within the next 10 minutes, the creature can roll the die and add the number rolled to one ability check, attack roll, or saving throw it makes. The creature can wait until after it rolls the d20 before deciding to use the Bardic Inspiration die, but must decide before the DM says whether the roll succeeds or fails. Once the Bardic Inspiration die is rolled, it is lost. A creature can have only one Bardic Inspiration die at a time.\n\tYou can use this feature a number of times equal to your Charisma modifier (a minimum of once). You regain any expended uses when you finish a long rest."
        classFeature38.lowerVariants!.insert(classFeature36)
        classFeature38.lowerVariants!.insert(classFeature37)
        
        let classFeature39: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature39.id = 239
        classFeature39.name = "Bardic Inspiration (d12)"
        classFeature39.level = 15
        classFeature39.pclass = classResults[1] //Bard
        classFeature39.details = "\tYou can inspire others through stirring words or music. To do so, you use a bonus action on your turn to choose one creature other than yourself within 60 feet of you who can hear you. That creature gains one Bardic Inspiration die, a d12.\n\tOnce within the next 10 minutes, the creature can roll the die and add the number rolled to one ability check, attack roll, or saving throw it makes. The creature can wait until after it rolls the d20 before deciding to use the Bardic Inspiration die, but must decide before the DM says whether the roll succeeds or fails. Once the Bardic Inspiration die is rolled, it is lost. A creature can have only one Bardic Inspiration die at a time.\n\tYou can use this feature a number of times equal to your Charisma modifier (a minimum of once). You regain any expended uses when you finish a long rest."
        classFeature39.lowerVariants!.insert(classFeature36)
        classFeature39.lowerVariants!.insert(classFeature37)
        classFeature39.lowerVariants!.insert(classFeature38)
        
        let classFeature40: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature40.id = 240
        classFeature40.name = "Jack of All Trades"
        classFeature40.level = 2
        classFeature40.pclass = classResults[1] //Bard
        classFeature40.details = "\tYou can add half of your proficiency bonus, rounded down, to any ability check you make that doesn't already include your proficiency bonus."
        
        let classFeature41: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature41.id = 241
        classFeature41.name = "Song of Rest (d6)"
        classFeature41.level = 2
        classFeature41.pclass = classResults[1] //Bard
        classFeature41.details = "\tYou can use soothing music or oration to help revitalize your wounded allies during a short rest. If you or any friendly creatures who can hear your performance regain hit points at the end of the short rest by spending one or more Hit Dice, each of those creatures regains an extra 1d6 hit points."
        
        let classFeature42: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature42.id = 242
        classFeature42.name = "Song of Rest (d8)"
        classFeature42.level = 9
        classFeature42.pclass = classResults[1] //Bard
        classFeature42.details = "\tYou can use soothing music or oration to help revitalize your wounded allies during a short rest. If you or any friendly creatures who can hear your performance regain hit points at the end of the short rest by spending one or more Hit Dice, each of those creatures regains an extra 1d8 hit points."
        classFeature42.lowerVariants!.insert(classFeature41)
        
        let classFeature43: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature43.id = 243
        classFeature43.name = "Song of Rest (d10)"
        classFeature43.level = 13
        classFeature43.pclass = classResults[1] //Bard
        classFeature43.details = "\tYou can use soothing music or oration to help revitalize your wounded allies during a short rest. If you or any friendly creatures who can hear your performance regain hit points at the end of the short rest by spending one or more Hit Dice, each of those creatures regains an extra 1d10 hit points."
        classFeature43.lowerVariants!.insert(classFeature41)
        classFeature43.lowerVariants!.insert(classFeature42)
        
        let classFeature44: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature44.id = 244
        classFeature44.name = "Song of Rest (d12)"
        classFeature44.level = 17
        classFeature44.pclass = classResults[1] //Bard
        classFeature44.details = "\tYou can use soothing music or oration to help revitalize your wounded allies during a short rest. If you or any friendly creatures who can hear your performance regain hit points at the end of the short rest by spending one or more Hit Dice, each of those creatures regains an extra 1d12 hit points."
        classFeature44.lowerVariants!.insert(classFeature41)
        classFeature44.lowerVariants!.insert(classFeature42)
        classFeature44.lowerVariants!.insert(classFeature43)
        
        let classFeature45: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature45.id = 245
        classFeature45.name = "Expertise (1)"
        classFeature45.level = 3
        classFeature45.pclass = classResults[1] //Bard
        classFeature45.details = "\tYour proficiency bonus is doubled for any ability check you make that uses either of two proficiencies you choose."
        
        let classFeature46: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature46.id = 246
        classFeature46.name = "Expertise (2)"
        classFeature46.level = 10
        classFeature46.pclass = classResults[1] //Bard
        classFeature46.details = "\tYour proficiency bonus is doubled for any ability check you make that uses any of four proficiencies you choose."
        classFeature46.lowerVariants!.insert(classFeature45)
        
        let classFeature47: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature47.id = 247
        classFeature47.name = "Bonus Proficiencies"
        classFeature47.level = 3
        classFeature47.subclass = subclassResults[2] //College of Lore
        classFeature47.details = "\tYou have proficiency with three additional skills of your choice."
        
        let classFeature48: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature48.id = 248
        classFeature48.name = "Bonus Proficiencies"
        classFeature48.level = 3
        classFeature48.subclass = subclassResults[3] //College of Valor
        classFeature48.details = "\tYou have proficiency with Medium Armor, Shields, and Martial Weapons."
        
        let classFeature49: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature49.id = 249
        classFeature49.name = "Cutting Words"
        classFeature49.level = 3
        classFeature49.subclass = subclassResults[2] //College of Lore
        classFeature49.details = "\tYou know how to use your wit to distract, confuse, and otherwise sap the confidence and competence of others. When a creature that you can see within 60 feet of you makes an attack roll, an ability check, or a damage roll, you can use your reaction to expend one of your uses of Bardic Inspiration, rolling a Bardic Inspiration die and subtracting the number rolled from the creature's roll. You can choose to use this feature after the creature makes its roll, but before the DM determines whether the attack roll or ability check succeeds or fails, or before the creature deals its damage. The creature is immune if it can't hear you or if it's immune to being charmed."
        
        let classFeature50: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature50.id = 250
        classFeature50.name = "Combat Inspiration"
        classFeature50.level = 3
        classFeature50.subclass = subclassResults[3] //College of Valor
        classFeature50.details = "\tYou know how to inspire others in battle. A ceature that has a Bardic Inspiration die from you can roll that die and add the number rolled to a weapon damage roll it just made. Alternatively, when an attack roll is made against the creature, it can use its reaction to roll the Bardic Inspiration die and add the number rolled to its AC against that attack, after seeing the roll but before knowing whether it hits or misses."
        
        let classFeature51: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature51.id = 251
        classFeature51.name = "Ability Score Improvement (1)"
        classFeature51.level = 4
        classFeature51.pclass = classResults[1] //Bard
        classFeature51.details = "\tYou can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can't increase an ability score above 20 using this feature."
        
        let classFeature52: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature52.id = 252
        classFeature52.name = "Ability Score Improvement (2)"
        classFeature52.level = 8
        classFeature52.pclass = classResults[1] //Bard
        classFeature52.details = "\tYou can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can't increase an ability score above 20 using this feature."
        classFeature52.lowerVariants!.insert(classFeature51)
        
        let classFeature53: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature53.id = 253
        classFeature53.name = "Ability Score Improvement (3)"
        classFeature53.level = 12
        classFeature53.pclass = classResults[1] //Bard
        classFeature53.details = "\tYou can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can't increase an ability score above 20 using this feature."
        classFeature53.lowerVariants!.insert(classFeature51)
        classFeature53.lowerVariants!.insert(classFeature52)
        
        let classFeature54: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature54.id = 254
        classFeature54.name = "Ability Score Improvement (4)"
        classFeature54.level = 16
        classFeature54.pclass = classResults[1] //Bard
        classFeature54.details = "\tYou can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can't increase an ability score above 20 using this feature."
        classFeature54.lowerVariants!.insert(classFeature51)
        classFeature54.lowerVariants!.insert(classFeature52)
        classFeature54.lowerVariants!.insert(classFeature53)
        
        let classFeature55: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature55.id = 255
        classFeature55.name = "Ability Score Improvement (5)"
        classFeature55.level = 19
        classFeature55.pclass = classResults[1] //Bard
        classFeature55.details = "\tYou can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can't increase an ability score above 20 using this feature."
        classFeature55.lowerVariants!.insert(classFeature51)
        classFeature55.lowerVariants!.insert(classFeature52)
        classFeature55.lowerVariants!.insert(classFeature53)
        classFeature55.lowerVariants!.insert(classFeature54)
        
        let classFeature56: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature56.id = 256
        classFeature56.name = "Font of Inspiration"
        classFeature56.level = 5
        classFeature56.pclass = classResults[1] //Bard
        classFeature56.details = "\tYou regain all of your expended uses of Bardic Inspiration when you finish a short or long rest."
        
        let classFeature57: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature57.id = 257
        classFeature57.name = "Countercharm"
        classFeature57.level = 6
        classFeature57.pclass = classResults[1] //Bard
        classFeature57.details = "\tYou have the ability to use musical notes or words of power to disrupt mind-influencing effects. As an action, you can start a performance that lasts until the end of your next turn. During that time, you and any friendly creatures within 30 feet of you have advantage on saving throws against being frightened or charmed. A creature must be able to hear you to gain this benefit. The performance ends early if you are incapacitated or silenced, or if you voluntarily end it (no action required)."
        
        let classFeature58: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature58.id = 258
        classFeature58.name = "Additional Magical Secrets"
        classFeature58.level = 6
        classFeature58.subclass = subclassResults[2] //College of Lore
        classFeature58.details = "\tYou know two spells of your choice from any class. A spell you choose must be of a level you can cast, or a cantrip. The chosen spells count as bard spells for you but don't count against the number of bard spells you know."
        
        let classFeature59: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature59.id = 259
        classFeature59.name = "Extra Attack"
        classFeature59.level = 6
        classFeature59.subclass = subclassResults[3] //College of Valor
        classFeature59.details = "\tYou can attack twice, instead of once, whenever you take the Attack action on your turn."
        
        let classFeature60: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature60.id = 260
        classFeature60.name = "Magical Secrets (2)"
        classFeature60.level = 10
        classFeature60.pclass = classResults[1] //Bard
        classFeature60.details = "\tYou have plundered magical knowledge from a wide spectrum of disciplines. Choose two spells from any class, including this one. A spell you choose must be of a level you can cast.\n\tThe chosen spells count as bard spells for you and are included in the number of Bard spells known."
        
        let classFeature61: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature61.id = 261
        classFeature61.name = "Magical Secrets (4)"
        classFeature61.level = 14
        classFeature61.pclass = classResults[1] //Bard
        classFeature61.details = "\tYou have plundered magical knowledge from a wide spectrum of disciplines. Choose four spells from any class, including this one. A spell you choose must be of a level you can cast.\n\tThe chosen spells count as bard spells for you and are included in the number of Bard spells known."
        classFeature61.lowerVariants!.insert(classFeature60)
        
        let classFeature62: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature62.id = 262
        classFeature62.name = "Magical Secrets (6)"
        classFeature62.level = 18
        classFeature62.pclass = classResults[1] //Bard
        classFeature62.details = "\tYou have plundered magical knowledge from a wide spectrum of disciplines. Choose six spells from any class, including this one. A spell you choose must be of a level you can cast.\n\tThe chosen spells count as bard spells for you and are included in the number of Bard spells known."
        classFeature62.lowerVariants!.insert(classFeature60)
        classFeature62.lowerVariants!.insert(classFeature61)
        
        let classFeature63: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature63.id = 263
        classFeature63.name = "Peerless Skill"
        classFeature63.level = 14
        classFeature63.subclass = subclassResults[2] //College of Lore
        classFeature63.details = "\tWhen you make an ability check, you can expend one use of Bardic Inspiration. Roll a Bardic Inspiration die and add the number rolled to your ability check. You can choose to do so after you roll the die for the ability check, but before the DM tells you whether you succeed or fail."
        
        let classFeature64: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature64.id = 264
        classFeature64.name = "Battle Magic"
        classFeature64.level = 14
        classFeature64.subclass = subclassResults[3] //College of Valor
        classFeature64.details = "\tYou have mastered the art of weaving spellcasting and weapon use into a single harmonious act. When you use your action to cast a bard spell, you can make one weapon attack as a bonus action."
        
        let classFeature65: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature65.id = 265
        classFeature65.name = "Superior Inspiration"
        classFeature65.level = 20
        classFeature65.pclass = classResults[1] //Bard
        classFeature65.details = "\tWhen you roll initiative and have no uses of Bardic Inspiration left, you regain one use."
        
        let classFeature66: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature66.id = 266
        classFeature66.name = "Blessings of Knowledge"
        classFeature66.level = 1
        classFeature66.subclass = subclassResults[4] //Knowledge Domain
        classFeature66.details = "\tYou know two additional languages of your choice. You also are proficient in your choice of two of the following skills: Arcana, History, Nature, or Religion.\n\tYour proficiency bonus is doubled for any ability check you make that uses either of those skills."
        
        let classFeature67: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature67.id = 267
        classFeature67.name = "Bonus Proficiency"
        classFeature67.level = 1
        classFeature67.subclass = subclassResults[5] //Life Domain
        classFeature67.details = "\tYou are proficient with Heavy Armor."
        
        let classFeature68: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature68.id = 268
        classFeature68.name = "Disciple of Life"
        classFeature68.level = 1
        classFeature68.subclass = subclassResults[5] //Life Domain
        classFeature68.details = "\tYour healing spells are more effective. When you use a spell of 1st level or higher to restore hit points to a creature, the creature regains additional hit points equal to 2 + the spell's level."
        
        let classFeature69: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature69.id = 269
        classFeature69.name = "Bonus Cantrip"
        classFeature69.level = 1
        classFeature69.subclass = subclassResults[6] //Light Domain
        classFeature69.details = "\tYou gain the Light cantrip if you don't already know it."
        
        let classFeature70: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature70.id = 270
        classFeature70.name = "Warding Flare"
        classFeature70.level = 1
        classFeature70.subclass = subclassResults[6] //Light Domain
        classFeature70.details = "\tYou can interpose divine light between yourself and an attacking enemy. When you are attacked by a creature within 30 feet of you that you can see, you can use your reaction to impose disadvantage on the attack roll, causing light to flare before the attacker before it hits or misses. An attacker that can't be blinded is immune to this feature.\n\tYou can use this feature a number of times equal to your Wisdom modifier (a minimum of once) per long rest."
        
        let classFeature71: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature71.id = 271
        classFeature71.name = "Bonus Proficiency"
        classFeature71.level = 1
        classFeature71.subclass = subclassResults[7] //Nature Domain
        classFeature71.details = "\tYou are proficient with Heavy Armor."
        
        let classFeature72: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature72.id = 272
        classFeature72.name = "Acolyte of Nature"
        classFeature72.level = 1
        classFeature72.subclass = subclassResults[7] //Nature Domain
        classFeature72.details = "\tYou learn one druid cantrip of your choice. You also gain proficiency in one of the following skills of your choice: Animal Handling, Nature, or Survival."
        
        let classFeature73: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature73.id = 273
        classFeature73.name = "Bonus Proficiencies"
        classFeature73.level = 1
        classFeature73.subclass = subclassResults[8] //Tempest Domain
        classFeature73.details = "\tYou are proficient with martial weapons and Heavy Armor."
        
        let classFeature74: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature74.id = 274
        classFeature74.name = "Wrath of the Storm"
        classFeature74.level = 1
        classFeature74.subclass = subclassResults[8] //Tempest Domain
        classFeature74.details = "\tYou can thunderously rebuke attackers. When a creature within 5 feet of you that you can see hits you with an attack, you can use your reaction to cause the creature to make a Dexterity saving throw. The creature takes 2d8 lightning or thunder damage (your choice) on a failed saving throw, or half as much on a successful one.\n\tYou can use this feature a number of times equal to your Wisdom modifier (a minimum of once) per long rest."
        
        let classFeature75: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature75.id = 275
        classFeature75.name = "Blessing of the Trickster"
        classFeature75.level = 1
        classFeature75.subclass = subclassResults[9] //Trickery Domain
        classFeature75.details = "\tYou can use your action to touch a willing creature other than yourself to give it advantage on Stealth checks. This blessing lasts for 1 hour or until you use this feature again."
        
        let classFeature76: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature76.id = 276
        classFeature76.name = "Bonus Proficiencies"
        classFeature76.level = 1
        classFeature76.subclass = subclassResults[10] //War Domain
        classFeature76.details = "\tYou are proficient with martial weapons and Heavy Armor."
        
        let classFeature77: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature77.id = 277
        classFeature77.name = "War Priest"
        classFeature77.level = 1
        classFeature77.subclass = subclassResults[10] //War Domain
        classFeature77.details = "\tYour god delivers bolts of inspitation to you while you are engaged in battle. When you use the Attack action, you can make one weapon attack as a bonus action.\n\tYou can use this feature a number of times equal to your Wisdom modifier (a minimum of once) per long rest."
        
        let classFeature78: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature78.id = 278
        classFeature78.name = "Channel Divinity (1)"
        classFeature78.level = 2
        classFeature78.pclass = classResults[2] //Cleric
        classFeature78.details = "\tYou have the ability to channel divine energy directly from your deity, using that energy to fuel magical effects.\n\tWhen you use your Channel Divinity, you choose which effect to create. Some Channel Divinity effects require saving throws. When you use such an effect from this class, the DC equals your cleric spell save DC.\n\tYou may use Channel Divinity once per short or long rest."
        
        let classFeature79: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature79.id = 279
        classFeature79.name = "Channel Divinity (2)"
        classFeature79.level = 6
        classFeature79.pclass = classResults[2] //Cleric
        classFeature79.details = "\tYou have the ability to channel divine energy directly from your deity, using that energy to fuel magical effects.\n\tWhen you use your Channel Divinity, you choose which effect to create. Some Channel Divinity effects require saving throws. When you use such an effect from this class, the DC equals your cleric spell save DC.\n\tYou may use Channel Divinity twice per short or long rest."
        classFeature79.lowerVariants!.insert(classFeature78)
        
        let classFeature80: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature80.id = 280
        classFeature80.name = "Channel Divinity (3)"
        classFeature80.level = 18
        classFeature80.pclass = classResults[2] //Cleric
        classFeature80.details = "\tYou have the ability to channel divine energy directly from your deity, using that energy to fuel magical effects.\n\tWhen you use your Channel Divinity, you choose which effect to create. Some Channel Divinity effects require saving throws. When you use such an effect from this class, the DC equals your cleric spell save DC.\n\tYou may use Channel Divinity three times per short or long rest."
        classFeature80.lowerVariants!.insert(classFeature78)
        classFeature80.lowerVariants!.insert(classFeature79)
        
        let classFeature81: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature81.id = 281
        classFeature81.name = "Channel Divinity: Turn Undead"
        classFeature81.level = 2
        classFeature81.pclass = classResults[2] //Cleric
        classFeature81.details = "\tAs an action, you present your holy symbol and speak a prayer censuring the undead. Each undead that can see or hear you within 30 feet of you must make a Wisdom saving throw. If the creature fails its saving throw, it is turned for 1 minute or until it takes any damage.\n\tA turned creature must spend its turns trying to move as far away from you as it can, and it can't willingly move to a space within 30 feet of you. It also can't take reactions. For its action, it can use only the Dash action or try to escape from an effect that prevents it from moving. If there's nowhere to move, the creature can use the Dodge action."
        
        let classFeature82: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature82.id = 282
        classFeature82.name = "Channel Divinity: Knowledge of the Ages"
        classFeature82.level = 2
        classFeature82.subclass = subclassResults[4] //Knowledge Domain
        classFeature82.details = "\tYou can use your Channel Divinity to tap into a divine well of knowledge.\n\tAs an action, you choose one skill or tool. For 10 minutes, you have proficiency with the chosen skill or tool."
        
        let classFeature83: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature83.id = 283
        classFeature83.name = "Channel Divinity: Preserve Life"
        classFeature83.level = 2
        classFeature83.subclass = subclassResults[5] //Life Domain
        classFeature83.details = "\tYou can use your Channel Divinity to heal the badly injured.\n\tAs an action, you present your holy symbol and evoke healing energy that can restore a number of hit points equal to five times your cleric level. Choose any creatures within 30 feet of you, and divide those hit points among them. This feature can restore a creature to no more than half of its hit point maximum. You can't use this feature on an undead or a construct."
        
        let classFeature84: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature84.id = 284
        classFeature84.name = "Channel Divinity: Radiance of the Dawn"
        classFeature84.level = 2
        classFeature84.subclass = subclassResults[6] //Light Domain
        classFeature84.details = "\tYou can use your Channel Divinity to harness sunlight, banishing darkness and dealing radiant damage to your foes.\n\tAs an action, you present your holy symbol, and any magical darkness within 30 feet of you is dispelled. Additionally, each hostile creature within 30 feet of you must make a Constitution saving throw. A creature takes radiant damage equal to 2d10 + your cleric level on a failed saving throw, and half as much on a successful one. A creature that has total cover from you is not affected."
        
        let classFeature85: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature85.id = 285
        classFeature85.name = "Channel Divinity: Charm Animals and Plants"
        classFeature85.level = 2
        classFeature85.subclass = subclassResults[7] //Nature Domain
        classFeature85.details = "\tYou can use your Channel Divinity to charm animals and plants.\n\tAs an action, you present your holy symbol and invoke the name of your deity. Each beast or plant creature that can see you within 30 feet of you must make a Wisdom saving throw. If the creature fails its saving throw, it is charmed by you for 1 minute or until it takes damage. While it is charmed by you, it is friendly to you and other creatures you designate."
        
        let classFeature86: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature86.id = 286
        classFeature86.name = "Channel Divinity: Destructive Wrath"
        classFeature86.level = 2
        classFeature86.subclass = subclassResults[8] //Tempest Domain
        classFeature86.details = "\tYou can use your Channel Divinity to wield the power of the storm with unchecked ferocity.\n\tWhen you roll lightning or thunder damage, you can use this feature to deal maximum damage instead of rolling."
        
        let classFeature87: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature87.id = 287
        classFeature87.name = "Channel Divinity: Invoke Duplicity"
        classFeature87.level = 2
        classFeature87.subclass = subclassResults[9] //Trickery Domain
        classFeature87.details = "\tYou can use your Channel Divinity to create an illusory duplicate of yourself.\n\tAs an action, you create a perfect illusion of yourself that lasts for 1 minute, or until you lose your concentration (as if you were concentrating on a spell). The illusion appears in an unoccupied space that you can see within 30 feet of you. As a bonus action on your turn, you can move the illusion up to 30 feet to a space you can see, as long as it remains within 120 feet of you.\n\tFor the duration, you can cast spells as though you were in the illusion's space, but you must use your own senses. Additionally, when both you and your illusion are within 5 feet of a creature that can see the illusion, you have advantage on attack rolls against that creature, given how distracting the illusion is to the target."
        
        let classFeature88: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature88.id = 288
        classFeature88.name = "Channel Divinity: Guided Strike"
        classFeature88.level = 2
        classFeature88.subclass = subclassResults[10] //War Domain
        classFeature88.details = "\tYou can use your Channel Divinity to strike with supernatural accuracy. When you make an attack roll, you can use your Channel Divinity to gain a +10 bonus to the roll. You make this choice after you see the roll, but before the DM says whether the attack hits or misses."
        
        let classFeature89: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature89.id = 289
        classFeature89.name = "Ability Score Improvement (1)"
        classFeature89.level = 4
        classFeature89.pclass = classResults[2] //Cleric
        classFeature89.details = "\tYou can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can't increase an ability score above 20 using this feature."
        
        let classFeature90: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature90.id = 290
        classFeature90.name = "Ability Score Improvement (2)"
        classFeature90.level = 8
        classFeature90.pclass = classResults[2] //Cleric
        classFeature90.details = "\tYou can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can't increase an ability score above 20 using this feature."
        classFeature90.lowerVariants!.insert(classFeature89)
        
        let classFeature91: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature91.id = 291
        classFeature91.name = "Ability Score Improvement (3)"
        classFeature91.level = 12
        classFeature91.pclass = classResults[2] //Cleric
        classFeature91.details = "\tYou can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can't increase an ability score above 20 using this feature."
        classFeature91.lowerVariants!.insert(classFeature89)
        classFeature91.lowerVariants!.insert(classFeature90)
        
        let classFeature92: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature92.id = 292
        classFeature92.name = "Ability Score Improvement (4)"
        classFeature92.level = 16
        classFeature92.pclass = classResults[2] //Cleric
        classFeature92.details = "\tYou can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can't increase an ability score above 20 using this feature."
        classFeature92.lowerVariants!.insert(classFeature89)
        classFeature92.lowerVariants!.insert(classFeature90)
        classFeature92.lowerVariants!.insert(classFeature91)
        
        let classFeature93: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature93.id = 293
        classFeature93.name = "Ability Score Improvement (5)"
        classFeature93.level = 19
        classFeature93.pclass = classResults[2] //Cleric
        classFeature93.details = "\tYou can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can't increase an ability score above 20 using this feature."
        classFeature93.lowerVariants!.insert(classFeature89)
        classFeature93.lowerVariants!.insert(classFeature90)
        classFeature93.lowerVariants!.insert(classFeature91)
        classFeature93.lowerVariants!.insert(classFeature92)
        
        let classFeature94: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature94.id = 294
        classFeature94.name = "Destroy Undead: CR 1/2"
        classFeature94.level = 5
        classFeature94.pclass = classResults[2] //Cleric
        classFeature94.details = "\tWhen an undead fails its saving throw against your Channel Divinity: Turn Undead feature, the creature is instantly destroyed if it is of challenge rating 1/2 or lower."
        
        let classFeature95: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature95.id = 295
        classFeature95.name = "Destroy Undead: CR 1"
        classFeature95.level = 8
        classFeature95.pclass = classResults[2] //Cleric
        classFeature95.details = "\tWhen an undead fails its saving throw against your Channel Divinity: Turn Undead feature, the creature is instantly destroyed if it is of challenge rating 1 or lower."
        classFeature95.lowerVariants!.insert(classFeature94)
        
        let classFeature96: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature96.id = 296
        classFeature96.name = "Destroy Undead: CR 2"
        classFeature96.level = 11
        classFeature96.pclass = classResults[2] //Cleric
        classFeature96.details = "\tWhen an undead fails its saving throw against your Channel Divinity: Turn Undead feature, the creature is instantly destroyed if it is of challenge rating 2 or lower."
        classFeature96.lowerVariants!.insert(classFeature94)
        classFeature96.lowerVariants!.insert(classFeature95)
        
        let classFeature97: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature97.id = 297
        classFeature97.name = "Destroy Undead: CR 3"
        classFeature97.level = 14
        classFeature97.pclass = classResults[2] //Cleric
        classFeature97.details = "\tWhen an undead fails its saving throw against your Channel Divinity: Turn Undead feature, the creature is instantly destroyed if it is of challenge rating 3 or lower."
        classFeature97.lowerVariants!.insert(classFeature94)
        classFeature97.lowerVariants!.insert(classFeature95)
        classFeature97.lowerVariants!.insert(classFeature96)
        
        let classFeature98: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature98.id = 298
        classFeature98.name = "Destroy Undead: CR 4"
        classFeature98.level = 17
        classFeature98.pclass = classResults[2] //Cleric
        classFeature98.details = "\tWhen an undead fails its saving throw against your Channel Divinity: Turn Undead feature, the creature is instantly destroyed if it is of challenge rating 4 or lower."
        classFeature98.lowerVariants!.insert(classFeature94)
        classFeature98.lowerVariants!.insert(classFeature95)
        classFeature98.lowerVariants!.insert(classFeature96)
        classFeature98.lowerVariants!.insert(classFeature97)
        
        let classFeature99: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature99.id = 299
        classFeature99.name = "Channel Divinity: Read Thoughts"
        classFeature99.level = 6
        classFeature99.subclass = subclassResults[4] //Knowledge Domain
        classFeature99.details = "\tYou can use your Channel Divinity to read a creature's thoughts. You can then use your access to the creature's mind to command it.\n\tAs an action, choose one creature that you can see within 60 feet of you. That creature must make a Wisdom saving throw. If the creature succeeds on the saving throw, you can't use this feature on it again until you finish a long rest.\n\tIf the creature fails its save, you can read its surface thoughts (those foremost in its mind, reflecting its current emotions and what it is actively thinking about) when it is within 60 feet of you. This effect lasts for 1 minute.\n\tDuring that time, you can use your action to end this effect and cast the Suggestion spell on the creature without expending a spell slot. The target automatically fails its saving throw against the spell."
        
        let classFeature100: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature100.id = 300
        classFeature100.name = "Blessed Healer"
        classFeature100.level = 6
        classFeature100.subclass = subclassResults[5] //Life Domain
        classFeature100.details = "\tThe healing spells you cast on others heal you as well. When you cast a spell of 1st level or higher that restores hit points to a creature other than you, you regain hit points equal to 2 + the spell's level."
        
        let classFeature101: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature101.id = 301
        classFeature101.name = "Improved Flare"
        classFeature101.level = 6
        classFeature101.subclass = subclassResults[6] //Light Domain
        classFeature101.details = "\tYou can also use your Warding Flare when a creature that you can see within 30 feet of you attacks a creature other than you."
        
        let classFeature102: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature102.id = 302
        classFeature102.name = "Dampen Elements"
        classFeature102.level = 6
        classFeature102.subclass = subclassResults[7] //Nature Domain
        classFeature102.details = "\tWhen you or a creature within 30 feet of you takes acid, cold, fire, lightning, or thunder damage, you can use your reaction to grant resistance to the creature against that instance of the damage."
        
        let classFeature103: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature103.id = 303
        classFeature103.name = "Thunderbolt Strike"
        classFeature103.level = 6
        classFeature103.subclass = subclassResults[8] //Tempest Domain
        classFeature103.details = "\tWhen you deal lightning damage to a Large or smaller creature, you can also push it up to 10 feet away from you."
        
        let classFeature104: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature104.id = 304
        classFeature104.name = "Channel Divinity: Cloak of Shadows"
        classFeature104.level = 6
        classFeature104.subclass = subclassResults[9] //Trickery Domain
        classFeature104.details = "\tYou can use your Channel Divinity to vanish.\n\tAs an action, you become invisible until the end of your next turn. You become visible if you attack or cast a spell."
        
        let classFeature105: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature105.id = 305
        classFeature105.name = "Channel Divinity: War God's Blessing"
        classFeature105.level = 6
        classFeature105.subclass = subclassResults[10] //War Domain
        classFeature105.details = "\tWhen a creature within 30 feet of you makes an attack roll, you can use your reaction to grant that creature a +10 bonus to the roll, using your Channel Divinity. You make this choice after you see the roll, but before the DM says whether the attack hits or misses."

        let classFeature106: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature106.id = 306
        classFeature106.name = "Potent Spellcasting"
        classFeature106.level = 8
        classFeature106.subclass = subclassResults[4] //Knowledge Domain
        classFeature106.details = "\tYou add your Wisdom modifier to the damage you deal with any cleric cantrip."
        
        let classFeature107: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature107.id = 307
        classFeature107.name = "Divine Strike (1d8)"
        classFeature107.level = 8
        classFeature107.subclass = subclassResults[5] //Life Domain
        classFeature107.details = "\tYou have the ability to infuse your weapon strikes with divine energy. Once on each of your turns when you hit a creature with a weapon attack, you can cause the attack to deal an extra 1d8 radiant damage to the target."
        
        let classFeature108: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature108.id = 308
        classFeature108.name = "Divine Strike (2d8)"
        classFeature108.level = 14
        classFeature108.subclass = subclassResults[5] //Life Domain
        classFeature108.details = "\tYou have the ability to infuse your weapon strikes with divine energy. Once on each of your turns when you hit a creature with a weapon attack, you can cause the attack to deal an extra 2d8 radiant damage to the target."
        classFeature108.lowerVariants!.insert(classFeature107)
        
        let classFeature109: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature109.id = 309
        classFeature109.name = "Potent Spellcasting"
        classFeature109.level = 8
        classFeature109.subclass = subclassResults[6] //Light Domain
        classFeature109.details = "\tYou add your Wisdom modifier to the damage you deal with any cleric cantrip."
        
        let classFeature110: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature110.id = 310
        classFeature110.name = "Divine Strike (1d8)"
        classFeature110.level = 8
        classFeature110.subclass = subclassResults[7] //Nature Domain
        classFeature110.details = "\tYou have the ability to infuse your weapon strikes with divine energy. Once on each of your turns when you hit a creature with a weapon attack, you can cause the attack to deal an extra 1d8 cold, fire, or lightning damage (your choice) to the target."
        
        let classFeature111: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature111.id = 311
        classFeature111.name = "Divine Strike (2d8)"
        classFeature111.level = 14
        classFeature111.subclass = subclassResults[7] //Nature Domain
        classFeature111.details = "\tYou have the ability to infuse your weapon strikes with divine energy. Once on each of your turns when you hit a creature with a weapon attack, you can cause the attack to deal an extra 2d8 cold, fire, or lightning damage (your choice) to the target."
        classFeature111.lowerVariants!.insert(classFeature110)
        
        let classFeature112: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature112.id = 312
        classFeature112.name = "Divine Strike (1d8)"
        classFeature112.level = 8
        classFeature112.subclass = subclassResults[8] //Tempest Domain
        classFeature112.details = "\tYou have the ability to infuse your weapon strikes with divine energy. Once on each of your turns when you hit a creature with a weapon attack, you can cause the attack to deal an extra 1d8 thunder damage to the target."
        
        let classFeature113: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature113.id = 313
        classFeature113.name = "Divine Strike (2d8)"
        classFeature113.level = 14
        classFeature113.subclass = subclassResults[8] //Tempest Domain
        classFeature113.details = "\tYou have the ability to infuse your weapon strikes with divine energy. Once on each of your turns when you hit a creature with a weapon attack, you can cause the attack to deal an extra 2d8 thunder damage to the target."
        classFeature113.lowerVariants!.insert(classFeature112)
        
        let classFeature114: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature114.id = 314
        classFeature114.name = "Divine Strike (1d8)"
        classFeature114.level = 8
        classFeature114.subclass = subclassResults[9] //Trickery Domain
        classFeature114.details = "\tYou have the ability to infuse your weapon strikes with poison. Once on each of your turns when you hit a creature with a weapon attack, you can cause the attack to deal an extra 1d8 poison damage to the target."
        
        let classFeature115: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature115.id = 315
        classFeature115.name = "Divine Strike (2d8)"
        classFeature115.level = 14
        classFeature115.subclass = subclassResults[9] //Trickery Domain
        classFeature115.details = "\tYou have the ability to infuse your weapon strikes with poison. Once on each of your turns when you hit a creature with a weapon attack, you can cause the attack to deal an extra 2d8 poison damage to the target."
        classFeature115.lowerVariants!.insert(classFeature114)
        
        let classFeature116: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature116.id = 316
        classFeature116.name = "Divine Strike (1d8)"
        classFeature116.level = 8
        classFeature116.subclass = subclassResults[10] //War Domain
        classFeature116.details = "\tYou have the ability to infuse your weapon strikes with divine energy. Once on each of your turns when you hit a creature with a weapon attack, you can cause the attack to deal an extra 1d8 damage of the same type of the weapon to the target."
        
        let classFeature117: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature117.id = 317
        classFeature117.name = "Divine Strike (2d8)"
        classFeature117.level = 14
        classFeature117.subclass = subclassResults[10] //War Domain
        classFeature117.details = "\tYou have the ability to infuse your weapon strikes with divine energy. Once on each of your turns when you hit a creature with a weapon attack, you can cause the attack to deal an extra 2d8 damage of the same type of the weapon to the target."
        classFeature117.lowerVariants!.insert(classFeature116)
        
        let classFeature118: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature118.id = 318
        classFeature118.name = "Divine Intervention (1)"
        classFeature118.level = 10
        classFeature118.pclass = classResults[2] //Cleric
        classFeature118.details = "\tYou can call on your deity to intervene on your behalf when your need is great.\n\tImploring your deity's aid requires you to use your action. Describe the assistance you seek, and roll percentile dice. If you roll a number equal to or lower than your cleric level, your deity intervenes. The DM chooses the nature of the intervention; the effect of any cleric spell or cleric domain spell would be appropriate.\n\tIf your deity intervenes, you can't use this feature again for 7 days. Otherwise, you can use it again after you finish a long rest."
        
        let classFeature119: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature119.id = 319
        classFeature119.name = "Divine Intervention (2)"
        classFeature119.level = 20
        classFeature119.pclass = classResults[2] //Cleric
        classFeature119.details = "\tYou can call on your deity to intervene on your behalf when your need is great.\n\tImploring your deity's aid requires you to use your action. Describe the assistance you seek, and your deity will intervene. The DM chooses the nature of the intervention; the effect of any cleric spell or cleric domain spell would be appropriate.\n\tIf your deity intervenes, you can't use this feature again for 7 days. Otherwise, you can use it again after you finish a long rest."
        
        let classFeature120: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature120.id = 320
        classFeature120.name = "Visions of the Past"
        classFeature120.level = 17
        classFeature120.subclass = subclassResults[4] //Knowledge Domain
        classFeature120.details = "\tYou can call up visions of the past that relate to an object you hold or your immediate surroundings. You spend at least 1 minute in meditation and prayer, then receive dreamlike, shadowy glimpses of recent events. You can meditate in this way for a number of minutes equal to your Wisdom score and must maintain concentration during that time, as if you were casting a spell.\n\tYou may use this feature once per short or long rest.\n  \u{2022} Object Reading: Holding an object as you meditate, you can see visions of the object's previous owner. After meditating for 1 minute, you learn how the owner acquired and lost the object, as well as the most recent significant event involving the object and that owner. If the object was owned by another creature in the recent past (within a number of days equal to your Wisdom score), you can spend 1 aditional minute for each owner to learn the same information about that creature.\n  \u{2022} Area Reading: As you meditate, you see visions of recent events in your immediate vicinity (a room, street, tunnel, clearing, or the like, up to a 50-foot cube), going back a number of days equal to your Wisdom score. For each minute you meditate, you learn about one significant event, beginning with the most recent. Significant events typically involve powerful emotions, such as battles and betrayals, marriages and murders, births and funerals. Howeverm they might also include more mundane events that are nevertheless important in your current situation."
        
        let classFeature121: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature121.id = 321
        classFeature121.name = "Supreme Healing"
        classFeature121.level = 17
        classFeature121.subclass = subclassResults[5] //Life Domain
        classFeature121.details = "\tWhen you would normally roll one or more dice to restore hit points with a spell, you insead use the highest number possible for each die. For example, instead of restoring 2d6 hit points to a creature, you restore 12."
        
        let classFeature122: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature122.id = 322
        classFeature122.name = "Corona of Light"
        classFeature122.level = 17
        classFeature122.subclass = subclassResults[6] //Light Domain
        classFeature122.details = "\tYou can use your action to activate an aura of sunlight that lasts for 1 minute or until you dismiss it using another action. You emit bright light in a 60-foot radius and dim light 30 feet beyond that. Your enemies in the bright light have disadvantage on saving throws against any spell that deals fire or radiant damage."
        
        let classFeature123: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature123.id = 323
        classFeature123.name = "Master of Nature"
        classFeature123.level = 17
        classFeature123.subclass = subclassResults[7] //Nature Domain
        classFeature123.details = "\tYou have the ability to command animals and plant creatures. While creatures are charmed by your Charm Animals an Plants feature, you can take a bonus action on your turn to verbally command what each of those creatures will do on its next turn."
        
        let classFeature124: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature124.id = 324
        classFeature124.name = "Stormborn"
        classFeature124.level = 17
        classFeature124.subclass = subclassResults[8] //Tempest Domain
        classFeature124.details = "\tYou have a flying speed equal to your current walking speed whenever you are not underground or indoors."
        
        let classFeature125: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature125.id = 325
        classFeature125.name = "Channel Divinity: Improved Invoke Duplicity"
        classFeature125.level = 17
        classFeature125.subclass = subclassResults[9] //Trickery Domain
        classFeature125.details = "\tYou can use your Channel Divinity to create four illusory duplicates of yourself.\n\tAs an action, you create four perfect illusions of yourself that last for 1 minute, or until you lose your concentration (as if you were concentrating on a spell). The illusions appear in unoccupied spaces that you can see within 30 feet of you. As a bonus action on your turn, you can move the illusions up to 30 feet each to spaces you can see, as long as they remain within 120 feet of you.\n\tFor the duration, you can cast spells as though you were in the illusions' spaces, but you must use your own senses. Additionally, when both you and an illusion are within 5 feet of a creature that can see the illusion, you have advantage on attack rolls against that creature, given how distracting the illusion is to the target."
        classFeature125.lowerVariants!.insert(classFeature87)
        
        let classFeature126: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature126.id = 326
        classFeature126.name = "Avatar of Battle"
        classFeature126.level = 17
        classFeature126.subclass = subclassResults[10] //War Domain
        classFeature126.details = "\tYou have resistance to bludgeoning, piercing, and slashing damage from nonmagical weapons."
        
        let classFeature127: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature127.id = 327
        classFeature127.name = "Druidic"
        classFeature127.level = 1
        classFeature127.pclass = classResults[3] //Druid
        classFeature127.details = "\tYou know Druidic, the secret language of druids. You can speak the language and use it to leave hidden messages. You and others who know this language automatically spot such a message. Others spot the message's presence with a successful DC 15 Perception check but can't decipher it without magic."
        
        let classFeature128: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature128.id = 328
        classFeature128.name = "Wild Shape: CR 1/4"
        classFeature128.level = 2
        classFeature128.pclass = classResults[3] //Druid
        classFeature128.details = "\tYou can use your action to magically assume the shape of a beast that you have seen before equal to or under a challenge rating of 1/4 with no flying or swimming speed (such as a Wolf). You can use this feature twice per short or long rest.\n\tYou can stay in a beast shape for a number of hours equal to half your druid level (rounded down). You then revert to your normal form unless you expend another use of this feature. You can revert to your normal form earlier by using a bonus action on your turn. You automatically revert if you fall unconscious, drop to 0hp, or die.\n\tWhile transformed, the following rules apply:  \u{2022} Your game statistics are replaced by the statistics of the beast, but you retain your alignment, personality, and Intelligence, Wisdom, and Charisma scores. You also retain all of your skill and saving throw proficiencies, in addition to gaining those of the creature. If the creature has the same proficiency as you and the bonus in its stat block is higher than yours, use the creature's bonus instead of yours. If the creature has any legendary or lair actions, you can't use them.\n  \u{2022} When you transform, you assume the beast's hit points and Hit Dice. When you revert to your normal form, you return to the number of hit points you had before you transformed. However, if you revert as a result of dropping to 0hp, any excess damage carries over to your normal form. As long as the excess damage doesn't reduce your normal form to 0hp, you are not knocked unconscious.\n  \u{2022} You can't cast spells, and your ability to speak or take any action that requires hands is limited to the capabilities of your beast form. Transforming doesn't break your concentration on a spell you've already cast, however, or prevent you from taking actions that are part of a spell that you've already cast.\n  \u{2022} You retain the benefits of any features from your class, race, or other source and can use them if the new form is physically capable of doing so. However, you can't use any of your special senses, such as darkvision, unless your new form also has that sense.\n  \u{2022} You choose whether your equipment falls to the ground in your space, merges into your new form, or is worn by it. Worn equipment functions as normal, but the DM decides whether it is practical for the new form to wear a piece of equopment, based on the creature's shape and size. Your equipment doesn't change size or shape to match the new form, and any equipment that the new form can't wear must either fall to the ground or merge with it. Equipment that merges with the form has no effect until you leave the form."
        
        let classFeature129: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature129.id = 329
        classFeature129.name = "Wild Shape: CR 1/2"
        classFeature129.level = 4
        classFeature129.pclass = classResults[3] //Druid
        classFeature129.details = "\tYou can use your action to magically assume the shape of a beast that you have seen before equal to or under a challenge rating of 1/2 with no flying speed (such as a Crocodile). You can use this feature twice per short or long rest.\n\tYou can stay in a beast shape for a number of hours equal to half your druid level (rounded down). You then revert to your normal form unless you expend another use of this feature. You can revert to your normal form earlier by using a bonus action on your turn. You automatically revert if you fall unconscious, drop to 0hp, or die.\n\tWhile transformed, the following rules apply:  \u{2022} Your game statistics are replaced by the statistics of the beast, but you retain your alignment, personality, and Intelligence, Wisdom, and Charisma scores. You also retain all of your skill and saving throw proficiencies, in addition to gaining those of the creature. If the creature has the same proficiency as you and the bonus in its stat block is higher than yours, use the creature's bonus instead of yours. If the creature has any legendary or lair actions, you can't use them.\n  \u{2022} When you transform, you assume the beast's hit points and Hit Dice. When you revert to your normal form, you return to the number of hit points you had before you transformed. However, if you revert as a result of dropping to 0hp, any excess damage carries over to your normal form. As long as the excess damage doesn't reduce your normal form to 0hp, you are not knocked unconscious.\n  \u{2022} You can't cast spells, and your ability to speak or take any action that requires hands is limited to the capabilities of your beast form. Transforming doesn't break your concentration on a spell you've already cast, however, or prevent you from taking actions that are part of a spell that you've already cast.\n  \u{2022} You retain the benefits of any features from your class, race, or other source and can use them if the new form is physically capable of doing so. However, you can't use any of your special senses, such as darkvision, unless your new form also has that sense.\n  \u{2022} You choose whether your equipment falls to the ground in your space, merges into your new form, or is worn by it. Worn equipment functions as normal, but the DM decides whether it is practical for the new form to wear a piece of equopment, based on the creature's shape and size. Your equipment doesn't change size or shape to match the new form, and any equipment that the new form can't wear must either fall to the ground or merge with it. Equipment that merges with the form has no effect until you leave the form."
        classFeature129.lowerVariants!.insert(classFeature128)
        
        let classFeature130: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature130.id = 330
        classFeature130.name = "Wild Shape: CR 1"
        classFeature130.level = 8
        classFeature130.pclass = classResults[3] //Druid
        classFeature130.details = "\tYou can use your action to magically assume the shape of a beast that you have seen before equal to or under a challenge rating of 1 (such as a Giant Eagle). You can use this feature twice per short or long rest.\n\tYou can stay in a beast shape for a number of hours equal to half your druid level (rounded down). You then revert to your normal form unless you expend another use of this feature. You can revert to your normal form earlier by using a bonus action on your turn. You automatically revert if you fall unconscious, drop to 0hp, or die.\n\tWhile transformed, the following rules apply:  \u{2022} Your game statistics are replaced by the statistics of the beast, but you retain your alignment, personality, and Intelligence, Wisdom, and Charisma scores. You also retain all of your skill and saving throw proficiencies, in addition to gaining those of the creature. If the creature has the same proficiency as you and the bonus in its stat block is higher than yours, use the creature's bonus instead of yours. If the creature has any legendary or lair actions, you can't use them.\n  \u{2022} When you transform, you assume the beast's hit points and Hit Dice. When you revert to your normal form, you return to the number of hit points you had before you transformed. However, if you revert as a result of dropping to 0hp, any excess damage carries over to your normal form. As long as the excess damage doesn't reduce your normal form to 0hp, you are not knocked unconscious.\n  \u{2022} You can't cast spells, and your ability to speak or take any action that requires hands is limited to the capabilities of your beast form. Transforming doesn't break your concentration on a spell you've already cast, however, or prevent you from taking actions that are part of a spell that you've already cast.\n  \u{2022} You retain the benefits of any features from your class, race, or other source and can use them if the new form is physically capable of doing so. However, you can't use any of your special senses, such as darkvision, unless your new form also has that sense.\n  \u{2022} You choose whether your equipment falls to the ground in your space, merges into your new form, or is worn by it. Worn equipment functions as normal, but the DM decides whether it is practical for the new form to wear a piece of equopment, based on the creature's shape and size. Your equipment doesn't change size or shape to match the new form, and any equipment that the new form can't wear must either fall to the ground or merge with it. Equipment that merges with the form has no effect until you leave the form."
        classFeature130.lowerVariants!.insert(classFeature128)
        classFeature130.lowerVariants!.insert(classFeature129)
        
        let classFeature131: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature131.id = 331
        classFeature131.name = "Combat Wild Shape"
        classFeature131.level = 2
        classFeature131.subclass = subclassResults[11] //Circle of the Moon
        classFeature131.details = "\tYou have the ability to use Wild Shape on your turn as a bonus action, rather than as an action.\n\tAdditionally, while you are transformed by Wild Shape, you can use a bonus action to expend one spell slot to regain 1d8 hit points per level of the spell slot expended."
        
        let classFeature132: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature132.id = 332
        classFeature132.name = "Circle Forms (1)"
        classFeature132.level = 2
        classFeature132.subclass = subclassResults[11] //Circle of the Moon
        classFeature132.details = "\tThe rites of your circle grant you the ability to transform into more dangerous animal forms. You may use Wild Shape to transform into a beast with a challenge rating as high as 1, though it must retain the swimming and flying limitations of the Wild Shape feature for your druid level."
        
        let classFeature133: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature133.id = 333
        classFeature133.name = "Circle Forms (2)"
        classFeature133.level = 6
        classFeature133.subclass = subclassResults[11] //Circle of the Moon
        classFeature133.details = "\tThe rites of your circle grant you the ability to transform into more dangerous animal forms. You may use Wild Shape to transform into a beast with a challenge rating as high as your druid level divided by 3 (rounded down), though it must retain the swimming and flying limitations of the Wild Shape feature for your druid level."
        classFeature133.lowerVariants!.insert(classFeature132)
        
        let classFeature134: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature134.id = 334
        classFeature134.name = "Bonus Cantrip"
        classFeature134.level = 2
        classFeature134.subclass = subclassResults[12] //Circle of the Land: Arctic
        classFeature134.details = "\tYou know one additional druid cantrip of your choice."
        
        let classFeature135: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature135.id = 335
        classFeature135.name = "Bonus Cantrip"
        classFeature135.level = 2
        classFeature135.subclass = subclassResults[13] //Circle of the Land: Coast
        classFeature135.details = "\tYou know one additional druid cantrip of your choice."
        
        let classFeature136: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature136.id = 336
        classFeature136.name = "Bonus Cantrip"
        classFeature136.level = 2
        classFeature136.subclass = subclassResults[14] //Circle of the Land: Desert
        classFeature136.details = "\tYou know one additional druid cantrip of your choice."
        
        let classFeature137: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature137.id = 337
        classFeature137.name = "Bonus Cantrip"
        classFeature137.level = 2
        classFeature137.subclass = subclassResults[15] //Circle of the Land: Forest
        classFeature137.details = "\tYou know one additional druid cantrip of your choice."
        
        let classFeature138: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature138.id = 338
        classFeature138.name = "Bonus Cantrip"
        classFeature138.level = 2
        classFeature138.subclass = subclassResults[16] //Circle of the Land: Grassland
        classFeature138.details = "\tYou know one additional druid cantrip of your choice."
        
        let classFeature139: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature139.id = 339
        classFeature139.name = "Bonus Cantrip"
        classFeature139.level = 2
        classFeature139.subclass = subclassResults[17] //Circle of the Land: Mountain
        classFeature139.details = "\tYou know one additional druid cantrip of your choice."
        
        let classFeature140: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature140.id = 340
        classFeature140.name = "Bonus Cantrip"
        classFeature140.level = 2
        classFeature140.subclass = subclassResults[18] //Circle of the Land: Swamp
        classFeature140.details = "\tYou know one additional druid cantrip of your choice."
        
        let classFeature141: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature141.id = 341
        classFeature141.name = "Bonus Cantrip"
        classFeature141.level = 2
        classFeature141.subclass = subclassResults[19] //Circle of the Land: Underdark
        classFeature141.details = "\tYou know one additional druid cantrip of your choice."
        
        let classFeature142: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature142.id = 342
        classFeature142.name = "Natural Recovery"
        classFeature142.level = 2
        classFeature142.subclass = subclassResults[12] //Circle of the Land: Arctic
        classFeature142.details = "\tYou can regain some of your magical energy by sitting in meditation and communing with nature. During a short rest, you choose expended spell slots to recover. The spell slots can have a combined level that is equal to or less than half your druid level (rounded up), and none of the slots can be 6th level or higher. You can't use this feature again until you complete a long rest."
        
        let classFeature143: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature143.id = 343
        classFeature143.name = "Natural Recovery"
        classFeature143.level = 2
        classFeature143.subclass = subclassResults[13] //Circle of the Land: Coast
        classFeature143.details = "\tYou can regain some of your magical energy by sitting in meditation and communing with nature. During a short rest, you choose expended spell slots to recover. The spell slots can have a combined level that is equal to or less than half your druid level (rounded up), and none of the slots can be 6th level or higher. You can't use this feature again until you complete a long rest."
        
        let classFeature144: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature144.id = 344
        classFeature144.name = "Natural Recovery"
        classFeature144.level = 2
        classFeature144.subclass = subclassResults[14] //Circle of the Land: Desert
        classFeature144.details = "\tYou can regain some of your magical energy by sitting in meditation and communing with nature. During a short rest, you choose expended spell slots to recover. The spell slots can have a combined level that is equal to or less than half your druid level (rounded up), and none of the slots can be 6th level or higher. You can't use this feature again until you complete a long rest."
        
        let classFeature145: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature145.id = 345
        classFeature145.name = "Natural Recovery"
        classFeature145.level = 2
        classFeature145.subclass = subclassResults[15] //Circle of the Land: Forest
        classFeature145.details = "\tYou can regain some of your magical energy by sitting in meditation and communing with nature. During a short rest, you choose expended spell slots to recover. The spell slots can have a combined level that is equal to or less than half your druid level (rounded up), and none of the slots can be 6th level or higher. You can't use this feature again until you complete a long rest."
        
        let classFeature146: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature146.id = 346
        classFeature146.name = "Natural Recovery"
        classFeature146.level = 2
        classFeature146.subclass = subclassResults[16] //Circle of the Land: Grassland
        classFeature146.details = "\tYou can regain some of your magical energy by sitting in meditation and communing with nature. During a short rest, you choose expended spell slots to recover. The spell slots can have a combined level that is equal to or less than half your druid level (rounded up), and none of the slots can be 6th level or higher. You can't use this feature again until you complete a long rest."
        
        let classFeature147: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature147.id = 347
        classFeature147.name = "Natural Recovery"
        classFeature147.level = 2
        classFeature147.subclass = subclassResults[17] //Circle of the Land: Mountain
        classFeature147.details = "\tYou can regain some of your magical energy by sitting in meditation and communing with nature. During a short rest, you choose expended spell slots to recover. The spell slots can have a combined level that is equal to or less than half your druid level (rounded up), and none of the slots can be 6th level or higher. You can't use this feature again until you complete a long rest."
        
        let classFeature148: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature148.id = 348
        classFeature148.name = "Natural Recovery"
        classFeature148.level = 2
        classFeature148.subclass = subclassResults[18] //Circle of the Land: Swamp
        classFeature148.details = "\tYou can regain some of your magical energy by sitting in meditation and communing with nature. During a short rest, you choose expended spell slots to recover. The spell slots can have a combined level that is equal to or less than half your druid level (rounded up), and none of the slots can be 6th level or higher. You can't use this feature again until you complete a long rest."
        
        let classFeature149: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature149.id = 349
        classFeature149.name = "Natural Recovery"
        classFeature149.level = 2
        classFeature149.subclass = subclassResults[19] //Circle of the Land: Underdark
        classFeature149.details = "\tYou can regain some of your magical energy by sitting in meditation and communing with nature. During a short rest, you choose expended spell slots to recover. The spell slots can have a combined level that is equal to or less than half your druid level (rounded up), and none of the slots can be 6th level or higher. You can't use this feature again until you complete a long rest."
        
        let classFeature150: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature150.id = 350
        classFeature150.name = "Ability Score Improvement (1)"
        classFeature150.level = 4
        classFeature150.pclass = classResults[3] //Druid
        classFeature150.details = "\tYou can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can't increase an ability score above 20 using this feature."
        
        let classFeature151: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature151.id = 351
        classFeature151.name = "Ability Score Improvement (2)"
        classFeature151.level = 8
        classFeature151.pclass = classResults[3] //Druid
        classFeature151.details = "\tYou can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can't increase an ability score above 20 using this feature."
        classFeature151.lowerVariants!.insert(classFeature150)
        
        let classFeature152: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature152.id = 352
        classFeature152.name = "Ability Score Improvement (3)"
        classFeature152.level = 12
        classFeature152.pclass = classResults[3] //Druid
        classFeature152.details = "\tYou can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can't increase an ability score above 20 using this feature."
        classFeature152.lowerVariants!.insert(classFeature150)
        classFeature152.lowerVariants!.insert(classFeature151)
        
        let classFeature153: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature153.id = 353
        classFeature153.name = "Ability Score Improvement (4)"
        classFeature153.level = 16
        classFeature153.pclass = classResults[3] //Druid
        classFeature153.details = "\tYou can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can't increase an ability score above 20 using this feature."
        classFeature153.lowerVariants!.insert(classFeature150)
        classFeature153.lowerVariants!.insert(classFeature151)
        classFeature153.lowerVariants!.insert(classFeature152)
        
        let classFeature154: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature154.id = 354
        classFeature154.name = "Ability Score Improvement (5)"
        classFeature154.level = 19
        classFeature154.pclass = classResults[3] //Druid
        classFeature154.details = "\tYou can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can't increase an ability score above 20 using this feature."
        classFeature154.lowerVariants!.insert(classFeature150)
        classFeature154.lowerVariants!.insert(classFeature151)
        classFeature154.lowerVariants!.insert(classFeature152)
        classFeature154.lowerVariants!.insert(classFeature153)
        
        let classFeature155: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature155.id = 355
        classFeature155.name = "Primal Strike"
        classFeature155.level = 6
        classFeature155.subclass = subclassResults[11] //Circle of the Moon
        classFeature155.details = "\tYour attacks in beast form count as magical for the purpose of overcoming resistance and immunity to nonmagical attacks and damage."
        
        let classFeature156: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature156.id = 356
        classFeature156.name = "Land's Stride"
        classFeature156.level = 6
        classFeature156.subclass = subclassResults[12] //Circle of the Land: Arctic
        classFeature156.details = "\tMoving through nonmagical difficult terrain costs you no extra movement. You can also pass through nonmagical plants without being slowed by them and without taking damage from them if they have thorns, spines, or a similar hazard.\n\tIn addition, you have advantage on saving throws against plants that are magically created or manipulated to impede movement, such as those created by the Entangle spell."
        
        let classFeature157: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature157.id = 357
        classFeature157.name = "Land's Stride"
        classFeature157.level = 6
        classFeature157.subclass = subclassResults[13] //Circle of the Land: Coast
        classFeature157.details = "\tMoving through nonmagical difficult terrain costs you no extra movement. You can also pass through nonmagical plants without being slowed by them and without taking damage from them if they have thorns, spines, or a similar hazard.\n\tIn addition, you have advantage on saving throws against plants that are magically created or manipulated to impede movement, such as those created by the Entangle spell."
        
        let classFeature158: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature158.id = 358
        classFeature158.name = "Land's Stride"
        classFeature158.level = 6
        classFeature158.subclass = subclassResults[14] //Circle of the Land: Desert
        classFeature158.details = "\tMoving through nonmagical difficult terrain costs you no extra movement. You can also pass through nonmagical plants without being slowed by them and without taking damage from them if they have thorns, spines, or a similar hazard.\n\tIn addition, you have advantage on saving throws against plants that are magically created or manipulated to impede movement, such as those created by the Entangle spell."
        
        let classFeature159: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature159.id = 359
        classFeature159.name = "Land's Stride"
        classFeature159.level = 6
        classFeature159.subclass = subclassResults[15] //Circle of the Land: Forest
        classFeature159.details = "\tMoving through nonmagical difficult terrain costs you no extra movement. You can also pass through nonmagical plants without being slowed by them and without taking damage from them if they have thorns, spines, or a similar hazard.\n\tIn addition, you have advantage on saving throws against plants that are magically created or manipulated to impede movement, such as those created by the Entangle spell."
        
        let classFeature160: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature160.id = 360
        classFeature160.name = "Land's Stride"
        classFeature160.level = 6
        classFeature160.subclass = subclassResults[16] //Circle of the Land: Grassland
        classFeature160.details = "\tMoving through nonmagical difficult terrain costs you no extra movement. You can also pass through nonmagical plants without being slowed by them and without taking damage from them if they have thorns, spines, or a similar hazard.\n\tIn addition, you have advantage on saving throws against plants that are magically created or manipulated to impede movement, such as those created by the Entangle spell."
        
        let classFeature161: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature161.id = 361
        classFeature161.name = "Land's Stride"
        classFeature161.level = 6
        classFeature161.subclass = subclassResults[17] //Circle of the Land: Mountain
        classFeature161.details = "\tMoving through nonmagical difficult terrain costs you no extra movement. You can also pass through nonmagical plants without being slowed by them and without taking damage from them if they have thorns, spines, or a similar hazard.\n\tIn addition, you have advantage on saving throws against plants that are magically created or manipulated to impede movement, such as those created by the Entangle spell."
        
        let classFeature162: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature162.id = 362
        classFeature162.name = "Land's Stride"
        classFeature162.level = 6
        classFeature162.subclass = subclassResults[18] //Circle of the Land: Swamp
        classFeature162.details = "\tMoving through nonmagical difficult terrain costs you no extra movement. You can also pass through nonmagical plants without being slowed by them and without taking damage from them if they have thorns, spines, or a similar hazard.\n\tIn addition, you have advantage on saving throws against plants that are magically created or manipulated to impede movement, such as those created by the Entangle spell."
        
        let classFeature163: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature163.id = 363
        classFeature163.name = "Land's Stride"
        classFeature163.level = 6
        classFeature163.subclass = subclassResults[19] //Circle of the Land: Underdark
        classFeature163.details = "\tMoving through nonmagical difficult terrain costs you no extra movement. You can also pass through nonmagical plants without being slowed by them and without taking damage from them if they have thorns, spines, or a similar hazard.\n\tIn addition, you have advantage on saving throws against plants that are magically created or manipulated to impede movement, such as those created by the Entangle spell."
        
        let classFeature164: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature164.id = 364
        classFeature164.name = "Elemental Wild Shape"
        classFeature164.level = 10
        classFeature164.subclass = subclassResults[11] //Circle of the Moon
        classFeature164.details = "\tYou can expend two uses of Wild Shape at the same time to transform into an air elemental, an earth elemental, a fire elemental, or a water elemental."
        
        let classFeature165: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature165.id = 365
        classFeature165.name = "Nature's Ward"
        classFeature165.level = 10
        classFeature165.subclass = subclassResults[12] //Circle of the Land: Arctic
        classFeature165.details = "\tYou can't be charmed or frightened by elementals or fey, and you are immune to poison and disease."
        
        let classFeature166: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature166.id = 366
        classFeature166.name = "Nature's Ward"
        classFeature166.level = 10
        classFeature166.subclass = subclassResults[13] //Circle of the Land: Coast
        classFeature166.details = "\tYou can't be charmed or frightened by elementals or fey, and you are immune to poison and disease."
        
        let classFeature167: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature167.id = 367
        classFeature167.name = "Nature's Ward"
        classFeature167.level = 10
        classFeature167.subclass = subclassResults[14] //Circle of the Land: Desert
        classFeature167.details = "\tYou can't be charmed or frightened by elementals or fey, and you are immune to poison and disease."
        
        let classFeature168: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature168.id = 368
        classFeature168.name = "Nature's Ward"
        classFeature168.level = 10
        classFeature168.subclass = subclassResults[15] //Circle of the Land: Forest
        classFeature168.details = "\tYou can't be charmed or frightened by elementals or fey, and you are immune to poison and disease."
        
        let classFeature169: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature169.id = 369
        classFeature169.name = "Nature's Ward"
        classFeature169.level = 10
        classFeature169.subclass = subclassResults[16] //Circle of the Land: Grassland
        classFeature169.details = "\tYou can't be charmed or frightened by elementals or fey, and you are immune to poison and disease."
        
        let classFeature170: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature170.id = 370
        classFeature170.name = "Nature's Ward"
        classFeature170.level = 10
        classFeature170.subclass = subclassResults[17] //Circle of the Land: Mountain
        classFeature170.details = "\tYou can't be charmed or frightened by elementals or fey, and you are immune to poison and disease."
        
        let classFeature171: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature171.id = 371
        classFeature171.name = "Nature's Ward"
        classFeature171.level = 10
        classFeature171.subclass = subclassResults[18] //Circle of the Land: Swamp
        classFeature171.details = "\tYou can't be charmed or frightened by elementals or fey, and you are immune to poison and disease."
        
        let classFeature172: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature172.id = 372
        classFeature172.name = "Nature's Ward"
        classFeature172.level = 10
        classFeature172.subclass = subclassResults[19] //Circle of the Land: Underdark
        classFeature172.details = "\tYou can't be charmed or frightened by elementals or fey, and you are immune to poison and disease."
        
        let classFeature173: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature173.id = 373
        classFeature173.name = "Thousand Forms"
        classFeature173.level = 14
        classFeature173.subclass = subclassResults[11] //Circle of the Moon
        classFeature173.details = "\tYou know how to use magic to alter your physical form in more subtle ways. You can cast the Alter Self spell at will."
        
        let classFeature174: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature174.id = 374
        classFeature174.name = "Nature's Sanctuary"
        classFeature174.level = 14
        classFeature174.subclass = subclassResults[12] //Circle of the Land: Arctic
        classFeature174.details = "\tCreatures of the natural world sense your connection to nature and become hesitant to attack you. When a beast or plant creature attacks you, that creature must make a Wisdom saving throw against your druid spell save DC. On a failed save, the creature must choose a different target, or the attack automatically misses. On a successful save, the creature is immune to this effect for 24 hours.\n\tThe creature is aware of this effect before it makes its attack against you."
        
        let classFeature175: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature175.id = 375
        classFeature175.name = "Nature's Sanctuary"
        classFeature175.level = 14
        classFeature175.subclass = subclassResults[13] //Circle of the Land: Coast
        classFeature175.details = "\tCreatures of the natural world sense your connection to nature and become hesitant to attack you. When a beast or plant creature attacks you, that creature must make a Wisdom saving throw against your druid spell save DC. On a failed save, the creature must choose a different target, or the attack automatically misses. On a successful save, the creature is immune to this effect for 24 hours.\n\tThe creature is aware of this effect before it makes its attack against you."
        
        let classFeature176: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature176.id = 376
        classFeature176.name = "Nature's Sanctuary"
        classFeature176.level = 14
        classFeature176.subclass = subclassResults[14] //Circle of the Land: Desert
        classFeature176.details = "\tCreatures of the natural world sense your connection to nature and become hesitant to attack you. When a beast or plant creature attacks you, that creature must make a Wisdom saving throw against your druid spell save DC. On a failed save, the creature must choose a different target, or the attack automatically misses. On a successful save, the creature is immune to this effect for 24 hours.\n\tThe creature is aware of this effect before it makes its attack against you."
        
        let classFeature177: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature177.id = 377
        classFeature177.name = "Nature's Sanctuary"
        classFeature177.level = 14
        classFeature177.subclass = subclassResults[15] //Circle of the Land: Forest
        classFeature177.details = "\tCreatures of the natural world sense your connection to nature and become hesitant to attack you. When a beast or plant creature attacks you, that creature must make a Wisdom saving throw against your druid spell save DC. On a failed save, the creature must choose a different target, or the attack automatically misses. On a successful save, the creature is immune to this effect for 24 hours.\n\tThe creature is aware of this effect before it makes its attack against you."
        
        let classFeature178: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature178.id = 378
        classFeature178.name = "Nature's Sanctuary"
        classFeature178.level = 14
        classFeature178.subclass = subclassResults[16] //Circle of the Land: Grassland
        classFeature178.details = "\tCreatures of the natural world sense your connection to nature and become hesitant to attack you. When a beast or plant creature attacks you, that creature must make a Wisdom saving throw against your druid spell save DC. On a failed save, the creature must choose a different target, or the attack automatically misses. On a successful save, the creature is immune to this effect for 24 hours.\n\tThe creature is aware of this effect before it makes its attack against you."
        
        let classFeature179: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature179.id = 379
        classFeature179.name = "Nature's Sanctuary"
        classFeature179.level = 14
        classFeature179.subclass = subclassResults[17] //Circle of the Land: Mountain
        classFeature179.details = "\tCreatures of the natural world sense your connection to nature and become hesitant to attack you. When a beast or plant creature attacks you, that creature must make a Wisdom saving throw against your druid spell save DC. On a failed save, the creature must choose a different target, or the attack automatically misses. On a successful save, the creature is immune to this effect for 24 hours.\n\tThe creature is aware of this effect before it makes its attack against you."
        
        let classFeature180: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature180.id = 380
        classFeature180.name = "Nature's Sanctuary"
        classFeature180.level = 14
        classFeature180.subclass = subclassResults[18] //Circle of the Land: Swamp
        classFeature180.details = "\tCreatures of the natural world sense your connection to nature and become hesitant to attack you. When a beast or plant creature attacks you, that creature must make a Wisdom saving throw against your druid spell save DC. On a failed save, the creature must choose a different target, or the attack automatically misses. On a successful save, the creature is immune to this effect for 24 hours.\n\tThe creature is aware of this effect before it makes its attack against you."
        
        let classFeature181: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature181.id = 381
        classFeature181.name = "Nature's Sanctuary"
        classFeature181.level = 14
        classFeature181.subclass = subclassResults[19] //Circle of the Land: Underdark
        classFeature181.details = "\tCreatures of the natural world sense your connection to nature and become hesitant to attack you. When a beast or plant creature attacks you, that creature must make a Wisdom saving throw against your druid spell save DC. On a failed save, the creature must choose a different target, or the attack automatically misses. On a successful save, the creature is immune to this effect for 24 hours.\n\tThe creature is aware of this effect before it makes its attack against you."
        
        let classFeature182: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature182.id = 382
        classFeature182.name = "Timeless Body"
        classFeature182.level = 18
        classFeature182.pclass = classResults[3] //Druid
        classFeature182.details = "\tThe primal magic that you weild causes you to age more slowly. For every 10 years that pass, your body ages only 1 year."
        
        let classFeature183: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature183.id = 383
        classFeature183.name = "Beast Spells"
        classFeature183.level = 18
        classFeature183.pclass = classResults[3] //Druid
        classFeature183.details = "\tYou can cast many of your druid spells in any shape you assume using Wild Shape. You can perform the somatic and verbal components of a druid spell while in a beast shape, but you aren't able to provide material components."
        
        let classFeature184: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature184.id = 384
        classFeature184.name = "Archdruid"
        classFeature184.level = 20
        classFeature184.pclass = classResults[3] //Druid
        classFeature184.details = "\tYou can use your Wild Shape an unlimited number of times."
        
        
        
        
        
        
        
        
        
        
        
        //Placeholder class features (1 per class or subclass)
        
        

        
        let classFeature1005: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature1005.id = 305
        classFeature1005.name = "Second Wind"
        classFeature1005.level = 1
        classFeature1005.pclass = classResults[4]
        classFeature1005.details = "\tYou have a limited well of stamina that you can draw on to protect yourself from harm. On your turn, you can use a bonus action to regain hit points equal to 1d10 + your fighter level. Once you use this feature, you must finish a short or long rest before you can use it again."
        
        let classFeature1006: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature1006.id = 306
        classFeature1006.name = "Unarmored Defense"
        classFeature1006.level = 1
        classFeature1006.pclass = classResults[5]
        classFeature1006.details = "\tWhile you are wearing no armor and not wielding a shield, your AC equals 10 + your Dexterity modifier + your Wisdom modifier."
        
        let classFeature1007: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature1007.id = 307
        classFeature1007.name = "Divine Sense"
        classFeature1007.level = 1
        classFeature1007.pclass = classResults[6]
        classFeature1007.details = "\tThe presence of strong evil registers on your senses like a noxious odor, and powerful good rings like heavenly music in your ears. As an action, you can open your awareness to detect such forces. Until the end of your next turn, you know the location of any celestial, fiend, or undead within 60 feet of you that is not behind total cover. You know the type (celestial, fiend, or undead) of any being whose presence you sense, but not its identity. Within the same radius, you also detect the presence of any place or object that has been consecrated or desecrated, as with the Hallow spell.\n\tYou can use this feature a number of times equal to 1 + your Charisma modifier. When you finish a long rest, you regain all expended uses."
        
        let classFeature1008: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature1008.id = 308
        classFeature1008.name = "Favored Enemy"
        classFeature1008.level = 1
        classFeature1008.pclass = classResults[7]
        classFeature1008.details = "\tYou have significant experience studying, tracking, hunting, and even talking to a certain type of enemy.\n\tChoose a type of favored enemy: aberrations, beasts, celestials, constructs, dragons, elementals, fey, fiends, giants, monstrosities, oozes, plants, or undead. Alternatively, you can select two races of humanoid (such as gnolls and orcs) as favored enemies.\n\tYou have advantage on Survival checks to track your favored enemies, as well as on Intelligence checks to recall information about them.\n\tWhen you gain this feature, you also learn one language of your choice that is spoken by your favored enemies, if they speak one at all."
        
        let classFeature1009: ClassFeature = NSManagedObject(entity: cfEntity, insertIntoManagedObjectContext: context) as! ClassFeature
        classFeature1009.id = 309
        classFeature1009.name = "Expertise"
        classFeature1009.level = 1
        classFeature1009.pclass = classResults[8]
        classFeature1009.details = "\tChoose two of your skill proficiencies, or one of your skill proficiencies and your proficiency with thieves' tools. Your proficiency bonus is doubled for any ability check you make that uses either of the chosen proficiencies."
        
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
