//
//  EditTraitViewController.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 3/16/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit
import CoreData

class EditTraitViewController: UIViewController{
    
    var prevTrait: Trait? = nil
    var categoryName: String = ""
    
    //MARK: Outlets
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    
    //MARK: Actions
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
        
    }//cancelButtonPressed
    
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
        
    }//doneButtonPressed
    
    //MARK: Viewcontroller navigation functions
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        updateTextFields()
        
    }
    
    //MARK: Helper functions
    
    func updateTextFields(){
        
        categoryLabel.text = categoryName
        if (prevTrait != nil){
            nameTextField.text = prevTrait!.name
            detailsTextView.text = prevTrait!.details
        }//if we have a trait
        else{
            nameTextField.text = "Enter short name"
            detailsTextView.text = "Enter details of the trait."
        }//for nil trait
        
    }
    
}//EditTraitViewController