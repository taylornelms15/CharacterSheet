//
//  AbilityScoreViewController.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 3/25/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit
import CoreData

class AbilityScoreViewController: CSViewController, UITextFieldDelegate{
    
    //MARK: Properties
    var scores: AScores = AScores.init();
    
    //MARK: Outlets
    @IBOutlet weak var strLabel: UILabel!
    @IBOutlet weak var dexLabel: UILabel!
    @IBOutlet weak var conLabel: UILabel!
    @IBOutlet weak var intLabel: UILabel!
    @IBOutlet weak var wisLabel: UILabel!
    @IBOutlet weak var chaLabel: UILabel!
    
    @IBOutlet weak var strTextField: UITextField!
    @IBOutlet weak var dexTextField: UITextField!
    @IBOutlet weak var conTextField: UITextField!
    @IBOutlet weak var intTextField: UITextField!
    @IBOutlet weak var wisTextField: UITextField!
    @IBOutlet weak var chaTextField: UITextField!
    
    @IBOutlet weak var strModLabel: UILabel!
    @IBOutlet weak var dexModLabel: UILabel!
    @IBOutlet weak var conModLabel: UILabel!
    @IBOutlet weak var intModLabel: UILabel!
    @IBOutlet weak var wisModLabel: UILabel!
    @IBOutlet weak var chaModLabel: UILabel!
    
    @IBOutlet weak var strSavSwitch: UISwitch!
    @IBOutlet weak var dexSavSwitch: UISwitch!
    @IBOutlet weak var conSavSwitch: UISwitch!
    @IBOutlet weak var intSavSwitch: UISwitch!
    @IBOutlet weak var wisSavSwitch: UISwitch!
    @IBOutlet weak var chaSavSwitch: UISwitch!
    
    
    //MARK: Actions
    
