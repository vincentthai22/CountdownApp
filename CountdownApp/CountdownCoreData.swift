//
//  CountdownCoreData.swift
//  CountdownApp
//
//  Created by Vincent on 12/23/16.
//  Copyright © 2016 Seven Logics. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CountdownCoreData {
    
    static let countdownCoreData = CountdownCoreData()
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    var managedContext : NSManagedObjectContext?
    var entity : NSEntityDescription?
    var countdownEvent : CountdownManagedObject?
    
    init(){
        
        self.managedContext = (self.appDelegate?.persistentContainer.viewContext)!
        self.entity = NSEntityDescription.entity(forEntityName: "Countdown", in: self.managedContext!)!
        
    }
    func fetchRequest() -> [CountdownManagedObject] {
        let request = NSFetchRequest<CountdownManagedObject>(entityName: "Countdown")
        do {
            let results = try self.managedContext?.fetch(request)
            return results!
        } catch {
            
        }
        return [CountdownManagedObject].init()
    }
    func insert(countdownEvent : CountdownManagedObject) -> Void {
        self.managedContext?.insert(countdownEvent)
    }
    func delete(countdownEvent : CountdownManagedObject) -> Void {
        self.managedContext?.delete(countdownEvent)
    }
    
    func refresh(countdownEvent : CountdownManagedObject) -> Void {
        self.managedContext?.refresh(countdownEvent, mergeChanges: true)
    }
    
    func getNewCountdownEvent() -> CountdownManagedObject {
        return CountdownManagedObject(entity: self.entity!, insertInto: self.managedContext)
    }
    
    func save() -> Void {
        do{
            try self.managedContext?.save()
        }catch {
            
        }
    }

}
