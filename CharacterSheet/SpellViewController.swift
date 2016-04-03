//
//  SpellViewController.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 3/26/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit
import CoreData

class SpellViewController: CSViewController, UITableViewDelegate, UITableViewDataSource, SpellDataReceiverDelegate{
    
    //MARK: Outlets
    
    @IBOutlet weak var spellTableView: UITableView!
    @IBOutlet weak var addSpellButton: UIBarButtonItem!
    @IBOutlet weak var classNameLabel: UILabel!
    
    var tableHeaders: [(Int, String)] = []
    var thisSpellList: PersonalSpellList? = nil
    
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
        
        classNameLabel.text = thisSpellList?.getPClassName()
        
        buildHeaders()
        
    }//viewWillAppear
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
    }//viewDidAppear
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spellTableView.delegate = self
        spellTableView.dataSource = self
        
        let headerNib: UINib = UINib(nibName: "PersonalSpellTableHeader", bundle: nil)
        spellTableView.registerNib(headerNib, forHeaderFooterViewReuseIdentifier: "header1")
        
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
            headerTitle = "Please Add a Spell"
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
        }
        
        header.slotsStackView.alpha = 1.0
        
        let level: Int16 = Int16(tableHeaders[section].0)
        
        let slotsMax: Int = thisSpellList!.getSlotsAvailableForLevel(level: level)
        
        //header.slotStepper.maximumValue = Double(slotsMax)
        header.slotsMaxLabel.text = String(slotsMax)
        header.slotsExpendedLabel.text = String(thisSpellList!.getSlotsExpendedForLevel(level: level))
        
        
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
        
        let cell: SpellTableCell = spellTableView.dequeueReusableCellWithIdentifier("spellCellBasic")! as! SpellTableCell
        
        let level: Int16 = Int16(tableHeaders[indexPath.section].0)
        let subList: [Spell] = thisSpellList!.getSpellsForLevel(level: level)
        let thisSpell: Spell = subList[indexPath.row]
        
        cell.setInfoWithSpell(spell: thisSpell)
        
        return cell
        
    }//cellForRowAtIndexPath
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
        let level: Int16 = Int16(tableHeaders[indexPath.section].0)
        let subList: [Spell] = thisSpellList!.getSpellsForLevel(level: level)
        let thisSpell: Spell = subList[indexPath.row]
        
        let detailViewController = UIAlertController(title: thisSpell.name, message: thisSpell.details, preferredStyle: .ActionSheet)
        let doneAction = UIAlertAction(title: "Done", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        detailViewController.addAction(doneAction)
        
        self.presentViewController(detailViewController, animated: true, completion: nil)
    }//accessory button tapped
    
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
        
        for (var i = 1; i < 10; i++){
            subList = thisSpellList!.getSpellNamesPerLevel(level: Int16(i))
            if (subList.count != 0){
                tableHeaders.append((i, "Level \(i)"))
            }
        }//for
        
    }//buildHeaders
    
}//SpellViewController

