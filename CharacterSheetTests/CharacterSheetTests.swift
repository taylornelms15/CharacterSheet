//
//  CharacterSheetTests.swift
//  CharacterSheetTests
//
//  Created by Taylor Nelms on 1/25/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import XCTest
import CoreData
@testable import CharacterSheet

class CharacterSheetTests: XCTestCase {
    
    var initialViewController: UIViewController!
    
    override func setUp() {
        super.setUp()
        
        initialViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }//setUp
    
    override func tearDown() {
        
        super.tearDown()
    }//tearDown
    
    
}//CharacterSheetTests
