//
//  AbilityScoreViewController.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 3/25/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit
import CoreData

class AbilityScoreViewController: CSViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{
    
    //MARK: Properties
    var scores: AScores = AScores.init();
    
    //MARK: Outlets
    
    weak var strTextField: UITextField? = nil
    weak var dexTextField: UITextField? = nil
    weak var conTextField: UITextField? = nil
    weak var intTextField: UITextField? = nil
    weak var wisTextField: UITextField? = nil
    weak var chaTextField: UITextField? = nil
    
    weak var strModLabel: UILabel? = nil
    weak var dexModLabel: UILabel? = nil
    weak var conModLabel: UILabel? = nil
    weak var intModLabel: UILabel? = nil
    weak var wisModLabel: UILabel? = nil
    weak var chaModLabel: UILabel? = nil
    
    weak var strProfButton: UIButton? = nil
    weak var dexProfButton: UIButton? = nil
    weak var conProfButton: UIButton? = nil
    weak var intProfButton: UIButton? = nil
    weak var wisProfButton: UIButton? = nil
    weak var chaProfButton: UIButton? = nil
    
    let scoreNames: [String] = ["Strength", "Dexterity", "Constitution", "Intelligence", "Wisdom", "Charisma"]
    
    @IBOutlet weak var ascoreTableView: UITableView!
    
    
    // MARK: UITextFieldDelegate
    
