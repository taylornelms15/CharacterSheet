//
//  CharacterSelectViewController.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 2/27/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CharacterSelectViewController: CSViewController, UITableViewDataSource, UITableViewDelegate{
    
    var characterArray: [PCharacter] = []
    
    //MARK: Outlets
    @IBOutlet weak var characterSelectTableView: UITableView!
    @IBOutlet weak var deleteCharactersButton: UIButton!
    
    
    //MARK: Actions
    @IBAction func deleteCharactersButtonPress(sender: UIButton) {
        if (characterSelectTableView.editing){
            characterSelectTableView.setEditing(false, animated: true)
            deleteCharactersButton.setTitle("Delete Characters", forState: UIControlState.Normal)
        }//if we're already editing
        else{
            characterSelectTableView.setEditing(true, animated: true)
            deleteCharactersButton.setTitle("Cancel", forState: UIControlState.Normal)
        }
    }
    
    //MARK: load functions
    override func viewDidLoad(){
        super.viewDidLoad()
        
        characterSelectTableView.dataSource = self;
        characterSelectTableView.delegate = self;
        
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
        
        //Init Feats
        
        entity = NSEntityDescription.entityForName("Feat", inManagedObjectContext: managedContext);
        fetchRequest = NSFetchRequest(entityName: "Feat");
        
        count = managedContext.countForFetchRequest(fetchRequest, error: &error)
        if (count == 0){
            Feat.featsInit(managedContext)
        }//if
        
        //Init Traits
        
        entity = NSEntityDescription.entityForName("Trait", inManagedObjectContext: managedContext);
        fetchRequest = NSFetchRequest(entityName: "Trait");
        
        count = managedContext.countForFetchRequest(fetchRequest, error: &error)
        if (count == 0){
            TraitList.traitsInit(managedContext)
        }//if
        
        //Init Spells
        
        entity = NSEntityDescription.entityForName("Spell", inManagedObjectContext: managedContext);
        fetchRequest = NSFetchRequest(entityName: "Spell");
        
        count = managedContext.countForFetchRequest(fetchRequest, error: &error)
        if (count == 0){
            Spell.spellsInit(managedContext)
        }//if
        
        //Init Subclasses
        
        entity = NSEntityDescription.entityForName("Subclass", inManagedObjectContext: managedContext);
        fetchRequest = NSFetchRequest(entityName: "Subclass");
        
        count = managedContext.countForFetchRequest(fetchRequest, error: &error)
        if (count == 0){
            Subclass.subClassesInit(managedContext)
        }//if

        NSNotificationCenter.defaultCenter().postNotificationName(pcharModNotificationKey, object: self)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        //get the list of characters out
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "PCharacter");
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        var results: [PCharacter] = [];
        do{
            results = try managedContext.executeFetchRequest(fetchRequest) as! [PCharacter]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }

        characterArray = Array(results)
        
        characterSelectTableView.reloadData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        characterSelectTableView.setEditing(false, animated: false)
        deleteCharactersButton.setTitle("Delete Characters", forState: UIControlState.Normal)
    }
    
    //MARK: UITableViewDataSource functions
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if (indexPath.row == characterArray.count){
            let cell = tableView.dequeueReusableCellWithIdentifier("addCharacterCell", forIndexPath: indexPath)
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("characterCell", forIndexPath: indexPath)
        cell.textLabel?.text = characterArray[indexPath.row].name
        cell.detailTextLabel!.text = charDetailText(characterArray[indexPath.row])
        if (characterArray[indexPath.row].id == appDelegate.currentCharacterId){
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }//if cell with current character in it
        else{
            cell.accessoryType = UITableViewCellAccessoryType.None
        }//other cell
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterArray.count + 1
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if (!characterSelectTableView.editing){
            return false;//no editing when we're not in editing mode
            //(this is to eliminate the redundant gesture recognizer on "swipe left")
        }
        
        if (indexPath.row == characterArray.count){
            return false//no deleting the add character row
        }
        else{
            if (characterArray.count == 1) {
                deleteCharactersButton.setTitle("Delete Characters", forState: UIControlState.Normal)
                characterSelectTableView.setEditing(false, animated: true)
                return false //no deleting the last character (unexpected issues might happen)
            }
            else{
                return true
            }
        }
    }
    
    //MARK: UITableViewDelegate functions

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        if (cell.reuseIdentifier == "addCharacterCell"){
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context = appDelegate.managedObjectContext!
            
            let newChar: PCharacter = PCharacter.createBlankCharacter(context)
            characterArray.append(newChar)
            
            
            appDelegate.currentCharacterId = newChar.id
            changeIdTo(newChar.id)
            characterSelectTableView.reloadData();
            
            return
            
        }//if add new
        else{
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let selectedChar: PCharacter = characterArray[indexPath.row];
            
            if (selectedChar.id == appDelegate.currentCharacterId){
                return
            }//if (same character)
            else{
                
                appDelegate.currentCharacterId = selectedChar.id;
                
                //make it persistent
                
                changeIdTo(selectedChar.id)
                
                characterSelectTableView.reloadData();
                return;
            }//else (other character)
            
        }//else
    }
    
    //Delete row from data source
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source

            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context = appDelegate.managedObjectContext!
            let fetchRequest = NSFetchRequest(entityName: "PCharacter");
            
            let oldChar = characterArray[indexPath.row]
            
            fetchRequest.predicate = NSPredicate(format: "id >= %@", String(oldChar.id));
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
            var results: [PCharacter] = [];
            do{
                results = try context.executeFetchRequest(fetchRequest) as! [PCharacter]
            }catch let error as NSError{
                print("Could not save \(error), \(error.userInfo)")
            }
            //results: [PCharacter] now contains, at index 0, the character we want to delete, and at all higher indexes, characters whose id's we want to decrement
            if(results.count == 1){
                context.deleteObject(results[0].skillProfs)
                context.deleteObject(results[0].traitList)
                context.deleteObject(results[0].featureList!)
                context.deleteObject(results[0])
            }//if we're deleting the last item
            else{
                context.deleteObject(results[0].skillProfs)
                context.deleteObject(results[0].traitList)
                context.deleteObject(results[0].featureList!)
                context.deleteObject(results[0])
                for i in 1 ..< results.count{
                    results[i].id -= 1
                }//for
            }//else (decrementing id's)

            characterArray.removeAtIndex(indexPath.row)
            
            if (oldChar.id == appDelegate.currentCharacterId){
                changeIdTo(1)//makes us select the first entry
            }

            do{
                try context.save()
            }catch let error as NSError{
                print("Could not save \(error), \(error.userInfo)")
            }
            
            //characterSelectTableView.setEditing(false, animated: true)
            
            characterSelectTableView.reloadData()
            
        }
    }
    
    //MARK: helper functions
    
    private func charDetailText(myChar: PCharacter)->String{
        
        var result: String = "Level \(myChar.level)"
        
        if (myChar.race != nil){
            result.appendContentsOf(" \(myChar.race!.name!)");
        }//if race
        
        if (myChar.pclass != nil){
            result.appendContentsOf(" \(myChar.pclass!.name!)");
        }//if class
        
        return result
    
    }//charDetailText
    
    private func changeIdTo(id: Int16){

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.currentCharacterId = id
        
        let context = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "CurrentId");
        var results: [NSManagedObject] = []
        do{
            results = try context.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
        results[0].setValue(Int(id), forKey: "currentId")
        
        do{
            try context.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(pcharModNotificationKey, object: self)

    }
    
}//class