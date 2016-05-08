//
//  OtherNotesStrings.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 5/7/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import Foundation
import CoreData


class OtherNotesStrings: NSManagedObject {

    
    @NSManaged var charDescription: String?
    @NSManaged var langDescription: String?
    @NSManaged var otherDescription: String?
    @NSManaged var pchar: PCharacter?

}//OtherNotesStrings
