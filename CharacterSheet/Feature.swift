//
//  Feature.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 2/25/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import Foundation
import CoreData

class Feature: NSManagedObject {

    @NSManaged var id: Int64
    @NSManaged var name: String
    @NSManaged var details: String
    
}
