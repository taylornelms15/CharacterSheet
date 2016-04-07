//
//  InventoryItem.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 4/7/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import Foundation
import CoreData

class InventoryItem: NSManagedObject {

    @NSManaged var id: Int64
    @NSManaged var name: String
    @NSManaged var quantity: Double
    @NSManaged var details: String
    @NSManaged var inv_inventory: Inventory?
    @NSManaged var weight: Double

}
