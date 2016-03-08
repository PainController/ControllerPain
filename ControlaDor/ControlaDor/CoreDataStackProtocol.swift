//
//  File.swift
//  ControlaDor
//
//  Created by Isaías Lima on 08/03/16.
//  Copyright © 2016 PainController. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataStackProtocol {
    // MARK: - Core Data stack

    var applicationDocumentsDirectory: NSURL { get set }

    var managedObjectModel: NSManagedObjectModel { get set }

    var persistentStoreCoordinator: NSPersistentStoreCoordinator { get set }

    var managedObjectContext: NSManagedObjectContext { get set }

    // MARK: - Core Data Saving support

    func saveContext()
}