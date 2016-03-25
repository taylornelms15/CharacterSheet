//
//  Traits.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 3/13/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import CoreData

class Trait: NSManagedObject{
    
    @NSManaged var id: Int64
    @NSManaged var name: String?
    @NSManaged var details: String?
    @NSManaged var canon: Bool
    @NSManaged var category: Int16
    @NSManaged var inv_traitList: NSSet?
    
    //MARK: Category getters
    func isPersTrait()->Bool{
        return (category == 1)
    }
    func isIdeal()->Bool{
        return (category == 2)
    }
    func isBond()->Bool{
        return (category == 3)
    }
    func isFlaw()->Bool{
        return (category == 4)
    }
    
    /**
     Handles setting id and such for the custom trait
     - Parameter context The context into which to put the trait
    */
    func addToCoreData(intoContext context: NSManagedObjectContext){
        
        let fetchRequest = NSFetchRequest(entityName: "Trait")
        fetchRequest.predicate = NSPredicate(format: "id > 1000", argumentArray: nil)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        var results: [Trait] = [];
        do{
            results = try context.executeFetchRequest(fetchRequest) as! [Trait]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }//catch
        //results now contains all traits above id 1000 (so, all the non-canon ones), in ascending order
        
        if (results.count == 0){
            id = Int64(1001)
        }//if this is first canon entry
        else{
            var newId: Int64 = results[results.count - 1].id
            newId++
            id = newId
        }//there are other non-canon traits
        
        do{
            try context.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }//addToCoreData
    
    /**
    Intelligently removes trait from core data, updating id values
    - Parameter context the context from which to pull the trait
    */
    func removeFromCoreData(fromContext context: NSManagedObjectContext){
        
        let predicateFormatString = "id > \(id)"
        var error: NSError? = nil
        
        let fetchRequest = NSFetchRequest(entityName: "Trait")
        fetchRequest.predicate = NSPredicate(format: predicateFormatString)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        let count = context.countForFetchRequest(fetchRequest, error: &error)
        
        if (count != 0){
            var results: [Trait] = [];
            do{
                results = try context.executeFetchRequest(fetchRequest) as! [Trait]
            }catch let error as NSError{
                print("Could not save \(error), \(error.userInfo)")
            }//catch
            //results now contains all traits above this one's id
            
            for trait in results{
                trait.id = trait.id - 1
            }//for all traits in results
            
        }//if there are any higher-numbered traits

        
        context.deleteObject(self) //just like suicide!
        
        do{
            try context.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }//removeFromCoreData
    
    /**
    Helper to get the category number for a specific trait category
    * Personality Trait 1: 1
    * Personality Trait 2: 1
    * Ideal: 2
    * Bond: 3
    * Flaw: 4
    - Parameter name: the name of the category
    - Returns: Int16 value representing the category number of the trait
    */
    static func getCategoryNumFromName(name: String)->Int16{
        
        switch (name){
            case "Personality Trait 1":
            return Int16(1)
            case "Personality Trait 2":
            return Int16(1)
            case "Ideal":
            return Int16(2)
            case "Bond":
            return Int16(3)
            case "Flaw":
            return Int16(4)
        default:
            return Int16(0)
        }
        
    }//getCategoryNumFromName
    
}//Trait

class TraitList: NSManagedObject{
    
    @NSManaged var traits: Set<Trait>
    
    //MARK: character set trait methods
    
    func setPersTrait(newTrait: Trait, replaceTrait: Trait?)->Bool{
        if (replaceTrait != nil){
            if(traits.remove(replaceTrait!) == nil){
                traits.insert(newTrait)
                return false
            }//if old trait not found
            else{
                traits.insert(newTrait)
                return true
            }//if successful replace
        }//if replacing
        else{
            traits.insert(newTrait)
            return true
        }//else not replacing
    }//setPersTrait
    func setIdeal(newIdeal: Trait){
        for i in traits{
            if (i.category == 2){
                traits.remove(i)
            }//if
        }//for
        traits.insert(newIdeal)
        return
    }//setIdeal
    func setBond(newBond: Trait){
        for i in traits{
            if (i.category == 3){
                traits.remove(i)
            }//if
        }//for
        traits.insert(newBond)
        return
    }//setBond
    func setFlaw(newFlaw: Trait){
        for i in traits{
            if (i.category == 4){
                traits.remove(i)
            }//if
        }//for
        traits.insert(newFlaw)
        return
    }//setFlaw
    
    static func traitsInit(context: NSManagedObjectContext){
        
        let traitsData: [[[String]]] = [
            [//Acolyte
                ["Hero-Worshipper", "I idolize a particular hero of my faith and constantly refer to that person's deeds and example."],
                ["Diplomat", "I can find common ground between the fiercest enemies, empathizing with them and always working toward peace."],
                ["Omen-Seer", "I see omens in every event and action. The gods try to speak to us; we just need to listen."],
                ["Optimistic", "Nothing can shake my optimistic attitude."],
                ["Quote-Heavy", "I quote (or misquote) sacred texts and proverbs in almost every situation."],
                ["(In)Tolerant", "I am tolerant (or intolerant) of other faiths and respect (or condemn) the worship of other gods."],
                ["Pampered", "I've enjoyed fine food, drink, and high society among my temple's elite. Rough living grates on me."],
                ["Isolated", "I've spent so long in the temple that I have little practical experience dealing with people in the outside world."],
                ["Tradition", "The ancient traditions of worship and sacrifice must be preserved and upheld."],
                ["Charity", "I always try to help those in need, no matter what the personal cost."],
                ["Change", "We must help bring about the changes the gods are constantly working in the world."],
                ["Power", "I hope to one day rise to the top of my faith's religious hierarchy."],
                ["Faith", "I trust that my deity will guide my actions. I have faith that if I work hard, things will go well."],
                ["Aspiration", "I seek to prove myself worthy of my god's favor by matching my actions against his or her teachings."],
                ["Relic", "I would die to recover an ancient relic of my faith that was lost long ago."],
                ["Revenge", "I will someday get revenge on the corrupt temple hierarchy who branded me a heretic."],
                ["Orphan", "I owe my life to the priest who took me in when my parents died."],
                ["Common Folk", "Everything I do is for the common people."],
                ["Temple", "I will do anything to protect the temple where I served."],
                ["Sacred Text", "I seek to preserve a sacred text that my enemies consider heretical and seek to destroy."],
                ["Judgemental", "I judge others harshly, and myself even more severely."],
                ["Trusting of Elders", "I put too much trust in those who wield power within my temple's hierarchy."],
                ["Trusting of Faithful", "My piety sometimes leads me to blindly trust those that profess faith in my god."],
                ["Inflexible", "I am inflecible in my thinking."],
                ["Suspicious", "I am suspicious of strangers and suspect the worst of them."],
                ["Obsessed", "Once I pick a goal, I become obsessed with it to the detriment of everything else in my life."]
            ],
            [//Charlatan
                ["Lover", "I fall in and out of love easiler, and am always pursuing someone."],
                ["Joker", "I have a joke for every occasion, especially occasions where humor is inappropriate."],
                ["Flatterer", "Flattery is my preferred trick for getting what I want."],
                ["Gambler", "I'm a born gambler who can't resist taking a risk for a potential payoff."],
                ["Liar", "I lie about almost everything, even when there's no good reason to."],
                ["Sarcastic", "Sarcasm and insults are my weapon of choice."],
                ["Fake Faith", "I keep multiple holy symbols on me and involve whatever deity might come in useful at any given moment."],
                ["Scavenger", "I pocket anything I see that might have some value."],
                ["Independence", "I am a free spirit - no one tells me what to do."],
                ["Fairness", "I never target people who can't afford to lose a few coins."],
                ["Charity", "I distribute the money I acquire to the people who really need it."],
                ["Creativity", "I never run the same con twice"],
                ["Friendship", "Material goods come and go. Bonds of friendship last forever."],
                ["Aspiration", "I'm determined to make something of myself"],
                ["Bad Target", "I fleeced the wrong person and must work to ensure that this individual never crosses paths with me or those I care about."],
                ["Mentor Debt", "I owe everything to my mentor - a horrible person who's probably rotting in jail somewhere."],
                ["Faraway Child", "Somewhere out there, I have a child who doesn't know me. I'm making the world better for them."],
                ["Noble's Revenge", "I come from a noble family, and one day I'll reclaim my lands and title from those who stole them from me."],
                ["Lover's Revenge", "A powerful person killed someone I love. Some day soon, I'll have my revenge."],
                ["Regret", "I swindled and ruined a person who didn't deserve it. I seek to atone for my misdeeds, but might never be able to forgive myself."],
                ["Easily Charmed", "I can't resist a pretty face."],
                ["Debt", "I'm always in debt. I spend my ill-gotted gains on decadent luxuries faster than I bring them in."],
                ["Pride", "I'm convinced that no one could ever fool me the way I fool others."],
                ["Greed", "I'm too greedy for my own good. I can't resist taking a risk if there's money involved."],
                ["Fight the Power", "I can't resist swindling people who are more powerful than I am."],
                ["Coward", "I hate to admit it and will hate myself for it, but I'll run and preserve my own hide if the going gets tough."]
            ],
            [//Criminal
                ["Planner", "I always have a plan for what to do when things go wrong."],
                ["Calm", "I am always calm, no matter what the situation. I never raise my voice or let my emotions control me."],
                ["Case the Joint", "The first thing I do in a new place is note the locations of everything valuable - or where such things could be hidden."],
                ["Friendly", "I would rather make a new friend than a new enemy."],
                ["Distrustful", "I am incredibly slow to trust. Those who seem the fairest often have the most to hide."],
                ["Reckless", "I don't pay attention to the risks in a situation. Never tell me the odds."],
                ["Daring", "The best way to get me to do something is to tell me I can't do it."],
                ["Easily Insulted", "I blow up at the slightest insult."],
                ["Honor", "I don't steal from others in the trade."],
                ["Freedom", "Chains are meant to be broken, as are those who would forge them."],
                ["Charity", "I steal from the wealthy so that I can help people in need."],
                ["Greed", "I will do whatever it takes to become wealthy."],
                ["People", "I'm loyal to my friends, not to any ideals, and everyone else can take a trip down the Styx for all I care."],
                ["Redemption", "There's a spark of good in everyone."],
                ["Debt", "I'm trying to pay off an old debt I owe to a generous benefactor"],
                ["Family", "My ill-gotten gains go to support my family"],
                ["Counter-Theft", "Something important was taken from me, and I aim to steal it back."],
                ["Aspiration", "I will become the greatest thief that ever lived."],
                ["Guilt", "I'm guilty of a terrible crime. I hope I can redeem myself for it."],
                ["Lost Love", "Someone I loved died because of a mistake I made. That will never happen again."],
                ["Easily Tempted", "When I see something valuable, I can't think about anything but how to steal it."],
                ["Disloyal", "When faced with a choice between money and my friends, I usually choose the money."],
                ["Improviser", "If there's a plan, I'l forget it. If I don't forget it, I'll ignore it."],
                ["Bad Liar", "I have a \"tell\" that reveals when I'm lying."],
                ["Coward", "I turn tail and run when things look bad."],
                ["Heartless", "An innocent person is in prison for a crime that I committed. I'm okay with that."]
            ],
            [//Entertainer
                ["Storyteller", "I know a story relevant to almost every situation."],
                ["Gossip", "Whenever I come to a new place, I collect local rumors and spread gossip."],
                ["Romantic", "I'm a hopeless romantic, always searching for that \"special someone.\""],
                ["Calming Presence", "Nobody stays angry at me or around me for long, since I can defuse any amount of tension."],
                ["Insulting", "I love a good insult, even one directed at me."],
                ["Attention-Seeker", "I get bitter if I'm not the center of attention."],
                ["Perfectionist", "I'll settle for nothing less than perfection."],
                ["Fickle", "I change my mood or my mind as quickly as I change key in a song."],
                ["Beauty", "When I perform, I make the world better than it was."],
                ["Tradition", "The stories, legends, and songs of the past must never be forgotten, for they teach us who we are."],
                ["Creativity", "The world is in need of new udeas and bold action."],
                ["Greed", "I'm only in it for the money and fame."],
                ["People", "I like seeing the smiles on people's faces when I perform. That's all that matters."],
                ["Honesty", "Art should reflect the soul; it should come from within and reveal who we really are."],
                ["Sentimental Instrument", "My instrument is my most treasured possession, and it reminds me of someone I love."],
                ["Stolen Instrument", "Someone stole my precious instrument, and someday I'll get it back."],
                ["Fame", "I want to be famous, whatever it takes."],
                ["Hero-Worship", "I idolize a hero of the old tales and measure my deeds against that person's."],
                ["Rival", "I will do anything to prove myself superior to my hated rival."],
                ["Loyal", "I would do anything for the other members of my old troupe."],
                ["Cutthroat", "I'll do anything to win fame and renown."],
                ["Easily Charmed", "I'm a sucker for a pretty face."],
                ["Scandalized", "A scandal prevents me from ever going home again. That kind of trouble seems to follow me around."],
                ["Bad Target", "I once satirized a noble who still wants my head. It was a mistake that I will likely repeat."],
                ["No Filter", "I have trouble keeping my true feelings hidden. My sharp tongue lands me in trouble."],
                ["Unreliable", "Despite my best efforts, I am unreliable to my friends."]
            ]
        ]
        
        let tEntity = NSEntityDescription.entityForName("Trait", inManagedObjectContext: context)!
        let tlEntity = NSEntityDescription.entityForName("TraitList", inManagedObjectContext: context)!
        
        //Get a background out
        let fetchRequest = NSFetchRequest(entityName: "Background");
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        var results: [Background] = [];
        do{
            results = try context.executeFetchRequest(fetchRequest) as! [Background]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }//catch
        
        var traitLists: [TraitList] = []
        
        for (var i = 0; i < traitsData.count; i++){
            
            let thisTraitList: TraitList = NSManagedObject(entity: tlEntity, insertIntoManagedObjectContext: context) as! TraitList
            traitLists.append(thisTraitList)
            
            for (var j = 0; j < 8; j++){
                let thisTrait: Trait = NSManagedObject(entity: tEntity, insertIntoManagedObjectContext: context) as! Trait
                
                thisTrait.id = 1 + i * 26 + j
                thisTrait.name = traitsData[i][j][0]
                thisTrait.details = traitsData[i][j][1]
                thisTrait.category = 1
                thisTrait.canon = true
                
                traitLists[i].traits.insert(thisTrait)
            }// personality traits
            for (var j = 8; j < 14; j++){
                let thisTrait: Trait = NSManagedObject(entity: tEntity, insertIntoManagedObjectContext: context) as! Trait
                
                thisTrait.id = 1 + i * 26 + j
                thisTrait.name = traitsData[i][j][0]
                thisTrait.details = traitsData[i][j][1]
                thisTrait.category = 2
                thisTrait.canon = true
                
                traitLists[i].traits.insert(thisTrait)
            }// ideals
            for (var j = 14; j < 20; j++){
                let thisTrait: Trait = NSManagedObject(entity: tEntity, insertIntoManagedObjectContext: context) as! Trait
                
                thisTrait.id = 1 + i * 26 + j
                thisTrait.name = traitsData[i][j][0]
                thisTrait.details = traitsData[i][j][1]
                thisTrait.category = 3
                thisTrait.canon = true
                
                traitLists[i].traits.insert(thisTrait)
            }// bonds
            for (var j = 20; j < 26; j++){
                let thisTrait: Trait = NSManagedObject(entity: tEntity, insertIntoManagedObjectContext: context) as! Trait
                
                thisTrait.id = 1 + i * 26 + j
                thisTrait.name = traitsData[i][j][0]
                thisTrait.details = traitsData[i][j][1]
                thisTrait.category = 4
                thisTrait.canon = true
                
                traitLists[i].traits.insert(thisTrait)
            }// flaws
            
            results[i].traitList = traitLists[i]
            
        }//for each background
        
        do{
            try context.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }//traitsInit
    
}//TraitList