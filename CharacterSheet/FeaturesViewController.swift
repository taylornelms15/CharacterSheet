//
//  FeaturesViewController.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 2/24/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit
import CoreData

class FeaturesViewController: CSViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, SpellDataReceiverDelegate{

    weak var currentFeatureList: FeatureList? = nil
    
    var raceFeatArray: [RaceFeature] = []
    var classFeatArray: [ClassFeature] = []
    var subclassNameArray: [String] = []
    var backgroundFeatArray: [BackgroundFeature] = []
    var featArray: [Feat] = []
    var spellArray: [Spell] = []
    var featNameArray: [String] =
        ["Alert", "Athlete", "Actor", "Charger", "Crossbow Expert", "Defensive Duelist", "Dual Wielder", "Dungeon Delver", "Durable",
            "Elemental Adept - Acid", "Elemental Adept - Cold", "Elemental Adept - Fire", "Elemental Adept - Lightning", "Elemental Adept - Thunder",
            "Grappler", "Great Weapon Master", "Healer", "Heavily Armored", "Heavy Armor Master", "Inspiring Leader", "Keen Mind",
            "Lightly Armored", "Linguist", "Lucky", "Mage Slayer", "Magic Initiate", "Martial Adept", "Medium Armor Master", "Mobile",
            "Moderately Armored", "Mounted Combatant", "Observant", "Polearm Master", "Resilient", "Ritual Caster", "Savage Attacker",
            "Sentinel", "Sharpshooter", "Shield Master", "Skilled", "Skulker", "Spell Sniper", "Tavern Brawler", "Tough", "War Caster", "Weapon Master"]
    
    let casterClassNameArray: [String] = ["Bard", "Cleric", "Druid", "Sorcerer", "Warlock", "Wizard"]
    let addSpellFeatIds: [Int] = [26, 86, 95, 258, 260, 261, 262, 272, 334, 335, 336, 337, 338, 339, 340, 341]//Cantrip (High Elf), Magic Initiate (feat), Ritual Caster (feat), Additional Magical Secrets (Bard), Magical Secrets (Bard), Acolyte of Nature (Cleric), Bonus Cantrip (Druid, Circle of the Land)
    var currentAddSpellId: Int? = nil
    
    var featPicker: UIPickerView = UIPickerView()
    var featPickerToolbar: UIToolbar = UIToolbar();
    var featDoneButton: UIBarButtonItem = UIBarButtonItem();
    var featSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
    var featCancelButton: UIBarButtonItem = UIBarButtonItem();
    var dummyTextField: UITextField = UITextField(frame: CGRectZero)
    
    var subclassTextField: UITextField? = nil
    var subclassPicker: UIPickerView = UIPickerView()
    var subclassPickerToolbar: UIToolbar = UIToolbar();
    var subclassDoneButton: UIBarButtonItem = UIBarButtonItem();
    var subclassSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
    var subclassCancelButton: UIBarButtonItem = UIBarButtonItem();
    
    //MARK: outlets
    @IBOutlet weak var featureTableView: UITableView!
    @IBOutlet weak var removeFeatButton: UIBarButtonItem!
    @IBOutlet weak var addFeatButton: UIBarButtonItem!
    @IBOutlet weak var customFeatButton: UIBarButtonItem!

    //MARK: actions
    
    func addSpellButtonPress(sender: UIBarButtonItem){
        
        currentAddSpellId = sender.tag
        
        let addSpellAlertController = UIAlertController(title: "Spell List", message: "Choose the class whose spell list you wish to choose a spell from.", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        
        for className in casterClassNameArray{
            let classAlertAction = UIAlertAction(title: className, style: .Default, handler: { alertAction in
                self.spellListButtonPress(alertAction)
            })
            addSpellAlertController.addAction(classAlertAction)
        }
        
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { alertAction in
                self.currentAddSpellId = nil
                self.dismissViewControllerAnimated(true, completion: nil)
        })
        
        addSpellAlertController.addAction(cancelAlertAction)
        
        self.presentViewController(addSpellAlertController, animated: true, completion: nil)
        
    }//addSpellButtonPress
    
