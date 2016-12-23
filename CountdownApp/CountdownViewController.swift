//
//  CountdownViewController.swift
//  CountdownApp
//
//  Created by Vincent on 12/20/16.
//  Copyright © 2016 Seven Logics. All rights reserved.
//

import Foundation
import UIKit

class CountdownViewController: UIViewController {
    
    let imageArray = [ #imageLiteral(resourceName: "Hotairballons"), #imageLiteral(resourceName: "butterfly-wallpaper"), #imageLiteral(resourceName: "alaska")]
    var pageIndex : Int?
    var titleText : String!
    var imageData : NSData!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    convenience init(pageIndex : Int, titleText : String, imageName : NSData ) {
        self.init()
        self.pageIndex = pageIndex
        self.titleText = titleText
        self.imageData = imageName
        
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let floatingLabel = UILabel.init(frame: CGRect.init(x: 100, y: 300, width: 100, height: 50))
        floatingLabel.text = "Drag me"
        floatingLabel.isUserInteractionEnabled = true
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(CountdownViewController.labelDragged) )
        floatingLabel.addGestureRecognizer(gesture)
        self.view.addSubview(floatingLabel)
        
        if self.imageData != nil {
            self.backgroundImageView.image = UIImage.init(data: self.imageData as Data)
        } else {
            self.backgroundImageView.image = imageArray[(Int(arc4random_uniform(UInt32(imageArray.count))))]
        }
        
    }
    
    func labelDragged(gesture : UIPanGestureRecognizer) -> Void {
        let label = gesture.view
        let translation = gesture.translation(in: label)
        label?.center = CGPoint.init(x: (label?.center.x)! + translation.x, y: (label?.center.y)! + translation.y)
        gesture.setTranslation(CGPoint.zero, in: label)
    }
    
}
