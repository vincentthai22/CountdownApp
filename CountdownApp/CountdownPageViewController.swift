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
    
    
    var pageTitles = [String]()
    var images = [String]()
    var count = 0
    var pageContentViewControllers = [CountdownViewController]()
    var pageViewController : UIPageViewController!
    
    let newCountdownAlertController = UIAlertController(title: "New Countdown", message: "Enter new countdown data", preferredStyle: .alert)

    var currentIndex : Int?
    var prevIndex : Int?
    var isTraversingRight : Bool?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.currentIndex = 0
        self.isTraversingRight = false
        setupAlertBoxes()
        reset()
        //addButton.action = #selector (addButtonHandler(sender:))
        
    }
    
    func setupAlertBoxes(){
        self.newCountdownAlertController.addTextField { (titleTextField) in
            titleTextField.placeholder = "Enter the event name"
        }
        self.newCountdownAlertController.addTextField { (dateTextField) in
            dateTextField.placeholder = "Enter date here"
        }
        let actionOK = UIAlertAction.init(title: "OK", style: .default, handler: {
            (action: UIAlertAction) in print("ok has been pressed")
            self.pageTitles.append((self.newCountdownAlertController.textFields?[0].text)!)
            self.images.append("yas")
            self.pageContentViewControllers.append(self.viewControllerAtIndex(index: self.pageTitles.count - 1) as! CountdownViewController)
            self.pageViewController.setViewControllers([self.pageContentViewControllers[self.pageTitles.count - 1]], direction: .forward, animated: true, completion: nil)
            self.newCountdownAlertController.textFields?[0].text = ""
            print("added pagecontent viewcontroller \t with index of \(self.pageTitles.count - 1)")
            print(self.images.count, "\t", self.pageTitles.count)
        })
        let actionCancel = UIAlertAction.init(title: "Cancel", style: .default, handler: {
            (action: UIAlertAction) in print("Cancel has been pressed")
            
        })
        self.newCountdownAlertController.addAction(actionOK)
        self.newCountdownAlertController.addAction(actionCancel)
    }
    
    func reset() {
        
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
        
    }
    
    func delBarButtonHandler(){
        
        if currentIndex! > 0 && self.currentIndex! < self.pageTitles.count {
            self.pageTitles.remove(at: self.currentIndex!)
            self.images.remove(at: self.currentIndex!)
            self.pageContentViewControllers.remove(at: self.currentIndex!)
            self.pageViewController.setViewControllers([self.pageContentViewControllers[0]], direction: .reverse, animated: true, completion: nil)
            self.pageViewController.dataSource = nil
            self.pageViewController.dataSource = self
        }
        
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
    
        var index = (viewController as! CountdownViewController).pageIndex!
        
        self.isTraversingRight = true
        print("viewControllerAfter is called . . . \(index) ")
        index += 1
        
        if(index  >= self.images.count){
            return nil
        }
        //self.navItem.title = self.pageContentViewControllers[index].titleText
        return self.pageContentViewControllers[index]
        //return self.viewControllerAtIndex(index: index)
    
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    
        var index = (viewController as! CountdownViewController).pageIndex!
        
        self.isTraversingRight = false
        
        if(index <= 0){
            return nil
        }
         print("viewControllerBefore is called . . . \(index) ")
        index -= 1
        //self.navItem.title = self.pageContentViewControllers[index].titleText
        return self.pageContentViewControllers[index]
        //return self.viewControllerAtIndex(index: index)
    
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            print("completed! \(self.currentIndex) \t \((previousViewControllers[0] as! CountdownViewController).pageIndex) \t \(isTraversingRight)")
            var index = (previousViewControllers[0] as! CountdownViewController).pageIndex
            
            self.prevIndex = index
            
            if (self.isTraversingRight)!{
                index! += 1
            } else {
                index! -= 1
            }
            if index! >= self.pageContentViewControllers.count {
                index! -= 2
            }
            if index! < 0 {
                index! += 2
            }
            self.currentIndex = index
            self.navItem.title = (self.pageContentViewControllers[index!]).titleText
        }
    }
    
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        
        if((self.pageTitles.count == 0) || (index >= self.pageTitles.count)) {
            return nil
        }
        
        
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as! CountdownViewController
    
        pageContentViewController.imageName = self.images[index]
        pageContentViewController.titleText = self.pageTitles[index]
        pageContentViewController.pageIndex = index
        
        self.navItem.title = self.pageTitles[index]
        return pageContentViewController
    }
    
    private func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pageTitles.count
    }
    
    private func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}
