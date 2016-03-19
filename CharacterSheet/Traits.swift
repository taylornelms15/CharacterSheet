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
        
        let fetchRequest = NSFetchRequest(entityName: "Trait")
        fetchRequest.predicate = NSPredicate(format: "id > %@", String(id))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        var results: [Trait] = [];
        do{
            results = try context.executeFetchRequest(fetchRequest) as! [Trait]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }//catch
        //results now contains all traits above this one's id
        
        if (results.count != 0){
            for trait in results{
                trait.id = trait.id - 1
            }//for all traits in results
        }//if there are
        
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
            [
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