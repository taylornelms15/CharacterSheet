//
//  FeaturesViewController.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 2/24/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit
import CoreData

class FeaturesViewController: CSViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate{

    var raceFeatArray: [RaceFeature] = []
    var backgroundFeatArray: [BackgroundFeature] = []
    var featArray: [Feat] = []
    var featNameArray: [String] =
        ["Alert", "Athlete", "Actor", "Charger", "Crossbow Expert", "Defensive Duelist", "Dual Wielder", "Dungeon Delver", "Durable",
            "Elemental Adept - Acid", "Elemental Adept - Cold", "Elemental Adept - Fire", "Elemental Adept - Lightning", "Elemental Adept - Thunder",
            "Grappler", "Great Weapon Master", "Healer", "Heavily Armored", "Heavy Armor Master", "Inspiring Leader", "Keen Mind",
            "Lightly Armored", "Linguist", "Lucky", "Mage Slayer", "Magic Initiate", "Martial Adept", "Medium Armor Master", "Mobile",
            "Moderately Armored", "Mounted Combatant", "Observant", "Polearm Master", "Resilient", "Ritual Caster", "Savage Attacker",
            "Sentinel", "Sharpshooter", "Shield Master", "Skilled", "Skulker", "Spell Sniper", "Tavern Brawler", "Tough", "War Caster", "Weapon Master"]
    
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
    
    @IBAction func addFeatButtonPress(sender: UIBarButtonItem) {
        dummyTextField.becomeFirstResponder()
    }
    
    @IBAction func removeFeatButtonPress(sender: UIBarButtonItem) {
        if (featureTableView.editing){
            removeFeatButton.title = "Remove Feat"
            featureTableView.setEditing(false, animated: true)
        }//if in editing mode
        else{
            removeFeatButton.title = "Cancel"
            featureTableView.setEditing(true, animated: true)
        }//if not in editing mode
    }
    
    func doneFeatPicker(sender: UIBarButtonItem){
        
        addFeat(featNameArray[featPicker.selectedRowInComponent(0)])
        
        dummyTextField.resignFirstResponder()
    }
    
    func cancelFeatPicker(sender: UIBarButtonItem){
        dummyTextField.resignFirstResponder()
    }
    
    
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
        


    }
    
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
    
    //MARK: Helper Functions
    
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
        featArray.append(featResults[0])
        
        do{
            try managedContext.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
        featureTableView.reloadData();

    }//addFeat
    
    //MARK: UITableViewDataSource functions
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
            let cell = tableView.dequeueReusableCellWithIdentifier("prototypeFeatureCell", forIndexPath: indexPath)
            
            switch(indexPath.section){
            case 0:
                cell.textLabel!.text = raceFeatArray[indexPath.row].name
            case 1:
                cell.textLabel!.text = backgroundFeatArray[indexPath.row].name
            case 2:
                cell.textLabel!.text = featArray[indexPath.row].name
            default:
                _ = 2 + 2
            }//switch
            
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
            default:
                return 0;
            }
    }//tableView number of rows in section
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3;
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section){
        case 0:
            return "Racial Features"
        case 1:
            return "Background Features"
        case 2:
            return "Features"
        default:
            return "Oh shit you broke it!"
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        switch (indexPath.section){
        case 0://race
            return false
        case 1://background
            return false
        case 2://feat
            return true
        default:
            return false
        }//switch
    }
    
    //MARK: UITableViewDelegate functions
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {

        var myFeature: Feature? = nil
        
        switch (indexPath.section){
        case 0:
            myFeature = raceFeatArray[indexPath.row]
        case 1:
            myFeature = backgroundFeatArray[indexPath.row]
        case 2:
            myFeature = featArray[indexPath.row]
        default:
            myFeature = nil
        }//switch
        
        let detailViewController = UIAlertController(title: nil, message: myFeature!.details, preferredStyle: .ActionSheet)
        let doneAction = UIAlertAction(title: "Done", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        detailViewController.addAction(doneAction)
        
        self.presentViewController(detailViewController, animated: true, completion: nil)
        
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //Delete a feat
        if editingStyle == .Delete {
            // Delete the row from the data source
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context = appDelegate.managedObjectContext!
            var fetchRequest = NSFetchRequest(entityName: "Feat");
            
            var oldFeat: Feature? = nil;
            
            switch(indexPath.section){
            case 0:
                oldFeat = raceFeatArray[indexPath.row]
            case 1:
                oldFeat = backgroundFeatArray[indexPath.row]
            case 2:
                oldFeat = featArray[indexPath.row]
            default:
                oldFeat = nil
            }

            
            fetchRequest.predicate = NSPredicate(format: "id = %@", String(oldFeat!.id));
            var featureResults: [Feature] = [];
            do{
                featureResults = try context.executeFetchRequest(fetchRequest) as! [Feature]
            }catch let error as NSError{
                print("Could not save \(error), \(error.userInfo)")
            }
            //featureResults[0] is the old feature
            //this whole block is likely superfluous, but oh well
            
            fetchRequest = NSFetchRequest(entityName: "PCharacter");
            fetchRequest.predicate = NSPredicate(format: "id = %@", String(appDelegate.currentCharacterId));
            var results: [PCharacter] = [];
            do{
                results = try context.executeFetchRequest(fetchRequest) as! [PCharacter]
            }catch let error as NSError{
                print("Could not save \(error), \(error.userInfo)")
            }
            results[0].updateAScores()
            //Note that now results[0] is our character
            
            results[0].featureList!.subtractFeature(featureResults[0])
            
            switch(indexPath.section){
            case 0:
                raceFeatArray.removeAtIndex(indexPath.row)
            case 1:
                backgroundFeatArray.removeAtIndex(indexPath.row)
            case 2:
                featArray.removeAtIndex(indexPath.row)
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

    }

    
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
    }
    
    
}//FeaturesViewController