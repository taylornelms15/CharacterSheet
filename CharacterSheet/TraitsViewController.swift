//
//  TraitsViewController.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 3/13/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit
import CoreData

class TraitsViewController: CSViewController, UIScrollViewDelegate{
    
    var persTrait1: Trait? = nil
    var persTrait2: Trait? = nil
    var idealTrait: Trait? = nil
    var bondTrait: Trait? = nil
    var flawTrait: Trait? = nil
    var traitToEdit: Trait? = nil
    
    //MARK: Outlets
    @IBOutlet weak var persTrait1TextView: UITextView!
    @IBOutlet weak var persTrait2TextView: UITextView!
    @IBOutlet weak var idealTextView: UITextView!
    @IBOutlet weak var bondTextView: UITextView!
    @IBOutlet weak var flawTextView: UITextView!
    @IBOutlet weak var persTrait1EditButton: UIButton!
    @IBOutlet weak var persTrait2EditButton: UIButton!
    @IBOutlet weak var idealEditButton: UIButton!
    @IBOutlet weak var bondEditButton: UIButton!
    @IBOutlet weak var flawEditButton: UIButton!
    
    //MARK: Segue handling
    
    @IBAction func makeSegueToEditTraits(sender: UIButton) {
    
        self.performSegueWithIdentifier("editTraitSegue", sender: sender)
    
    }//makeSegueToEditTraits
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        //If we're not segue-ing to the edit page, don't do bad things
        if (sender!.isKindOfClass(UISwipeGestureRecognizer) || sender!.isKindOfClass(UIBarButtonItem)){
            return
        }
        
        let thisSender: UIButton = sender! as! UIButton
        let destController: EditTraitViewController = segue.destinationViewController as! EditTraitViewController
        
        switch (thisSender){
        case persTrait1EditButton:
            destController.categoryName = "Personality Trait 1"
            destController.prevTrait = persTrait1
            break
        case persTrait2EditButton:
            destController.categoryName = "Personality Trait 2"
            destController.prevTrait = persTrait2
            break
        case idealEditButton:
            destController.categoryName = "Ideal"
            destController.prevTrait = idealTrait
            break
        case bondEditButton:
            destController.categoryName = "Bond"
            destController.prevTrait = bondTrait
            break
        case flawEditButton:
            destController.categoryName = "Flaw"
            destController.prevTrait = flawTrait
            break
        default:
            break
        }//switch
        

        
    }//prepareForSegue

    
    
    //MARK: Viewcontroller navigation functions
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        updateTextsOfViews()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
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

        
        
    }//viewDidAppear
 
    //MARK: Helper functions
    
    func updateTextsOfViews(){
        
        updateCharacterTraits()
        
        setTextOfView(persTrait1TextView, fromTrait: persTrait1)
        setTextOfView(persTrait2TextView, fromTrait: persTrait2)
        setTextOfView(idealTextView, fromTrait: idealTrait)
        setTextOfView(bondTextView, fromTrait: bondTrait)
        setTextOfView(flawTextView, fromTrait: flawTrait)
        
    }//updateTextsOfViews

    
    func updateCharacterTraits(){
        
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
        
        var onePersTraitSet: Bool = false
        var removing: Bool = false
        
        for trait in results[0].traitList.traits{
            
            //Remove canonical traits not associated with the right background
            if (trait.canon == true && results[0].background!.traitList!.traits.contains(trait) == false){
                
                results[0].traitList.traits.remove(trait)
                
                do{
                    try context.save()
                }catch let error as NSError{
                    print("Could not save \(error), \(error.userInfo)")
                }
                
                removing = true
                
            }//if it doesn't c
            else{
                removing = false
            }
            
            
            if (trait.category == 1 && onePersTraitSet == true){
                persTrait2 = trait
                if(removing){persTrait2 = nil}
            }
            if (trait.category == 1 && onePersTraitSet == false){
                persTrait1 = trait
                onePersTraitSet = true
                if(removing){persTrait1 = nil}
            }
            if (trait.category == 2){
                idealTrait = trait
                if(removing){idealTrait = nil}
            }
            if (trait.category == 3){
                bondTrait = trait
                if(removing){bondTrait = nil}
            }
            if (trait.category == 4){
                flawTrait = trait
                if(removing){flawTrait = nil}
            }
            
            
        }//for trait
        
    }//updateCharacterTraits
    
    
    private func setTextOfView(textView: UITextView, fromTrait trait: Trait?){
        var results: String = ""
        if (trait != nil){
            results = trait!.name! + ":\n" + trait!.details!;
        }
        else{
            results = "Press edit button to modify"
        }
        textView.text = results
    }//setTextOfView

    
}//TraitsViewController