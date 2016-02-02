//
//  Race.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 1/28/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import CoreData
import Foundation


class Race: NSManagedObject{

    @NSManaged var id: Int16
    @NSManaged var name: String?
    @NSManaged var strmod: Int16
    @NSManaged var dexmod: Int16
    @NSManaged var conmod: Int16
    @NSManaged var intmod: Int16
    @NSManaged var wismod: Int16
    @NSManaged var chamod: Int16
    
}