//
//  SpellViewController.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 3/26/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit
import CoreData

class SpellViewController: CSViewController, UITableViewDelegate, UITableViewDataSource, SpellDataReceiverDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    //MARK: Outlets
    
    @IBOutlet weak var spellTableView: UITableView!
    @IBOutlet weak var addSpellButton: UIBarButtonItem!
    @IBOutlet weak var removeSpellButton: UIBarButtonItem!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var subclassTypeLabel: UILabel!
    @IBOutlet weak var subclassNameField: UITextField!
    
    var subclassPickerView = UIPickerView()
    var subclassPickerViewToolbar = UIToolbar()
    var subclassPickerDoneButton = UIBarButtonItem()
    var subclassPickerCancelButton = UIBarButtonItem()
    var subclassSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
    
    var tableHeaders: [(Int, String)] = []
    var thisSpellList: PersonalSpellList? = nil
    
    var subclassPickerTitles: [String] = []
    
    //MARK: Viewcontroller Navigation functions
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
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

        
        if (results[0].spellLists.count == 0){
            
            thisSpellList = PersonalSpellList.makePersonalSpellList(forPChar: results[0], withPClass: results[0].pclass!, inManagedObjectContext: context)
            
            do{
                try context.save()
            }catch let error as NSError{
                print("Could not save \(error), \(error.userInfo)")
            }//save
            
        }//if no personal spell list exists
        else{
            let charList: Set<PersonalSpellList>? = results[0].spellLists
            
            var found: Bool = false
            
            //check if there's a personal spell list matching our current class
            for list in charList!{
                if (list.pclassId == results[0].pclass!.id){
                    thisSpellList = list
                    found = true
                }//if
            }//for all
            
            //if there isn't, make one, and add it to our pchar's spell lists
            if (found == false){
                thisSpellList = PersonalSpellList.makePersonalSpellList(forPChar: results[0], withPClass: results[0].pclass!, inManagedObjectContext: context)
                
                do{
                    try context.save()
                }catch let error as NSError{
                    print("Could not save \(error), \(error.userInfo)")
                }//save
            }
        }//else
        
        thisSpellList!.updateSpellSlotsForCharLevel(level: results[0].level, withClassId: results[0].pclass!.id)
        classNameLabel.text = thisSpellList?.getPClassName()
        subclassTypeLabel.text = thisSpellList?.getSubclassTypeName()
        subclassPickerTitles = buildSubclassNames((thisSpellList?.pclassId)!)
        
        if (results[0].subclass == nil){
            subclassNameField.text = "None"
        }
        else{
            subclassNameField.text = results[0].subclass!.name
        }
        
        
        buildHeaders()
        
    }//viewWillAppear
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }//viewDidAppear
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (spellTableView.editing){
            removeSpellButtonPressed(removeSpellButton)//fake an editing toggle
        }//if editing, switch to not editing
        
    }//viewWillDisappear
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spellTableView.delegate = self
        spellTableView.dataSource = self
        
        let headerNib: UINib = UINib(nibName: "PersonalSpellTableHeader", bundle: nil)
        spellTableView.registerNib(headerNib, forHeaderFooterViewReuseIdentifier: "header1")
        
        subclassPickerView.delegate = self
        subclassPickerView.dataSource = self
        subclassPickerCancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(self.subclassPickerCancelButtonPressed))
        subclassPickerDoneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(self.subclassPickerDoneButtonPressed))
        
        subclassPickerViewToolbar.barStyle = UIBarStyle.Default
        subclassPickerViewToolbar.sizeToFit()
        subclassPickerViewToolbar.setItems([subclassPickerCancelButton, subclassSpaceButton, subclassPickerDoneButton], animated: false)
        
        
        subclassNameField.inputView = subclassPickerView
        subclassNameField.inputAccessoryView = subclassPickerViewToolbar
        subclassNameField.delegate = self
        
    }//viewDidLoad
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if (sender!.isKindOfClass(UIBarButtonItem) && (sender! as! UIBarButtonItem) == addSpellButton){
            let destController: AddSpellViewController = segue.destinationViewController as! AddSpellViewController
            
            
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
            
            destController.delegate = self
            
            destController.currentClass = results[0].pclass!
            destController.currentSpellList = results[0].pclass!.spellList
            
            destController.buildHeaders()
            
        }//if going to add spell
    
    }//prepareForSegue
    
    //MARK: Spell Addition
    
    func receiveSpell(spell: Spell) {
        
        thisSpellList!.addSpell(spell: spell)
        
        do{
            try spell.managedObjectContext!.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
        thisSpellList!.updateSpellNamesPerLevel(level: spell.level)
        
        reloadTable()
        
    }//receiveSpell

    //MARK: UIPickerView things
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if (pickerView == subclassPickerView){
            return 1
        }
        
        return 1
        
    }//numberOfComponentsInPickerView
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == subclassPickerView && component == 0){
            return subclassPickerTitles.count
        }//if
        
        return 0
    }//numberOfRowsInComponent
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == subclassPickerView && component == 0){
            return subclassPickerTitles[row]
        }//if
        return ""
    }//titleForRowInComponent
    
    func subclassPickerCancelButtonPressed(){
        
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
        
        var desiredText: String = ""
        
        if (results[0].subclass == nil){
            desiredText = "None"
        }
        else{
            desiredText = results[0].subclass!.name
        }
        
        let desiredRow: Int = subclassPickerTitles.indexOf(desiredText)!
        
        subclassPickerView.selectRow(desiredRow, inComponent: 0, animated: false)
        
        subclassNameField.resignFirstResponder()
        
    }//subclassPickerCancelButtonPressed
    
    func subclassPickerDoneButtonPressed(){
        
        subclassNameField.endEditing(true)
        
    }//subclassPickerDoneButtonPressed
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidEndEditing(textField: UITextField) {
        if (textField == subclassNameField){
            
            let newSubclassName = subclassPickerTitles[subclassPickerView.selectedRowInComponent(0)]
            
            textField.text = newSubclassName
            
            if (newSubclassName == "None"){
                thisSpellList!.pcharacter!.changeSubclassTo(nil)
            }//if we're clearing subclass
            else{
                thisSpellList!.pcharacter!.changeSubclassWithNameTo(newSubclassName)
            }//if not clearing subclass
            
            do{
                try thisSpellList!.managedObjectContext!.save()
            }catch let error as NSError{
                print("Could not save \(error), \(error.userInfo)")
            }

            for i in 1...20{
                thisSpellList!.updateSpellNamesPerLevel(level: Int16(i))
            }
            
            reloadTable()
            
        }//if the subclass name field
    }//textFieldDidEndEditing
    
    //MARK: UITableView things
    
    func reloadTable(){
        buildHeaders()
        spellTableView.reloadData()
    }//reloadTable
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (tableHeaders.count == 0){
            return 1
        }
        else{
            return tableHeaders.count
        }
    }//numSections
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (tableHeaders.count == 0){
            return "Please Add a Spell"
        }
        else{
            return tableHeaders[section].1
        }
    }//sectionTitle
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerTitle: String = ""
        if (tableHeaders.count == 0){
            headerTitle = "Add..."
        }
        else{
            headerTitle = tableHeaders[section].1
        }
        
        let cell = spellTableView.dequeueReusableHeaderFooterViewWithIdentifier("header1")
        let header = cell as! PersonalSpellTableHeader
        header.titleLabel.text = headerTitle

        if (tableHeaders.count == 0){
            header.slotsStackView.alpha = 0.0
            return header
        }//if no spells
        
        let level: Int16 = Int16(tableHeaders[section].0)

        if (level == 0){
            header.slotsStackView.alpha = 0.0
        }//if cantrip (no slots)
        else{
            header.slotsStackView.alpha = 1.0
        }//if other spell type (slots)
        
        header.level = level
        header.persSpellList = thisSpellList
        
        header.updateSlotsLabels()
        
        return header
    }//viewForHeaderInSection
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! PersonalSpellTableHeader
        
        header.overallView.backgroundColor = UIColor.lightGrayColor()
        
    }//willDisplayHeaderView
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableHeaders.count == 0) {return 0}
        
        let level: Int = tableHeaders[section].0
        
        return thisSpellList!.getSpellNamesPerLevel(level: Int16(level)).count
        
    }//numberOfRowsInSection
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var reuseIdentifier: String = ""
        if (thisSpellList!.preparesSpells){
            reuseIdentifier = "personalSpellCellPrep"
        }
        else{
            reuseIdentifier = "personalSpellCell"
        }
        
        let cell: PersonalSpellTableCell = spellTableView.dequeueReusableCellWithIdentifier(reuseIdentifier)! as! PersonalSpellTableCell
        
        /* DEBUG!!!
        print(indexPath.row)
        if(thisSpellList != nil){
            for spell in thisSpellList!.spells{
                print(spell)
            }
        }
 */
        
        let level: Int16 = Int16(tableHeaders[indexPath.section].0)
        let subList: [Spell] = thisSpellList!.getSpellsForLevel(level: level)
        let thisSpell: Spell = subList[indexPath.row]
        
        cell.persList = thisSpellList!
        cell.setInfoWithSpell(spell: thisSpell)
        
        return cell
        
    }//cellForRowAtIndexPath
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
        let level: Int16 = Int16(tableHeaders[indexPath.section].0)
        let subList: [Spell] = thisSpellList!.getSpellsForLevel(level: level)
        let thisSpell: Spell = subList[indexPath.row]
        
        let newVC: SpellDetailViewController = storyboard!.instantiateViewControllerWithIdentifier("SpellDetailViewController") as! SpellDetailViewController
        newVC.modalPresentationStyle = .OverCurrentContext
        newVC.modalTransitionStyle = .CoverVertical
        newVC.mySpell = thisSpell
        
        self.presentViewController(newVC, animated: true, completion: {
            ()->Void in
        })

    }//accessory button tapped
    
    //MARK: UITableView removal functions
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete){
            
            let level: Int16 = Int16(tableHeaders[indexPath.section].0)
            let subList: [Spell] = thisSpellList!.getSpellsForLevel(level: level)
            let thisSpell: Spell = subList[indexPath.row]
            
            thisSpellList!.removeSpell(spell: thisSpell)
            thisSpellList!.updateSpellNamesPerLevel(level: thisSpell.level)
            
            buildHeaders()
            
            //spellTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
            removeSpellButtonPressed(removeSpellButton)//fake a button press
            
            spellTableView.reloadData()
            
            do{
                try thisSpellList!.managedObjectContext!.save()
            }catch let error as NSError{
                print("Could not save \(error), \(error.userInfo)")
            }
            
        }//if we're deleting
    }//commitEditingStyle
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }//editingStyleForRow
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }//canEditRow
    
    @IBAction func removeSpellButtonPressed(sender: UIBarButtonItem) {
        
        if (spellTableView.editing){
            spellTableView.setEditing(false, animated: true)
            
            addSpellButton.enabled = true
            removeSpellButton.title = "Remove Spell"
        }//if canceling
        else{
            spellTableView.setEditing(true, animated: true)
            
            addSpellButton.enabled = false
            removeSpellButton.title = "Cancel"
        }//else deleting
        
    }//removeSpellButtonPressed
    
    func titleLevel(header: String)->Int{
        switch(header){
        case "Level 1":
            return 1
        case "Level 2":
            return 2
        case "Level 3":
            return 3
        case "Level 4":
            return 4
        case "Level 5":
            return 5
        case "Level 6":
            return 6
        case "Level 7":
            return 7
        case "Level 8":
            return 8
        case "Level 9":
            return 9
        default:
            return 0
        }
    }
    
    func buildHeaders(){
        tableHeaders = []
        
        var subList: [String] = []
        
        subList = thisSpellList!.getSpellNamesPerLevel(level: 0)
        if (subList.count != 0){
            tableHeaders.append((0, "Cantrips"))
        }
        
        for i in 1 ..< 10 {
            subList = thisSpellList!.getSpellNamesPerLevel(level: Int16(i))
            if (subList.count != 0 || thisSpellList!.getSlotsAvailableForLevel(level: Int16(i)) > 0){
                tableHeaders.append((i, "Level \(i)"))
            }
        }//for
        
    }//buildHeaders
    
    func buildSubclassNames(pclassId: Int16)->[String]{
        
        var results: [String] = ["None"]
        
        let context = thisSpellList!.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "Subclass")
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "id", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "parentClass.id", "\(pclassId)")
        var subclassResults: [Subclass] = []
        do{
            try subclassResults = context.executeFetchRequest(fetchRequest) as! [Subclass]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
        for subclass in subclassResults{
            results.append(subclass.name)
        }
        
        return results
        
        
    }//buildSubclassNames
    
}//SpellViewController