    @IBAction func setStrValue(sender: UITextField) {
        sender.resignFirstResponder();
        let newValue: Int = NSNumberFormatter().numberFromString(sender.text!)!.integerValue;
        scores.setStr(newValue);
        sender.text = "\(newValue)";//force an int conversion to cut down on trash input
        let modval: Int = scores.getStrMod();
        if (modval >= 0){
            strModLabel.text = "+\(modval)";
        }//if
        else{
            strModLabel.text = "\(modval)";
        }//else
        
        updateScoresInCore()
    }
    @IBAction func setDexValue(sender: UITextField) {
        sender.resignFirstResponder();
        let newValue: Int = NSNumberFormatter().numberFromString(sender.text!)!.integerValue;
        scores.setDex(newValue);
        sender.text = "\(newValue)";//force an int conversion to cut down on trash input
        let modval: Int = scores.getDexMod();
        if (modval >= 0){
            dexModLabel.text = "+\(modval)";
        }//if
        else{
            dexModLabel.text = "\(modval)";
        }//else
        
        updateScoresInCore()
    }
    @IBAction func setConValue(sender: UITextField) {
        sender.resignFirstResponder();
        let newValue: Int = NSNumberFormatter().numberFromString(sender.text!)!.integerValue;
        scores.setCon(newValue);
        sender.text = "\(newValue)";//force an int conversion to cut down on trash input
        let modval: Int = scores.getConMod();
        if (modval >= 0){
            conModLabel.text = "+\(modval)";
        }//if
        else{
            conModLabel.text = "\(modval)";
        }//else
        
        updateScoresInCore()
    }
    @IBAction func setIntValue(sender: UITextField) {
        sender.resignFirstResponder();
        let newValue: Int = NSNumberFormatter().numberFromString(sender.text!)!.integerValue;
        scores.setInt(newValue);
        sender.text = "\(newValue)";//force an int conversion to cut down on trash input
        let modval: Int = scores.getIntMod();
        if (modval >= 0){
            intModLabel.text = "+\(modval)";
        }//if
        else{
            intModLabel.text = "\(modval)";
        }//else
        
        updateScoresInCore()
    }
    @IBAction func setWisValue(sender: UITextField) {
        sender.resignFirstResponder();
        let newValue: Int = NSNumberFormatter().numberFromString(sender.text!)!.integerValue;
        scores.setWis(newValue);
        sender.text = "\(newValue)";//force an int conversion to cut down on trash input
        let modval: Int = scores.getWisMod();
        if (modval >= 0){
            wisModLabel.text = "+\(modval)";
        }//if
        else{
            wisModLabel.text = "\(modval)";
        }//else
        
        updateScoresInCore()
    }
    @IBAction func setChaValue(sender: UITextField) {
        sender.resignFirstResponder();
        let newValue: Int = NSNumberFormatter().numberFromString(sender.text!)!.integerValue;
        scores.setCha(newValue);
        sender.text = "\(newValue)";//force an int conversion to cut down on trash input
        let modval: Int = scores.getChaMod();
        if (modval >= 0){
            chaModLabel.text = "+\(modval)";
        }//if
        else{
            chaModLabel.text = "\(modval)";
        }//else
        
        updateScoresInCore()
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    // MARK: Helper functions
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        //let entity =  NSEntityDescription.entityForName("PCharacter", inManagedObjectContext:managedContext)
        let fetchRequest = NSFetchRequest(entityName: "PCharacter");
        fetchRequest.predicate = NSPredicate(format: "id = %@", String(appDelegate.currentCharacterId));
        
        var results: [PCharacter] = [];
        do{
            results = try managedContext.executeFetchRequest(fetchRequest) as! [PCharacter]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
        //make the scores match what's in the database
        scores = AScores(
            str: Int(results[0].str),
            dex: Int(results[0].dex),
            con: Int(results[0].con),
            intl: Int(results[0].intl),
            wis: Int(results[0].wis),
            cha: Int(results[0].cha))
        
        updateTextFields(scores);
        
        let myClass: PClass? = results[0].pclass;
        if (myClass != nil){
            clearPrimAbil()
            updatePrimAbil(myClass!.primAbil)
            clearSavThrows()
            updateSavThrows(myClass!.saveThrows)
        }//if
        
    }//viewDidAppear
    
    func updateScoresInCore(){
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        //let entity =  NSEntityDescription.entityForName("PCharacter", inManagedObjectContext:managedContext)
        
        //getting the most recent version, just to be safe.
        let fetchRequest = NSFetchRequest(entityName: "PCharacter");
        fetchRequest.predicate = NSPredicate(format: "id = %@", String(appDelegate.currentCharacterId));
        
        var results: [PCharacter] = [];
        do{
            results = try managedContext.executeFetchRequest(fetchRequest) as! [PCharacter]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        results[0].updateAScores();
        
        results[0].ascores = scores;
        results[0].str = Int16(scores.getStr())
        results[0].dex = Int16(scores.getDex())
        results[0].con = Int16(scores.getCon())
        results[0].intl = Int16(scores.getInt())
        results[0].wis = Int16(scores.getWis())
        results[0].cha = Int16(scores.getCha())
        
        do{
            try managedContext.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }//updateScoresInCore
    
    func updateTextFields(newscores: AScores){
        strTextField.text = "\(newscores.getStr())"
        dexTextField.text = "\(newscores.getDex())"
        conTextField.text = "\(newscores.getCon())"
        intTextField.text = "\(newscores.getInt())"
        wisTextField.text = "\(newscores.getWis())"
        chaTextField.text = "\(newscores.getCha())"
        
        var modval: Int = 0;
        
        modval = newscores.getStrMod();
        if (modval >= 0){
            strModLabel.text = "+\(modval)";
        }//if
        else{
            strModLabel.text = "\(modval)";
        }//else
        
        modval = newscores.getDexMod();
        if (modval >= 0){
            dexModLabel.text = "+\(modval)";
        }//if
        else{
            dexModLabel.text = "\(modval)";
        }//else
        
        modval = newscores.getConMod();
        if (modval >= 0){
            conModLabel.text = "+\(modval)";
        }//if
        else{
            conModLabel.text = "\(modval)";
        }//else
        
        modval = newscores.getIntMod();
        if (modval >= 0){
            intModLabel.text = "+\(modval)";
        }//if
        else{
            intModLabel.text = "\(modval)";
        }//else
        
        modval = newscores.getWisMod();
        if (modval >= 0){
            wisModLabel.text = "+\(modval)";
        }//if
        else{
            wisModLabel.text = "\(modval)";
        }//else
        
        modval = newscores.getChaMod();
        if (modval >= 0){
            chaModLabel.text = "+\(modval)";
        }//if
        else{
            chaModLabel.text = "\(modval)";
        }//else
        
    }//updateTextFields
    
    func updateSavThrows(saveThrows: Int16){
        if (saveThrows % 10 == 1 || saveThrows / 10 == 1){
            strSavSwitch.setOn(true, animated: false)
        }//if
        
        if (saveThrows % 10 == 2 || saveThrows / 10 == 2){
            dexSavSwitch.setOn(true, animated: false)
        }//if
        
        if (saveThrows % 10 == 3 || saveThrows / 10 == 3){
            conSavSwitch.setOn(true, animated: false)
        }//if
        
        if (saveThrows % 10 == 4 || saveThrows / 10 == 4){
            intSavSwitch.setOn(true, animated: false)
        }//if
        
        if (saveThrows % 10 == 5 || saveThrows / 10 == 5){
            wisSavSwitch.setOn(true, animated: false)
        }//if
        
        if (saveThrows % 10 == 6 || saveThrows / 10 == 6){
            chaSavSwitch.setOn(true, animated: false)
        }//if
    }//updateSavThrows
    
    func clearSavThrows(){
        strSavSwitch.setOn(false, animated: false)
        dexSavSwitch.setOn(false, animated: false)
        conSavSwitch.setOn(false, animated: false)
        intSavSwitch.setOn(false, animated: false)
        wisSavSwitch.setOn(false, animated: false)
        chaSavSwitch.setOn(false, animated: false)
    }//clearSavThrows
    
    /**
    Designed to highlight the skill that is the class's primary ability.
    Commented out, as it's not visually clear
    */
    func updatePrimAbil(primAbil: Int16){
        /*
        if (primAbil % 10 == 1 || primAbil / 10 == 1){
            strLabel.backgroundColor = UIColor.lightGrayColor();
        }//if
        if (primAbil % 10 == 2 || primAbil / 10 == 2){
            dexLabel.backgroundColor = UIColor.lightGrayColor();
        }//if
        if (primAbil % 10 == 3 || primAbil / 10 == 3){
            conLabel.backgroundColor = UIColor.lightGrayColor();
        }//if
        if (primAbil % 10 == 4 || primAbil / 10 == 4){
            intLabel.backgroundColor = UIColor.lightGrayColor();
        }//if
        if (primAbil % 10 == 5 || primAbil / 10 == 5){
            wisLabel.backgroundColor = UIColor.lightGrayColor();
        }//if
        if (primAbil % 10 == 6 || primAbil / 10 == 6){
            chaLabel.backgroundColor = UIColor.lightGrayColor();
        }//if
        */
    }//updatePrimAbil
    
    func clearPrimAbil(){
        strLabel.backgroundColor = UIColor.clearColor();
        dexLabel.backgroundColor = UIColor.clearColor();
        conLabel.backgroundColor = UIColor.clearColor();
        intLabel.backgroundColor = UIColor.clearColor();
        wisLabel.backgroundColor = UIColor.clearColor();
        chaLabel.backgroundColor = UIColor.clearColor();
    }
    
    
    
}//AbilityScoreViewController