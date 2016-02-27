//
//  FeaturesViewController.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 2/24/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit
import CoreData

class FeaturesViewController: CSViewController, UITableViewDataSource, UITableViewDelegate{

    var raceFeatArray: [RaceFeature] = []
    var backgroundFeatArray: [BackgroundFeature] = []
    
    //MARK: outlets
    @IBOutlet weak var featureTableView: UITableView!
    
    //MARK: onAppear
    override func viewDidLoad(){
        super.viewDidLoad()
        
        featureTableView.dataSource = self;
        featureTableView.delegate = self;

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        //Get our character out
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "PCharacter");
        fetchRequest.predicate = NSPredicate(format: "id = 1", argumentArray: nil);
        var results: [PCharacter] = [];
        do{
            results = try managedContext.executeFetchRequest(fetchRequest) as! [PCharacter]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        results[0].updateAScores()
        //Note that now results[0] is our character

        raceFeatArray.removeAll()
        for raceFeat in results[0].featureList!.raceFeatures{
            raceFeatArray.append(raceFeat as! RaceFeature)
        }
        backgroundFeatArray.removeAll()
        for backgroundFeat in results[0].featureList!.backgroundFeatures{
            backgroundFeatArray.append(backgroundFeat as! BackgroundFeature)
        }
        //print(results[0].featureList!.printAll())

    }//viewWillAppear
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        featureTableView.reloadData()
        
    }//viewDidAppear
    
    
    //MARK: UITableViewDataSource functions
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
            let cell = tableView.dequeueReusableCellWithIdentifier("prototypeFeatureCell", forIndexPath: indexPath)
            
            if (indexPath.section == 0){
                cell.textLabel!.text = raceFeatArray[indexPath.row].name

            }
            else if (indexPath.section == 1){
                cell.textLabel!.text = backgroundFeatArray[indexPath.row].name
            }

            
            return cell
    }//tableView Cell for row at index path
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int{
            switch (section){
            case 0:
                return raceFeatArray.count
            case 1:
                return backgroundFeatArray.count
            default:
                return 0;
            }
    }//tableView number of rows in section
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2;
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section){
        case 0:
            return "Racial Features"
        case 1:
            return "Background Features"
        default:
            return "Oh shit you broke it!"
        }
    }
    
    //MARK: UITableViewDelegate functions
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
        
        
        var myFeature: Feature? = nil
        
        switch (indexPath.section){
        case 0:
            myFeature = raceFeatArray[indexPath.row]
        case 1:
            myFeature = backgroundFeatArray[indexPath.row]
        default:
            myFeature = nil
        }//switch
        
        let detailViewController = UIAlertController(title: nil, message: myFeature!.details, preferredStyle: .ActionSheet)
        let doneAction = UIAlertAction(title: "Done", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        detailViewController.addAction(doneAction)
        
        self.presentViewController(detailViewController, animated: true, completion: nil)
        
    }
    
}//FeaturesViewController