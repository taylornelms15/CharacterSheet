//
//  SkillViewController.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 2/20/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit
import CoreData

class SkillViewController: CSViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource{
    //MARK: Outlets
    
    @IBOutlet weak var profBonusLabel: UILabel!
    @IBOutlet weak var skillTableView: UITableView!
    
    //MARK: variables
    
    var pchar: PCharacter? = nil
    var skillProfs: SkillProfs? = nil
    
    //MARK: viewcontroller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skillTableView.dataSource = self
        skillTableView.delegate = self
        
    }//viewDidLoad
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Get our character out
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "PCharacter");
        fetchRequest.predicate = NSPredicate(format: "id = %@", String(appDelegate.currentCharacterId));
        var results: [PCharacter] = [];
        do{
            results = try managedContext.executeFetchRequest(fetchRequest) as! [PCharacter]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        results[0].updateAScores()
        //Note that now results[0] is our character
        
        pchar = results[0]
        skillProfs = results[0].skillProfs
        
        profBonusLabel.text = "+\(pchar!.getProfBonus())"
        
    }//viewWillAppear
    
    override func viewDidAppear(animated: Bool) {

        super.viewDidAppear(animated);

    }//viewDidAppear

    
    //MARK: UITableView functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }//numberOfSectionsInTableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section){
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return 5
        case 3:
            return 5
        case 4:
            return 4
        default:
            return 0
        }//switch
    }//numberOfRowsInSection
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let mySkillIndex: Int = SkillProfs.SkillStatTable.indexOf({
            return $0.0 == indexPath.section && $0.1 == indexPath.row
        })!
        
        let cell: SkillTableRowCell = tableView.dequeueReusableCellWithIdentifier("skillTableRow") as! SkillTableRowCell
        
        cell.index = mySkillIndex
        cell.pchar = pchar!
        cell.skillProfs = skillProfs!
        
        let name: String = SkillProfs.skillNameTable[mySkillIndex]
        
        cell.rowTitleLabel.text = name
        
        cell.updateLabels()
        
        return cell
    }//cellForRowAtIndexPath
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header: SkillTableHeaderCell = tableView.dequeueReusableCellWithIdentifier("skillTableHeader") as! SkillTableHeaderCell
        
        var modVal: Int = 0
        
        switch(section){
        case 0:
            header.headerTitleLabel.text = "Strength"
            modVal = pchar!.ascores.getStrMod()
        case 1:
            header.headerTitleLabel.text = "Dexterity"
            modVal = pchar!.ascores.getDexMod()
        case 2:
            header.headerTitleLabel.text = "Intelligence"
            modVal = pchar!.ascores.getIntMod()
        case 3:
            header.headerTitleLabel.text = "Wisdom"
            modVal = pchar!.ascores.getWisMod()
        case 4:
            header.headerTitleLabel.text = "Charisma"
            modVal = pchar!.ascores.getChaMod()
        default:
            break
        }//switch
        
        if (modVal < 0){
            header.headerModLabel.text = "\(modVal)"
        }
        else{
            header.headerModLabel.text = "+\(modVal)"
        }
        
        return header
        
    }//viewForHeaderInSection
    
}//SkillViewController
