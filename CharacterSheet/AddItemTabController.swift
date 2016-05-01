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
    
    weak var parentVC: InventoryViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        borderView.layer.cornerRadius = 8.0
        borderView.layer.borderWidth = 3.0
        borderView.layer.borderColor = UIColor.darkGrayColor().CGColor
        
    }//viewDidLoad
    
    ///gives each child view controller a reference to this, the containing view controller
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
    
    static let detailPlaceholderString: String = "Press to edit details"
    
    //MARK: Outlets
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var detailField: UITextView!
    
    weak var containerViewController: AddItemContainerViewController? = nil
    
    var currentTextField: UIView? = nil
    
    //MARK: Actions
    
    /**
     When the user presses "add", the program checks if the item can be added (read: has all the necessary info), and if so, makes the 
     item to be added, and passes it back to the Inventory View Controller, which handles dismissing the add item VC's
     */
    @IBAction func addItemButtonPressed(sender: UIButton) {
     
        if (canAddItem() == false){
            //TODO: make alert saying they don't have enough information
            return;
        }//if
        
        let newItem: InventoryItem = makeInventoryItem()!
        self.containerViewController!.parentVC!.receiveCreatedItem(newItem)
        
    }//addItemButtonPressed
    
    /**
     When the user presses cancel, just dismiss this whole shebang
     */
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.containerViewController!.parentVC!.dismissViewControllerAnimated(true, completion: nil)
    }//cancelButtonPressed
    
    func makeInventoryItem()->InventoryItem?{
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let armorEntity = NSEntityDescription.entityForName("ArmorInventoryItem", inManagedObjectContext: context)!
        let weaponEntity = NSEntityDescription.entityForName("WeaponInventoryItem", inManagedObjectContext: context)!
        let itemEntity = NSEntityDescription.entityForName("InventoryItem", inManagedObjectContext: context)!
        
        //There was likely a better inheritance-related way to do this, but, eh...
        if (self.isMemberOfClass(AddArmorViewController)){
            let armorItem = NSManagedObject(entity: armorEntity, insertIntoManagedObjectContext: context) as! ArmorInventoryItem
            armorItem.setInfoWithCore((self as! AddArmorViewController).createItemCore())
            return armorItem
        }//if armor
        else if (self.isMemberOfClass(AddWeaponViewController)){
            let weaponItem = NSManagedObject(entity: weaponEntity, insertIntoManagedObjectContext: context) as! WeaponInventoryItem
            weaponItem.setInfoWithCore((self as! AddWeaponViewController).createItemCore())
            return weaponItem
        }//if weapon
        else if (self.isMemberOfClass(AddItemViewController)){
            let item = NSManagedObject(entity: itemEntity, insertIntoManagedObjectContext: context) as! InventoryItem
            item.setInfoWithCore((self as! AddItemViewController).createItemCore())
            return item
        }//if item
        
        
        return nil
    }//makeInventoryItem
    
    //MARK: viewcontroller navigation functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()

        //center.addObserver(self, selector: #selector(AddItemParentController.keyboardOnScreen(_:)), name: UIKeyboardDidShowNotification, object: nil)
        center.addObserver(self, selector: #selector(AddItemParentController.keyboardChangeScreen(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        center.addObserver(self, selector: #selector(AddItemParentController.keyboardOffScreen(_:)), name: UIKeyboardDidHideNotification, object: nil)
        
        nameField.delegate = self
        detailField.delegate = self
        detailField.text = AddItemParentController.detailPlaceholderString
        
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
        
        let heightDiff: CGFloat = borderBottom - (containerViewController!.view.frame.height - kbHeight)//how much to move the keyboard up
        
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
    }//textFieldShouldBeginEditing
    
    func textViewWillEndEditing(textView: UITextView) {
        resignFirstResponder()
        currentTextField = nil
    }//textViewWillEndEditing
    func textFieldWillEndEditing(textField: UITextField) {
        resignFirstResponder()
        currentTextField = nil
    }//textFieldWillEndEditing
    
    /**
     Tests whether the necessary conditions for adding an item have been met.
     Subclasses implement this more directly
     Requires an entry in the name field, but not the details field
     */
    func canAddItem()->Bool{
        if (nameField.text == nil){
            return false
        }
        else{
            return true
        }
    }//canAddItem
    
    func getName()->String?{
        return nameField.text
    }
    
    /**
     Gives the value in the details text field.
     Returns nil if the default details have not been changed.
     Technically, this means you can't have the string "Press to edit details" as your item details. Sorry.
     */
    func getDetails()->String?{
        if (detailField.text == AddItemParentController.detailPlaceholderString){
            return nil
        }
        else{
            return detailField.text
        }
    }
    
}//AddItemParentController

