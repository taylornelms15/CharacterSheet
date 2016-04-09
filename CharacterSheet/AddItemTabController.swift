//
//  AddItemTabController.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 4/8/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit
import CoreData

/**
 This is the container view controller that holds all of the add item view controllers.
 Consists of a view that handles drawing the border around it all, and then a container view holding the tab view controller.
 */
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

/**
    This is the tab view controller for the add item controllers.
    Almost entirely unchanged; default tab functionality preserved.
 */
class AddItemTabController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preferredContentSize = CGSize(width: 300, height: 300)
        
        self.view.backgroundColor = UIColor.clearColor()
        
    }//viewDidLoad
    
}//AddItemTabController


/**
 All of the add item view controllers subclass from this class.
 It handles outlets, actions, and functions common to all three tabs of item view controllers.
 Namely, most delegate functions, the name and detail fields, and the add button, which exist in each.
 */
class AddItemParentController: UIViewController, UITextFieldDelegate, UITextViewDelegate{
    
    //MARK: item vars
    var name: String? = nil
    var details: String? = nil
    
    //MARK: Outlets
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var detailField: UITextView!
    
    var containerViewController: AddItemContainerViewController? = nil
    
    var currentTextField: UIView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()

        //center.addObserver(self, selector: #selector(AddItemParentController.keyboardOnScreen(_:)), name: UIKeyboardDidShowNotification, object: nil)
        center.addObserver(self, selector: #selector(AddItemParentController.keyboardChangeScreen(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        center.addObserver(self, selector: #selector(AddItemParentController.keyboardOffScreen(_:)), name: UIKeyboardDidHideNotification, object: nil)
        
        nameField.delegate = self
        detailField.delegate = self
        
    }//viewDidLoad
    
    //MARK: keyboard business
    /*
    func keyboardOnScreen(notification: NSNotification){
        let info: NSDictionary  = notification.userInfo!
        let kbHeight: CGFloat = (info.valueForKey(UIKeyboardFrameEndUserInfoKey)?.CGRectValue().size)!.height
        let borderView: UIView = containerViewController!.borderView
        let borderBottom: CGFloat = borderView.frame.origin.y + borderView.frame.height
        
        let heightDiff: CGFloat = borderBottom - (containerViewController!.view.frame.height - kbHeight)
        print(heightDiff)
        
        borderView.transform = CGAffineTransformMakeTranslation(0.0, -1 * heightDiff)
        
        
    }//keyboardOnScreen
    */
    func keyboardChangeScreen(notification: NSNotification){
        let info: NSDictionary  = notification.userInfo!
        let kbHeight: CGFloat = (info.valueForKey(UIKeyboardFrameEndUserInfoKey)?.CGRectValue().size)!.height
        let borderView: UIView = containerViewController!.borderView
        let borderBottom: CGFloat = borderView.frame.origin.y + borderView.frame.height
        
        let heightDiff: CGFloat = borderBottom - (containerViewController!.view.frame.height - kbHeight)
        print(heightDiff)
        
        borderView.transform = CGAffineTransformMakeTranslation(0.0, -1 * heightDiff)
        
    }//keyboardChangeScreen
    
    func keyboardOffScreen(notification: NSNotification){
        
        let borderView: UIView = containerViewController!.borderView
        
        borderView.transform = CGAffineTransformMakeTranslation(0.0, 0.0)

        
    }//keyboardOffScreen
    
    //MARK: Text Delegate Functions
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        return false
    }//textFieldShouldReturn
    
    
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
    }
    
    func textViewWillEndEditing(textView: UITextView) {
        resignFirstResponder()
        currentTextField = nil
    }//textViewWillEndEditing
    func textFieldWillEndEditing(textField: UITextField) {
        resignFirstResponder()
        currentTextField = nil
    }//textFieldWillEndEditing
    
}//AddItemParentController

class AddArmorViewController: AddItemParentController{
    
    //MARK: item vars
    var baseAC: Int? = nil
    var armorType: ArmorType? = nil
    
    //MARK: Outlets
    @IBOutlet weak var baseACField: UITextField!
    @IBOutlet weak var armorTypeField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseACField.delegate = self
        armorTypeField.delegate = self
        
    }//viewDidLoad
    
}//AddArmorViewController

class AddWeaponViewController: AddItemParentController{
    
    //MARK: item vars
    var damageDieNum: Int? = nil
    var damageDieType: Int? = nil
    var damageType: PhysicalDamageType? = nil
    var finesse: Bool = false
    
    //MARK: Outlets
    @IBOutlet weak var damageDieNumField: UITextField!
    @IBOutlet weak var damageDieTypeField: UITextField!
    @IBOutlet weak var damageTypeField: UITextField!
    @IBOutlet weak var finesseButton: UIButton!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        damageDieNumField.delegate = self
        damageDieTypeField.delegate = self
        damageTypeField.delegate = self
        
        setFinesseFalse()
        
    }//viewDidLoad
    
    
    //MARK: Finesse functions
    @IBAction func finesseButtonPressed(sender: UIButton) {
        if (finesse){
            setFinesseFalse()
        }//if turning finesse off
        else{
            setFinesseTrue()
        }//if turning finesse on
    }//finesseButtonPressed
    func setFinesseTrue(){
        finesse = true
        finesseButton.setTitle(CheckBox.Checked, forState: .Normal)
    }//setFinesseTrue
    func setFinesseFalse(){
        finesse = false
        finesseButton.setTitle(CheckBox.UnChecked, forState: .Normal)
    }//setFinesseFalse
    
}//AddWeaponViewController

class AddItemViewController: AddItemParentController{
    
    //MARK: Outlets
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        quantityField.delegate = self
        weightField.delegate = self
        
    }//viewDidLoad
    
}//AddItemViewController

