//
//  InventoryTableCells.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 4/7/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit
import CoreData

protocol InventoryTableCell{
    
    weak var nameField: UITextField! {get set}
    weak var detailField: UITextField! {get set}
    
    weak var inventoryItem: InventoryItem? {get set}
    weak var parentTableView: UITableView? {get set}
    
    func setInfoWithItem(item item: InventoryItem)->Void
    func setDelegateHandlers()->Void
    
}//InventoryTableCell

class InventoryTableHeader: UITableViewCell{
    
    func setLabelsWithInventory(inventory: Inventory){}
    
}//InventoryTableHeader

class ArmorHeader: InventoryTableHeader{
    
    //MARK: Outlets
    @IBOutlet weak var acValueLabel: UILabel!
    @IBOutlet weak var acLabelLabel: UILabel!
    
    override func setLabelsWithInventory(inventory: Inventory){
        
        acValueLabel.text = String(inventory.computeArmorClass())
        
    }//setACLabels
    
}//ArmorHeader

class WeaponHeader: InventoryTableHeader{
    
    //MARK: Outlets
    @IBOutlet weak var meleeBonusLabel: UILabel!
    @IBOutlet weak var rangedBonusLabel: UILabel!
    
    override func setLabelsWithInventory(inventory: Inventory) {
        
        let meleeBonus: Int = Int(inventory.computeMeleeBonus())
        let rangedBonus: Int = Int(inventory.computeRangedBonus())
        
        var meleeString: String = ""
        var rangedString: String = ""
        
        if (meleeBonus >= 0){
            meleeString = "+\(meleeBonus)"
        }
        else{
            meleeString = "\(meleeBonus)"
        }
        
        if (rangedBonus >= 0){
            rangedString = "+\(rangedBonus)"
        }
        else{
            rangedString = "\(rangedBonus)"
        }
        
        meleeBonusLabel.text = meleeString
        rangedBonusLabel.text = rangedString
        
    }//setLabelsWithInventory
    
    
}//WeaponHeader

class ItemHeader: InventoryTableHeader{
    
    //MARK: Outlets
    @IBOutlet weak var weightLabel: UILabel!
    
    override func setLabelsWithInventory(inventory: Inventory) {
        let weight: Double = inventory.computePackWeight()
        let weightString: String = roundWeight(weight)
        
        weightLabel.text = weightString
        
    }//setLabelsWithInventory
    
    func roundWeight(weight: Double)->String{
        
        if (abs(weight - round(weight)) < 0.0000001){
            return String(Int(round(weight)))
        }//if essentially a whole number
        else{
            return String(format: "%0.2f", weight)
        }//if given a decimal quantity
        
    }//setQuantityText
    
}//ItemHeader

