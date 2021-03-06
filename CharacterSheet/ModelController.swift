//
//  ModelController.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 1/25/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import UIKit

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */


class ModelController: NSObject, UIPageViewControllerDataSource {

    var pageData: [String] = []
    var pages: [CSViewController] = [];
    var pageList = ["CharacterSelectViewController", "SummaryViewController","AbilityScoreViewController", "SkillViewController", "FeaturesViewController", "TraitsViewController", "SpellViewController"];


    override init() {
        super.init()
        // Create the data model.
        /*
        let dateFormatter = NSDateFormatter()
        pageData = dateFormatter.monthSymbols
        */
    }

    func viewControllerAtIndex(index: Int, storyboard: UIStoryboard) -> UIViewController? {
        // Return the data view controller for the given index.

        
        if (!(pages.isEmpty)) {
            return pages[index];
        }
        
        for i in 0..<pageList.count{
            let viewController = storyboard.instantiateViewControllerWithIdentifier(pageList[i]) as! CSViewController;
            pages.append(viewController);
            if (i > 0){
                viewController.prevViewController = pages[i - 1];
                pages[i-1].nextViewController = viewController;
            }
        }//for
        
        return pages[index];
        
    }

    func indexOfViewController(viewController: UIViewController) -> Int {
        return 0;
        
        // Return the index of the given data view controller.
        // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
//        return pageData.indexOf(viewController.dataObject) ?? NSNotFound
    }

    // MARK: - Page View Controller Data Source

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let myViewController = viewController as! CSViewController;
        return myViewController.prevViewController;

    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let myViewController = viewController as! CSViewController;
        return myViewController.nextViewController
    }

    /*
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int{
        return pages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        print(pageViewController)
        
        return 0;
    }
*/

}

