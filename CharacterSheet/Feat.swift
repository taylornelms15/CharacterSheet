//
//  Feat.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 2/28/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import Foundation
import CoreData

class Feat: Feature {

    @NSManaged var canon: Bool

    
    static func featsInit(context: NSManagedObjectContext){
        
        let featEntity = NSEntityDescription.entityForName("Feat", inManagedObjectContext: context)!
        
        let feat1 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat1.setValue(61, forKey: "id")
        feat1.setValue(true, forKey: "canon")
        feat1.setValue("Alert", forKey: "name")
        feat1.setValue("You gain a +5 bonus to initiative, and cannot be surprised while conscious. Additionally, other creatures don't gain advantage from being hidden when attacking you.", forKey: "details")
        
        let feat2 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat2.setValue(62, forKey: "id")
        feat2.setValue(true, forKey: "canon")
        feat2.setValue("Athlete", forKey: "name")
        feat2.setValue("Increase your Strength or Dexterity score by 1. When prone, standing only uses 5 feet of movement. Additionally, climbing doesn't cost extra movement, and you may make a running jump after only 5 feet of movement rather than 10.", forKey: "details")
        
        let feat3 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat3.setValue(63, forKey: "id")
        feat3.setValue(true, forKey: "canon")
        feat3.setValue("Actor", forKey: "name")
        feat3.setValue("Increase your Charisma score by 1. You have advantage on Deception and Performance checks when passing yourself off as another person. Additionally, you may mimic another creature/person's speech or sounds, which may be found out by an Insight check defeating your Deception check.", forKey: "details")
        
        let feat4 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat4.setValue(64, forKey: "id")
        feat4.setValue(true, forKey: "canon")
        feat4.setValue("Charger", forKey: "name")
        feat4.setValue("When you use your action to Dash, you may attack or shove a creature as a bonus action. If the movement was in a straight line of at least 10 feet, you gain +5 damage to the attack roll or increase the shove distance by 10 feet.", forKey: "details")
        
        let feat5 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat5.setValue(65, forKey: "id")
        feat5.setValue(true, forKey: "canon")
        feat5.setValue("Crossbow Expert", forKey: "name")
        feat5.setValue("You ignore the loading properties of crossbows with which you are proficient, and being within 5 feet of a hostile creature doesn't impose disadvantage on your ranged attack rolls. Additionally, you may attack with a hand crossbow as a bonus action after attacking with a one-handed weapon.", forKey: "details")
        
        let feat6 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat6.setValue(66, forKey: "id")
        feat6.setValue(true, forKey: "canon")
        feat6.setValue("Defensive Duelist", forKey: "name")
        feat6.setValue("When wielding a finesse weapon with which you are proficient and another creature hits you with a melee attack, you may use your reaction to add your proficiency bonus to your AC for that attack. Taking this requires a Dexterity of 13 or higher.", forKey: "details")
        
        let feat7 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat7.setValue(67, forKey: "id")
        feat7.setValue(true, forKey: "canon")
        feat7.setValue("Dual Wielder", forKey: "name")
        feat7.setValue("You gain +1 to your AC while dual-wielding. You may also dual-wield one-handed weapons that are not light, and may draw or stow both weapons in the time it would take to draw/stow one of them.", forKey: "details")
        
        let feat8 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat8.setValue(68, forKey: "id")
        feat8.setValue(true, forKey: "canon")
        feat8.setValue("Dungeon Delver", forKey: "name")
        feat8.setValue("You have advantage on Perception and Investigation checks made to detect secret doors. You also have advantage on saving throws made to avoid traps, resistance to damage dealt by traps, and may search for traps while moving at a normal pace rather than just a slow pace.", forKey: "details")
        
        let feat9 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat9.setValue(69, forKey: "id")
        feat9.setValue(true, forKey: "canon")
        feat9.setValue("Durable", forKey: "name")
        feat9.setValue("Increase your Constitution score by 1. Additionally, when you roll a Hit Die to regain hit points, the minimum number of hit points you regain equals twice your Constitution modifier.", forKey: "details")
        
        let feat10 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat10.setValue(70, forKey: "id")
        feat10.setValue(true, forKey: "canon")
        feat10.setValue("Elemental Adept - Acid", forKey: "name")
        feat10.setValue("Spells you cast ignore resistance to acid damage, and if you cast a spell dealing acid damage, you may treat any 1 on a damage die as a 2.", forKey: "details")
        
        let feat11 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat11.setValue(71, forKey: "id")
        feat11.setValue(true, forKey: "canon")
        feat11.setValue("Elemental Adept - Cold", forKey: "name")
        feat11.setValue("Spells you cast ignore resistance to cold damage, and if you cast a spell dealing cold damage, you may treat any 1 on a damage die as a 2.", forKey: "details")
        
        let feat12 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat12.setValue(72, forKey: "id")
        feat12.setValue(true, forKey: "canon")
        feat12.setValue("Elemental Adept - Fire", forKey: "name")
        feat12.setValue("Spells you cast ignore resistance to fire damage, and if you cast a spell dealing fire damage, you may treat any 1 on a damage die as a 2.", forKey: "details")
        
        let feat13 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat13.setValue(73, forKey: "id")
        feat13.setValue(true, forKey: "canon")
        feat13.setValue("Elemental Adept - Lightning", forKey: "name")
        feat13.setValue("Spells you cast ignore resistance to lightning damage, and if you cast a spell dealing lightning damage, you may treat any 1 on a damage die as a 2.", forKey: "details")
        
        let feat14 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat14.setValue(74, forKey: "id")
        feat14.setValue(true, forKey: "canon")
        feat14.setValue("Elemental Adept - Thunder", forKey: "name")
        feat14.setValue("Spells you cast ignore resistance to thunder damage, and if you cast a spell dealing thunder damage, you may treat any 1 on a damage die as a 2.", forKey: "details")
        
        let feat15 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat15.setValue(75, forKey: "id")
        feat15.setValue(true, forKey: "canon")
        feat15.setValue("Grappler", forKey: "name")
        feat15.setValue("You have advantage on attack rolls against a creature you are grappling, and may use your action to try and pin the creature grappled by you by making an additional grapple check. If you succeed, you and the creature are restrained until the grapple ends.", forKey: "details")
        
        let feat16 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat16.setValue(76, forKey: "id")
        feat16.setValue(true, forKey: "canon")
        feat16.setValue("Great Weapon Master", forKey: "name")
        feat16.setValue("When you score a critical hit with a melee weapon or reduce a creature to 0 hit points with one, you may make a melee weapon attack as a bonus action. Additionally, before you make an attack with a heavy weapon with which you are proficient, you may choose to take a -5 penalty to the attack roll in exhange for a +10 bonus to damage upon a hit.", forKey: "details")
        
        let feat17 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat17.setValue(77, forKey: "id")
        feat17.setValue(true, forKey: "canon")
        feat17.setValue("Healer", forKey: "name")
        feat17.setValue("When you use a healing kit to stabilize a dying creature, the creature also regains 1 hit point. Additionally, as an action, you may use a healer's kit to tend to a creature and restore 1d6+4 hit points, plus the creature's maximum number of Hit Dice. The creature can only benefit from this feat once per short or long rest.", forKey: "details")
        
        let feat18 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat18.setValue(78, forKey: "id")
        feat18.setValue(true, forKey: "canon")
        feat18.setValue("Heavily Armored", forKey: "name")
        feat18.setValue("Increase your Strength score by 1. You gain proficiency with heavy armor. Taking this feat requires proficiency with medium armor.", forKey: "details")
        
        let feat19 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat19.setValue(79, forKey: "id")
        feat19.setValue(true, forKey: "canon")
        feat19.setValue("Heavy Armor Master", forKey: "name")
        feat19.setValue("Increase your Strength score by 1. Additionally, while wearing heavy armor, non-magical bludgeoning, piercing, and slashing damage is reduced by 3. Taking this feat requires proficiency with heavy armor.", forKey: "details")
        
        let feat20 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat20.setValue(80, forKey: "id")
        feat20.setValue(true, forKey: "canon")
        feat20.setValue("Inspiring Leader", forKey: "name")
        feat20.setValue("You may spend 10 minutes inspiring your companions, affecting up to 6 friendly creatures within 30 feet of you. Each gains temporary hit points equal to your level + your Charisma modifier. The creature can only benefit from this feat once per short or long rest. Taking this requires a Charisma of 13 or higher.", forKey: "details")
        
        let feat21 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat21.setValue(81, forKey: "id")
        feat21.setValue(true, forKey: "canon")
        feat21.setValue("Keen Mind", forKey: "name")
        feat21.setValue("Increase your Intelligence score by 1. You always know which direction is north, the number of hours before the next sunrise/sunset, and you may accurately recall anything you have seen or heard in the past month.", forKey: "details")
        
        let feat22 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat22.setValue(82, forKey: "id")
        feat22.setValue(true, forKey: "canon")
        feat22.setValue("Lightly Armored", forKey: "name")
        feat22.setValue("Increase your Strength or Dexterity score by 1. You gain proficiency with light armor.", forKey: "details")
        
        let feat23 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat23.setValue(83, forKey: "id")
        feat23.setValue(true, forKey: "canon")
        feat23.setValue("Linguist", forKey: "name")
        feat23.setValue("Increase your Intelligence score by 1. You learn three languaged of your choice. Additionally, you may create written ciphers, decipherable by others only if you have taught them the cipher, they succeed an Intelligence check (DC equalling your Intelligence score plus your proficiency bonus), or they decipher it using magic.", forKey: "details")
        
        let feat24 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat24.setValue(84, forKey: "id")
        feat24.setValue(true, forKey: "canon")
        feat24.setValue("Lucky", forKey: "name")
        feat24.setValue("You have 3 luck points. When making an attack roll, ability check, or saving throw, you may spend one point to roll an additional d20. You may also spend one point when an attack roll is made against you, and then roll a d20 and choose which roll is used for the attack. If two creatures use luck points on a roll, the effects cancel out. You regain spent points after a long rest.", forKey: "details")
        
        let feat25 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat25.setValue(85, forKey: "id")
        feat25.setValue(true, forKey: "canon")
        feat25.setValue("Mage Slayer", forKey: "name")
        feat25.setValue("When a creature within 5 feet casts a spell, you have advantage on saving throws against that spell, and you may use your reaction to make a melee weapon attack against the creature. Additionally, when you damage a creature that is concentrating on a spell, it has disadvantage on the saving throw to maintain concentration.", forKey: "details")
        
        let feat26 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat26.setValue(86, forKey: "id")
        feat26.setValue(true, forKey: "canon")
        feat26.setValue("Magic Initiate", forKey: "name")
        feat26.setValue("Choose a class: Bard, Cleric, Druid, Sorcerer, Warlock, or Wizard. You learn two cantrips from this class' spell list. You also may choose one first-level spell from this spell list, and may, once per long rest, cast it once at its lowest level. The spellcasting ability for these spells matches that for the class you have chosen.", forKey: "details")
        
        let feat27 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat27.setValue(87, forKey: "id")
        feat27.setValue(true, forKey: "canon")
        feat27.setValue("Martial Adept", forKey: "name")
        feat27.setValue("You learn two maneuvers of your choice from the Battle Master archetype of the Fighter class. Any saving throws against them are equal to 8 plus your proficiency modifier plus either your Strength or Dexterity modifier. Additionally, you gain one superiority die (d6), which is used to fuel these maneuvers, and is expended when you use it.", forKey: "details")
        
        let feat28 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat28.setValue(88, forKey: "id")
        feat28.setValue(true, forKey: "canon")
        feat28.setValue("Medium Armor Master", forKey: "name")
        feat28.setValue("Wearning medium armor doesn't impose disadvantage on your Stealth checks. Additionally, when wearing medium armor, you can add 3 to your AC rather than 2, if you have a Dexterity of 16 or higher. Taking this feat requires proficiency with medium armor.", forKey: "details")
        
        let feat29 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat29.setValue(89, forKey: "id")
        feat29.setValue(true, forKey: "canon")
        feat29.setValue("Mobile", forKey: "name")
        feat29.setValue("Your speed increases by 10 feet, and difficult terrain doesn't cost any extra movement when using Dash. Additionally, when you make a melee attack against a creature, you don't provoke opportunity attacks from them for the rest of the turn.", forKey: "details")
        
        let feat30 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat30.setValue(90, forKey: "id")
        feat30.setValue(true, forKey: "canon")
        feat30.setValue("Moderately Armored", forKey: "name")
        feat30.setValue("Increase your Strength or Dexterity score by 1. You gain proficiency with medium armor and shields. Taking this feat requires proficiency with light armor.", forKey: "details")
        
        let feat31 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat31.setValue(91, forKey: "id")
        feat31.setValue(true, forKey: "canon")
        feat31.setValue("Mounted Combatant", forKey: "name")
        feat31.setValue("While mounted, you have advantahe on melee attack rolls against unmounted creatures smaller than your mount. You can force an attack targeted at your mount to target you instead. Additionally, if your mount must make a Dexterity saving throw to take only half damage from an effect, it instead takes no damage on the throw's success and half damage on the throw's failure.", forKey: "details")
        
        let feat32 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat32.setValue(92, forKey: "id")
        feat32.setValue(true, forKey: "canon")
        feat32.setValue("Observant", forKey: "name")
        feat32.setValue("Increase your Intelligence or Wisdom score by 1. You may read lips if a creature is speaking a language you understand. You also gain +5 bonus to your Perception and Investigation scores.", forKey: "details")
        
        let feat33 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat33.setValue(93, forKey: "id")
        feat33.setValue(true, forKey: "canon")
        feat33.setValue("Polearm Master", forKey: "name")
        feat33.setValue("When attacking with a glaive, halberd, or quarterstaff, you may attack with the opposite end of the weapon as a bonus action, for 1d4 bludgeoning damage. Additionally, creatures provoke an opportunity attack from you when entering within the reach of the weapon.", forKey: "details")
        
        let feat34 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat34.setValue(94, forKey: "id")
        feat34.setValue(true, forKey: "canon")
        feat34.setValue("Resilient", forKey: "name")
        feat34.setValue("Choose one ability score. You gain +1 to it, and gain proficiency in saving throws using it.", forKey: "details")
        
        let feat35 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat35.setValue(95, forKey: "id")
        feat35.setValue(true, forKey: "canon")
        feat35.setValue("Ritual Caster", forKey: "name")
        feat35.setValue("You acquire a ritual book containing two 1st-level spells of your choice from the bard, cleric, druid, sorcerer, warlock, or wizard spell list, provided they have the Ritual tag. You may also add spells you come across in written form. The spellcasting ability for these spells matches that for the class you have chosen.", forKey: "details")
        
        let feat36 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat36.setValue(96, forKey: "id")
        feat36.setValue(true, forKey: "canon")
        feat36.setValue("Savage Attacker", forKey: "name")
        feat36.setValue("Once per turn, when you roll damage for a melee weapon attack, you may reroll the damage dice and use either total.", forKey: "details")
        
        let feat37 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat37.setValue(97, forKey: "id")
        feat37.setValue(true, forKey: "canon")
        feat37.setValue("Sentinel", forKey: "name")
        feat37.setValue("When you hit a creature with an opportunity attack, their speed becomes 0 for the rest of the turn. Creatures provoke opportunity attacks from you even if they use the Disengage action. Additionally, when a creature within 5 feet of you makes an attack against a target that isn't you, you may use your reaction to make a melee attack against the creature.", forKey: "details")
        
        let feat38 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat38.setValue(98, forKey: "id")
        feat38.setValue(true, forKey: "canon")
        feat38.setValue("Sharpshooter", forKey: "name")
        feat38.setValue("Attacking at long range doesn't impose disadvantage on your ranged attack rolls, and your ranged attacks ignore half cover and three-quarters cover. Additionally, before making a ranged attack with a weapon with which you are proficient, you may choose to take a -5 penalty to the attack roll in exhange for a +10 bonus to damage upon a hit.", forKey: "details")
        
        let feat39 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat39.setValue(99, forKey: "id")
        feat39.setValue(true, forKey: "canon")
        feat39.setValue("Shield Master", forKey: "name")
        feat39.setValue("If you attack on your turn, you may use a bonus action to try and shove a creature with your shield. You may also add your shield's AC bonus to any Dexterity saving throw you make against a spell or effect targeting only you. You may also, if subjected to an effect allowing you to make a Dexterity saving throw to take half damage, use your reaction to take no damage on the throw's success.", forKey: "details")
        
        let feat40 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat40.setValue(100, forKey: "id")
        feat40.setValue(true, forKey: "canon")
        feat40.setValue("Skilled", forKey: "name")
        feat40.setValue("You gain proficiency in any combination of three skills or tools of your choice.", forKey: "details")
        
        let feat41 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat41.setValue(101, forKey: "id")
        feat41.setValue(true, forKey: "canon")
        feat41.setValue("Skulker", forKey: "name")
        feat41.setValue("You may try to hide when lightly obscured. When you are hidden from a creature and miss it with a ranged weapon attack, the attack does not reveal your position. Additionally, dim light doesn't impose disadvantage on your Perception checks. Taking this requires a Dexterity of 13 or higher.", forKey: "details")
        
        let feat42 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat42.setValue(102, forKey: "id")
        feat42.setValue(true, forKey: "canon")
        feat42.setValue("Spell Sniper", forKey: "name")
        feat42.setValue("Your ranged spell attacks have their ranges doubled, and ignore half-cover and three-quarters cover. You also learn one cantrip that requires an attack roll, and the spellcasting ability for this cantrip matches the class from whose spell list you have chosen it.", forKey: "details")
        
        let feat43 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat43.setValue(103, forKey: "id")
        feat43.setValue(true, forKey: "canon")
        feat43.setValue("Tavern Brawler", forKey: "name")
        feat43.setValue("Increase your Strength or Constitution score by 1. You are proficient with improvised weapons. Your unarmed strike uses a d4 for damage, and when hitting a creature with an unarmed strike or improvised weapon, you may use a bonus action to attempt to grapple them.", forKey: "details")
        
        let feat44 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat44.setValue(104, forKey: "id")
        feat44.setValue(true, forKey: "canon")
        feat44.setValue("Tough", forKey: "name")
        feat44.setValue("Your hit point maximum increases by an amount equal to twice your level when you gain this feat. When gaining a level thereafter, your hit point maximum increases by an additional 2.", forKey: "details")
        
        let feat45 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat45.setValue(105, forKey: "id")
        feat45.setValue(true, forKey: "canon")
        feat45.setValue("War Caster", forKey: "name")
        feat45.setValue("You have advantage on Constitution saving throws that you make to maintain concentration on spells when you take damage. You may perform the comatic components of spells even with weapons or shields in your hands. Additionally, when a hostile creature provokes an opportunity attack from you, you may use your reaction to cast a spell against them instead.", forKey: "details")
        
        let feat46 = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        feat46.setValue(106, forKey: "id")
        feat46.setValue(true, forKey: "canon")
        feat46.setValue("Weapon Master", forKey: "name")
        feat46.setValue("Increase your Strength or Dexterity score by 1. Additionally, you gain proficiency with four simple or martial weapons of your choice.", forKey: "details")
        
        do{
            try context.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }//featsInit
    
}
