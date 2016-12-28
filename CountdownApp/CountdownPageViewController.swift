//
//  ViewController.swift
//  CountdownApp
//
//  Created by Vincent on 12/20/16.
//  Copyright © 2016 Seven Logics. All rights reserved.
//

import Foundation
import UIKit

class CountdownPageViewController : UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    let countdownCoreData = CountdownCoreData.countdownCoreData
    
    //var pageTitles = [String]()
    let imageArray = [#imageLiteral(resourceName: "Hotairballons"), #imageLiteral(resourceName: "alaska"), #imageLiteral(resourceName: "butterfly-wallpaper")]
    
    var count = 0
    var pageContentViewControllers = [CountdownViewController]()
    var countDownArray = [CountdownManagedObject]()
    var pageViewController : UIPageViewController!
    
    let newCountdownAlertController = UIAlertController(title: "New Countdown", message: "Enter new countdown data", preferredStyle: .alert)

    var currentIndex : Int?
    var prevIndex : Int?
    var isTraversingRight : Bool?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.currentIndex = 0
        
        self.isTraversingRight = false
        self.setupAlertBoxes()
        self.setupPageViewer()
        //addButton.action = #selector (addButtonHandler(sender:))
        
    }
    
    func setupAlertBoxes(){
        
        self.newCountdownAlertController.addTextField { (titleTextField) in
            titleTextField.placeholder = "Enter the event name"
        }
        self.newCountdownAlertController.addTextField { (dateTextField) in
            dateTextField.placeholder = "Enter date here "
        }
        let actionOK = UIAlertAction.init(title: "OK", style: .default, handler: {
            (action: UIAlertAction) in print("ok has been pressed")
            
            let countdownEvent = self.countdownCoreData.getNewCountdownEvent()
            
            countdownEvent.title = self.newCountdownAlertController.textFields?[0].text
            countdownEvent.imageData = UIImagePNGRepresentation( self.imageArray[(Int(arc4random_uniform(UInt32(self.imageArray.count))))] ) as NSData?
            
            self.countDownArray.append(countdownEvent)
            self.countdownCoreData.insert(countdownEvent: countdownEvent)
            self.pageContentViewControllers.append(self.viewControllerAtIndex(index: self.countDownArray.count - 1) as! CountdownViewController)
            self.pageViewController.setViewControllers([self.pageContentViewControllers[self.countDownArray.count - 1]], direction: .forward, animated: true, completion: nil)
            
            self.newCountdownAlertController.textFields?[0].text = ""
            self.newCountdownAlertController.textFields?[1].text = ""
            self.prevIndex = self.pageContentViewControllers.count
            self.countdownCoreData.save()
            
            print("added pagecontent viewcontroller \t with index of \(self.countDownArray.count - 1)")
            print(self.countDownArray.count)
            
        }) //END ACTION OK
        
        let actionCancel = UIAlertAction.init(title: "Cancel", style: .default, handler: {
            (action: UIAlertAction) in print("Cancel has been pressed")
        })
        
        self.newCountdownAlertController.addAction(actionOK)
        self.newCountdownAlertController.addAction(actionCancel)
    }
    
    func setupPageViewer() {
        
        /* Getting the PageView controller */
        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "CountdownPageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        //let pageContentViewController = self.viewControllerAtIndex(index: 0)
        //self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        
        
        self.pageViewController.view.frame = CGRect.init(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height-50)
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMove(toParentViewController: self)
        self.navItem.rightBarButtonItem = UIBarButtonItem.init(title: "New", style: UIBarButtonItemStyle.plain, target: self, action: #selector(addBarButtonHandler))
        self.navItem.leftBarButtonItem = UIBarButtonItem.init(title: "Delete", style: UIBarButtonItemStyle.plain, target: self, action: #selector(delBarButtonHandler))
        
        //setup pageContentArray
        var index = 0
        self.countDownArray = self.countdownCoreData.fetchRequest()
        
        for _ in self.countDownArray {
            self.pageContentViewControllers.append(self.viewControllerAtIndex(index: index) as! CountdownViewController)
            index += 1
        }
        if(self.pageContentViewControllers.count > 0){
            self.pageViewController.setViewControllers([self.pageContentViewControllers[0]], direction: .forward, animated: true, completion: nil)
        }
        
    }
    func delBarButtonHandler(){
        var index = 0
        if currentIndex! > 0 && self.currentIndex! < self.countDownArray.count {
            
            self.countdownCoreData.delete(countdownEvent: self.countDownArray[self.currentIndex!])
            self.countDownArray.remove(at: self.currentIndex!)
            self.pageContentViewControllers.remove(at: self.currentIndex!)
            self.pageViewController.setViewControllers([self.pageContentViewControllers[self.currentIndex! - 1]], direction: .reverse, animated: true, completion: nil)
            self.navItem.title = self.pageContentViewControllers[self.currentIndex! - 1].titleText
            self.countdownCoreData.save()
            for viewController in self.pageContentViewControllers {
                if index >= self.currentIndex! {
                    viewController.pageIndex = index
                }
                index += 1
            } //END FOR
            
        }// END IF
        
    }
    
    func addBarButtonHandler(){
        self.present(newCountdownAlertController, animated: true, completion: nil)
    }
    @IBAction func start(sender: AnyObject) {
        
        let pageContentViewController = self.viewControllerAtIndex(index: 0)
        self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    
        var index = self.pageContentViewControllers.index(of: viewController as! CountdownViewController)//(viewController as! CountdownViewController).pageIndex!
        
        self.navItem.title = self.pageContentViewControllers[index!].titleText
        
        self.currentIndex = index
        self.isTraversingRight = true
        index = index! + 1
        print("viewControllerAfter is called . . . \(index) ")
        
        if(index!  >= self.countDownArray.count){
            return nil
        }
        //self.navItem.title = self.pageContentViewControllers[index].titleText
        return self.pageContentViewControllers[index!]
        //return self.viewControllerAtIndex(index: index)
    
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    
        var index = self.pageContentViewControllers.index(of: viewController as! CountdownViewController)//(viewController as! CountdownViewController).pageIndex!
        
        self.isTraversingRight = false
        self.navItem.title = self.pageContentViewControllers[index!].titleText
        self.currentIndex = index
        index = index! - 1
        if(index! < 0){
            return nil
        }
        print("viewControllerBefore is called . . . \(index) ")
        //self.navItem.title = self.pageContentViewControllers[index].titleText
        return self.pageContentViewControllers[index!]
        //return self.viewControllerAtIndex(index: index)
    
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            
            //print("completed! \(self.prevIndex) \t \((previousViewControllers[0] as! CountdownViewController).pageIndex) \t \(isTraversingRight)")
            var index = (previousViewControllers[0] as! CountdownViewController).pageIndex
            print("previous view controllers size is \(previousViewControllers.count)")
            if index == self.pageContentViewControllers.count - 1  {
                
                isTraversingRight = false
                
            } else if index == 0 {
                
                isTraversingRight = true
                
            } else if prevIndex! > index! {
                
                isTraversingRight = false
                
            } else if prevIndex! < index! {
                
                isTraversingRight = true
            }
            
            //print("completed! \(self.prevIndex) \t \((previousViewControllers[0] as! CountdownViewController).pageIndex) \t \(isTraversingRight)")
            
            self.prevIndex = index
            
            if self.pageContentViewControllers.count > 1 {
                
                if (self.isTraversingRight)!{
                    index! += 1
                } else {
                    index! -= 1
                }
                
            }
            
            self.currentIndex = index
            self.navItem.title = (self.pageContentViewControllers[index!]).titleText
            
        }
    }
    
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        
        if((self.countDownArray.count == 0) || (index >= self.countDownArray.count)) {
            return nil
        }
        
        
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as! CountdownViewController
        
        pageContentViewController.countdownEvent = self.countDownArray[index]
        pageContentViewController.imageData = self.countDownArray[index].imageData
        pageContentViewController.titleText = self.countDownArray[index].title
        pageContentViewController.pageIndex = index
        
        self.navItem.title = self.countDownArray[index].title
        return pageContentViewController
    }
    
    private func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.countDownArray.count
    }
    
    private func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}
