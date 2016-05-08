//
//  FeaturesViewController.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 2/24/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit
import CoreData

class FeaturesViewController: CSViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, SpellDataReceiverDelegate{

    var raceFeatArray: [RaceFeature] = []
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
    let addSpellFeatIds: [Int] = [26, 86, 95]//Cantrip (High Elf), Magic Initiate (feat), Ritual Caster (feat)
    var currentAddSpellId: Int? = nil
    
    var featPicker: UIPickerView = UIPickerView()
    var featPickerToolbar: UIToolbar = UIToolbar();
    var featDoneButton: UIBarButtonItem = UIBarButtonItem();
    var featSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
    var featCancelButton: UIBarButtonItem = UIBarButtonItem();
    var dummyTextField: UITextField = UITextField(frame: CGRectZero)
    
    //MARK: outlets
    @IBOutlet weak var featureTableView: UITableView!
    @IBOutlet weak var removeFeatButton: UIBarButtonItem!
    @IBOutlet weak var addFeatButton: UIBarButtonItem!

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
            removeFeatButton.title = "Remove Feat"
            featureTableView.setEditing(false, animated: true)
        }//if in editing mode
        else{
            removeFeatButton.title = "Cancel"
            featureTableView.setEditing(true, animated: true)
        }//if not in editing mode
    }//removeFeatButtonPress
    
    func doneFeatPicker(sender: UIBarButtonItem){
        
        addFeat(featNameArray[featPicker.selectedRowInComponent(0)])
        
        dummyTextField.resignFirstResponder()
    }//doneFeatPicker
    
    func cancelFeatPicker(sender: UIBarButtonItem){
        dummyTextField.resignFirstResponder()
    }//cancelFeatPicker
    
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
        
        
        //featPicker things
        featPicker.dataSource = self
        featPicker.delegate = self
        
        dummyTextField.inputView = featPicker
        dummyTextField.inputAccessoryView = featPickerToolbar
        
        featPickerToolbar.barStyle = UIBarStyle.Default
        featPickerToolbar.sizeToFit()
        featDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(FeaturesViewController.doneFeatPicker(_:)))
        featCancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(FeaturesViewController.cancelFeatPicker(_:)))
        
        featPickerToolbar.setItems([featCancelButton, featSpaceButton, featDoneButton], animated: false)
        featPickerToolbar.userInteractionEnabled = true
        
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

        raceFeatArray.removeAll()
        for raceFeat in results[0].featureList!.raceFeatures{
            raceFeatArray.append(raceFeat as! RaceFeature)
        }
        backgroundFeatArray.removeAll()
        for backgroundFeat in results[0].featureList!.backgroundFeatures{
            backgroundFeatArray.append(backgroundFeat as! BackgroundFeature)
        }
        featArray.removeAll()
        for feat in results[0].featureList!.feats{
            featArray.append(feat as! Feat)
        }
        spellArray.removeAll()
        spellArray = buildSpellArray(results[0].featureList!)

    }//viewWillAppear
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        featureTableView.reloadData()
        
    }//viewDidAppear
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeFeatButton.title = "Remove Feat"
        
        featureTableView.setEditing(false, animated: false)
        
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
    
    /**
     Makes the spell list we're about to use for the addspellVC match the specifications of the feature allowing us to add a spell
     - Parameter fullSpellList: The class spell list we're filtering down
     - Parameter usingFeatId: the id of the feat that's allowing us to add spells. Currently, only Cantrip (26), Magic Initiate (86), and Ritual Caster (95) are supported
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
        
        switch(indexPath.section){
        case 0:
            thisFeature = raceFeatArray[indexPath.row]
        case 1:
            thisFeature = backgroundFeatArray[indexPath.row]
        case 2:
            thisFeature = featArray[indexPath.row]
        case 3:
            thisSpell = spellArray[indexPath.row]
        default:
            _ = 2 + 2
        }//switch
        
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
            
        }//if a cell spell
        
        return cell
            
    }//tableView Cell for row at index path
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int{
            switch (section){
            case 0:
                return raceFeatArray.count
            case 1:
                return backgroundFeatArray.count
            case 2:
                return featArray.count
            case 3:
                return spellArray.count
            default:
                return 0;
            }
    }//tableView number of rows in section
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
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
        
        let featureList: FeatureList = results[0].featureList!
        
        if (featureList.getNumberOfSpells() == 0){
            return 3
        }
        else{
            return 4
        }
        
    }//numberOfSectionsInTableView
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section){
        case 0:
            return "Racial Features"
        case 1:
            return "Background Features"
        case 2:
            return "Features"
        case 3:
            return "Spells"
        default:
            return "Oh shit you broke it!"
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch(indexPath.section){
        case 0:
            return 44
        case 1:
            return 44
        case 2:
            return 44
        case 3:
            return 66
        default:
            return 44
        }//switch
    }//heightForRowAtIndexPath
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        switch (indexPath.section){
        case 0://race
            return false
        case 1://background
            return false
        case 2://feat
            return true
        case 3://spells
            return true
        default:
            return false
        }//switch
    }
    
    
    
    //MARK: UITableViewDelegate functions
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {

        var myFeature: Feature? = nil
        var mySpell: Spell? = nil
        
        switch (indexPath.section){
        case 0:
            myFeature = raceFeatArray[indexPath.row]
        case 1:
            myFeature = backgroundFeatArray[indexPath.row]
        case 2:
            myFeature = featArray[indexPath.row]
        case 3:
            mySpell = spellArray[indexPath.row]
        default:
            myFeature = nil
        }//switch
        
        if (myFeature != nil){
            presentFeatureDetailVC(withFeature: myFeature!)
        }
        if (mySpell != nil){
            presentSpellDetailVC(withSpell: mySpell!)
        }

    }//accessoryButtonTappedForRowWithIndexPath
    
    
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
            
            switch(indexPath.section){
            case 0:
                oldFeat = raceFeatArray[indexPath.row]
            case 1:
                oldFeat = backgroundFeatArray[indexPath.row]
            case 2:
                oldFeat = featArray[indexPath.row]
            case 3:
                oldSpell = spellArray[indexPath.row]
            default:
                oldFeat = nil
            }

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
    
    func pickerView(pickerView: UIPickerView,
        numberOfRowsInComponent component: Int) -> Int{
            return featNameArray.count
    }

    
    //MARK: UIPickerViewDelegate functions
    
    func pickerView(
        pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
        ) -> String? {

            return featNameArray[row]
    }//titleForRowInComponent
    
    
}//FeaturesViewController

class FeatureCellAddSpell: UITableViewCell{
    
    //MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addSpellButton: UIBarButtonItem!

    
    
}//featureCellAddSpell






