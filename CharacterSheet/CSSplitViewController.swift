//
//  CSSplitViewController.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 4/22/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit
import CoreData

class CSSplitViewController: UISplitViewController{
    
    var csvcHandler: CSVCHandler = CSVCHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preferredDisplayMode = .PrimaryHidden
        self.preferredPrimaryColumnWidthFraction = 0.6
        self.delegate = csvcHandler
        csvcHandler.splitVC = self
        
    }//viewDidLoad
    
}//CSSplitViewController

class RootMenuTableViewController: UITableViewController{
    
    weak var splitVC: CSSplitViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        splitVC = (self.parentViewController!.parentViewController! as! CSSplitViewController)
        
        self.tableView.dataSource = splitVC!.csvcHandler
        self.tableView.delegate = splitVC!.csvcHandler
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.reloadTableData), name: menuNavTableReloadNotificationKey, object: nil)
        
        //self.navigationItem.rightBarButtonItem = splitVC!.displayModeButtonItem()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .Stop, target: splitVC!.displayModeButtonItem().target, action: splitVC!.displayModeButtonItem().action)
    }//viewDidLoad
    
    func reloadTableData(){
        self.tableView.reloadData()
    }
    
}//RootMenuTableViewController

class ContainerViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let segueName: String = segue.identifier!
        
        if (segueName == "splitViewEmbedSegue"){
            self.setOverrideTraitCollection(UITraitCollection.init(horizontalSizeClass: UIUserInterfaceSizeClass.Regular), forChildViewController: segue.destinationViewController)
        }//if we're looking at the embed segue
    }
    
}//ContianerViewController
