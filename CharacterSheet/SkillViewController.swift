//
//  SkillViewController.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 2/20/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit
import CoreData

class SkillViewController: CSViewController, UIScrollViewDelegate{
    //MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profBonusLabel: UILabel!
    @IBOutlet weak var mainVertStack: UIStackView!
    @IBOutlet weak var strBonusLabel: UILabel!
    @IBOutlet weak var dexBonusLabel: UILabel!
    @IBOutlet weak var intlBonusLabel: UILabel!
    @IBOutlet weak var wisBonusLabel: UILabel!
    @IBOutlet weak var chaBonusLabel: UILabel!
    @IBOutlet weak var athSwitch: UISwitch!
    @IBOutlet weak var acrSwitch: UISwitch!
    @IBOutlet weak var sleSwitch: UISwitch!
    @IBOutlet weak var steSwitch: UISwitch!
    @IBOutlet weak var arcSwitch: UISwitch!
    @IBOutlet weak var hisSwitch: UISwitch!
    @IBOutlet weak var invSwitch: UISwitch!
    @IBOutlet weak var natSwitch: UISwitch!
    @IBOutlet weak var relSwitch: UISwitch!
    @IBOutlet weak var aniSwitch: UISwitch!
    @IBOutlet weak var insSwitch: UISwitch!
    @IBOutlet weak var medSwitch: UISwitch!
    @IBOutlet weak var perSwitch: UISwitch!
    @IBOutlet weak var surSwitch: UISwitch!
    @IBOutlet weak var decSwitch: UISwitch!
    @IBOutlet weak var intSwitch: UISwitch!
    @IBOutlet weak var prfSwitch: UISwitch!
    @IBOutlet weak var prsSwitch: UISwitch!
    @IBOutlet weak var athBonusLabel: UILabel!
    @IBOutlet weak var acrBonusLabel: UILabel!
    @IBOutlet weak var sleBonusLabel: UILabel!
    @IBOutlet weak var steBonusLabel: UILabel!
    @IBOutlet weak var arcBonusLabel: UILabel!
    @IBOutlet weak var hisBonusLabel: UILabel!
    @IBOutlet weak var invBonusLabel: UILabel!
    @IBOutlet weak var natBonusLabel: UILabel!
    @IBOutlet weak var relBonusLabel: UILabel!
    @IBOutlet weak var aniBonusLabel: UILabel!
    @IBOutlet weak var insBonusLabel: UILabel!
    @IBOutlet weak var medBonusLabel: UILabel!
    @IBOutlet weak var perBonusLabel: UILabel!
    @IBOutlet weak var surBonusLabel: UILabel!
    @IBOutlet weak var decBonusLabel: UILabel!
    @IBOutlet weak var intBonusLabel: UILabel!
    @IBOutlet weak var prfBonusLabel: UILabel!
    @IBOutlet weak var prsBonusLabel: UILabel!
    
    
    //MARK: variables
    
    var statBonusLabels: [UILabel] = []
    var profSwitches: [UISwitch] = []
    var getSkillProfFuncArray: [()->Bool] = []
    var profBonusLabels: [UILabel] = []
    
    //MARK: Actions

