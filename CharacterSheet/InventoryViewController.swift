//
//  InventoryViewController.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 4/5/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit
import CoreData

class InventoryViewController: CSViewController{
    
    var tableHeaderTitles: [String] = ["Armor", "Weapons", "Items"]
    
    //MARK: Outlets
    @IBOutlet weak var goldField: UITextField!
    @IBOutlet weak var silverField: UITextField!
    @IBOutlet weak var copperField: UITextField!
    @IBOutlet weak var inventoryTableView: UITableView!
    
    
}//InventoryViewController
