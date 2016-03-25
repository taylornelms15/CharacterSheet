//
//  CollectionViewCellClasses.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 3/21/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit
import CoreData

class AlignmentCell: UICollectionViewCell{
    
    @IBOutlet weak var alignmentField: UITextField!
    
}//AlignmentCell


class HpCell: UICollectionViewCell{
    
    @IBOutlet weak var currHpField: UITextField!
    @IBOutlet weak var maxHpField: UITextField!
    @IBOutlet weak var hitDieLabel: UILabel!
    
    
}//HpCell

class ArmorCell: UICollectionViewCell{
    
    @IBOutlet weak var armorField: UITextField!
    
    
}//ArmorCell

class SpellCell: UICollectionViewCell{
    
    @IBOutlet weak var spellSaveDCLabel: UILabel!
    @IBOutlet weak var spellAttackLabel: UILabel!
    
    
}//SpellCell