//
//  initTests.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 5/6/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import XCTest
import CoreData
@testable import CharacterSheet


class InitTests: CharacterSheetTests {

    var fetchRequest = NSFetchRequest()
    var context: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        context = appDelegate.managedObjectContext!
        
    }
    
    override func tearDown() {
        
        super.tearDown()
    }


    func testRacesInit(){
        //given
        fetchRequest = NSFetchRequest(entityName: "Race")
        
        //when
        let count = context.countForFetchRequest(fetchRequest, error: nil)
        
        //then
        XCTAssertEqual(count, 14, "Didn't make enough races")
        
    }//testRacesInit
    
    func testClassesInit(){
        //given
        fetchRequest = NSFetchRequest(entityName: "PClass")
        
        //when
        let count = context.countForFetchRequest(fetchRequest, error: nil)
        
        //then
        XCTAssertEqual(count, 12, "Didn't make enough classes")
        
    }//testClassesInit
    
    func testBackgroundInit(){
        //given
        fetchRequest = NSFetchRequest(entityName: "Background")
        
        //when
        let count = context.countForFetchRequest(fetchRequest, error: nil)
        
        //then
        XCTAssertEqual(count, 13, "Didn't make enough backgrounds")
        
    }//testBackgroundInit
    
    func testBackgroundFeaturesInit(){
        
        fetchRequest = NSFetchRequest(entityName: "Background")
        var results: [Background] = []
        
        do{
            results = try context.executeFetchRequest(fetchRequest) as! [Background]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }//results now has all our backgrounds
        
        for background in results{
            
            let numFeatures = background.features!.count
            XCTAssertEqual(numFeatures, 1, "A background lacks a feature!")
            
        }//for each background
        
        
    }//testBackgroundFeaturesInit
    
    func testSpellListsInit(){
        
        fetchRequest = NSFetchRequest(entityName: "PClass")
        var results: [PClass] = []
        
        fetchRequest.predicate = NSPredicate(format: "name != %@ && name != %@", "Barbarian", "Monk")
        
        do{
            results = try context.executeFetchRequest(fetchRequest) as! [PClass]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }//results now has all our caster classes
        
        for pclass in results{
            
            XCTAssertNotNil(pclass.spellList)
            
            let pclassSpellList: SpellList = pclass.spellList
            let numSpells = pclassSpellList.spells.count
            
            XCTAssertGreaterThan(numSpells, 0)
            
        }//for each caster class, make sure there is a spell list with spells in it
        
        fetchRequest.predicate = nil
        
    }//testSpellListsInit
    
    
    
}//initTests
