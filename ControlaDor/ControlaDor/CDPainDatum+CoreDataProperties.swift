//
//  CDPainDatum+CoreDataProperties.swift
//  ControlaDor
//
//  Created by Isaías Lima on 09/03/16.
//  Copyright © 2016 PainController. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CDPainDatum {

    @NSManaged var intensity: Double
    @NSManaged var date: NSDate?
    @NSManaged var local: String?

}
