//
//  CSVCHandler.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 4/22/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit
import CoreData

///Static class to hold the damn checkbox unicode. Seemed like a decent place to put it.
class CheckBox{
    static let Checked: String = "\u{2611}"
    static let UnChecked: String = "\u{2B1C}"
}//CheckBox

let pcharModNotificationKey: String = "cspcharmodnotificationkey"
let menuNavTableReloadNotificationKey: String = "csmenunavtablereloadnotificationkey"

/**
 This class is designed to handle the collection of view controllers in the app.
 It is the source of data for a lot of inter-VC navigation.
 Mostly, it's being used as a data collection
 */
class CSVCHandler: NSObject, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, CSNavigationDataSource, UISplitViewControllerDelegate{
    
    static let fullNameArray: [(String, String)] = [
    ("Character Select", "CharacterSelectViewController"),
    ("Summary", "SummaryViewController"),
    ("Ability Scores", "AbilityScoreViewController"),
    ("Skills", "SkillViewController"),
    ("Features", "FeaturesViewController"),
    ("Inventory", "InventoryViewController"),
    ("Spells", "SpellViewController"),
    ("Traits", "TraitsViewController")
    ]
    
    weak var splitVC: CSSplitViewController? = nil
    
    ///Array of view controllers. Mirrors the navigation stack, as close as it can.
    var vcArray: [CSViewController] = []
    ///Array of names (0) and storyboard identifiers (1) for the view controllers. More static list of possible view controller titles and identifiers.
    var nameArray: [(String, String)] = CSVCHandler.fullNameArray //init'ed to assume all VC's are possible
    
    //MARK: init
    
