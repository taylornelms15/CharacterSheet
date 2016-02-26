//
//  SummaryViewController.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 1/25/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit;
import CoreData;

class SummaryViewController: CSViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate{

    //MARK: Properties
    var racePicker: UIPickerView = UIPickerView();
    var pickerData: [[String]] = [["Hill Dwarf", "Mountain Dwarf", "High Elf", "Wood Elf", "Dark Elf", "Lightfoot Halfling", "Stout Halfling", "Human", "Dragonborn", "Forest Gnome", "Rock Gnome", "Half-Elf", "Half-Orc", "Tiefling"]];
    var classPicker: UIPickerView = UIPickerView();
    var cpickerData: [[String]] = [["Barbarian", "Bard", "Cleric", "Druid", "Fighter", "Monk", "Paladin", "Ranger", "Rogue", "Sorcerer", "Warlock", "Wizard"]];
    var backgroundPicker: UIPickerView = UIPickerView();
    var bpickerData: [[String]] = [["Acolyte", "Charlatan", "Criminal", "Entertainer", "Folk Hero", "Guild Artisan", "Hermit", "Noble", "Outlander", "Sage", "Sailor", "Soldier", "Urchin"]];
    
    //MARK: Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var levelTextField: UITextField!
    @IBOutlet weak var raceTextField: UITextField!
    @IBOutlet weak var classTextField: UITextField!
    @IBOutlet weak var backgroundTextField: UITextField!
    
    //MARK: Actions
    @IBAction func setNameField(sender: UITextField) {
        
        nameTextField.resignFirstResponder();
        
        //Get our character out
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "PCharacter");
        fetchRequest.predicate = NSPredicate(format: "id = 1", argumentArray: nil);
        var results: [PCharacter] = [];
        do{
            results = try managedContext.executeFetchRequest(fetchRequest) as! [PCharacter]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        results[0].updateAScores()
        //Note that now results[0] is our character
        
        results[0].name = nameTextField.text!;
        
        do{
            try managedContext.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true);
        return true;
    }
    

    
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
        
        //find the race we're switching to
        fetchRequest = NSFetchRequest(entityName: "Race");
        fetchRequest.predicate = NSPredicate(format: "name = %@", raceTextField.text!);
        var raceResults: [Race] = [];
        do{
            raceResults = try managedContext.executeFetchRequest(fetchRequest) as! [Race]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
        //change the race
        results[0].changeRaceTo(raceResults[0]);
        
        //save
        do{
            try managedContext.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }

    }
    
