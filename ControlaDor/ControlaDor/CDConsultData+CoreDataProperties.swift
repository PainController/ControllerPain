//
//  CDConsultData+CoreDataProperties.swift
//  ControlaDor
//
//  Created by Isaías Lima on 15/03/16.
//  Copyright © 2016 PainController. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CDConsultData {

    @NSManaged var contact: NSData?
    @NSManaged var images: NSData?
    @NSManaged var results: String?

}