class ArmorTableCell: UITableViewCell, InventoryTableCell, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var currentTextField: UIView? = nil
    
    //MARK: view/field things
    var armorTypePicker: UIPickerView = UIPickerView()
    let armorTypePickerToolbar: UIToolbar = UIToolbar()
    var armorTypePickerDoneButton: UIBarButtonItem? = nil
    let pickerSpaceButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
    let armorTypePickerTitles: [String] = ["Light Armor", "Medium Armor", "Heavy Armor", "Shield", "Other"]
    let armorTypeStringDict: [String: ArmorType] = ["Light Armor": ArmorType.Light, "Medium Armor": ArmorType.Medium, "Heavy Armor": ArmorType.Heavy, "Shield": ArmorType.Shield, "Other": ArmorType.Other]
    
    //MARK: Outlets
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var detailField: UITextField!
    @IBOutlet weak var baseACField: UITextField!
    @IBOutlet weak var armorTypeField: UITextField!
    @IBOutlet weak var equipButton: UIButton!
    
    weak var inventoryItem: InventoryItem?
    weak var parentTableView: UITableView?
    
    func setDelegateHandlers(){
        nameField.delegate = self
        detailField.delegate = self
        baseACField.delegate = self
        armorTypeField.inputView = armorTypePicker
        armorTypeField.inputAccessoryView = armorTypePickerToolbar
        armorTypePicker.dataSource = self
        armorTypePicker.delegate = self
        
        armorTypePickerToolbar.barStyle = UIBarStyle.Default
        armorTypePickerToolbar.sizeToFit()
        armorTypePickerDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.donePicker(_:)))
        armorTypePickerToolbar.setItems([pickerSpaceButton, armorTypePickerDoneButton!], animated: false)
        armorTypePickerToolbar.userInteractionEnabled = true
        
        
    }//setDelegateHandlers
    
    /**
     This sets the content of the cell, based on an item
    */
    func setInfoWithItem(item item: InventoryItem) {
        let armorItem: ArmorInventoryItem = item as! ArmorInventoryItem
        
        nameField.text = armorItem.name
        detailField.text = armorItem.details
        baseACField.text = String(armorItem.baseAC)
        armorTypeField.text = String(armorItem.armorType)
        setEquippedButtonText(equipped: armorItem.equipped)
        
        inventoryItem = item
        
    }//setInfoWithItem
    
    func setEquippedButtonText(equipped equipped: Bool){
        if (equipped){
            equipButton.setTitle(CheckBox.Checked, forState: .Normal)
        }
        else{
            equipButton.setTitle(CheckBox.UnChecked, forState: .Normal)
        }
    }//setEquippedButtonText
    
    @IBAction func equippedButtonPressed(sender: UIButton) {
        
        let myArmorItem: ArmorInventoryItem = inventoryItem! as! ArmorInventoryItem
        
        //make the inventory toggle the equipped parameter
        myArmorItem.inv_inventory_a!.setArmorEquipped(myArmorItem, equipped: !(myArmorItem.equipped))
        
        setEquippedButtonText(equipped: myArmorItem.equipped)
        
        parentTableView!.reloadData()
        
    }//equippedButtonPressed
    
    //MARK: TextField functions
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        resignFirstResponder()
        
        let myArmor: ArmorInventoryItem = inventoryItem as! ArmorInventoryItem
        let inv: Inventory = myArmor.inv_inventory_a!
        
        switch textField{
        case nameField:
            inv.changeName(myArmor, newName: textField.text!)
            parentTableView!.reloadData()
            return
        case detailField:
            inv.changeDetails(myArmor, newDetails: textField.text!)
            parentTableView!.reloadData()
            return
        case baseACField:
            inv.changeArmorBaseAC(myArmor, newBaseAC: Int(textField.text!)!)
            parentTableView!.reloadData()
            return
        default:
            return
        }//switch
        
        
    }//textFieldDidEndEditing
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        return false
    }//textFieldShouldReturn
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if (textField == baseACField){
            let text = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            
            if (text == ""){
                return true
            }//allow empty string
            
            if (Int(text) == nil){
                return false
            }//if the new value wouldn't be an int
            else{
                return true
            }//if we're still talking numerically
        }//if baseAC field (restrict to numbers)

        return true
    }//shouldChangeCharactersInRange
    
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
    /*
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        currentTextField = nil
        resignFirstResponder()
        return true
    }//textFieldShouldEndEditing
*/
    
    //MARK: Picker Functions
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if (pickerView == armorTypePicker){return 1}
        else {
            return 0
        }
    }//numberOfComponentsInPickerView
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == armorTypePicker){return armorTypePickerTitles.count}
        else{
            return 0
        }
    }//numberOfRowsInComponent
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == armorTypePicker){
            return armorTypePickerTitles[row]
        }
        else{
            return nil
        }
    }//titleForRowInPicker
    
    func donePicker(sender: UIBarButtonItem){
        
        if (sender == armorTypePickerDoneButton){
            let armorString: String = armorTypePickerTitles[armorTypePicker.selectedRowInComponent(0)]
            let newType: ArmorType = armorTypeStringDict[armorString]!
            armorTypeField.text = String(newType)
            
            let inv: Inventory = (inventoryItem! as! ArmorInventoryItem).inv_inventory_a!
            inv.changeArmorItemType((inventoryItem! as! ArmorInventoryItem), newType: newType)
            
            armorTypeField.endEditing(true)
            
            parentTableView!.reloadData()
            
        }//if
        
    }//donePicker
    
    
}//ArmorTableCell

