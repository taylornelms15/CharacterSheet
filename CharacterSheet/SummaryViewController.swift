//
//  SummaryViewController.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 3/25/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit
import CoreData

class SummaryViewController: CSViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource{
    
    //MARK: Properties
    var racePicker: UIPickerView = UIPickerView();
    var pickerData: [[String]] = [["Hill Dwarf", "Mountain Dwarf", "High Elf", "Wood Elf", "Dark Elf", "Lightfoot Halfling", "Stout Halfling", "Human", "Dragonborn", "Forest Gnome", "Rock Gnome", "Half-Elf", "Half-Orc", "Tiefling"]];
    var racePickerToolbar: UIToolbar = UIToolbar()
    var racePickerDoneButton: UIBarButtonItem = UIBarButtonItem()
    
    var classPicker: UIPickerView = UIPickerView();
    var cpickerData: [[String]] = [["Barbarian", "Bard", "Cleric", "Druid", "Fighter", "Monk", "Paladin", "Ranger", "Rogue", "Sorcerer", "Warlock", "Wizard"]];
    var classPickerToolbar: UIToolbar = UIToolbar()
    var classPickerDoneButton: UIBarButtonItem = UIBarButtonItem()
    
    var backgroundPicker: UIPickerView = UIPickerView();
    var bpickerData: [[String]] = [["Acolyte", "Charlatan", "Criminal", "Entertainer", "Folk Hero", "Guild Artisan", "Hermit", "Noble", "Outlander", "Sage", "Sailor", "Soldier", "Urchin"]];
    var backgroundPickerToolbar: UIToolbar = UIToolbar()
    var backgroundPickerDoneButton: UIBarButtonItem = UIBarButtonItem()
    
    var alignmentPicker: UIPickerView = UIPickerView()
    var alignmentPickerData: [[String]] = [["Lawful", "Neutral", "Chaotic"], ["Good", "Neutral", "Evil"]]
    var alignmentPickerToolbar: UIToolbar = UIToolbar()
    var alignmentPickerDoneButton: UIBarButtonItem = UIBarButtonItem()
    
    var pickerSpaceButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
    
    let casterClasses: [String] = ["Bard", "Cleric", "Druid", "Paladin", "Sorcerer", "Warlock", "Wizard"]
    
    var activeField: UITextField? = nil
    
    //MARK: Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var levelTextField: UITextField!
    @IBOutlet weak var raceTextField: UITextField!
    @IBOutlet weak var classTextField: UITextField!
    @IBOutlet weak var backgroundTextField: UITextField!
    @IBOutlet weak var summaryCollectionView: UICollectionView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var alignmentField: UITextField = UITextField()
    var currHpField: UITextField = UITextField()
    var maxHpField: UITextField = UITextField()
    var hitDieLabel: UILabel = UILabel()
    var armorField: UITextField = UITextField()
    var spellSaveDCLabel: UILabel = UILabel()
    var spellAttackLabel: UILabel = UILabel()
    
    
    //MARK: Actions
    
