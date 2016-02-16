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
        //Note: this happens whether or not
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
        
        var results: [AnyObject] = [];
        do{
            results = try managedContext.executeFetchRequest(fetchRequest) as! [PCharacter]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        let charName = results[0].name;
        nameTextField.text = charName;
        print(results[0]);
        
        let myCharacter: PCharacter = results[0] as! PCharacter;
        
        print(myCharacter);
        
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
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }

    

    
}//AbilityScoreViewController