class WeaponTableCell: UITableViewCell, InventoryTableCell, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var currentTextField: UIView? = nil
    
    //MARK: view/field things
    var damageTypePicker: UIPickerView = UIPickerView()
    let damageTypePickerToolbar: UIToolbar = UIToolbar()
    var damageTypePickerDoneButton: UIBarButtonItem? = nil
    let pickerSpaceButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
    let damageTypePickerTitles: [String] = ["Bludgeoning", "Piercing", "Slashing", "Other"]
    let damageTypeStringDict: [String: PhysicalDamageType] = ["Bludgeoning": PhysicalDamageType.Bludgeoning, "Piercing": PhysicalDamageType.Piercing, "Slashing": PhysicalDamageType.Slashing, "Other": PhysicalDamageType.Other]
    
    //MARK: Outlets
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var detailField: UITextField!
    @IBOutlet weak var damageDieNumField: UITextField!
    @IBOutlet weak var damageDieTypeField: UITextField!
    @IBOutlet weak var damageTypeField: UITextField!
    @IBOutlet weak var finessebutton: UIButton!
    @IBOutlet weak var equipButton: UIButton!
    
    weak var inventoryItem: InventoryItem?
    weak var parentTableView: UITableView?
    
    func setDelegateHandlers() {
        nameField.delegate = self
        detailField.delegate = self
        damageDieNumField.delegate = self
        damageDieTypeField.delegate = self
        damageTypeField.inputView = damageTypePicker
        damageTypeField.inputAccessoryView = damageTypePickerToolbar
        damageTypePicker.dataSource = self
        damageTypePicker.delegate = self
        
        damageTypePickerToolbar.barStyle = UIBarStyle.Default
        damageTypePickerToolbar.sizeToFit()
        damageTypePickerDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.donePicker(_:)))
        damageTypePickerToolbar.setItems([pickerSpaceButton, damageTypePickerDoneButton!], animated: false)
        damageTypePickerToolbar.userInteractionEnabled = true
        
    }//setDelegateHandlers
    
    func setInfoWithItem(item item: InventoryItem) {
        let weaponItem: WeaponInventoryItem = item as! WeaponInventoryItem
        
        nameField.text = weaponItem.name
        detailField.text = weaponItem.details
        damageDieNumField.text = String(weaponItem.damageDice.0)
        damageDieTypeField.text = String(weaponItem.damageDice.1)
        setFinesseButtonText(finesse: weaponItem.finesse)
        setEquippedButtonText(equipped: weaponItem.equipped)
        damageTypeField.text = String(weaponItem.damageType)
        
        inventoryItem = item
        
    }//setInfoWithItem
    
    //MARK: equip/finesse functions
    
    func setFinesseButtonText(finesse finesse: Bool){
        if (finesse){
            finessebutton.setTitle(CheckBox.Checked, forState: .Normal)
        }
        else{
            finessebutton.setTitle(CheckBox.UnChecked, forState: .Normal)
        }
    }//setFinesseButtonText
    
    func setEquippedButtonText(equipped equipped: Bool){
        if (equipped){
            equipButton.setTitle(CheckBox.Checked, forState: .Normal)
        }
        else{
            equipButton.setTitle(CheckBox.UnChecked, forState: .Normal)
        }
    }//setEquippedButtonText
    
    @IBAction func finesseButtonPressed(sender: UIButton) {
        
        let myWeapon: WeaponInventoryItem = inventoryItem! as! WeaponInventoryItem
        
        if (myWeapon.finesse == true){
            setFinesseButtonText(finesse: false)
            
            myWeapon.finesse = false
        }//if un-finessing
        else{
            setFinesseButtonText(finesse: true)
            
            myWeapon.finesse = true
        }//if finesseing
        
        do{
            let context = myWeapon.managedObjectContext!
            try context.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    
    }//finesseButtonPressed
    
    @IBAction func equippedButtonPressed(sender: UIButton) {
    
        let myWeapon: WeaponInventoryItem = inventoryItem! as! WeaponInventoryItem
        
        if (myWeapon.equipped == true){
            setEquippedButtonText(equipped: false)
            
            myWeapon.equipped = false
        }//if un-equipping
        else{
            setEquippedButtonText(equipped: true)
            
            myWeapon.equipped = true
        }//if equipping
        
        do{
            let context = myWeapon.managedObjectContext!
            try context.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }//equippedButtonPressed
    
    //MARK: textfield functions
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        resignFirstResponder()
        
        let myWeapon: WeaponInventoryItem = inventoryItem as! WeaponInventoryItem
        let inv: Inventory = myWeapon.inv_inventory_w!
        
        switch textField{
        case nameField:
            inv.changeName(myWeapon, newName: textField.text!)
            parentTableView!.reloadData()
            return
        case detailField:
            inv.changeDetails(myWeapon, newDetails: textField.text!)
            parentTableView!.reloadData()
            return
        case damageDieNumField:
            inv.changeWeaponDamageDice(myWeapon, newDamageDice: (Int(textField.text!), nil))
            parentTableView!.reloadData()
            return
        case damageDieTypeField:
            inv.changeWeaponDamageDice(myWeapon, newDamageDice: (nil, Int(textField.text!)))
            parentTableView!.reloadData()
            return
        default:
            return
        }//switch
        
        
    }//textFieldDidEndEditing
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        return false
    }//textFieldShouldReturn
    
    ///Used for restricting to numerical inputs
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if ([damageDieNumField, damageDieTypeField].contains(textField)){
            let text = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            
            if (text == ""){
                return true
            }//allow empty string
            
            if (Int(text) == nil){
                return false
            }//if the new value wouldn't be an int
            else{
                return true
            }//if we're still talking numerically
        }//if restricting to numbers
        
        return true
    }//shouldChangeCharactersInRange
    
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
    
    func textFieldWillEndEditing(textField: UITextField) {
        resignFirstResponder()
        currentTextField = nil
    }//textFieldWillEndEditing
    
    //MARK: Picker Functions
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if (pickerView == damageTypePicker){return 1}
        else {
            return 0
        }
    }//numberOfComponentsInPickerView
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == damageTypePicker){return damageTypePickerTitles.count}
        else{
            return 0
        }
    }//numberOfRowsInComponent
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == damageTypePicker){
            return damageTypePickerTitles[row]
        }
        else{
            return nil
        }
    }//titleForRowInPicker
    
    func donePicker(sender: UIBarButtonItem){
        
        if (sender == damageTypePickerDoneButton){
            let damageString: String = damageTypePickerTitles[damageTypePicker.selectedRowInComponent(0)]
            let newType: PhysicalDamageType = damageTypeStringDict[damageString]!
            damageTypeField.text = String(newType)
            
            let inv: Inventory = (inventoryItem! as! WeaponInventoryItem).inv_inventory_w!
            inv.changeWeaponItemType((inventoryItem! as! WeaponInventoryItem), newType: newType)
            
            damageTypeField.endEditing(true)
            
            parentTableView!.reloadData()
            
        }//if
        
    }//donePicker
    
    
}//WeaponTableCell

