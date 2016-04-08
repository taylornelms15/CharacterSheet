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
    
}//InventoryTableCell

class ArmorTableCell: UITableViewCell, InventoryTableCell{
    
    static let checkBoxChecked: String = "\u{2611}"
    static let checkBoxUnChecked: String = "\u{2B1C}"
    
    //MARK: Outlets
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var detailField: UITextField!
    @IBOutlet weak var baseACField: UITextField!
    @IBOutlet weak var armorTypeField: UITextField!
    @IBOutlet weak var equipButton: UIButton!
    
    weak var inventoryItem: InventoryItem?
    
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
            equipButton.setTitle(ArmorTableCell.checkBoxChecked, forState: .Normal)
        }
        else{
            equipButton.setTitle(ArmorTableCell.checkBoxUnChecked, forState: .Normal)
        }
    }//setEquippedButtonText
    
}//ArmorTableCell

class WeaponTableCell: UITableViewCell, InventoryTableCell{
    
    static let checkBoxChecked: String = "\u{2611}"
    static let checkBoxUnChecked: String = "\u{2B1C}"
    
    //MARK: Outlets
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var detailField: UITextField!
    @IBOutlet weak var damageDieNumField: UITextField!
    @IBOutlet weak var damageDieTypeField: UITextField!
    @IBOutlet weak var damageTypeField: UITextField!
    @IBOutlet weak var finessebutton: UIButton!
    @IBOutlet weak var equipButton: UIButton!
    
    weak var inventoryItem: InventoryItem?
    
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
            finessebutton.setTitle(WeaponTableCell.checkBoxChecked, forState: .Normal)
        }
        else{
            finessebutton.setTitle(WeaponTableCell.checkBoxUnChecked, forState: .Normal)
        }
    }//setFinesseButtonText
    
    func setEquippedButtonText(equipped equipped: Bool){
        if (equipped){
            equipButton.setTitle(WeaponTableCell.checkBoxChecked, forState: .Normal)
        }
        else{
            equipButton.setTitle(WeaponTableCell.checkBoxUnChecked, forState: .Normal)
        }
    }//setEquippedButtonText
    
    
}//WeaponTableCell

class ItemTableCell: UITableViewCell, InventoryTableCell{
    
    static let checkBoxChecked: String = "\u{2611}"
    static let checkBoxUnChecked: String = "\u{2B1C}"
    
    //MARK: Outlets
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var detailField: UITextField!
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    
    weak var inventoryItem: InventoryItem?
    
    func setInfoWithItem(item item: InventoryItem) {
        
        nameField.text = item.name
        detailField.text = item.details
        quantityField.text = String(item.quantity)
        weightField.text = String(item.weight)
        
        inventoryItem = item
        
    }//setInfoWithItem
    
}
