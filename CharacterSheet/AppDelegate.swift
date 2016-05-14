//
//  AppDelegate.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 1/25/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var currentCharacterId: Int16 = 1;


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let managedContext = self.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "CurrentId");
        var results: [NSManagedObject] = []
        do{
            results = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
        if (results.count == 0){
            let entity = NSEntityDescription.entityForName("CurrentId", inManagedObjectContext: managedContext)!
            let currentId1 = NSManagedObject(entity: entity, insertIntoManagedObjectContext: managedContext)
            
            currentId1.setValue(1, forKey: "currentId")
            
            currentCharacterId = 1;

        }//if no CurrentId (init)
        else{//wow, what crazy compile error was I trying to avoid here...
            let x = results[0].valueForKey("currentId")!
            let y: NSNumber = x as! NSNumber
            let z: Int = y.integerValue
            self.currentCharacterId = Int16(z)
        }//else
        
        initEverything(managedContext)
        
        return true
    }
    
    func initEverything(managedContext: NSManagedObjectContext){
        //Init Race Data
        
        var entity =  NSEntityDescription.entityForName("Race",
                                                        inManagedObjectContext:managedContext)
        var fetchRequest = NSFetchRequest(entityName: "Race");
        
        var error: NSError? = nil;
        var count = managedContext.countForFetchRequest(fetchRequest, error: &error)
        if (count == 0){
            racesInit(entity!, context: managedContext)
        }//if
        
        //Init Class Data
        entity =  NSEntityDescription.entityForName("PClass",
                                                    inManagedObjectContext:managedContext)
        fetchRequest = NSFetchRequest(entityName: "PClass");
        
        count = managedContext.countForFetchRequest(fetchRequest, error: &error)
        if (count == 0){
            PClass.classesInit(entity!, context: managedContext)
        }
        
        //Init Character
        entity = NSEntityDescription.entityForName("PCharacter", inManagedObjectContext: managedContext);
        fetchRequest = NSFetchRequest(entityName: "PCharacter");
        
        count = managedContext.countForFetchRequest(fetchRequest, error: &error)
        if (count == 0){
            characterInit(entity!, context: managedContext);
        }//if
        
        //Init Background
        entity = NSEntityDescription.entityForName("Background", inManagedObjectContext: managedContext);
        fetchRequest = NSFetchRequest(entityName: "Background");
        
        count = managedContext.countForFetchRequest(fetchRequest, error: &error)
        if (count == 0){
            Background.backgroundInit(managedContext);
        }//if
        
        //Init Feats
        
        entity = NSEntityDescription.entityForName("Feat", inManagedObjectContext: managedContext);
        fetchRequest = NSFetchRequest(entityName: "Feat");
        
        count = managedContext.countForFetchRequest(fetchRequest, error: &error)
        if (count == 0){
            Feat.featsInit(managedContext)
        }//if
        
        //Init Traits
        
        entity = NSEntityDescription.entityForName("Trait", inManagedObjectContext: managedContext);
        fetchRequest = NSFetchRequest(entityName: "Trait");
        
        count = managedContext.countForFetchRequest(fetchRequest, error: &error)
        if (count == 0){
            TraitList.traitsInit(managedContext)
        }//if
        
        //Init Spells
        
        entity = NSEntityDescription.entityForName("Spell", inManagedObjectContext: managedContext);
        fetchRequest = NSFetchRequest(entityName: "Spell");
        
        count = managedContext.countForFetchRequest(fetchRequest, error: &error)
        if (count == 0){
            Spell.spellsInit(managedContext)
        }//if
        
        //Init Subclasses
        
        entity = NSEntityDescription.entityForName("Subclass", inManagedObjectContext: managedContext);
        fetchRequest = NSFetchRequest(entityName: "Subclass");
        
        count = managedContext.countForFetchRequest(fetchRequest, error: &error)
        if (count == 0){
            Subclass.subClassesInit(managedContext)
        }//if
        
        //Init Class Features
        
        entity = NSEntityDescription.entityForName("ClassFeature", inManagedObjectContext: managedContext);
        fetchRequest = NSFetchRequest(entityName: "ClassFeature");
        
        count = managedContext.countForFetchRequest(fetchRequest, error: &error)
        if (count == 0){
            ClassFeature.classFeatureInit(managedContext)
        }//if
    }//initEverything

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.xxxx.ProjectName" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("DataModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("CharacterSheet.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do{
            let testval = try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil);
            //if (testval === nil){
        }//do
        catch{
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = "it failed!"
            dict[NSUnderlyingErrorKey] = "0000"
            //error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error bitch, and it's all your fault")
            abort()
        }
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            do{
                if (moc.hasChanges){
                    try moc.save();
                }
            }
            catch  {
                NSLog("Unresolved error, in the moc.save business")
                abort()
            }
        }
    }
}