class AddArmorViewController: AddItemParentController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    //MARK: item vars
    var baseAC: Int? = nil
    var armorType: ArmorType? = nil
    
    let armorTypePicker: UIPickerView = UIPickerView()
    let armorTypePickerToolbar: UIToolbar = UIToolbar()
    var armorTypePickerDoneButton: UIBarButtonItem? = nil
    let pickerSpaceButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
    let armorPickerTitles: [String] = ["Light Armor", "Medium Armor", "Heavy Armor", "Shield", "Other"]
    let armorTypeStringDict: [String: ArmorType] = ["Light Armor" : ArmorType.Light, "Medium Armor" : ArmorType.Medium, "Heavy Armor" : ArmorType.Heavy, "Shield" : ArmorType.Shield, "Other" : ArmorType.Other]
    
    //MARK: Outlets
    @IBOutlet weak var baseACField: UITextField!
    @IBOutlet weak var armorTypeField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseACField.delegate = self
        armorTypeField.delegate = self
        
        armorTypeField.inputView = armorTypePicker
        armorTypeField.inputAccessoryView = armorTypePickerToolbar
        armorTypePicker.delegate = self
        armorTypePicker.dataSource = self
        
        armorTypePickerToolbar.barStyle = UIBarStyle.Default
        armorTypePickerToolbar.sizeToFit()
        armorTypePickerDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddArmorViewController.donePicker(_:)))
        armorTypePickerToolbar.setItems([pickerSpaceButton, armorTypePickerDoneButton!], animated: false)
        armorTypePickerToolbar.userInteractionEnabled = true
        
    }//viewDidLoad
    
    //MARK: item creation functions
    
    func getBaseAC()->Int?{
        if (baseACField.text == nil){
            return nil
        }//if
        let ac: Int? = Int(baseACField.text!)
        return ac
    }//getBaseAC
    func getArmorType()->ArmorType?{
        if (armorTypeField.text == nil){
            return nil
        }//if
        return armorTypeStringDict[armorTypeField.text!]
    }//getArmorType
    
    override func canAddItem()->Bool{
        if (!super.canAddItem()){
            return false
        }//if
        if (getBaseAC() == nil || getArmorType() == nil){
            return false
        }//if
        else{
            return true
        }//else
    }//canAddItem
    
    func createItemCore()->ArmorInventoryItemCore{
        var core: ArmorInventoryItemCore = ArmorInventoryItemCore()
        core.name = getName()!
        if (getDetails() == nil){
            core.details = ""
        }
        else{
            core.details = getDetails()!
        }
        core.baseAC = Int16(getBaseAC()!)
        core.armorType = getArmorType()!
        
        return core
    }//createItemCore
    
    //MARK: Picker Functions
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if (pickerView == armorTypePicker){return 1}
        else {
            return 0
        }
    }//numberOfComponentsInPickerView
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == armorTypePicker){return armorPickerTitles.count}
        else{
            return 0
        }
    }//numberOfRowsInComponent
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == armorTypePicker){
            return armorPickerTitles[row]
        }
        else{
            return nil
        }
    }//titleForRowInPicker
    
    func donePicker(sender: UIBarButtonItem){
        
        if (sender == armorTypePickerDoneButton){
            let armorString: String = armorPickerTitles[armorTypePicker.selectedRowInComponent(0)]
            armorTypeField.text = armorString
            
            armorTypeField.endEditing(true)
        }//if
        
    }//donePicker
    
}//AddArmorViewController

