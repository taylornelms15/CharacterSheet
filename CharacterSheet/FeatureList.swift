//
//  FeatureList.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 2/25/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import Foundation
import CoreData

class FeatureList: NSManagedObject {

    @NSManaged var character: PCharacter?
    @NSManaged var backgroundFeatures: Set<Feature>
    @NSManaged var raceFeatures: Set<Feature>
    @NSManaged var feats: Set<Feature>
    @NSManaged var spellList: SpellList
    @NSManaged var classFeatures: NSMutableOrderedSet?
    
    private let headerTitles: [String] = ["Race Features", "Class Features", "Background Features", "Feats", "Spells"]
    
    func addSpell(spell: Spell){
        spellList.addSpell(spell: spell)
    }//addSpell
    
    func removeSpell(spell: Spell){
        spellList.removeSpell(spell: spell)
    }//removeSpell
    
    func getNumberOfSpells() -> Int{
        return spellList.spells.count
    }//getNumberOfSpells
    
    func getNumberOfSections()->Int{
        
        var numSections: Int = 0
        
        for i in 0..<headerTitles.count{
            if doesHeaderExistAtIndex(i){
                numSections += 1
            }
        }//for
        
        return numSections
        
    }//getNumberOfSections
    
    func getTitleOfSection(section: Int)->String{
        
        if (getNumberOfSections() - 1 < section){
            return ""
        }//return empty string if we're out of bounds
        
        let headerIndex: Int = getNthLowestExtantHeaderIndex(section)
        
        return headerTitles[headerIndex]
        
    }//getTitleOfSection
    
    /**
     Given n, find (nth + 1) lowest extant header index.
     For example, for n = 0, find the lowest extant header index.
     For n = 1, find the second lowest, etc.
     */
    func getNthLowestExtantHeaderIndex(n: Int)->Int{
        
        var numFound: Int = 0
        
        for i in 0..<headerTitles.count{
            if doesHeaderExistAtIndex(i){
                numFound += 1
            }//if header at i exists, we've found the numFound'th extant header index at i
            
            if (numFound == n + 1){
                return i
            }
        }//for
        
        return 0
    }//getNthLowestExtantHeaderIndex
    
    private func doesHeaderExistAtIndex(index: Int)->Bool{
        switch index{
        case 0:
            return (raceFeatures.count > 0)
        case 1:
            let level = character!.level
            return (getFilteredClassFeatures(atLevel: level).count > 0)
        case 2:
            return (backgroundFeatures.count > 0)
        case 3:
            return (feats.count > 0)
        case 4:
            return (getNumberOfSpells() > 0)
        default:
            return false
        }//switch
    }//doesHeaderExistAtIndex
    
    func addFeature(newFeat: Feature){
        
        if (newFeat.isMemberOfClass(BackgroundFeature)){
            backgroundFeatures.insert(newFeat);
        }//if backgroundfeature
        else if(newFeat.isMemberOfClass(RaceFeature)){
            raceFeatures.insert(newFeat)
        }//if
        else if (newFeat.isMemberOfClass(Feat)){
            feats.insert(newFeat)
        }//if
        
    }//addFeature
    
    func subtractFeature(oldFeat: Feature){
        
        for feat in backgroundFeatures{
            if (feat.id == oldFeat.id){
                backgroundFeatures.remove(feat)
                break;
            }
        }//for
        
        for feat in raceFeatures{
            if (feat.id == oldFeat.id){
                raceFeatures.remove(feat)
                break;
            }
        }//for
        
        for feat in feats{
            if (feat.id == oldFeat.id){
                feats.remove(feat)
                
                if ((feat as! Feat).canon == false){
                    
                    self.managedObjectContext!.deleteObject(feat)
                    
                    do{
                        try self.managedObjectContext!.save()
                    }catch let error as NSError{
                        print("Could not save \(error), \(error.userInfo)")
                    }
                    
                }//if we're deleting the feat
                break
            }//if
        }//for
        
    }//subtractFeature
    
    func subtractAllClassFeatures(){
        
        classFeatures!.removeAllObjects()
        
    }//subtractAllClassFeatures
    
    /**
     Puts the pclass' class features into our featurelist, and makes sure they're sorted by level.
     The expectation is that the PChar is modifying this
     - Parameter pclass: The class we're building our class feature list from
     */
    func buildClassFeatures(fromClass pclass: PClass, usingSubclass subclass: Subclass?){
        
        classFeatures = NSMutableOrderedSet()
        
        for feature in pclass.features{
            classFeatures!.addObject(feature)
        }
        
        classFeatures!.sortUsingDescriptors([NSSortDescriptor(key: "level", ascending: true), NSSortDescriptor(key: "name", ascending: true)])//sort by feature level, then alphabetically
        
        if (subclass != nil){
            for feature in subclass!.features{
                classFeatures!.addObject(feature)
            }//for
        }//if subclass
        
    }//buildClassFeatures
    
    /**
     Changes our class feature list to have features from the correct new subclass.
     Allows nil on either parameter to allow for a lack of subclass.
     The expectation is that this is called by the PChar
     - Parameter oldSubclass: The previous subclass, if any
     - Parameter newSubclass: The new subclass, if any
     */
    func changeSubclass(from oldSubclass: Subclass?, toNewSubclass newSubclass: Subclass?){
        
        for feature in classFeatures!{
            let myClassFeature = feature as! ClassFeature
            
            if (myClassFeature.subclass != nil && oldSubclass != nil && myClassFeature.subclass == oldSubclass){
                classFeatures!.removeObject(feature)
            }//if
            
        }//for each class feature, remove if necessary
        
        if newSubclass != nil{
            
            for feature in newSubclass!.features{
                classFeatures!.addObject(feature)
            }//for
            
        }//if we have a new subclass, put in its features
        
        classFeatures!.sortUsingDescriptors([NSSortDescriptor(key: "level", ascending: true), NSSortDescriptor(key: "name", ascending: true)])//sort by feature level, then alphabetically
        
    }//changeSubClass
    
    /**
     Filters the class features based on (class) level.
     The expectation is that the featureList has already been modified by its parent PCharacter to include the correct subclass features.
     */
    func getFilteredClassFeatures(atLevel level: Int16)->[ClassFeature]{
        
        var results: [ClassFeature] = []
        
        for i in 0..<classFeatures!.count{
            
            let myClassFeature = classFeatures![i] as! ClassFeature
            
            if myClassFeature.level > level{
                continue
            }//if we're too low-level for this one
            
            if (myClassFeature.lowerVariants != nil){
                for a in myClassFeature.lowerVariants!{
                    if (results.contains(a)){
                        let myIndex = results.indexOf(a)!
                        results[myIndex] = myClassFeature
                        break
                    }
                }
            }//if we have lower variants
            
            if (results.contains(myClassFeature) == false){
                results.append(myClassFeature)
            }//if we haven't already added the feature by replacing a lower-level version of it
            
        }//for
        
        return results
        
    }//getFilteredClassFeatures
    
    func printAll()->String{
        var results: String = ""
        for feat in backgroundFeatures{
            results.appendContentsOf(feat.name)
            results.appendContentsOf(" ")
        }
        for feat in raceFeatures{
            results.appendContentsOf(feat.name)
            results.appendContentsOf(" ")
        }
        for feat in feats{
            results.appendContentsOf(feat.name)
            results.appendContentsOf(" ")
        }
        
        return results
    }
}

/*
Feature id ranges:
1-13: Background Features
21-50: Race Features
61-102: Feats (canon)
111+: User-defined feats?
*/
