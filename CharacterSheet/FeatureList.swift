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

    
    func addFeature(newFeat: Feature){
        
        if (newFeat.isMemberOfClass(BackgroundFeature)){
            backgroundFeatures.insert(newFeat);
        }//if backgroundfeature
        else if(newFeat.isMemberOfClass(RaceFeature)){
            raceFeatures.insert(newFeat)
        }//if
        
    }//addFeature
    
    func subtractFeature(oldFeat: Feature){
        
        for feat in backgroundFeatures{
            if (feat.id == oldFeat.id){
                backgroundFeatures.remove(feat)
                break;
            }
        }
        
        for feat in raceFeatures{
            if (feat.id == oldFeat.id){
                raceFeatures.remove(feat)
                break;
            }
        }
        
    }//subtractFeature
    
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
        
        
        return results
    }
}

/*
Feature id ranges:
1-13: Background Features
21-50: Race Features
61-102: Feats (canon)
111+: User-defined feats
*/
