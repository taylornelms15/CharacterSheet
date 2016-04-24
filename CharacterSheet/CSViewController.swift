//
//  CSViewController.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 1/25/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit

class CSViewController: UIViewController{
    
    weak var nextViewController: CSViewController?;
    weak var prevViewController: CSViewController?;
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        nextViewController = nil
        prevViewController = nil
    }//init
}