    func spellListButtonPress(sender: UIAlertAction){
        let className: String = sender.title!
        
        //Get our character out
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "PClass");
        fetchRequest.predicate = NSPredicate(format: "name = %@", className);
        var classResults: [PClass] = [];
        do{
            classResults = try context.executeFetchRequest(fetchRequest) as! [PClass]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        //Note that now classResults[0] is our class
        
        let fullSpellList: SpellList = classResults[0].spellList
        
        let tempSpellList: SpellList = NSManagedObject(entity: NSEntityDescription.entityForName("SpellList", inManagedObjectContext: context)!, insertIntoManagedObjectContext: context) as! SpellList
        
        filterSpellList(fullSpellList, usingFeatId: currentAddSpellId!, intoTempSpellList: tempSpellList)

        tempSpellList.temporary = true
        
        do{
            try context.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
        currentAddSpellId = nil
        
        presentAddSpellVC(withList: tempSpellList)
        
        
    }//spellListButtonPress
    
    func presentAddSpellVC(withList spellList: SpellList){
        let destController: AddSpellViewController = self.storyboard!.instantiateViewControllerWithIdentifier("AddSpellViewController") as! AddSpellViewController
        
        destController.delegate = self
        
        destController.currentSpellList = spellList
        
        destController.buildHeaders()
        
        self.navigationController!.pushViewController(destController, animated: true)
        
    }//presentAddSpellVC
    
    func presentFeatureDetailVC(withFeature feature: Feature){
        
        let newVC: FeatureDetailViewController = storyboard!.instantiateViewControllerWithIdentifier("FeatureDetailViewController") as! FeatureDetailViewController
        newVC.modalPresentationStyle = .OverCurrentContext
        newVC.modalTransitionStyle = .CoverVertical
        newVC.myFeature = feature
        
        self.presentViewController(newVC, animated: true, completion: {
            ()->Void in
        })
        
    }//presentFeatureDetailVC
    
    func presentSpellDetailVC(withSpell spell: Spell){
        let newVC: SpellDetailViewController = storyboard!.instantiateViewControllerWithIdentifier("SpellDetailViewController") as! SpellDetailViewController
        newVC.modalPresentationStyle = .OverCurrentContext
        newVC.modalTransitionStyle = .CoverVertical
        newVC.mySpell = spell
        
        self.presentViewController(newVC, animated: true, completion: {
            ()->Void in
        })
    }//presentSpellDetailVC
    
    @IBAction func addFeatButtonPress(sender: UIBarButtonItem) {
        dummyTextField.becomeFirstResponder()
    }//addFeatButtonPress
    
    @IBAction func removeFeatButtonPress(sender: UIBarButtonItem) {
        if (featureTableView.editing){
            setDeletionMode(false)
        }//if in editing mode
        else{
            setDeletionMode(true)
        }//if not in editing mode
    }//removeFeatButtonPress
    
    private func setDeletionMode(mode: Bool){
        if (mode){
            removeFeatButton.title = "Cancel"
            featureTableView.setEditing(true, animated: true)
            addFeatButton.enabled = false
            customFeatButton.enabled = false
        }
        else{
            removeFeatButton.title = "Remove Feat"
            featureTableView.setEditing(false, animated: true)
            addFeatButton.enabled = true
            customFeatButton.enabled = true
        }
    }//setDeletionMode
    
    func doneFeatPicker(sender: UIBarButtonItem){
        
        addFeat(featNameArray[featPicker.selectedRowInComponent(0)])
        
        dummyTextField.endEditing(true)
    }//doneFeatPicker
    
    func cancelFeatPicker(sender: UIBarButtonItem){
        
        dummyTextField.endEditing(true)
    }//cancelFeatPicker
    
    func doneSubclassPicker(sender: UIBarButtonItem){
        
        let newSubclassName: String = pickerView(subclassPicker, titleForRow: subclassPicker.selectedRowInComponent(0), forComponent: 0)!
        
        currentFeatureList!.character!.changeSubclassWithNameTo(newSubclassName)
        
        do{
            try currentFeatureList!.managedObjectContext!.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
        
        
        subclassTextField?.text = newSubclassName
        
        subclassTextField?.endEditing(true)
        
        updateClassFeatArray()
        
        featureTableView.reloadData()
        
    }//doneSubclassPicker
    
    func cancelSubclassPicker(sender: UIBarButtonItem){
        
        let oldSubclass: Subclass? = currentFeatureList!.character!.subclass
        
        if (oldSubclass == nil){
            subclassTextField?.text = "None"
        }
        else{
            subclassTextField?.text = oldSubclass!.name
        }
        
        subclassTextField?.endEditing(true)
    }//cancelSubclassPicker
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        textField.resignFirstResponder()
        
    }//textFieldDidEndEditing
    
    /**
     Called when the addSpellVC exits, with a spell in it that we'll want to add to our feature page
     */
    func receiveSpell(spell: Spell){
        
        //Get our character out
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "PCharacter");
        fetchRequest.predicate = NSPredicate(format: "id = %@", String(appDelegate.currentCharacterId));
        var results: [PCharacter] = [];
        do{
            results = try context.executeFetchRequest(fetchRequest) as! [PCharacter]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        results[0].updateAScores()
        //Note that now results[0] is our character
        
        results[0].featureList!.addSpell(spell)
        spellArray = buildSpellArray(results[0].featureList!)
        
        featureTableView.reloadData()
        
    }//receiveSpell
    
    //MARK: onAppear
    override func viewDidLoad(){
        super.viewDidLoad()
        
        featureTableView.dataSource = self;
        featureTableView.delegate = self;
        
        self.view.addSubview(dummyTextField)
        
        let featureHeaderNib: UINib = UINib(nibName: "FeatureHeader", bundle: nil)
        let classFeatureHeaderNib: UINib = UINib(nibName: "ClassFeatureHeader", bundle: nil)
        featureTableView.registerNib(featureHeaderNib, forHeaderFooterViewReuseIdentifier: "featureHeader")
        featureTableView.registerNib(classFeatureHeaderNib, forHeaderFooterViewReuseIdentifier: "classFeatureHeader")
        
        //delegate things
        featPicker.dataSource = self
        featPicker.delegate = self
        subclassPicker.dataSource = self
        subclassPicker.delegate = self
        dummyTextField.delegate = self
        subclassTextField?.delegate = self
        
        dummyTextField.inputView = featPicker
        dummyTextField.inputAccessoryView = featPickerToolbar
        
        //feat picker things
        
        featPickerToolbar.barStyle = UIBarStyle.Default
        featPickerToolbar.sizeToFit()
        featDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(FeaturesViewController.doneFeatPicker(_:)))
        featCancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(FeaturesViewController.cancelFeatPicker(_:)))
        