    @IBAction func setClassField(sender: UITextField) {
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
        
        //find the class we're switching to
        fetchRequest = NSFetchRequest(entityName: "PClass");
        fetchRequest.predicate = NSPredicate(format: "name = %@", classTextField.text!);
        var classResults: [PClass] = [];
        do{
            classResults = try managedContext.executeFetchRequest(fetchRequest) as! [PClass]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        _ = classResults[0].name;
        
        
        //Change the class in the database
        results[0].changeClassTo(classResults[0])
        
        do{
            try managedContext.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }

    }
    
    @IBAction func setBackgroundField(sender: UITextField) {
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
        
        
        //find the background we're switching to
        fetchRequest = NSFetchRequest(entityName: "Background");
        fetchRequest.predicate = NSPredicate(format: "name = %@", backgroundTextField.text!);
        var backgroundResults: [Background] = [];
        do{
            backgroundResults = try managedContext.executeFetchRequest(fetchRequest) as! [Background]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        _ = backgroundResults[0].name;
        
        //change background
        results[0].changeBackgroundTo(backgroundResults[0])
        
        //save
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
        
        //Init Class Data
        entity =  NSEntityDescription.entityForName("PClass",
            inManagedObjectContext:managedContext)
        fetchRequest = NSFetchRequest(entityName: "PClass");
        
        count = managedContext.countForFetchRequest(fetchRequest, error: &error)
        if (count == 0){
            PClass.classesInit(entity!, context: managedContext)
        }
        
        //Init Character
        entity = NSEntityDescription.entityForName("PCharacter", inManagedObjectContext: managedContext);
        fetchRequest = NSFetchRequest(entityName: "PCharacter");
        
        count = managedContext.countForFetchRequest(fetchRequest, error: &error)
        if (count == 0){
            characterInit(entity!, context: managedContext);
        }//if
        
        //Init Background
        entity = NSEntityDescription.entityForName("Background", inManagedObjectContext: managedContext);
        fetchRequest = NSFetchRequest(entityName: "Background");
        
        count = managedContext.countForFetchRequest(fetchRequest, error: &error)
        if (count == 0){
            Background.backgroundInit(managedContext);
        }//if
        
        //Update text fields
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
        
        let myClass: PClass? = results[0].pclass;
        if (myClass != nil){
            classTextField.text = results[0].pclass!.name;
        }//if
        else{
            classTextField.text = "Please Select"
        }
        
        let myRace: Race? = results[0].race;
        if (myRace != nil){
            raceTextField.text = results[0].race!.name;
        }//if
        else{
            raceTextField.text = "Please Select"
        }//else
        
        let myBackground: Background? = results[0].background;
        if (myBackground != nil){
            backgroundTextField.text = results[0].background!.name;
        }//if
        else{
            raceTextField.text = "Please Select"
        }//else
        
        //Deal with delegates
        
        nameTextField.delegate = self;
        
        raceTextField.inputView = racePicker;
        racePicker.dataSource = self;
        racePicker.delegate = self;
        
        classTextField.inputView = classPicker;
        classPicker.dataSource = self;
        classPicker.delegate = self;
        
        backgroundTextField.inputView = backgroundPicker
        backgroundPicker.dataSource = self
        backgroundPicker.delegate = self
        
        

    }
    
    //MARK: Picker functions
    
    //num columns
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if (pickerView == racePicker){
            return pickerData.count
        }
        if (pickerView == classPicker){
            return cpickerData.count
        }
        if (pickerView == backgroundPicker){
            return bpickerData.count
        }
        return 0;
    }
    
    //options per column
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == racePicker){
            return pickerData[component].count
        }
        if (pickerView == classPicker){
            return cpickerData[component].count
        }
        if (pickerView == backgroundPicker){
            return bpickerData[component].count
        }
        return 0;
    }
    
    //Get column label
    func pickerView(
        pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
        ) -> String? {
            if (pickerView == racePicker){
                return pickerData[component][row]
            }
            if (pickerView == classPicker){
                return cpickerData[component][row]
            }
            if (pickerView == backgroundPicker){
                return bpickerData[component][row]
            }
            return nil;
    }
    
    //On row select
    func pickerView(
        pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int)
    {
        if (pickerView == racePicker){
            updateLabel()
        
            //confirmRaceAlert(pickerData[0][row]);
        
            //raceTextField.resignFirstResponder();

            raceTextField.endEditing(true);
            
        }
        if (pickerView == classPicker){
            updateCLabel()
            
            classTextField.endEditing(true);
        }//pickerView
        if (pickerView == backgroundPicker){
            updateBLabel()
            
            backgroundTextField.endEditing(true);
        }//pickerView
    }//pickerView
    
    
    //MARK: Helper functions
    func updateLabel(){
        let race = pickerData[0][racePicker.selectedRowInComponent(0)]
        raceTextField.text = race;
    }//updateLabel
    
    func updateCLabel(){
        let pclass = cpickerData[0][classPicker.selectedRowInComponent(0)]
        classTextField.text = pclass;
    }//updateLabel
    
    func updateBLabel(){
        let background = bpickerData[0][backgroundPicker.selectedRowInComponent(0)]
        backgroundTextField.text = background;
    }
    
    //Note: deprecated?
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
    
    func updatePrimAbil(primAbil: Int16){
        
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