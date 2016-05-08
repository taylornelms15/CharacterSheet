//
//  SkillTableCells.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 5/8/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import CoreData
import UIKit

class SkillTableHeaderCell: UITableViewCell{
    
    //MARK: Outlets
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var headerModLabel: UILabel!
    
}//SkillTableHeaderCell

class SkillTableRowCell: UITableViewCell{
    
    var skillProfs: SkillProfs? = nil
    var pchar: PCharacter? = nil
    var index: Int = 0
    
    //MARK: Outlets
    @IBOutlet weak var rowTitleLabel: UILabel!
    @IBOutlet weak var rowModLabel: UILabel!
    @IBOutlet weak var rowProfButton: UIButton!
    
    //MARK: Actions
    @IBAction func rowProfButtonPressed(sender: UIButton) {
        
        skillProfs!.toggleProficiency(index)
        
        updateLabels()
        
        do{
            try skillProfs!.managedObjectContext!.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }//rowProfButtonPressed
    
    func updateLabels(){
        
        setProfText(skillProfs!.getProf(atIndex: index))
        setBonusText(getModifier())
        
    }//updateLabels
    
    func getModifier()-> Int{
        let relevantScoreIndex = SkillProfs.SkillStatTable[index].0
        var relevantAscoreBonus: Int = 0
        switch(relevantScoreIndex){
        case 0:
            relevantAscoreBonus = pchar!.ascores.getStrMod()
        case 1:
            relevantAscoreBonus = pchar!.ascores.getDexMod()
        case 2:
            relevantAscoreBonus = pchar!.ascores.getIntMod()
        case 3:
            relevantAscoreBonus = pchar!.ascores.getWisMod()
        case 4:
            relevantAscoreBonus = pchar!.ascores.getChaMod()
        default:
            break
        }//switch
        
        if (skillProfs!.getProf(atIndex: index)){
            relevantAscoreBonus += pchar!.getProfBonus()
        }
        
        return relevantAscoreBonus
    }//getModifier
    
    
    
    func setBonusText(bonus: Int){
        if (bonus < 0){
            rowModLabel.text = "\(bonus)"
        }
        else{
            rowModLabel.text = "+\(bonus)"
        }//else
    }//setBonusText
    
    func setProfText(prof: Bool){
        
        if (prof){
            rowProfButton.setTitle(CheckBox.Checked, forState: .Normal)
        }
        else{
            rowProfButton.setTitle(CheckBox.UnChecked, forState: .Normal)
        }
        
    }//setProfText
    
}//skillTableRowCell
