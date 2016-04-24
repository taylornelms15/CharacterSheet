//
//  CSNavigationController.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 3/26/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit
import CoreData

/**
 Shifts responsibility for which view controller comes up on forward/back operations
 */
protocol CSNavigationDataSource{
    
    func getVCWithIdentifier(navigationController: UINavigationController, identifier: String, currentViewController: CSViewController)->CSViewController
    func getNextVC(navigationController: UINavigationController, currentViewController: CSViewController)->CSViewController?
    func getPrevVC(navigationController: UINavigationController, currentViewController: CSViewController)->CSViewController?
    func canGoNext(navigationController: UINavigationController, currentViewController: CSViewController)->Bool
    func canGoPrev(navigationController: UINavigationController, currentViewController: CSViewController)->Bool
    
}//CSNavigationDataSource

class CSNavigationController: UINavigationController{
    
    weak var splitVC: CSSplitViewController? = nil
    var dataSource: CSNavigationDataSource? = nil
    
    var segControl: UISegmentedControl = UISegmentedControl()
    var myRightItem: UIBarButtonItem = UIBarButtonItem()
    var myLeftItem: UIBarButtonItem = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        splitVC = (self.parentViewController! as! CSSplitViewController)
        
        self.delegate = splitVC!.csvcHandler
        self.dataSource = splitVC!.csvcHandler
        
        self.setToolbarThings()
        
    }//viewDidLoad
    
    ///Instantiates the custom navigation bar
    func setToolbarThings(){
        let myBar: UINavigationBar = self.navigationBar
        
        //make the right buttons
        segControl = UISegmentedControl(items: ["<", ">"])
        segControl.momentary = true
        segControl.addTarget(self, action: #selector(CSNavigationController.segmentPressed) , forControlEvents: UIControlEvents.ValueChanged)
        myRightItem = UIBarButtonItem(customView: segControl)
        //myLeftItem = splitVC!.displayModeButtonItem()
        myLeftItem = UIBarButtonItem(title: "Menu", style: .Plain, target: splitVC!.displayModeButtonItem().target, action: splitVC!.displayModeButtonItem().action)
        
        //put the buttons on the bar
        myBar.topItem!.rightBarButtonItem = myRightItem
        myBar.topItem!.leftBarButtonItem = myLeftItem
        
    }//setToolbarThings
    
    //MARK: actions
    
    func segmentPressed(sender: UISegmentedControl){
        switch(sender.selectedSegmentIndex){
        case 0://back
            navigateBackward()
        case 1://forward
            navigateForward()
        default:
            return
        }//switch
    }//segmentPressed
    
    //MARK: navigation
    
    func navigateToIdentifier(identifier: String){
        
        let nextVC: CSViewController = dataSource!.getVCWithIdentifier(self, identifier: identifier, currentViewController:  self.topViewController as! CSViewController)
        
        nextVC.navigationItem.rightBarButtonItem = myRightItem
        nextVC.navigationItem.leftBarButtonItem = myLeftItem
        
        if (viewControllers.contains(nextVC)){
            popToViewController(nextVC, animated: true)
        }
        
        else{
            pushViewController(nextVC, animated: true)
        }
        
    }//navigateToIdentifier
    
    func navigateForward(){
        if (dataSource!.canGoNext(self, currentViewController: self.topViewController as! CSViewController) == false){
            return
        }//if we can't go forward, don't
        
        let nextVC: CSViewController = dataSource!.getNextVC(self, currentViewController: self.topViewController as! CSViewController)!
        nextVC.navigationItem.rightBarButtonItem = myRightItem
        nextVC.navigationItem.leftBarButtonItem = myLeftItem
        
        pushViewController(nextVC, animated: true)
        
    }//navigateForward
    
    func navigateBackward(){
        if (dataSource!.canGoPrev(self, currentViewController: self.topViewController as! CSViewController) == false){
            return
        }//if we can't go backwards, don't
        
        let nextVC: CSViewController = dataSource!.getPrevVC(self, currentViewController: self.topViewController as! CSViewController)!
        
        if (viewControllers.contains(nextVC)){
            popToViewController(nextVC, animated: true)
        }//if we're going straight back
        else{
            nextVC.navigationItem.rightBarButtonItem = myRightItem
            nextVC.navigationItem.leftBarButtonItem = myLeftItem
            
            let steadySlice = viewControllers[Range(0..<(viewControllers.count - 1))]
            var newState: [UIViewController] = Array(steadySlice)
            newState.append(nextVC)
            newState.append(self.topViewController!)
            self.setViewControllers(newState, animated: false)
            self.popViewControllerAnimated(true)

        }//else (inserting backwards)
        
    }//navigateBackward
    
}//CSNavigationController







