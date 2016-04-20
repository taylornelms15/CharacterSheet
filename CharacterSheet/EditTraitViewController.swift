//
//  EditTraitViewController.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 3/16/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit
import CoreData

class EditTraitViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate, UITextFieldDelegate{
    
    /*
        Convention: a trait without an id, even if it's been saved to the context, should not exist.
        Thus, in removing/changing canon things, make sure to delete the object if it has no id
    
        Other convention: the prevTrait is what the trait was when we came into this view
        The currTrait is the trait we are building/displaying
    */
    
    var prevTrait: Trait? = nil
    var currTrait: Trait? = nil
    var categoryName: String = ""
    var pickerData: [String] = []
    
    var traitPicker: UIPickerView = UIPickerView()
    var traitPickerToolbar: UIToolbar = UIToolbar();
    var traitDoneButton: UIBarButtonItem = UIBarButtonItem();
    var traitSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
    var traitCancelButton: UIBarButtonItem = UIBarButtonItem();
    
    //MARK: Outlets
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var traitPickerField: UITextField!
    
    //MARK: Actions
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return false
    }//textFieldShouldReturn
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n"){
            textView.resignFirstResponder()
            return false
        }
        return true
    }//textViewShouldChangeTextInRange
    
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        
        //we haven't fucked with core data at all, we can probably just abandon ship on a "cancel"
        
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
        
    }//cancelButtonPressed
    
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        
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
        
        //Deal with logical combinations of previous/current traits' existence
        /*The TraitList set functions will handle removal on the character end.
        We need to make/set our new trait,
        set it in the character's traitList,
        and then wipe the old one from existence if necessary
        */
        
        var newTrait: Trait? = nil
        let tEntity = NSEntityDescription.entityForName("Trait", inManagedObjectContext: context)!
        
        if (currTrait == nil || (currTrait != nil && currTrait!.canon == false)){
            
            newTrait = (NSManagedObject(entity: tEntity, insertIntoManagedObjectContext: context) as! Trait)
            
            newTrait!.name = nameTextField.text
            newTrait!.details = detailsTextView.text
            newTrait!.canon = false
            newTrait!.category = Trait.getCategoryNumFromName(categoryName)
            
            newTrait!.addToCoreData(intoContext: context)
            
            if (currTrait != nil){
                currTrait!.removeFromCoreData(fromContext: context)
            }
            
        }//if we're making a non-canon trait
        else{
            newTrait = currTrait
        }//else
        
        switch(Trait.getCategoryNumFromName(categoryName)){
        case 1:
            results[0].traitList.setPersTrait(newTrait!, replaceTrait: prevTrait)
        case 2:
            results[0].traitList.setIdeal(newTrait!)
        case 3:
            results[0].traitList.setBond(newTrait!)
        case 4:
            results[0].traitList.setFlaw(newTrait!)
        default:
            print("You broke it!")
        }
        
        if (prevTrait != nil && prevTrait!.canon == false){
            prevTrait?.removeFromCoreData(fromContext: context)
        }//prevTrait is non-canon
        
        do{
            try context.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
        
        
    }//doneButtonPressed
    
    func doneTraitPicker(sender: UIBarButtonItem){
        
        let nameChoice = pickerData[traitPicker.selectedRowInComponent(0)]
        
        if (traitPicker.selectedRowInComponent(0) == 0){
            
            self.currTrait = nil
            
        }//if editable
        else{
            setCurrTraitToCanonTrait(nameChoice)
        }
        
        updateTextFields(toTrait: currTrait)
        
        traitPickerField.resignFirstResponder()
        
    }//doneTraitPicker
    
    func cancelTraitPicker(sender: UIBarButtonItem){
        
        traitPickerField.resignFirstResponder()
        
    }//cancelTraitPicker
    
    //MARK: Viewcontroller navigation functions
    
    override func viewDidLoad(){
        super.viewDidLoad()

        detailsTextView.delegate = self
        nameTextField.delegate = self
        
        //featPicker things
        traitPicker.dataSource = self
        traitPicker.delegate = self
        
        traitPickerField.inputView = traitPicker
        traitPickerField.inputAccessoryView = traitPickerToolbar
        
        traitPickerToolbar.barStyle = UIBarStyle.Default
        traitPickerToolbar.sizeToFit()
        traitDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EditTraitViewController.doneTraitPicker(_:)))
        traitCancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EditTraitViewController.cancelTraitPicker(_:)))
        
        traitPickerToolbar.setItems([traitCancelButton, traitSpaceButton, traitDoneButton], animated: false)
        traitPickerToolbar.userInteractionEnabled = true
        
    }//viewDidLoad
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if(prevTrait != nil){
            currTrait = prevTrait
        }
        
        updatePickerData()
        updateTextFields(toTrait: currTrait)
        
        
    }
    
    //MARK: UIPickerViewDataSource/Delegate functions
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView,
        numberOfRowsInComponent component: Int) -> Int{
            
            return pickerData.count

    }//numberOfRowsInComponent
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerData[row]

    }//titleForRow

    
    //MARK: Helper functions
    
    /**
    Sets the current trait to the canonical trait picked in the picker
    - Parameter name: the name of the trait to be chosen
    */
    func setCurrTraitToCanonTrait(name: String){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        var fetchRequest = NSFetchRequest(entityName: "PCharacter");
        fetchRequest.predicate = NSPredicate(format: "id = %@", String(appDelegate.currentCharacterId));
        var results: [PCharacter] = [];
        do{
            results = try context.executeFetchRequest(fetchRequest) as! [PCharacter]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        results[0].updateAScores()
        //Note that now results[0] is our character
        
        fetchRequest = NSFetchRequest(entityName: "Trait");
        //Desired result: I want the trait with the right name, and I'm verifying the background is alright. So duplicate names are fine, but not within a background
        fetchRequest.predicate = NSPredicate(format: "name == %@ AND ANY inv_traitList.inv_background.id == %@", name, String(results[0].background!.id) )
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        var traitResults: [Trait] = []
        do{
            traitResults = try context.executeFetchRequest(fetchRequest) as! [Trait]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
        currTrait = traitResults[0]
        
    }//setCurrTraitToCanonTrait
    
    func updatePickerData(){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        var fetchRequest = NSFetchRequest(entityName: "PCharacter");
        fetchRequest.predicate = NSPredicate(format: "id = %@", String(appDelegate.currentCharacterId));
        var results: [PCharacter] = [];
        do{
            results = try context.executeFetchRequest(fetchRequest) as! [PCharacter]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        results[0].updateAScores()
        //Note that now results[0] is our character
        
        //build list of canonical traits
        
        fetchRequest = NSFetchRequest(entityName: "Trait");
        //Desired result: I want all traits where they have a trait list whose background matches the character's background, and category matches
        //Future expansion: block duplicate personality traits
        fetchRequest.predicate = NSPredicate(format: "category == %@ AND ANY inv_traitList.inv_background.id == %@", String(Trait.getCategoryNumFromName(categoryName)), String(results[0].background!.id) )
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        var traitResults: [Trait] = []
        do{
            traitResults = try context.executeFetchRequest(fetchRequest) as! [Trait]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
        var newPickerData: [String] = ["Custom Trait"]
        for traits in traitResults{
            newPickerData.append(traits.name!)
        }//for each trait

        pickerData = newPickerData
        
    }//updatePickerData
    
    /**
    This updates the text fields to reflect the current trait.
    It also handles any issues with the presence/absence of a previous or current trait
    */
    func updateTextFields(){
        
        categoryLabel.text = categoryName
        
        if (currTrait == nil){

                nameTextField.text = "Enter short name"
                detailsTextView.text = "Enter details of the trait."
                
                nameTextField.enabled = true
                detailsTextView.editable = true

        }//if no current trait, then make one
        else{
            nameTextField.text = currTrait!.name
            detailsTextView.text = currTrait!.details
            
            if (currTrait!.canon){
                nameTextField.enabled = false
                detailsTextView.editable = false
            }//if canon (non-editable) trait
            else{
                nameTextField.enabled = true
                detailsTextView.editable = true
            }//if editable trait
            
        }//set the text fields for the current trait
        
        if (currTrait != nil && currTrait!.canon){
            traitPickerField.text = currTrait!.name
            traitPicker.selectRow(pickerData.indexOf(currTrait!.name!)!, inComponent: 0, animated: false)
        }
        else if (currTrait != nil && !currTrait!.canon){
            traitPickerField.text = "Custom Trait"
            traitPicker.selectRow(0, inComponent: 0, animated: false)
        }
        
        if (pickerData.count > 0){
            traitPickerField.text = pickerData[traitPicker.selectedRowInComponent(0)]
        }

    }//updateTextFields
    
    func updateTextFields(toTrait trait: Trait?){
        
        categoryLabel.text = categoryName
        
        if(trait == nil){
            nameTextField.text = "Enter short name"
            detailsTextView.text = "Enter details of the trait."
            
            nameTextField.enabled = true
            detailsTextView.editable = true
            
            traitPickerField.text = "Custom Trait"
            traitPicker.selectRow(0, inComponent: 0, animated: false)
            
        }
        else{
            
            nameTextField.text = trait!.name
            detailsTextView.text = trait!.details
            
            nameTextField.enabled = !trait!.canon
            detailsTextView.editable = !trait!.canon
            
            if (trait!.canon){
                traitPickerField.text = trait!.name
                traitPicker.selectRow(pickerData.indexOf(trait!.name!)!, inComponent: 0, animated: false)
            }
            else{
                traitPickerField.text = "Custom Trait"
                traitPicker.selectRow(0, inComponent: 0, animated: false)
            }
            
        }//trait exists
        
        
    }//updateTextFieldstoTrait
    
}//EditTraitViewController