class AddWeaponViewController: AddItemParentController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    //MARK: item vars
    var damageDieNum: Int? = nil
    var damageDieType: Int? = nil
    var damageType: PhysicalDamageType? = nil
    var finesse: Bool = false
    
    let damageTypePicker: UIPickerView = UIPickerView()
    let damageTypePickerToolbar: UIToolbar = UIToolbar()
    var damageTypePickerDoneButton: UIBarButtonItem? = nil
    let pickerSpaceButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
    let damagePickerTitles: [String] = ["Bludgeoning", "Piercing", "Slashing", "Other"]
    let damageTypeStringDict: [String: PhysicalDamageType] = ["Bludgeoning" : PhysicalDamageType.Bludgeoning, "Piercing" : PhysicalDamageType.Piercing, "Slashing" : PhysicalDamageType.Slashing, "Other" : PhysicalDamageType.Other]
    
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
        
        damageTypeField.inputView = damageTypePicker
        damageTypeField.inputAccessoryView = damageTypePickerToolbar
        damageTypePicker.delegate = self
        damageTypePicker.dataSource = self
        
        damageTypePickerToolbar.barStyle = UIBarStyle.Default
        damageTypePickerToolbar.sizeToFit()
        damageTypePickerDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddWeaponViewController.donePicker(_:)))
        damageTypePickerToolbar.setItems([pickerSpaceButton, damageTypePickerDoneButton!], animated: false)
        damageTypePickerToolbar.userInteractionEnabled = true
        
        setFinesseFalse()
        
    }//viewDidLoad
    
    func getDamageDice() -> (Int, Int)?{
        if (damageDieNumField.text == nil || damageDieTypeField.text == nil){
            return nil
        }//if
        let a: Int? = Int(damageDieNumField.text!)
        let b: Int? = Int(damageDieTypeField.text!)
        
        if (a == nil || b == nil){
            return nil
        }
        else{
            return (a!, b!)
        }
    }//getDamageDice
    
    func getDamageType()->PhysicalDamageType?{
        if (damageTypeField.text == nil){
            return nil
        }//if
        else{
            return damageTypeStringDict[damageTypeField.text!]
        }//else
    }//getDamageType
    
    override func canAddItem() -> Bool {
        if (super.canAddItem() == false){
            return false
        }//if
        if (getDamageDice() == nil || getDamageType() == nil){
            return false
        }
        return true
    }//canAddItem
    
    func createItemCore()->WeaponInventoryItemCore{
        var core = WeaponInventoryItemCore()
        core.name = getName()!
        if (getDetails() == nil){
            core.details = ""
        }
        else{
            core.details = getDetails()!
        }
        let damageDice: (Int, Int) = getDamageDice()!
        core.damageDice = (Int16(damageDice.0), Int16(damageDice.1))
        core.damageType = getDamageType()!
        core.finesse = finesse
        
        return core
    }//createItemCore
    
    //MARK: Picker Functions
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if (pickerView == damageTypePicker){return 1}
        else {
            return 0
        }
    }//numberOfComponentsInPickerView
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == damageTypePicker){return damagePickerTitles.count}
        else{
            return 0
        }
    }//numberOfRowsInComponent
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == damageTypePicker){
            return damagePickerTitles[row]
        }
        else{
            return nil
        }
    }//titleForRowInPicker
    
    func donePicker(sender: UIBarButtonItem){
        
        if (sender == damageTypePickerDoneButton){
            let damageString: String = damagePickerTitles[damageTypePicker.selectedRowInComponent(0)]
            damageTypeField.text = damageString
            
            damageTypeField.endEditing(true)
        }//if
        
    }//donePicker
    
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
    
    func getWeight()->Double?{
        if (weightField.text == nil){
            return nil
        }//if
        let weightString: String = weightField.text!
        return Double(weightString)
    }//getWeight
    
    func getQuantity()->Double?{
        if (quantityField.text == nil){
            return nil
        }//if
        let quantityString: String = quantityField.text!
        return Double(quantityString)
    }//getQuantity
    
    override func canAddItem() -> Bool {
        if (super.canAddItem() == false){
            return false
        }//if
        //Note: accepting blank quantity and weight fields
        return true
    }//canAddItem
    
    func createItemCore()->InventoryItemCore{
        var core = InventoryItemCore()
        core.name = getName()!
        if (getDetails() == nil){
            core.details = ""
        }
        else{
            core.details = getDetails()!
        }
        if (getWeight() == nil){
            core.weight = -1
        }
        else{
            core.weight = getWeight()!
        }
        if (getQuantity() == nil){
            core.quantity = 1
        }
        else{
            core.quantity = getQuantity()!
        }
        
        return core
    }//createItemCore
    
}//AddItemViewController

