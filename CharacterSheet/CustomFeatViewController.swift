//
//  CustomFeatViewController.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 4/30/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit
import CoreData

class CustomFeatViewController: CSViewController, UITextViewDelegate, UITextFieldDelegate{
    
    //MARK: Variables
    
    var featureList: FeatureList? = nil
    var featArray: [Feat] = []
    
    var currentTextField: UIView? = nil
    
    //MARK: Outlets
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var detailField: UITextView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    //MARK: Actions
    
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        if (nameField.text == nil || nameField.text == "" || detailField.text == nil || detailField.text == "" || detailField.text == "Press to edit details"){
            return
        }//enforce meaningful data in the fields!
        
        let newFeat: Feat = makeNewFeature(featureList!.managedObjectContext!)
        
        featureList!.addFeature(newFeat)
        featArray.append(newFeat)
        
        do{
            try featureList!.managedObjectContext!.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }//doneButtonPressed
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }//cancelButtonPressed
    
    //MARK: Viewcontroller Navigation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
        detailField.delegate = self
        
    }//viewDidLoad
    
    //MARK: feature creation
    
    func makeNewFeature(context: NSManagedObjectContext) -> Feat{
        
        let featEntity = NSEntityDescription.entityForName("Feat", inManagedObjectContext: context)!
        
        let myFeat: Feat = NSManagedObject(entity: featEntity, insertIntoManagedObjectContext: context) as! Feat
        
        myFeat.name = nameField.text!
        myFeat.details = detailField.text!
        
        myFeat.canon = false
        
        let fetchRequest = NSFetchRequest(entityName: "Feat")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        var results: [Feat] = []
        do{
            try results = context.executeFetchRequest(fetchRequest) as! [Feat]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }//results[0] has the feat with the highest id
        
        let highestID: Int64 = results[0].id
        
        myFeat.id = highestID + 1
        
        return myFeat
        
    }//makeNewFeature
    
    //MARK: Text Delegate things
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        return false
    }//textFieldShouldReturn
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n"){
            textView.endEditing(true)
            return false
        }
        else{
            return true
        }
    }//shouldChangeTextInRange
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if (currentTextField != nil){
            if (currentTextField!.isKindOfClass(UITextField)){
                (currentTextField as! UITextField).endEditing(true)
            }
            else{ if (currentTextField!.isKindOfClass(UITextView)){
                (currentTextField as! UITextView).endEditing(true)
                }}
        }
        currentTextField = textView
        
        return true
    }//textViewShouldBeginEditing
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if (currentTextField != nil){
            if (currentTextField!.isKindOfClass(UITextField)){
                (currentTextField as! UITextField).endEditing(true)
            }
            else {if (currentTextField!.isKindOfClass(UITextView)){
                (currentTextField as! UITextView).endEditing(true)
                }}
        }
        currentTextField = textField
        
        return true
    }//textFieldShouldBeginEditing
    
    func textViewWillEndEditing(textView: UITextView) {
        resignFirstResponder()
        currentTextField = nil
    }//textViewWillEndEditing
    func textFieldWillEndEditing(textField: UITextField) {
        resignFirstResponder()
        currentTextField = nil
    }//textFieldWillEndEditing
    
    
    
}//CustomFeatViewController