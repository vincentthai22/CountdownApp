//
//  CountdownManagedObject+CoreDataProperties.swift
//  CountdownApp
//
//  Created by Vincent on 12/22/16.
//  Copyright © 2016 Seven Logics. All rights reserved.
//

import Foundation
import CoreData



extension CountdownManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CountdownManagedObject> {
        return NSFetchRequest<CountdownManagedObject>(entityName: "Countdown");
    }
    
    @NSManaged public var date: Date?
    @NSManaged public var title: String?
    @NSManaged public var imageData: NSData?
    
}