        featPickerToolbar.setItems([featCancelButton, featSpaceButton, featDoneButton], animated: false)
        featPickerToolbar.userInteractionEnabled = true
        
        //subclass picker things
        
        subclassPickerToolbar.barStyle = .Default
        subclassPickerToolbar.sizeToFit()
        subclassDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(FeaturesViewController.doneSubclassPicker(_:)))
        subclassCancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(FeaturesViewController.cancelSubclassPicker(_:)))
        
        subclassPickerToolbar.setItems([subclassCancelButton, subclassSpaceButton, subclassDoneButton], animated: false)
        subclassPickerToolbar.userInteractionEnabled = true
        
        
        
    }//viewDidLoad
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
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
        
        results[0].buildClassFeatures(context: managedContext)

        currentFeatureList = results[0].featureList!
        
        raceFeatArray.removeAll()
        for raceFeat in currentFeatureList!.raceFeatures{
            raceFeatArray.append(raceFeat as! RaceFeature)
        }

        updateClassFeatArray()
        
        backgroundFeatArray.removeAll()
        for backgroundFeat in currentFeatureList!.backgroundFeatures{
            backgroundFeatArray.append(backgroundFeat as! BackgroundFeature)
        }
        featArray.removeAll()
        for feat in currentFeatureList!.feats{
            featArray.append(feat as! Feat)
        }
        spellArray.removeAll()
        spellArray = buildSpellArray(currentFeatureList!)
        
        if (results[0].pclass != nil){
            subclassNameArray = SpellViewController.buildSubclassNames(results[0].pclass!.id)
        }
        
        
    }//viewWillAppear
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        featureTableView.reloadData()
        
    }//viewDidAppear
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        setDeletionMode(false)
        
        dummyTextField.resignFirstResponder()
        
    }//viewWillDisappear
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if (segue.identifier == "customFeatSegue"){
            
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
            
            let destVC: CustomFeatViewController = segue.destinationViewController as! CustomFeatViewController
            
            destVC.featArray = featArray
            destVC.featureList = results[0].featureList
            
            
        }//if we're putting in a custom VC
    }//prepareForSegue
    
    //MARK: Helper Functions
    
    func updateClassFeatArray(){
        classFeatArray.removeAll()
        for classFeat in currentFeatureList!.getFilteredClassFeatures(atLevel: currentFeatureList!.character!.level){
            classFeatArray.append(classFeat)
        }
    }
    
    /**
     Makes the spell list we're about to use for the addspellVC match the specifications of the feature allowing us to add a spell
     - Parameter fullSpellList: The class spell list we're filtering down
     - Parameter usingFeatId: the id of the feat that's allowing us to add spells. Currently, only Cantrip (26), Magic Initiate (86), and Ritual Caster (95) are supported. Update: also supporting Additional Magical Secrets (258, bard, college of lore), Magical Secrets (260-262, bard), Bonus Cantrip (334-341, Druid, Circle of the Land)
     - Parameter intoTempSpellList: The temporary spell list we're putting the filtered spells into. Destructively modifies its internal set of spells
     */
    func filterSpellList(fullSpellList: SpellList, usingFeatId: Int, intoTempSpellList: SpellList){
        
        var cantrips: [Spell] = fullSpellList.getSpellsForLevel(level: 0)
        let lev1Spells: [Spell] = fullSpellList.getSpellsForLevel(level: 1)
        cantrips.appendContentsOf(lev1Spells)
        
        intoTempSpellList.setSpellsTo(cantrips)
        
        switch(usingFeatId){
        case 26://Cantrip (High Elf)
            
            intoTempSpellList.setSpellsTo(fullSpellList.getSpellsForLevel(level: 0))
            
        case 86://Magic Initiate (Feat)
            
            var cantrips: [Spell] = fullSpellList.getSpellsForLevel(level: 0)
            let lev1Spells: [Spell] = fullSpellList.getSpellsForLevel(level: 1)
            cantrips.appendContentsOf(lev1Spells)
            
            intoTempSpellList.setSpellsTo(cantrips)
            
        case 95://Ritual Caster (Feat)
            
            //Get our character out
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            let fetchRequest = NSFetchRequest(entityName: "PCharacter");
            fetchRequest.predicate = NSPredicate(format: "id = %@", String(appDelegate.currentCharacterId));
            var charResults: [PCharacter] = [];
            do{
                charResults = try managedContext.executeFetchRequest(fetchRequest) as! [PCharacter]
            }catch let error as NSError{
                print("Could not save \(error), \(error.userInfo)")
            }
            charResults[0].updateAScores()
            //Note that now results[0] is our character
            
            let myLevel: Double = Double(charResults[0].level)
            var maxSpellLevel: Int = Int(ceil(myLevel / 2))//max spell level is player level / 2, rounded up
            if (maxSpellLevel > 9){
                maxSpellLevel = 9//can't be higher than 9th-level spells
            }//if
            
            var levelFilteredArray: [Spell] = []
            
            for i in 0...maxSpellLevel{
                levelFilteredArray.appendContentsOf(fullSpellList.getSpellsForLevel(level: Int16(i)))
            }//for all applicable spell levels
            
            var results: [Spell] = []
            for spell in levelFilteredArray{
                if spell.ritual{
                    results.append(spell)
                }//if it's a ritual
            }//for each lev1 spell
            
            intoTempSpellList.setSpellsTo(results)
            
        case 258://Additional Magical Secrets (Bard, College of Lore)
            //Rules: must be able at current bard level to know this spell level
            //TODO: give a shit about enforcing the above
            
            var levelFilteredArray: [Spell] = []
            
            //placeholder: allow access to all spells in chosen spell list
            for i in 0...9{
                levelFilteredArray.appendContentsOf(fullSpellList.getSpellsForLevel(level: Int16(i)))
            }
            
            var results: [Spell] = []
            for spell in levelFilteredArray{
                results.append(spell)
            }//for each lev1 spell
            
            intoTempSpellList.setSpellsTo(results)
            
        case 260, 261, 262:
            //Rules: must be able at current bard level to know this spell level
            //TODO: give a shit about enforcing the above
            
            var levelFilteredArray: [Spell] = []
            
            //placeholder: allow access to all spells in chosen spell list
            for i in 0...9{
                levelFilteredArray.appendContentsOf(fullSpellList.getSpellsForLevel(level: Int16(i)))
            }
            
            var results: [Spell] = []
            for spell in levelFilteredArray{
                results.append(spell)
            }//for each lev1 spell
            
            intoTempSpellList.setSpellsTo(results)
            
        case 272: //Acolyte of Nature (Cleric, Nature subclass)
            //Rules: druid cantrip
            //TODO: restrict to druid list
            intoTempSpellList.setSpellsTo(fullSpellList.getSpellsForLevel(level: 0))
        case 334, 335, 336, 337, 338, 339, 340, 341://Bonus Cantrip (Druid, Circle of the Land)
            //Rules: druid cantrip
            //TODO: restrict to druid list
            intoTempSpellList.setSpellsTo(fullSpellList.getSpellsForLevel(level: 0))
        default:
            intoTempSpellList.setSpellsTo(fullSpellList.getSpellsForLevel(level: 0))//default to choosing from cantrips
        }//switch
        
    }//filterSpellList
    
    func buildSpellArray(fromFeatureList: FeatureList)->[Spell]{
        
        var results: [Spell] = []
        
        if (fromFeatureList.getNumberOfSpells() == 0){
            return []
        }//if empty (Reduces multiple calls to the getspellsforlevel function)
        
        for i in 0...9{
            results.appendContentsOf(fromFeatureList.spellList.getSpellsForLevel(level: Int16(i)))
        }//for each level
        
        return results
        
    }//buildSpellArray
    
    func addFeat(name: String){
        
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
        
        let myFeatList: FeatureList = results[0].featureList!
        
        fetchRequest = NSFetchRequest(entityName: "Feat")
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        var featResults: [Feat] = []
        do{
            featResults = try managedContext.executeFetchRequest(fetchRequest) as! [Feat]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
        myFeatList.addFeature(featResults[0])
        
        if (featArray.contains(featResults[0]) == false){
            
            featArray.append(featResults[0])
            
            featArray.sortInPlace({(feat1, feat2) -> Bool in
                return feat1.id < feat2.id
            })
            
            
        }//if we don't already have the feat in there
        
        
        do{
            try managedContext.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
        featureTableView.reloadData();

    }//addFeat
    
    //MARK: UITableViewDataSource functions
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        var cell: UITableViewCell = UITableViewCell()
        var name: String = ""
        
        var thisFeature: Feature? = nil
        var thisSpell: Spell? = nil
        
        let featureSpellBlock: (Feature?, Spell?) = getRelevantFeatureOrSpell(atIndexPath: indexPath)
        thisFeature = featureSpellBlock.0
        thisSpell = featureSpellBlock.1
        
        if (thisFeature != nil){
            name = thisFeature!.name
            
            if (addSpellFeatIds.contains(Int(thisFeature!.id))){
                
                currentAddSpellId = Int(thisFeature!.id)
                
                cell = tableView.dequeueReusableCellWithIdentifier("prototypeFeatureCellAddSpell", forIndexPath: indexPath)
                (cell as! FeatureCellAddSpell).titleLabel.text = name
                (cell as! FeatureCellAddSpell).addSpellButton.target = self
                (cell as! FeatureCellAddSpell).addSpellButton.action = #selector(FeaturesViewController.addSpellButtonPress(_:))
                (cell as! FeatureCellAddSpell).addSpellButton.tag = Int(thisFeature!.id)
                
            }//if making an add-spell thing
            else{
                cell = tableView.dequeueReusableCellWithIdentifier("prototypeFeatureCell", forIndexPath: indexPath)
                cell.textLabel!.text = name
            }
        }//if a feature cell
        if (thisSpell != nil){
            
            cell = tableView.dequeueReusableCellWithIdentifier("personalSpellCell", forIndexPath: indexPath)
            (cell as! PersonalSpellTableCell).setInfoWithSpell(spell: thisSpell!)
            
        }//if a spell cell
        
        return cell
            
    }//tableView Cell for row at index path
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var header: FeatureHeader? = nil
        
        if (currentFeatureList!.getNthLowestExtantHeaderIndex(section) == 1){
            header = tableView.dequeueReusableHeaderFooterViewWithIdentifier("classFeatureHeader") as? ClassFeatureHeader
            
            let currentSubclass: Subclass? = currentFeatureList!.character!.subclass
            
            subclassTextField = (header as! ClassFeatureHeader).subclassTextField
            subclassTextField!.delegate = self
            
            //make sure the label for the subclass is decent
            (header as! ClassFeatureHeader).subclassTitleLabel.text = "\(currentFeatureList!.character!.pclass!.subclassIdentifierName):"
            
            (header as! ClassFeatureHeader).subclassTextField.inputView = subclassPicker
            (header as! ClassFeatureHeader).subclassTextField.inputAccessoryView = subclassPickerToolbar
            
            if (currentSubclass == nil){
                (header as! ClassFeatureHeader).subclassTextField.text = "None"
            }
            else{
                (header as! ClassFeatureHeader).subclassTextField.text = currentSubclass!.name
            }
            
        }//if we're looking at the class features
        else{
            header = tableView.dequeueReusableHeaderFooterViewWithIdentifier("featureHeader") as? FeatureHeader
        }
        
        let title: String = currentFeatureList!.getTitleOfSection(section)
        
        header!.titleLabel.text = title
        
        return header!
        
    }//viewForHeaderInSection
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            switch (currentFeatureList!.getNthLowestExtantHeaderIndex(section)){
            case 0://race
                return raceFeatArray.count
            case 1://class
                return classFeatArray.count
            case 2://background
                return backgroundFeatArray.count
            case 3://feat
                return featArray.count
            case 4://spell
                return spellArray.count
            default:
                return 0;
            }
    }//tableView number of rows in section
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return currentFeatureList!.getNumberOfSections()
        
    }//numberOfSectionsInTableView
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return currentFeatureList!.getTitleOfSection(section)

    }//titleForHeaderInSection
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch(currentFeatureList!.getNthLowestExtantHeaderIndex(indexPath.section)){
        case 0://Race
            return 44
        case 1://Class
            return 44
        case 2://Background
            return 44
        case 3://Feat
            return 44
        case 4://Spell
            return 66
        default:
            return 44
        }//switch
    }//heightForRowAtIndexPath
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }//heightForHeaderInSection
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        switch (currentFeatureList!.getNthLowestExtantHeaderIndex(indexPath.section)){
        case 0://race
            return false
        case 1://class
            return false
        case 2://background
            return false
        case 3://feat
            return true
        case 4://spells
            return true
        default:
            return false
        }//switch
    }//canEditRowAtIndexPath
    
    private func getRelevantFeatureOrSpell(atIndexPath indexPath: NSIndexPath)->(Feature?, Spell?){
        
        var myFeature: Feature? = nil
        var mySpell: Spell? = nil
        
        let headerIndex = currentFeatureList!.getNthLowestExtantHeaderIndex(indexPath.section)
        switch headerIndex{
        case 0:
            myFeature = raceFeatArray[indexPath.row]
        case 1:
            myFeature = classFeatArray[indexPath.row]
        case 2:
            myFeature = backgroundFeatArray[indexPath.row]
        case 3:
            myFeature = featArray[indexPath.row]
        case 4:
            mySpell = spellArray[indexPath.row]
        default:
            myFeature = nil
        }//switch
        
        return (myFeature, mySpell)
        
    }//getRelevantFeatureOrSpell
    
    //MARK: UITableViewDelegate functions
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {

        let featureSpellBlock: (Feature?, Spell?) = getRelevantFeatureOrSpell(atIndexPath: indexPath)
        
        if (featureSpellBlock.0 != nil){
            presentFeatureDetailVC(withFeature: featureSpellBlock.0!)
        }
        if (featureSpellBlock.1 != nil){
            presentSpellDetailVC(withSpell: featureSpellBlock.1!)
        }

    }//accessoryButtonTappedForRowWithIndexPath
    
    //TODO: make this work
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //Delete a feat
        if editingStyle == .Delete {
            // Delete the row from the data source
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context = appDelegate.managedObjectContext!
            let fetchRequest = NSFetchRequest(entityName: "PCharacter");
            fetchRequest.predicate = NSPredicate(format: "id = %@", String(appDelegate.currentCharacterId));
            var results: [PCharacter] = [];
            do{
                results = try context.executeFetchRequest(fetchRequest) as! [PCharacter]
            }catch let error as NSError{
                print("Could not save \(error), \(error.userInfo)")
            }
            results[0].updateAScores()
            //Note that now results[0] is our character
            
            var oldFeat: Feature? = nil;
            var oldSpell: Spell? = nil
            
            let featureSpellBlock: (Feature?, Spell?) = getRelevantFeatureOrSpell(atIndexPath: indexPath)
            oldFeat = featureSpellBlock.0
            oldSpell = featureSpellBlock.1

            if (oldFeat != nil){
                results[0].featureList!.subtractFeature(oldFeat!)
            }//if killing a feature
            if (oldSpell != nil){
                results[0].featureList!.removeSpell(oldSpell!)
            }//if killing a spell
                
            switch(indexPath.section){
            case 0:
                raceFeatArray.removeAtIndex(indexPath.row)
            case 1:
                backgroundFeatArray.removeAtIndex(indexPath.row)
            case 2:
                featArray.removeAtIndex(indexPath.row)
            case 3:
                spellArray.removeAtIndex(indexPath.row)
            default:
                _ = 2 + 2
            }
            
            do{
                try context.save()
            }catch let error as NSError{
                print("Could not save \(error), \(error.userInfo)")
            }
            
            featureTableView.reloadData()
            
            removeFeatButton.title = "Remove Feat"
            featureTableView.setEditing(false, animated: true)
        }

    }//commitEditingStyle

    
    //MARK: UIPickerViewDataSource functions
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if (pickerView == featPicker){
            return featNameArray.count
        }
        if (pickerView == subclassPicker){
            return subclassNameArray.count
        }
        
        return 0
    }//numberOfRowsInComponent

    
    //MARK: UIPickerViewDelegate functions
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        
        if (pickerView == featPicker){
            return featNameArray[row]
        }
        if (pickerView == subclassPicker){
            return subclassNameArray[row]
        }

        return nil
        
    }//titleForRowInComponent
    
    
}//FeaturesViewController

class FeatureCellAddSpell: UITableViewCell{
    
    //MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addSpellButton: UIBarButtonItem!
    
}//featureCellAddSpell

class FeatureHeader: UITableViewHeaderFooterView{
    
    //MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    
    
}//FeatureHeader

class ClassFeatureHeader: FeatureHeader{
    
    //MARK: Outlets
    @IBOutlet weak var subclassTitleLabel: UILabel!
    @IBOutlet weak var subclassTextField: UITextField!
    
    
}//ClassFeatureHeader









