//
//  SpellTableCells.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 3/27/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit
import CoreData

/*
Important constants:
"\u{2B1C}" is an unchecked box
"\u{2611}" is a checked box
*/

/**
This is the superclass for any UITableViewCell classes that display spell info.
 This allows them to dynamically support a variety of visual options, such as spells being prepared, being rituals, etc.
 The common functionality is as such:
 
 * Every spell cell has a name
 * Every spell cell has a detail button
 * Pressing the detail button will pop up a window that discloses details about the spell
 
 Important
*/
class SpellTableCell: UITableViewCell{


    var name: String = ""    
    var details: String = ""
    
    //MARK: Outlets
    @IBOutlet weak var spellNameLabel: UILabel!
    
    //MARK: Setting with Spell
    
    func setInfoWithSpell(spell spell: Spell){
        self.name = spell.name
        spellNameLabel.text = spell.name
        
        self.details = spell.description //might do something different in the future
    }//setInfoWithSpell

    
}//spellCell

class PersonalSpellTableHeader: UITableViewHeaderFooterView{
    
    var level: Int = 0
    var persSpellList: PersonalSpellList? = nil
    
    //MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    //@IBOutlet weak var slotStepper: UIStepper!
    @IBOutlet weak var slotsExpendedLabel: UILabel!
    @IBOutlet weak var slotsMaxLabel: UILabel!
    @IBOutlet weak var slotsStackView: UIStackView!
    @IBOutlet weak var overallView: UIView!
    
    
    /*
    func setMaxStepper(max: Int){
        slotStepper.maximumValue = Double(max)
    }//setMaxStepper
  */  
    
}//PersonalSpellTableHeader