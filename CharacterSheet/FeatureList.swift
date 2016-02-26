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
              print(character!.race!.name!)
              print(newFeat.name)
        }//if
        
    }//addFeature
    
    func subtractFeature(oldFeat: Feature){
        
        if (backgroundFeatures.contains(oldFeat)){
            backgroundFeatures.remove(oldFeat)
        }//if backgroundfeature
        else if(raceFeatures.contains(oldFeat)){
            raceFeatures.remove(oldFeat);
        }//if

        
    }//subtractFeature
}
