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
        
        self.preferredContentSize = CGSize(width: 350, height: 300)
        
        self.view.layer.cornerRadius = 5.0
        self.view.layer.borderWidth = 1.0
        self.view.layer.borderColor = UIColor.darkGrayColor().CGColor
        
        self.view.backgroundColor = UIColor.clearColor()
        
    }//viewDidLoad
    
}//AddItemTabController

class AddItemParentController: UIViewController{
    
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {

    }//viewDidLoad
    
}//AddItemParentController

class AddArmorViewController: AddItemParentController{
    
}//AddArmorViewController

class AddWeaponViewController: AddItemParentController{
    
}//AddWeaponViewController

class AddItemViewController: AddItemParentController{
    
}//AddItemViewController
