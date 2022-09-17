//
//  DBManager.swift
//  EmployeeDirectory
//
//  Created by Gobinath on 17/09/22.
//

import Foundation

import CoreData
import UIKit


class DBManager : UIViewController {
    
    static  func insert (keyName : String, ValueName: String) {
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
        
        // 1
        let managedContext =
        appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
        NSEntityDescription.entity(forEntityName: "EmployeeDB",
                                   in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3 Set Values
        person.setValue(ValueName, forKeyPath: keyName)
        
        // 4 Insert in to Employee Entity
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