    ///Changes the name field and sets the character name when editing completes
    @IBAction func setNameField(sender: UITextField) {
        
        nameTextField.resignFirstResponder();
        
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
        
        results[0].name = nameTextField.text!;
        
        do{
            try managedContext.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    ///Changes the level field and sets the character level when editing completes
    @IBAction func setLevelField(sender: UITextField) {
        
        levelTextField.resignFirstResponder()
        
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
        
        var newLevel: Int = Int(levelTextField.text!)!
        if (newLevel < 1) {newLevel = 1}
        if (newLevel > 20) {newLevel = 20}
        
        results[0].level = Int16(newLevel)
        
        do{
            try managedContext.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
        summaryCollectionView.reloadData()
        
    }

    ///Changes the race field and sets the character race when editing completes
    @IBAction func setRaceField(sender: UITextField) {
        
        //Get our character out
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        var fetchRequest = NSFetchRequest(entityName: "PCharacter");
        fetchRequest.predicate = NSPredicate(format: "id = %@", String(appDelegate.currentCharacterId));
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
        
        summaryCollectionView.reloadData()
        
    }//setRaceField
    
    ///Changes the class field and sets the character class when editing completes
    @IBAction func setClassField(sender: UITextField) {
        //Get our character out
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        var fetchRequest = NSFetchRequest(entityName: "PCharacter");
        fetchRequest.predicate = NSPredicate(format: "id = %@", String(appDelegate.currentCharacterId));
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
        
        summaryCollectionView.reloadData()
        
    }//setClassField
    
    ///Changes the background field and sets the character background when editing completes
    @IBAction func setBackgroundField(sender: UITextField) {
        //Get our character out
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        var fetchRequest = NSFetchRequest(entityName: "PCharacter");
        fetchRequest.predicate = NSPredicate(format: "id = %@", String(appDelegate.currentCharacterId));
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
        
        summaryCollectionView.reloadData()
        
    }//setBackgroundField
    
    ///Changes the alignment field and sets the character alignment, pretty much when editing completes (called elsewhere, not an action)
    func setAlignment(newCode: Int16){
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
        
        results[0].alignment = newCode
        
        //save
        do{
            try managedContext.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }//setAlignment
    
    func setArmorClass(sender: UITextField){
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
        
        var armorClassInt: Int? = nil
        if (sender.text == nil){
            armorClassInt = nil
        }
        else{
            armorClassInt = Int(sender.text!)
        }
        //possible values for armorClassInt: nil for empty text or non-int text, ints for all else
        
        var newAC: Int64 = 0
        
        if (armorClassInt != nil){
            newAC = Int64(armorClassInt!)
        }
        
        results[0].armorClass = newAC
        
        //save
        do{
            try managedContext.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }//setArmorClass
    
    func setCurrHp(sender: UITextField){
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
        
        var currHpInt: Int? = nil
        if (sender.text == nil){
            currHpInt = nil
        }
        else{
            currHpInt = Int(sender.text!)
        }
        //possible values for currHpInt: nil for empty text or non-int text, ints for all else
        
        var newCurrHp: Int64 = 0
        
        if (currHpInt != nil){
            newCurrHp = Int64(currHpInt!)
        }
        
        results[0].currHp = newCurrHp
        
        //save
        do{
            try managedContext.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }//setCurrHp
    
    func setMaxHp(sender: UITextField){
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
        
        var maxHpInt: Int? = nil
        if (sender.text == nil){
            maxHpInt = nil
        }
        else{
            maxHpInt = Int(sender.text!)
        }
        //possible values for maxHpInt: nil for empty text or non-int text, ints for all else
        
        var newMaxHp: Int64 = 0
        
        if (maxHpInt != nil){
            newMaxHp = Int64(maxHpInt!)
        }
        
        results[0].maxHp = newMaxHp
        
        //save
        do{
            try managedContext.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }//setMaxHp
    
    //MARK: ViewDidLoad functions
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
                
        //do delegate things
        nameTextField.delegate = self;
        levelTextField.delegate = self;
        
        raceTextField.inputView = racePicker;
        raceTextField.inputAccessoryView = racePickerToolbar
        racePicker.dataSource = self;
        racePicker.delegate = self;
        racePickerToolbar.barStyle = UIBarStyle.Default
        racePickerToolbar.sizeToFit()
        racePickerDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "donePicker:")
        racePickerToolbar.setItems([pickerSpaceButton, racePickerDoneButton], animated: false)
        racePickerToolbar.userInteractionEnabled = true
        
        classTextField.inputView = classPicker;
        classTextField.inputAccessoryView = classPickerToolbar
        classPicker.dataSource = self;
        classPicker.delegate = self;
        classPickerToolbar.barStyle = UIBarStyle.Default
        classPickerToolbar.sizeToFit()
        classPickerDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "donePicker:")
        classPickerToolbar.setItems([pickerSpaceButton, classPickerDoneButton], animated: false)
        classPickerToolbar.userInteractionEnabled = true
        
        backgroundTextField.inputView = backgroundPicker
        backgroundTextField.inputAccessoryView = backgroundPickerToolbar
        backgroundPicker.dataSource = self
        backgroundPicker.delegate = self
        backgroundPickerToolbar.barStyle = UIBarStyle.Default
        backgroundPickerToolbar.sizeToFit()
        backgroundPickerDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "donePicker:")
        backgroundPickerToolbar.setItems([pickerSpaceButton, backgroundPickerDoneButton], animated: false)
        backgroundPickerToolbar.userInteractionEnabled = true
        
        alignmentPicker.dataSource = self
        alignmentPicker.delegate = self
        alignmentPickerToolbar.barStyle = UIBarStyle.Default
        alignmentPickerToolbar.sizeToFit()
        alignmentPickerDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "donePicker:")
        alignmentPickerToolbar.setItems([pickerSpaceButton, alignmentPickerDoneButton], animated: false)
        alignmentPickerToolbar.userInteractionEnabled = true
        
        summaryCollectionView.delegate = self
        summaryCollectionView.dataSource = self
        
    }//viewDidLoad
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        summaryCollectionView.reloadData()
        
    }//viewWillAppear
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
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
        
        //Update text fields
        
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
            backgroundTextField.text = "Please Select"
        }//else
        
    }//viewDidAppear
    
    //MARK: Picker functions
    
    ///Gets the number of columns in the picker
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
        if (pickerView == alignmentPicker){
            return alignmentPickerData.count
        }
        return 0;
    }
    
    ///Gets the number of rows per column
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
        if (pickerView == alignmentPicker){
            return alignmentPickerData[component].count
        }
        return 0;
    }
    
    ///Gets the row label
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if (pickerView == racePicker){
                return pickerData[component][row]
            }
            if (pickerView == classPicker){
                return cpickerData[component][row]
            }
            if (pickerView == backgroundPicker){
                return bpickerData[component][row]
            }
            if (pickerView == alignmentPicker){
                return alignmentPickerData[component][row]
            }
            return nil;
    }
    
    ///Handles pressing the "done" button at the top of a picker
    func donePicker(sender: UIBarButtonItem){
        
        if (sender == racePickerDoneButton){
            updateLabel()
            
            raceTextField.endEditing(true);
        }
        if (sender == classPickerDoneButton){
            updateCLabel()
            
            classTextField.endEditing(true);
        }
        if (sender == backgroundPickerDoneButton){
            updateBLabel()
            
            backgroundTextField.endEditing(true);
        }
        
        if (sender == alignmentPickerDoneButton){
            updateALabel()
            
            alignmentField.endEditing(true)
            
            summaryCollectionView.reloadData()
        }
        
        
    }//donePicker
    
    //MARK: UICollectionView functions
    
    ///Get the items in a section
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
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
        
        if (results[0].pclass != nil && casterClasses.contains(results[0].pclass!.name!)){
            return 4
        }//if caster
        else{
            return 3
        }//if not caster, or no class
        
    }
    
    ///Get the number of sections
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int{
        return 1
    }
    
    ///Get the cell in the collection
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
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
        
        var cell: UICollectionViewCell = UICollectionViewCell()
        
        switch(indexPath.row){
        case 0:
            let thisCell: AlignmentCell = summaryCollectionView.dequeueReusableCellWithReuseIdentifier("alignmentCell", forIndexPath: indexPath) as! AlignmentCell
            alignmentField = thisCell.alignmentField
            
            alignmentField.inputView = alignmentPicker
            alignmentField.inputAccessoryView = alignmentPickerToolbar
            
            
            //Alignment Label
            let alignmentCode: Int16 = results[0].alignment
            alignmentField.text = PCharacter.getAlignmentStringShort(alignmentCode)
            
            cell = thisCell
        case 1:
            let thisCell = summaryCollectionView.dequeueReusableCellWithReuseIdentifier("hpCell", forIndexPath: indexPath) as! HpCell
            currHpField = thisCell.currHpField
            maxHpField = thisCell.maxHpField
            hitDieLabel = thisCell.hitDieLabel
            currHpField.delegate = self
            maxHpField.delegate = self
            
            //Hit Die Label
            if (results[0].pclass == nil){
                hitDieLabel.alpha = 0//make transparent
            }//if no class
            else{
                hitDieLabel.alpha = 1//make opaque
                hitDieLabel.text = results[0].pclass!.hitDieLabel()
            }//if class exists
            //HpLabels
            currHpField.text = "\(results[0].currHp)"
            maxHpField.text = "\(results[0].maxHp)"
            
            cell = thisCell
        case 2:
            let thisCell = summaryCollectionView.dequeueReusableCellWithReuseIdentifier("armorCell", forIndexPath: indexPath) as! ArmorCell
            armorField = thisCell.armorField
            armorField.delegate = self
            
            //Armor Class Label
            let armorClass: Int64 = results[0].armorClass
            armorField.text = "\(armorClass)"
            
            cell = thisCell
        case 3:
            let thisCell = summaryCollectionView.dequeueReusableCellWithReuseIdentifier("spellCell", forIndexPath: indexPath) as! SpellCell
            spellSaveDCLabel = thisCell.spellSaveDCLabel
            spellAttackLabel = thisCell.spellAttackLabel
            
            //Spell Stats
            if (results[0].pclass == nil){
                
            }//if no class
            else{
                let spellStats: (Int, Int) = results[0].getSpellDCandMod()
                
                spellSaveDCLabel.text = "\(spellStats.0)"
                spellAttackLabel.text = "+\(spellStats.1)"
            }//else (class)
            
            cell = thisCell
        default:
            return UICollectionViewCell()
        }//switch
        
        cell.layer.borderColor = UIColor.blackColor().CGColor
        cell.layer.borderWidth = 1
        
        return cell
        
    }//cellForItemAtIndexPath
    
    //MARK: UITextFieldDelegate
    
    ///Enforces type of text entry
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if ([armorField, currHpField, maxHpField].contains(textField)){
            if (string == "") {
                return true
            }
            let intVal: Int? = Int(string)
            return (intVal != nil)
        }//if enforcing numeric
        else{
            return true
        }//can enter anything
    }//enforce numeric entry
    
    ///Called upon ending text field editing
    func textFieldDidEndEditing(textField: UITextField) {
        activeField = nil
        
        switch(textField){
        case armorField:
            setArmorClass(textField)
        case currHpField:
            setCurrHp(textField)
        case maxHpField:
            setMaxHp(textField)
        default:
            return
        }//switch
    }//end editing for text fields
    
    ///Called when editing starts
    func textFieldDidBeginEditing(textField: UITextField) {
        activeField = textField
    }
    
    ///End editing on a return call
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true);
        return true;
    }
    
    //MARK: keyboard functions
    
    func keyboardWillShow(notification: NSNotification){
        adjustingHeight(true, notification: notification)
    }//keyboardWillShow
    
    func keyboardWillHide(notification: NSNotification){
        adjustingHeight(false, notification: notification)
    }//keyboardWillHide
    
    func adjustingHeight(show: Bool, notification: NSNotification){

        var userInfo = notification.userInfo!
        let keyboardFrame: CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        let changeInHeight = (CGRectGetHeight(keyboardFrame)/* + 40*/) * (show ? 1 : -1)
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            self.bottomConstraint.constant += changeInHeight
            //if we want to move the frame. potential later project
            //self.view.frame.origin.y -= changeInHeight
        })
        
        
    }//adjustingHeight
    
    //MARK: Helper functions
    ///Updates the race field label
    func updateLabel(){
        let race = pickerData[0][racePicker.selectedRowInComponent(0)]
        raceTextField.text = race;
    }//updateRaceLabel
    
    ///Updates the class field label
    func updateCLabel(){
        let pclass = cpickerData[0][classPicker.selectedRowInComponent(0)]
        classTextField.text = pclass;
    }//updateClassLabel
    
    ///Updates the background field label
    func updateBLabel(){
        let background = bpickerData[0][backgroundPicker.selectedRowInComponent(0)]
        backgroundTextField.text = background;
    }//updateBackgroundLabel
    
    ///Updates the armor class label
    func updateALabel(){
        let alignmentString: String =
        "\(alignmentPickerData[0][alignmentPicker.selectedRowInComponent(0)]) \(alignmentPickerData[1][alignmentPicker.selectedRowInComponent(1)])"//Creates alignment string by concatenating the choices
        let alignmentCode = PCharacter.getAlignmentCode(alignmentString)
        
        setAlignment(alignmentCode)
        
        alignmentField.text = PCharacter.getAlignmentStringShort(alignmentCode)
        
    }//updateArmorClassLabel
    
    
}//SummaryViewController