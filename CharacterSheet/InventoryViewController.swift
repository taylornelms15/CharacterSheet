//
//  InventoryViewController.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 4/5/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit
import CoreData

class InventoryViewController: CSViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{
    
    var tableHeaderTitles: [String] = ["Armor", "Weapons", "Items"]
    
    var thisInventory: Inventory? = nil
    
    //MARK: Outlets
    @IBOutlet weak var goldField: UITextField!
    @IBOutlet weak var silverField: UITextField!
    @IBOutlet weak var copperField: UITextField!
    @IBOutlet weak var inventoryTableView: UITableView!
    
    var headers: [String] = ["Armor", "Weapons", "Items"]
    
    var currentTextField: UIView? = nil

    //MARK: adding items
    
    @IBAction func addItemButtonPressed(sender: UIBarButtonItem) {
        
        let newVC: AddItemContainerViewController = storyboard!.instantiateViewControllerWithIdentifier("addItemContainerView") as! AddItemContainerViewController
        newVC.modalPresentationStyle = .OverCurrentContext
        newVC.modalTransitionStyle = .CrossDissolve
        newVC.parentVC = self
        
        self.presentViewController(newVC, animated: true, completion: {
            ()->Void in
        })
        
    }//addItemButtonPressed
    
    /**
     The idea is to call this from the addItem pages, and by doing so close things out and then add the item to the inventory
     It should receive a non-saved item with no ties to any inventory
     */
    func receiveCreatedItem(item: InventoryItem){
        
        //kills the add item controller stack
        self.dismissViewControllerAnimated(true, completion: nil)
        
        //adds item to inventory
        if (item.isMemberOfClass(ArmorInventoryItem)){
            thisInventory!.addArmorItem(item as! ArmorInventoryItem)
        }//if
        else if (item.isMemberOfClass(WeaponInventoryItem)){
            thisInventory!.addWeaponItem(item as! WeaponInventoryItem)
        }//elif
        else{
            thisInventory!.addItem(item)
        }//else
        
        do{
            let context = thisInventory!.managedObjectContext!
            try context.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }

        
        inventoryTableView.reloadData()
        
    }//receiveCreatedItem
    
    //MARK: ViewController Navigation Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        thisInventory = results[0].inventory
        
        goldField.delegate = self
        silverField.delegate = self
        copperField.delegate = self
        
        updateCurrencyFields()
        
        inventoryTableView.dataSource = self
        inventoryTableView.delegate = self
        
        inventoryTableView.reloadData()
        
    }//viewDidLoad
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (thisInventory != nil){
            inventoryTableView.reloadData()
        }
        
    }//viewWillAppear
    
    //MARK: UITextFieldDelegate functions
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        switch textField{
        case goldField:
            if (textField.text == nil || textField.text! == ""){
                textField.text = "\(0)"
            }//if
            thisInventory!.gold = Int64(textField.text!)!
        case silverField:
            if (textField.text == nil || textField.text! == ""){
                textField.text = "\(0)"
            }//if
            thisInventory!.silver = Int64(textField.text!)!
        case copperField:
            if (textField.text == nil || textField.text! == ""){
                textField.text = "\(0)"
            }//if
            thisInventory!.copper = Int64(textField.text!)!
        default:
            return
        }//switch
        
        do{
            try thisInventory!.managedObjectContext!.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }//textFieldDidEndEditing
    
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
    
    //Note: this is a made-up function maybe?
    func textFieldWillEndEditing(textField: UITextField) {
        resignFirstResponder()
        currentTextField = nil
    }//textFieldWillEndEditing
 
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }//textFieldShouldReturn
    
    ///Used to restrict the currency fields to int values
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if ([goldField, silverField, copperField].contains(textField)){
            let text = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            
            if (text == ""){
                return true
            }//allow empty string (will change to a zero if we end editing on it, in the did end editing function)
            
            if (Int(text) == nil){
                return false
            }//if the new value wouldn't be an int
            else{
                return true
            }//if we're still talking numerically
        }//if we're in the currency fields
        
        else{
            return true
        }//else
        
    }//shouldChangeCharactersInRange
    
    //MARK: UITableView functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }//numberOfSectionsInTableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section){
        case 0:
            return thisInventory!.getNumArmor()
        case 1:
            return thisInventory!.getNumWeapons()
        default:
            return thisInventory!.getNumItems()
        }//switch
    }//numberOfRowsInSection
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header: InventoryTableHeader? = nil
        
        switch(section){
        case 0:
            header = tableView.dequeueReusableCellWithIdentifier("armorHeader") as! ArmorHeader
        case 1:
            header = tableView.dequeueReusableCellWithIdentifier("weaponHeader") as! WeaponHeader
        default:
            header = tableView.dequeueReusableCellWithIdentifier("itemHeader") as! ItemHeader
        }//switch
        
        header!.setLabelsWithInventory(thisInventory!)
        
        return header

    }//viewForHeaderInSection
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }//titleForHeaderInSection
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell()
        var myCell: InventoryTableCell? = nil
        var myItem: InventoryItem? = nil
        
        switch(indexPath.section){
        case 0://Armor
            cell = tableView.dequeueReusableCellWithIdentifier("armorInventoryCell") as! ArmorTableCell
            
            myCell = cell as? InventoryTableCell
            
            myItem = thisInventory!.getArmorAtIndex(index: indexPath.row)
            
        case 1://Weapon
            cell = tableView.dequeueReusableCellWithIdentifier("weaponInventoryCell") as! WeaponTableCell
            
            myCell = cell as? InventoryTableCell
            
            myItem = thisInventory!.getWeaponAtIndex(index: indexPath.row)
            
        case 2://Item
            cell = tableView.dequeueReusableCellWithIdentifier("itemInventoryCell") as! ItemTableCell
            
            myCell = cell as? InventoryTableCell
            
            myItem = thisInventory!.getItemAtIndex(index: indexPath.row)
            
        default:
            
            return cell
            
        }//switch
        
        myCell!.setInfoWithItem(item: myItem!)
        myCell!.setDelegateHandlers()
        myCell!.parentTableView = tableView
        
        return myCell as! UITableViewCell
    }//cellForRowAtIndexPath
    
    //MARK: helper functions
    
    func updateCurrencyFields(){
        
        goldField.text = String(Int(thisInventory!.gold))
        silverField.text = String(Int(thisInventory!.silver))
        copperField.text = String(Int(thisInventory!.copper))
        
    }//updateCurrencyFields
    
}//InventoryViewController










