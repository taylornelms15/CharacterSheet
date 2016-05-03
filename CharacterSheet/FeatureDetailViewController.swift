//
//  FeatureDetailViewController.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 5/3/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit
import CoreData

class FeatureDetailViewController: UIViewController{
    
    var myFeature: Feature? = nil
    
    //MARK: Outlets
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var featureNameLabel: UILabel!
    @IBOutlet weak var detailView: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.layer.cornerRadius = 10.0
        backgroundView.layer.borderWidth = 4.0
        backgroundView.layer.borderColor = UIColor.darkGrayColor().CGColor
        
        setTextWithFeature(myFeature!)
        
    }//viewDidLoad
    
    @IBAction func doneButtonPressed(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }//doneButtonPressed
    
    func setTextWithFeature(feature: Feature){
        
        featureNameLabel.text = feature.name
        detailView.text = feature.details
        
    }//setTextWithFeature
    
}//FeatureDetailViewController