    override init(){
        super.init()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CSVCHandler.pCharNotificationReceived), name: pcharModNotificationKey, object: nil)
        
    }//init
    
    //MARK: data source mods
    
    /**
     Receives notification that the pcharacter has been modified in a way that affects navigation, and then pulls out the current char and updates the list
     */
    func pCharNotificationReceived(){
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
        
        buildNameArrayFromPChar(results[0])
        
    }//pCharNotificationReceived
    
    /**
     Applies all logic of which VC's are possible or not possible, based on what does or doesn't exist for the current character.
     Current implementation: only allow spells with a class selected, only allow traits with a background selected
     - Parameter pchar: Character upon which to base the possible view controllers
     */
    func buildNameArrayFromPChar(pchar: PCharacter){
        
        //apply subtractive functions from the fullNameArray
        
        //If we haven't chosen a class (or if we're a barbarian or monk!), don't allow spell view controller
        let myClass: PClass? = pchar.pclass
        if (myClass == nil || ["Barbarian", "Monk"].contains(myClass!.name!)){
            
            let spellVCIndex: Int? = nameArray.indexOf{ $0.0 == "Spells" }//this is how we need to deal with operations on tuples in arrays, it seems
            if (spellVCIndex != nil){
                nameArray.removeAtIndex(spellVCIndex!)
                
                if (spellVCIndex! < nameArray.count - 1){
                    //move all higher indexes down one
                    for i in spellVCIndex! ..< nameArray.count - 1{
                        nameArray[i] = nameArray[i + 1]
                    }//for all
                
                    //remove the now-duplicate final array entry
                    nameArray.removeLast()
                }//if
                
            }//if
            
        }//if we can't cast spells
        else if (nameArray.contains{$0.0 == "Spells"} == false){
            
            let fullSpellIndex: Int = CSVCHandler.fullNameArray.indexOf{
                $0.0 == "Spells"
            }!
            var closestPrevIndex: Int = 0
            
            //convoluted, but: goes down the entries in our full name array. if we find one that exists in our namearray, we set that as closestPrevIndex and break the loop. and yes, this is a bastard for loop
            var i = fullSpellIndex
            while (i >= 0){
                if (nameArray.contains{
                    $0.0 == CSVCHandler.fullNameArray[i].0
                    }){
                    closestPrevIndex = nameArray.indexOf{$0.0 == CSVCHandler.fullNameArray[i].0}!
                    break
                }
                i -= 1
            }//for
            
            var results: [(String, String)] = []
            
            for i in 0...closestPrevIndex{
                    results.append(nameArray[i])
            }//for
            results.append(CSVCHandler.fullNameArray[fullSpellIndex])
            if (closestPrevIndex != nameArray.count - 1){
                for i in (closestPrevIndex + 1)..<nameArray.count{
                    results.append(nameArray[i])
                }//for
            }//if we have things after spells
            
            nameArray = results
            
        }//else if we can cast spells but only recently, restore spells to the name array (as close to its desired spot as possible)
        
        //If we don't have a background, don't allow traits view controller
        let myBG: Background? = pchar.background
        if (myBG == nil){
            
            let traitVCIndex: Int? = nameArray.indexOf{ $0.0 == "Traits" }//this is how we need to deal with operations on tuples in arrays, it seems
            if (traitVCIndex != nil){
                nameArray.removeAtIndex(traitVCIndex!)
                
                if (traitVCIndex! < nameArray.count - 1){
                    //move all higher indexes down one
                    for i in traitVCIndex! ..< nameArray.count - 1{
                        nameArray[i] = nameArray[i + 1]
                    }//for all
                
                    //remove the now-duplicate final array entry
                    nameArray.removeLast()
                }//if
                
            }//if
            
        }//if
        
        NSNotificationCenter.defaultCenter().postNotificationName(menuNavTableReloadNotificationKey, object: self)
        
    }//buildNameArrayFromPChar
    
    //MARK: UISplitViewDelegate
    
    func targetDisplayModeForActionInSplitViewController(svc: UISplitViewController) -> UISplitViewControllerDisplayMode {
        if (svc.displayMode == UISplitViewControllerDisplayMode.PrimaryOverlay){
            return .PrimaryHidden
        }
        else{
            return .PrimaryOverlay
        }
    }//targetDisplayModeForAction
    
    //MARK: UINavigationController Delegate
    
    /**
     Called when the navigation controller shows a viewcontroller.
     Use this to handle the array of VC's?
     */
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        
        vcArray = navigationController.viewControllers as! [CSViewController]
        
    }//didShowViewController
    
    /**
     Initializes the next view controller to be presented, or nil if we have no more to present.
     */
    func getNextVC(navigationController: UINavigationController, currentViewController: CSViewController)->CSViewController?{
        
        let currentIdentifier: String = currentViewController.restorationIdentifier!
        let currentIndex: Int = nameArray.indexOf{
            $0.1 == currentIdentifier
        }!//the index in our name array of where we're going
        
        if (currentIndex == nameArray.count - 1){
            return nil
        }//if we're at the end
        
        let nextIdentifier: String = nameArray[currentIndex + 1].1
        let nextVC: CSViewController = navigationController.storyboard?.instantiateViewControllerWithIdentifier(nextIdentifier) as! CSViewController
        
        nextVC.navigationItem.title = nameArray[currentIndex + 1].0
        
        return nextVC
        
    }//getNextVC
    
    /**
     returns the previous view controller, or nil if we're at the bottom of the stack
     */
    func getPrevVC(navigationController: UINavigationController, currentViewController: CSViewController)->CSViewController?{
        
        let currentIndex = vcArray.indexOf(currentViewController)!
        if (currentIndex == 0){
            return nil
        }
        else{
            let nameIndex: Int = nameArray.indexOf{$0.1 == currentViewController.restorationIdentifier}!
            let prevName: String = nameArray[nameIndex - 1].1
            var nextVC: CSViewController? = nil
            if (prevName != vcArray[currentIndex - 1].restorationIdentifier){
                nextVC = (navigationController.storyboard?.instantiateViewControllerWithIdentifier(prevName) as! CSViewController)
            }//if we're inserting a VC into the stack
            else{
                nextVC = vcArray[currentIndex - 1]
            }
            
            return nextVC!
        }
        
    }//getPrevVC
    
    func canGoNext(navigationController: UINavigationController, currentViewController: CSViewController)->Bool{
        let currentIdentifier: String = currentViewController.restorationIdentifier!
        let currentIndex: Int = nameArray.indexOf{
            $0.1 == currentIdentifier
            }!//the index in our name array of where we're going
        
        if (currentIndex == nameArray.count - 1){
            return false
        }//if we're at the end
        else{
            return true
        }
    }//canGoNext
    
    func canGoPrev(navigationController: UINavigationController, currentViewController: CSViewController)->Bool{
        let currentIndex = vcArray.indexOf(currentViewController)!
        if (currentIndex == 0){
            return false
        }
        else{
            return true
        }
    }//canGoPrev
    
    func getVCWithIdentifier(navigationController: UINavigationController, identifier: String, currentViewController: CSViewController)->CSViewController{
        for i in vcArray{
            if (i.restorationIdentifier == identifier){
                return i
            }//if
        }//for each
        
        let nextVC: CSViewController = navigationController.storyboard?.instantiateViewControllerWithIdentifier(identifier) as! CSViewController
        
        return nextVC
        
    }//getVCWithIdentifier
    
    func pushVCWithIdentifier(identifier: String){
        
        splitVC!.preferredDisplayMode = UISplitViewControllerDisplayMode.PrimaryHidden
        
        (splitVC!.viewControllers[1] as! CSNavigationController).navigateToIdentifier(identifier)
        
    }//pushVCWithIdentifier
    
    //MARK: TableView functions
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let identifier: String = nameArray[indexPath.row].1
        
        pushVCWithIdentifier(identifier)
    }//accessoryButtonTappedForRowWithIndexPath
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let identifier: String = nameArray[indexPath.row].1
        
        pushVCWithIdentifier(identifier)
    }//didSelectRowAtIndexPath
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }//numberOfSectionsInTableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }//numberOfRowsInSection
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("rootMenuCell")!
        
        cell.textLabel!.text = nameArray[indexPath.row].0
        
        return cell
    }//cellForRowAtIndexPath
    
}//CSVCHandler