    @IBAction func profChanged(sender: UISwitch) {
        //Get our character out
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "PCharacter");
        fetchRequest.predicate = NSPredicate(format: "id = %@", String(appDelegate.currentCharacterId));
        var results: [PCharacter] = [];
        do{
            results = try managedContext.executeFetchRequest(fetchRequest) as! [PCharacter]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        results[0].updateAScores()
        //Note that now results[0] is our character
    
        let index: Int = profSwitches.indexOf(sender)!
        
        results[0].skillProfs.toggleProficiency(index)
        
        do{
            try managedContext.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
        updateLabels()
    }
    
    
    //MARK: Other functions
    
    func scrollViewDidScroll(sender: UIScrollView) {
        if (sender.contentOffset.x != 0) {
            var offset: CGPoint = sender.contentOffset;
            offset.x = 0;
            sender.contentOffset = offset;
        }
    }
    
    override func viewDidAppear(animated: Bool) {

        super.viewDidAppear(animated);
        
        
        statBonusLabels =   [strBonusLabel, dexBonusLabel, intlBonusLabel, wisBonusLabel, chaBonusLabel]
        profSwitches =      [athSwitch, acrSwitch, sleSwitch, steSwitch, arcSwitch, hisSwitch,
                             invSwitch, natSwitch, relSwitch, aniSwitch, insSwitch, medSwitch,
                             perSwitch, surSwitch, decSwitch, intSwitch, prfSwitch, prsSwitch]
        profBonusLabels =   [athBonusLabel, acrBonusLabel, sleBonusLabel, steBonusLabel, arcBonusLabel, hisBonusLabel,
                             invBonusLabel, natBonusLabel, relBonusLabel, aniBonusLabel, insBonusLabel, medBonusLabel,
                             perBonusLabel, surBonusLabel, decBonusLabel, intBonusLabel, prfBonusLabel, prsBonusLabel]
        
        
        
        //mainVertStack.frame.size.width = scrollView.frame.size.width - 16;
        
        updateLabels();
    }
    
    func updateLabels(){
        
        //Get our character out
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "PCharacter");
        fetchRequest.predicate = NSPredicate(format: "id = %@", String(appDelegate.currentCharacterId));
        var results: [PCharacter] = [];
        do{
            results = try managedContext.executeFetchRequest(fetchRequest) as! [PCharacter]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        results[0].updateAScores()
        //Note that now results[0] is our character
        
        let mySkillProfs: SkillProfs = results[0].skillProfs
        
        updateStatBonusLabels(results[0].ascores.getStrMod(),
            newDex: results[0].ascores.getDexMod(),
            newInt: results[0].ascores.getIntMod(),
            newWis: results[0].ascores.getWisMod(),
            newCha: results[0].ascores.getChaMod())
        
        getSkillProfFuncArray = [SkillProfs.getAthProf(mySkillProfs),
            SkillProfs.getAcrProf(mySkillProfs), SkillProfs.getSleProf(mySkillProfs),
            SkillProfs.getSteProf(mySkillProfs), SkillProfs.getArcProf(mySkillProfs),
            SkillProfs.getHisProf(mySkillProfs), SkillProfs.getInvProf(mySkillProfs),
            SkillProfs.getNatProf(mySkillProfs), SkillProfs.getRelProf(mySkillProfs),
            SkillProfs.getAniProf(mySkillProfs), SkillProfs.getInsProf(mySkillProfs),
            SkillProfs.getMedProf(mySkillProfs), SkillProfs.getPerProf(mySkillProfs),
            SkillProfs.getSurProf(mySkillProfs), SkillProfs.getDecProf(mySkillProfs),
            SkillProfs.getIntProf(mySkillProfs), SkillProfs.getPrfProf(mySkillProfs),
            SkillProfs.getPrsProf(mySkillProfs)]
        
        updateProfSwitches()
        
        updateProfBonusLabels(results[0])
        
        let profBonus = results[0].getProfBonus();
        if (profBonus >= 0) {profBonusLabel.text = "+\(profBonus)"}
        else {profBonusLabel.text = "\(profBonus)"}
        
    }//updateLabels
    
    func updateStatBonusLabels(newStr: Int, newDex: Int, newInt: Int, newWis: Int, newCha: Int){
        
        if (newStr >= 0){strBonusLabel.text = "+\(newStr)"}
        else {strBonusLabel.text = "\(newStr)"}
        if (newDex >= 0){dexBonusLabel.text = "+\(newDex)"}
        else {dexBonusLabel.text = "\(newDex)"}
        if (newInt >= 0){intlBonusLabel.text = "+\(newInt)"}
        else {intlBonusLabel.text = "\(newInt)"}
        if (newWis >= 0){wisBonusLabel.text = "+\(newWis)"}
        else {wisBonusLabel.text = "\(newWis)"}
        if (newCha >= 0){chaBonusLabel.text = "+\(newCha)"}
        else {chaBonusLabel.text = "\(newCha)"}
        
    }//updateStatBonusLabels
    
    func updateProfSwitches(){

        for i in 0 ..< getSkillProfFuncArray.count{
            profSwitches[i].setOn(getSkillProfFuncArray[i](), animated: false);
        }//for
        
    }//updateProfSwitches
    
    func updateProfBonusLabels(myChar: PCharacter){
        
        for i in 0 ..< getSkillProfFuncArray.count{
            let isProf: Bool = getSkillProfFuncArray[i]();
            var bonus: Int = 0;
            
            if (i == 0){//Strength
                bonus = myChar.ascores.getStrMod();
                if isProf {bonus += myChar.getProfBonus()}
                if (bonus >= 0){profBonusLabels[i].text = "+\(bonus)"}
                else {profBonusLabels[i].text = "\(bonus)"}
            }
            else if (i < 4){//Dexterity
                bonus = myChar.ascores.getDexMod();
                if isProf {bonus += myChar.getProfBonus()}
                if (bonus >= 0){profBonusLabels[i].text = "+\(bonus)"}
                else {profBonusLabels[i].text = "\(bonus)"}
            }
            else if (i < 9){//Intelligence
                bonus = myChar.ascores.getIntMod();
                if isProf {bonus += myChar.getProfBonus()}
                if (bonus >= 0){profBonusLabels[i].text = "+\(bonus)"}
                else {profBonusLabels[i].text = "\(bonus)"}
            }
            else if (i < 14){//Wisdom
                bonus = myChar.ascores.getWisMod();
                if isProf {bonus += myChar.getProfBonus()}
                if (bonus >= 0){profBonusLabels[i].text = "+\(bonus)"}
                else {profBonusLabels[i].text = "\(bonus)"}
            }
            else{//Charisma
                bonus = myChar.ascores.getChaMod();
                if isProf {bonus += myChar.getProfBonus()}
                if (bonus >= 0){profBonusLabels[i].text = "+\(bonus)"}
                else {profBonusLabels[i].text = "\(bonus)"}
            }
        }//for
        
    }//updateProfBonusLabels
    
}//SkillViewController