    ///Enforces numerical entries
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        //Potential todo: restrict this function to the named text fields. Only relevant if we put other text fields in this VC
            let text = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            
            if (text == ""){
                return true
            }//allow empty string
            if (Int(text) == nil){
                return false
            }//if the new value wouldn't be an int
            else{
                return true
            }//if we're still talking numerically
    }//shouldChangeCharactersInRange
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if (textField.text == nil || textField.text == ""){
            textField.text = "10"
        }//if empty string, make it a default 10
        
        let newValue: Int = Int(textField.text!)!
        var modValue: Int = 0
        switch(textField){
        case strTextField!:
            scores.setStr(newValue)
            modValue = scores.getStrMod()
            strModLabel!.text = getModString(modValue)
        case dexTextField!:
            scores.setDex(newValue)
            modValue = scores.getDexMod()
            dexModLabel!.text = getModString(modValue)
        case conTextField!:
            scores.setCon(newValue)
            modValue = scores.getConMod()
            conModLabel!.text = getModString(modValue)
        case intTextField!:
            scores.setInt(newValue)
            modValue = scores.getIntMod()
            intModLabel!.text = getModString(modValue)
        case wisTextField!:
            scores.setWis(newValue)
            modValue = scores.getWisMod()
            wisModLabel!.text = getModString(modValue)
        case chaTextField!:
            scores.setCha(newValue)
            modValue = scores.getChaMod()
            chaModLabel!.text = getModString(modValue)
        default:
            break
        }//switch
        
        updateScoresInCore()
        
        //ascoreTableView.reloadData()
        
        
    }//textFieldDidEndEditing
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false;
    }//textfieldShouldReturn
    
    // MARK: Helper functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ascoreTableView.delegate = self
        ascoreTableView.dataSource = self
        
    }//viewDidLoad
    
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
            clearSavThrows()
            updateSavThrows(myClass!.saveThrows)
        }//if
        
        ascoreTableView.reloadData()
        

        
    }//viewDidAppear
    
    func getModString(mod: Int)->String{
        if (mod >= 0){
            return "+\(mod)"
        }
        else{
            return "\(mod)"
        }
    }//getModString
    
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
        strTextField?.text = "\(newscores.getStr())"
        dexTextField?.text = "\(newscores.getDex())"
        conTextField?.text = "\(newscores.getCon())"
        intTextField?.text = "\(newscores.getInt())"
        wisTextField?.text = "\(newscores.getWis())"
        chaTextField?.text = "\(newscores.getCha())"
        
        var modval: Int = 0;
        
        modval = newscores.getStrMod();
        if (modval >= 0){
            strModLabel?.text = "+\(modval)";
        }//if
        else{
            strModLabel?.text = "\(modval)";
        }//else
        
        modval = newscores.getDexMod();
        if (modval >= 0){
            dexModLabel?.text = "+\(modval)";
        }//if
        else{
            dexModLabel?.text = "\(modval)";
        }//else
        
        modval = newscores.getConMod();
        if (modval >= 0){
            conModLabel?.text = "+\(modval)";
        }//if
        else{
            conModLabel?.text = "\(modval)";
        }//else
        
        modval = newscores.getIntMod();
        if (modval >= 0){
            intModLabel?.text = "+\(modval)";
        }//if
        else{
            intModLabel?.text = "\(modval)";
        }//else
        
        modval = newscores.getWisMod();
        if (modval >= 0){
            wisModLabel?.text = "+\(modval)";
        }//if
        else{
            wisModLabel?.text = "\(modval)";
        }//else
        
        modval = newscores.getChaMod();
        if (modval >= 0){
            chaModLabel?.text = "+\(modval)";
        }//if
        else{
            chaModLabel?.text = "\(modval)";
        }//else
        
    }//updateTextFields
    
    func updateSavThrows(saveThrows: Int16){
        if (saveThrows % 10 == 1 || saveThrows / 10 == 1){
            strProfButton?.setTitle(CheckBox.Checked, forState: .Normal)
        }//if
        
        if (saveThrows % 10 == 2 || saveThrows / 10 == 2){
            dexProfButton?.setTitle(CheckBox.Checked, forState: .Normal)
        }//if
        
        if (saveThrows % 10 == 3 || saveThrows / 10 == 3){
            conProfButton?.setTitle(CheckBox.Checked, forState: .Normal)
        }//if
        
        if (saveThrows % 10 == 4 || saveThrows / 10 == 4){
            intProfButton?.setTitle(CheckBox.Checked, forState: .Normal)
        }//if
        
        if (saveThrows % 10 == 5 || saveThrows / 10 == 5){
            wisProfButton?.setTitle(CheckBox.Checked, forState: .Normal)
        }//if
        
        if (saveThrows % 10 == 6 || saveThrows / 10 == 6){
            chaProfButton?.setTitle(CheckBox.Checked, forState: .Normal)
        }//if
    }//updateSavThrows
    
    func clearSavThrows(){
        strProfButton?.setTitle(CheckBox.UnChecked, forState: .Normal)
        dexProfButton?.setTitle(CheckBox.UnChecked, forState: .Normal)
        conProfButton?.setTitle(CheckBox.UnChecked, forState: .Normal)
        intProfButton?.setTitle(CheckBox.UnChecked, forState: .Normal)
        wisProfButton?.setTitle(CheckBox.UnChecked, forState: .Normal)
        chaProfButton?.setTitle(CheckBox.UnChecked, forState: .Normal)
    }//clearSavThrows
    
    //MARK: UITableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }//numberOfSections
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }//numberOfRowsInSection
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell: AbilityScoreHeader = tableView.dequeueReusableCellWithIdentifier("ascoreHeader") as! AbilityScoreHeader
        
        return headerCell
    }//viewForHeaderInSection
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: AbilityScoreTableCell = tableView.dequeueReusableCellWithIdentifier("ascoreRow") as! AbilityScoreTableCell
        
        cell.ascoreLabel.text = scoreNames[indexPath.row]
        
        switch (indexPath.row){
        case 0://Strength
            strTextField = cell.ascoreField
            strModLabel = cell.ascoreModField
            strProfButton = cell.ascoreSavThrowButton
        case 1://Dexterity
            dexTextField = cell.ascoreField
            dexModLabel = cell.ascoreModField
            dexProfButton = cell.ascoreSavThrowButton
        case 2://Constitution
            conTextField = cell.ascoreField
            conModLabel = cell.ascoreModField
            conProfButton = cell.ascoreSavThrowButton
        case 3://Intelligence
            intTextField = cell.ascoreField
            intModLabel = cell.ascoreModField
            intProfButton = cell.ascoreSavThrowButton
        case 4://Wisdom
            wisTextField = cell.ascoreField
            wisModLabel = cell.ascoreModField
            wisProfButton = cell.ascoreSavThrowButton
        case 5://Charisma
            chaTextField = cell.ascoreField
            chaModLabel = cell.ascoreModField
            chaProfButton = cell.ascoreSavThrowButton
        default:
            break
        }//switch
        
        cell.ascoreField.delegate = self
        
        return cell

    }//cellForRowAtIndexPath
    
    
    
    
    
    
    
    
}//AbilityScoreViewController