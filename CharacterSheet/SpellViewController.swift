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
    
    //MARK: Viewcontroller Navigation functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spellTableView.delegate = self
        spellTableView.dataSource = self
    }
    
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
            
            print(destController.tableHeaders)
            
        }
        
    }
    
    //MARK: Spell Addition
    
    func receiveSpell(spell: Spell) {
        
        //TODO: Add spell
        
    }//receiveSpell
    
    //MARK: UITableView things
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: SpellTableCell = spellTableView.dequeueReusableCellWithIdentifier("spellCellBasic")! as! SpellTableCell
        
        cell.spellNameLabel.text = "Cure Wounds"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
}//SpellViewController

