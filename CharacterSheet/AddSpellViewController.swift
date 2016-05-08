//
//  AddSpellViewController.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 3/26/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit
import CoreData

protocol SpellDataReceiverDelegate{
    func receiveSpell(spell: Spell)
}//SpellDataReceiverDelegate

class AddSpellViewController: CSViewController, UITableViewDataSource, UITableViewDelegate{
 
    var delegate: SpellDataReceiverDelegate?
    
    //MARK: Variables
    var currentSpellList: SpellList? = nil
    var tableHeaders: [(Int, String)] = []
    
    //MARK: Outlets
    @IBOutlet weak var addSpellTable: UITableView!
    
    
    //MARK: ViewController Navigation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSpellTable.dataSource = self
        addSpellTable.delegate = self
        
    }//viewDidLoad
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        if (currentSpellList != nil && currentSpellList!.temporary){
            
            let context: NSManagedObjectContext = currentSpellList!.managedObjectContext!
            
            context.deleteObject(currentSpellList!)
            
            do{
                try context.save()
            }catch let error as NSError{
                print("Could not save \(error), \(error.userInfo)")
            }
            
        }//if temporary spell list, delete it
    }//viewWillDisappear
    
    //MARK: UITableView functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableHeaders.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableHeaders[section].1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let level: Int = tableHeaders[section].0
        
        return currentSpellList!.getSpellNamesPerLevel(level: Int16(level)).count

    }//numberOfRowsInSection
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: SpellTableCell = addSpellTable.dequeueReusableCellWithIdentifier("spellCellBasic")! as! SpellTableCell
        
        let level: Int16 = Int16(tableHeaders[indexPath.section].0)
        let subList: [Spell] = currentSpellList!.getSpellsForLevel(level: level)
        let thisSpell: Spell = subList[indexPath.row]
        
        cell.setInfoWithSpell(spell: thisSpell)
        
        return cell
        
    }//cellForRowAtIndexPath
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
        let level: Int16 = Int16(tableHeaders[indexPath.section].0)
        let subList: [Spell] = currentSpellList!.getSpellsForLevel(level: level)
        let thisSpell: Spell = subList[indexPath.row]
        
        let newVC: SpellDetailViewController = storyboard!.instantiateViewControllerWithIdentifier("SpellDetailViewController") as! SpellDetailViewController
        newVC.modalPresentationStyle = .OverCurrentContext
        newVC.modalTransitionStyle = .CoverVertical
        newVC.mySpell = thisSpell
        
        self.presentViewController(newVC, animated: true, completion: {
            ()->Void in
        })
        
    }//accessory button tapped
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let level: Int16 = Int16(tableHeaders[indexPath.section].0)
        let subList: [Spell] = currentSpellList!.getSpellsForLevel(level: level)
        let thisSpell: Spell = subList[indexPath.row]
        
        //send the spell back for adding purposes
        self.delegate!.receiveSpell(thisSpell)
        
        //shut the city down
        //self.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController!.popViewControllerAnimated(true)

    }//didSelectRowAtIndexPath
    
    //MARK: Helper functions
    
    func buildHeaders(){
        tableHeaders = []
        
        var subList: [String] = []
        
        subList = currentSpellList!.getSpellNamesPerLevel(level: 0)
        if (subList.count != 0){
            tableHeaders.append((0, "Cantrips"))
        }
        
        for i in 1 ..< 10 {
            subList = currentSpellList!.getSpellNamesPerLevel(level: Int16(i))
            if (subList.count != 0){
                tableHeaders.append((i, "Level \(i)"))
            }
        }//for

    }//buildHeaders
    
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
    
    
}//AddSpellViewController
