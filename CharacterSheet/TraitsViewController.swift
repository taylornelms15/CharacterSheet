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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        let thisSender: UIButton = sender! as! UIButton
        var destController: EditTraitViewController = segue.destinationViewController as! EditTraitViewController
        
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
        
    }//viewDidAppear
 
    //MARK: Helper functions
    
    func updateTextsOfViews(){
        
        setTextOfView(persTrait1TextView, fromTrait: persTrait1)
        setTextOfView(persTrait2TextView, fromTrait: persTrait2)
        setTextOfView(idealTextView, fromTrait: idealTrait)
        setTextOfView(bondTextView, fromTrait: bondTrait)
        setTextOfView(flawTextView, fromTrait: flawTrait)
        
    }//updateTextsOfViews
    
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