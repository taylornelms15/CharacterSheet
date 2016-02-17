//
//  Character.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 2/16/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import CoreData
import Foundation

class PCharacter: NSManagedObject{
    
    @NSManaged var id: Int16
    @NSManaged var name: String?
    @NSManaged var level: Int16
    @NSManaged var str: Int16
    @NSManaged var dex: Int16
    @NSManaged var con: Int16
    @NSManaged var intl: Int16
    @NSManaged var wis: Int16
    @NSManaged var cha: Int16
    @NSManaged var race: Race
    @NSManaged var pclass: PClass
    
    var ascores: AScores = AScores();
    
    func updateAScores(){
        ascores = AScores(str: Int(str), dex: Int(dex), con: Int(con), intl: Int(intl), wis: Int(wis), cha: Int(cha));
    }//updateAScores
    
}//character

func characterInit(entity: NSEntityDescription, context: NSManagedObjectContext){
    
    let character1 = NSManagedObject(entity: entity, insertIntoManagedObjectContext: context)
    
    character1.setValue(1, forKey: "id");
    character1.setValue("Jason", forKey: "name");
    character1.setValue(1, forKey: "level");
    character1.setValue(10, forKey: "str");
    character1.setValue(10, forKey: "dex");
    character1.setValue(10, forKey: "con");
    character1.setValue(10, forKey: "intl");
    character1.setValue(10, forKey: "wis");
    character1.setValue(10, forKey: "cha");
    //character1.setValue(nil, forKey: "race");
    
    do{
        try context.save()
    }catch let error as NSError{
        print("Could not save \(error), \(error.userInfo)")
    }
    
}//characterInit