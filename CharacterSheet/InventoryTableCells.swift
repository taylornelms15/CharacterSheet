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
    
    func setInfoWithItem(item item: InventoryItem)->Void
    func setDelegateHandlers()->Void
    
}//InventoryTableCell

class ArmorTableCell: UITableViewCell, InventoryTableCell, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    //MARK: view/field things
    var armorTypePicker: UIPickerView = UIPickerView()
    let armorTypePickerToolbar: UIToolbar = UIToolbar()
    var armorTypePickerDoneButton: UIBarButtonItem? = nil
    let pickerSpaceButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
    let armorTypePickerTitles: [String] = ["Light Armor", "Medium Armor", "Heavy Armor", "Shield", "Other"]
    let armorTypeStringDict: [String: ArmorType] = ["Light Armor" : ArmorType.Light, "Medium Armor" : ArmorType.Medium, "Heavy Armor" : ArmorType.Heavy, "Shield" : ArmorType.Shield, "Other" : ArmorType.Other]
    
    //MARK: Outlets
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var detailField: UITextField!
    @IBOutlet weak var baseACField: UITextField!
    @IBOutlet weak var armorTypeField: UITextField!
    @IBOutlet weak var equipButton: UIButton!
    
    weak var inventoryItem: InventoryItem?
    
    func setDelegateHandlers(){
        nameField.delegate = self
        detailField.delegate = self
        baseACField.delegate = self
        armorTypeField.inputView = armorTypePicker
        armorTypePicker.dataSource = self
        armorTypePicker.delegate = self
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
            armorTypeField.text = armorString
            
            armorTypeField.endEditing(true)
        }//if
        
    }//donePicker
    
    
}//ArmorTableCell

class WeaponTableCell: UITableViewCell, InventoryTableCell, UITextFieldDelegate{
    
    //MARK: Outlets
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var detailField: UITextField!
    @IBOutlet weak var damageDieNumField: UITextField!
    @IBOutlet weak var damageDieTypeField: UITextField!
    @IBOutlet weak var damageTypeField: UITextField!
    @IBOutlet weak var finessebutton: UIButton!
    @IBOutlet weak var equipButton: UIButton!
    
    weak var inventoryItem: InventoryItem?
    
    func setDelegateHandlers() {
        nameField.delegate = self
        detailField.delegate = self
        damageDieNumField.delegate = self
        damageDieTypeField.delegate = self
        
    }//setDelegateHandlers
    
    func setInfoWithItem(item item: InventoryItem) {
        let weaponItem: WeaponInventoryItem = item as! WeaponInventoryItem
        
        nameField.text = weaponItem.name
        detailField.text = weaponItem.details
        damageDieNumField.text = String(weaponItem.damageDice.0)
        damageDieTypeField.text = String(weaponItem.damageDice.1)
        setFinesseButtonText(finesse: weaponItem.finesse)
        setEquippedButtonText(equipped: weaponItem.equipped)
        
        inventoryItem = item
        
    }//setInfoWithItem
    
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
    
    
}//WeaponTableCell

class ItemTableCell: UITableViewCell, InventoryTableCell, UITextFieldDelegate{
    
    //MARK: Outlets
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var detailField: UITextField!
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    
    weak var inventoryItem: InventoryItem?
    
    func setDelegateHandlers() {
        nameField.delegate = self
        detailField.delegate = self
        quantityField.delegate = self
        weightField.delegate = self
    }//setDelegateHandlers
    
    func setInfoWithItem(item item: InventoryItem) {
        
        nameField.text = item.name
        detailField.text = item.details
        quantityField.text = String(item.quantity)
        weightField.text = String(item.weight)
        
        inventoryItem = item
        
    }//setInfoWithItem
    
}
