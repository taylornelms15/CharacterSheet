//
//  SpellDetailViewController.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 4/3/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit
import CoreData

class SpellDetailViewController: UIViewController{
    
    var mySpell: Spell? = nil
    
    //MARK: Outlets
    @IBOutlet weak var spellNameLabel: UILabel!
    @IBOutlet weak var spellLevelTypeLabel: UILabel!
    @IBOutlet weak var castingTimeLabel: UILabel!
    @IBOutlet weak var rangeLabel: UILabel!
    @IBOutlet weak var componentLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var backgroundView: UIView!
    
    @IBAction func exitDetailController(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        backgroundView.layer.cornerRadius = 10.0
        backgroundView.layer.borderWidth = 4.0
        backgroundView.layer.borderColor = UIColor.darkGrayColor().CGColor
        
        updateLabelsWithSpell(spell: mySpell!)
    }
    
    func updateLabelsWithSpell(spell spell: Spell){
        
        spellNameLabel.text = spell.name
        spellLevelTypeLabel.text = spell.levelTypeString()
        castingTimeLabel.text = spell.castingTime
        rangeLabel.text = spell.rangeString()
        componentLabel.text = spell.componentString()
        durationLabel.text = spell.duration
        detailTextView.text = spell.details
        
    }//updateLabelsWithSpell
    
    
}//SpellDetailViewController
