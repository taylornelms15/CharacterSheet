//
//  AbilityScoreTableCells.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 5/1/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit
import CoreData

class AbilityScoreHeader: UITableViewCell{
    
    //MARK: Outlets
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var modLabel: UILabel!
    @IBOutlet weak var savthrowprofLabel: UILabel!
    
    
}//abilityScoreHeader

class AbilityScoreTableCell: UITableViewCell{
    
    //MARK: Outlets
    @IBOutlet weak var ascoreLabel: UILabel!
    @IBOutlet weak var ascoreField: UITextField!
    @IBOutlet weak var ascoreModField: UILabel!
    @IBOutlet weak var ascoreSavThrowButton: UIButton!
    
    
}//abilityScoreTableCell