class ItemTableCell: UITableViewCell, InventoryTableCell, UITextFieldDelegate{
    
    var currentTextField: UIView? = nil
    
    //MARK: Outlets
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var detailField: UITextField!
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    
    weak var inventoryItem: InventoryItem?
    weak var parentTableView: UITableView?
    
    func setDelegateHandlers() {
        nameField.delegate = self
        detailField.delegate = self
        quantityField.delegate = self
        weightField.delegate = self
    }//setDelegateHandlers
    
    func setInfoWithItem(item item: InventoryItem) {
        
        nameField.text = item.name
        detailField.text = item.details
        setQuantityText(item.quantity)
        setWeightFieldText(item.weight)
        
        inventoryItem = item
        
    }//setInfoWithItem
    
    func setQuantityText(quantity: Double){
        
        if (abs(quantity - round(quantity)) < 0.0000001){
            quantityField.text = String(Int(round(quantity)))
        }//if essentially a whole number
        else{
            quantityField.text = String(quantity)
        }//if given a decimal quantity
        
    }//setQuantityText
    
    func setWeightFieldText(weight: Double){
        
        if (weight == -1.0){
            weightField.text = ""
            return
        }//if no weight given
        
        if (abs(weight - round(weight)) < 0.0000001){
            weightField.text = String(Int(round(weight)))
        }//if essentially a whole number
        else{
            weightField.text = String(weight)
        }//if given a decimal weight
        
        
    }//setWeightFieldtext
    
    //MARK: TextField functions
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        resignFirstResponder()
        
        let myItem: InventoryItem = inventoryItem! //as! InventoryItem
        let inv: Inventory = myItem.inv_inventory!
        
        switch textField{
        case nameField:
            inv.changeName(myItem, newName: textField.text!)
            parentTableView!.reloadData()
            return
        case detailField:
            inv.changeDetails(myItem, newDetails: textField.text!)
            parentTableView!.reloadData()
            return
        case quantityField:
            inv.changeItemQuantity(myItem, newQuantity: Double(textField.text!)!)
            parentTableView!.reloadData()
            return
        case weightField:
            var newWeight: Double = 0.0
            let weightText = textField.text
            if (weightText == nil || weightText == ""){
                newWeight = -1.0
            }//if no weight field (represented by -1)
            else{
                newWeight = Double(weightText!)!
            }//else normal weight entry
            inv.changeItemWeight(myItem, newWeight: newWeight)
            parentTableView!.reloadData()
            return
        default:
            return
        }//switch
        
    }//textFieldDidEndEditing
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        return false
    }//textFieldShouldReturn
    
    ///Used for restricting to numerical inputs
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if ([quantityField, weightField].contains(textField)){
            let text = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            
            if (text == ""){
                return true
            }//allow empty string
            
            if (Double(text) == nil){
                return false
            }//if the new value wouldn't be a double
            else{
                return true
            }//if we're still talking numerically
        }//if restricting to numbers
        
        return true
    }//shouldChangeCharactersInRange
    
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
    
    func textFieldWillEndEditing(textField: UITextField) {
        resignFirstResponder()
        currentTextField = nil
    }//textFieldWillEndEditing

    
}//ItemTableCell
