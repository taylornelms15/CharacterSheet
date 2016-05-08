//
//  OtherNotesViewController.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 5/7/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit
import CoreData

class OtherNotesViewController: CSViewController, UITextViewDelegate{
    
    //MARK: Outlets
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var langTextView: UITextView!
    @IBOutlet weak var otherTextView: UITextView!
    
    @IBOutlet weak var otherNotesScrollView: UIScrollView!
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    
    var keyboardToolbar: UIToolbar = UIToolbar()
    var keyboardToolbarSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
    var keyboardToolbarDoneButton: UIBarButtonItem = UIBarButtonItem()
    
    var currentField: UITextView? = nil
    
    override func viewDidLoad() {
        
        descTextView.delegate = self
        langTextView.delegate = self
        otherTextView.delegate = self
        
        descTextView.layer.borderWidth = 1
        langTextView.layer.borderWidth = 1
        otherTextView.layer.borderWidth = 1
        
        keyboardToolbar.barStyle = .Default
        keyboardToolbar.sizeToFit()
        keyboardToolbarDoneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(self.doneButtonPressed(_:)))
        keyboardToolbar.items = [keyboardToolbarSpace, keyboardToolbarDoneButton]
        
        descTextView.inputAccessoryView = keyboardToolbar
        langTextView.inputAccessoryView = keyboardToolbar
        otherTextView.inputAccessoryView = keyboardToolbar
        
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        
        center.addObserver(self, selector: #selector(self.keyboardChangeScreen(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        center.addObserver(self, selector: #selector(self.keyboardOffScreen(_:)), name: UIKeyboardDidHideNotification, object: nil)
        
    }//viewDidLoad
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        updateFieldsFromModel()
    }//viewWillAppear
    
    //MARK: Model Editing
    
    func updateFieldsFromModel(){
        
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
        
        let notes: OtherNotesStrings = results[0].otherNotes
        
        if (notes.charDescription != nil){
            descTextView.text = notes.charDescription
        }//if
        else{
            descTextView.text = ""
        }//else
        
        if (notes.langDescription != nil){
            langTextView.text = notes.langDescription
        }//if
        else{
            langTextView.text = ""
        }//else
        
        if (notes.otherDescription != nil){
            otherTextView.text = notes.otherDescription
        }//if
        else{
            otherTextView.text = ""
        }//else
        
    }//updateFieldsFromModel
    
    func updateModelFromField(field: UITextView){
        
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
        
        switch (field){
        case descTextView:
            results[0].otherNotes.charDescription = descTextView.text
        case langTextView:
            results[0].otherNotes.langDescription = langTextView.text
        case otherTextView:
            results[0].otherNotes.otherDescription = otherTextView.text
        default:
            break
        }//switch
        
        do{
            try context.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }//updateModelFromField
    
    
    //MARK: UITextView Delegate Functions
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        
        currentField = textView
        
        return true
    }//shouldBeginEditing
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        
        currentField = nil
        
        return true
    }//shouldEndEditing
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        currentField = textView
        
    }//textviewDidBeginEditing
    
    func textViewDidEndEditing(textView: UITextView) {
        
        viewBottomConstraint.constant = 0//drop view below the keyboard
        
        self.resignFirstResponder()
        
        updateModelFromField(textView)
        
    }//textViewDidEndEditing
    
    func doneButtonPressed(sender: UIBarButtonItem){
        
        currentField?.endEditing(true)
        
    }//doneButtonPressed
    
    //MARK: keyboard things

    func keyboardChangeScreen(notification: NSNotification){
        let info: NSDictionary  = notification.userInfo!
        let kbHeight: CGFloat = (info.valueForKey(UIKeyboardFrameEndUserInfoKey)?.CGRectValue().size)!.height
        
        otherNotesScrollView.contentInset = UIEdgeInsetsMake(0, 0, kbHeight, 0)

        if (currentField != nil){
            let frame: CGRect = otherNotesScrollView.convertRect(currentField!.frame, fromView: currentField!)
            
            otherNotesScrollView.scrollRectToVisible(frame, animated: true)
        }//if we have a current field

        
    }//keyboardChangeScreen
    
    func keyboardOffScreen(notification: NSNotification){
        
        otherNotesScrollView.contentInset = UIEdgeInsetsZero
        
    }//keyboardOffScreen
    
    
}//OtherNotesViewController
