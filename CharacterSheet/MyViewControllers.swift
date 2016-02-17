//
//  SummaryViewController.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 1/25/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit;
import CoreData;

class SummaryViewController: CSViewController, UIPickerViewDataSource, UIPickerViewDelegate{

    //MARK: Properties
    var racePicker: UIPickerView = UIPickerView();
    var pickerData: [[String]] = [["Hill Dwarf", "Mountain Dwarf", "High Elf", "Wood Elf", "Dark Elf", "Lightfoot Halfling", "Stout Halfling", "Human", "Dragonborn", "Forest Gnome", "Rock Gnome", "Half-Elf", "Half-Orc", "Tiefling"]];
    
    //MARK: Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var levelTextField: UITextField!
    @IBOutlet weak var raceTextField: UITextField!
    @IBOutlet weak var classTextField: UITextField!
    
    //MARK: Actions
    
    @IBAction func setRaceField(sender: UITextField) {
        //Note: this happens whether or not the user hits yes on the alert. And apparently happens twice. Blegh.
        
        //Get our character out
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        var fetchRequest = NSFetchRequest(entityName: "PCharacter");
        fetchRequest.predicate = NSPredicate(format: "id = 1", argumentArray: nil);
        var results: [PCharacter] = [];
        do{
            results = try managedContext.executeFetchRequest(fetchRequest) as! [PCharacter]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        results[0].updateAScores()
        //Note that now results[0] is our character
        
        //take off previous racial bonuses
        let prevRace: Race? = results[0].race;
        
        if (prevRace != nil){
            results[0].ascores.subValues(
                Int(prevRace!.strmod),
                dexmod: Int(prevRace!.dexmod),
                conmod: Int(prevRace!.conmod),
                intmod: Int(prevRace!.intmod),
                wismod: Int(prevRace!.wismod),
                chamod: Int(prevRace!.chamod))
        }//if
        
        
        //find the race we're switching to
        fetchRequest = NSFetchRequest(entityName: "Race");
        fetchRequest.predicate = NSPredicate(format: "name = %@", raceTextField.text!);
        var raceResults: [Race] = [];
        do{
            raceResults = try managedContext.executeFetchRequest(fetchRequest) as! [Race]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
        results[0].race = raceResults[0];
        results[0].ascores.addValues(
            Int(raceResults[0].strmod),
            dexmod: Int(raceResults[0].dexmod),
            conmod: Int(raceResults[0].conmod),
            intmod: Int(raceResults[0].intmod),
            wismod: Int(raceResults[0].wismod),
            chamod: Int(raceResults[0].chamod))
        
        results[0].str = Int16(results[0].ascores.getStr())
        results[0].dex = Int16(results[0].ascores.getDex())
        results[0].con = Int16(results[0].ascores.getCon())
        results[0].intl = Int16(results[0].ascores.getInt())
        results[0].wis = Int16(results[0].ascores.getWis())
        results[0].cha = Int16(results[0].ascores.getCha())
        
        do{
            try managedContext.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Init Race Data
        let managedContext = appDelegate.managedObjectContext!
        
        var entity =  NSEntityDescription.entityForName("Race",
            inManagedObjectContext:managedContext)
        var fetchRequest = NSFetchRequest(entityName: "Race");

        var error: NSError? = nil;
        var count = managedContext.countForFetchRequest(fetchRequest, error: &error)
        if (count == 0){
            racesInit(entity!, context: managedContext)
        }//if
        
        //Init Character
        entity = NSEntityDescription.entityForName("PCharacter", inManagedObjectContext: managedContext);
        fetchRequest = NSFetchRequest(entityName: "PCharacter");
        
        count = managedContext.countForFetchRequest(fetchRequest, error: &error)
        if (count == 0){
            characterInit(entity!, context: managedContext);
        }//if
        
        //Update some fields
        fetchRequest = NSFetchRequest(entityName: "PCharacter");
        fetchRequest.predicate = NSPredicate(format: "id = 1", argumentArray: nil);
        
        var results: [PCharacter] = [];
        do{
            results = try managedContext.executeFetchRequest(fetchRequest) as! [PCharacter]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        let charName = results[0].name;
        nameTextField.text = charName;
        
        results[0].updateAScores();
        levelTextField.text = "\(results[0].level)";
        classTextField.text = "Rogue";
        let myRace: Race? = results[0].race;
        if (myRace != nil){
            raceTextField.text = results[0].race.name;
        }//if
        else{
            raceTextField.text = "Please Select"
        }//else
            
        //Put the race picker view together
        
        raceTextField.inputView = racePicker;
        
        racePicker.dataSource = self;
        racePicker.delegate = self;

    }
    
    //MARK: Picker functions
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    //Get column label
    func pickerView(
        pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
        ) -> String? {
            return pickerData[component][row]
    }
    
    //On row select
    func pickerView(
        pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int)
    {
        updateLabel()
        
        confirmRaceAlert(pickerData[0][row]);
        
        raceTextField.resignFirstResponder();
    }//pickerView
    
    
    //MARK: Helper functions
    func updateLabel(){
        let race = pickerData[0][racePicker.selectedRowInComponent(0)]
        raceTextField.text = race;
    }//updateLabel
    
    func confirmRaceAlert(choice: String){
        let alertController = UIAlertController(title: "Change class to " + choice + "?", message: "This will modify your ability scores accordingly", preferredStyle: UIAlertControllerStyle.Alert);
        alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default,handler: nil))
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default,handler: {
            (alert: UIAlertAction!) in
            //what happens when they say yes
            raceTextField.endEditing(true); //closes the picker
            
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }//confirmRaceAlert
    
}//SummaryViewController

class AbilityScoreViewController: CSViewController, UITextFieldDelegate{
    
    //MARK: Properties
    var scores: AScores = AScores.init();
    
    //MARK: Outlets
    
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
        fetchRequest.predicate = NSPredicate(format: "id = 1", argumentArray: nil);
        
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
        
    }//viewDidLoad
    
    func updateScoresInCore(){
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        //let entity =  NSEntityDescription.entityForName("PCharacter", inManagedObjectContext:managedContext)
        
        //getting the most recent version, just to be safe.
        let fetchRequest = NSFetchRequest(entityName: "PCharacter");
        fetchRequest.predicate = NSPredicate(format: "id = 1", argumentArray: nil);
        
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

    

    
}//AbilityScoreViewController