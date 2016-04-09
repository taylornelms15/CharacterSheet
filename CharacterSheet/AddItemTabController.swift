//
//  AddItemTabController.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 4/8/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit
import CoreData

class AddItemTabController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preferredContentSize = CGSize(width: 300, height: 300)
        
        self.view.backgroundColor = UIColor.clearColor()
        
    }//viewDidLoad
    
}//AddItemTabController

class AddItemParentController: UIViewController, UITextFieldDelegate, UITextViewDelegate{
    
    @IBOutlet weak var addButton: UIButton!
    
    var containerViewController: UIViewController? = nil
    
    override func viewDidLoad() {

    }//viewDidLoad
    
    //MARK: Text Delegate Functions
    
    func textViewDidEndEditing(textView: UITextView) {
        resignFirstResponder()
    }//textViewDidEndEditing
    func textFieldDidEndEditing(textField: UITextField) {
        resignFirstResponder()
    }//textFieldDidEndEditing
    
}//AddItemParentController

class AddArmorViewController: AddItemParentController{
    
}//AddArmorViewController

class AddWeaponViewController: AddItemParentController{
    
}//AddWeaponViewController

class AddItemViewController: AddItemParentController{
    
}//AddItemViewController

class AddItemContainerViewController: UIViewController{
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var borderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        borderView.layer.cornerRadius = 8.0
        borderView.layer.borderWidth = 3.0
        borderView.layer.borderColor = UIColor.darkGrayColor().CGColor
        
    }//viewDidLoad
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "addItemEmbedSegue"){
            let tabVC: UITabBarController = segue.destinationViewController as! UITabBarController
            
            for a in tabVC.viewControllers!{
                let b: AddItemParentController = a as! AddItemParentController
                b.containerViewController = self
            }//for each tab
        }
    }
    
}//AddItemContainerViewController