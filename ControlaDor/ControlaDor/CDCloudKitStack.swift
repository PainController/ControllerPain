//
//  CDCloudKitStack.swift
//  ControlaDor
//
//  Created by Isaías Lima on 10/03/16.
//  Copyright © 2016 PainController. All rights reserved.
//

import UIKit
import CloudKit

class CDCloudKitStack {

    class func createNewRecordWithObject(object: CDPainDatum, andKey key: String, completionHandler: (success: Bool) -> Void) {
        let recordID = CKRecordID(recordName: "PainDatum : \(NSDate())")
        let record = CKRecord(recordType: "PainDatum", recordID: recordID)

        record["Date"] = object.date
        record["Intensity"] = object.intensity
        record["Locals"] = object.local

        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            if let container: CKContainer? = CKContainer.defaultContainer() {
                let database = container!.privateCloudDatabase
                database.saveRecord(record) { (record, error) -> Void in
                    if error != nil {
                        completionHandler(success: false)
                    } else {
                        completionHandler(success: true)
                    }
                }
            } else {
                completionHandler(success: true)
            }
        }

    }

    class func createBPIRecord(results: String, images: NSData, contact: CDUserContact, indicator: UIActivityIndicatorView, completionHandler: (success: Bool) -> Void){
        let recordID = CKRecordID(recordName: "CDBPI - consulta : \(NSDate())")
        let record = CKRecord(recordType: "CDBPI", recordID: recordID)

        record["Results"] = results
        record["Images"] = images
        record["Username"] = contact.name
        record["Convenium"] = contact.convenio
        record["Telephone"] = contact.telephone
        record["Email"] = contact.email
        record["Date"] = contact.date

        let predicate = NSPredicate(format: "Username == %@", contact.name!)

        let subscription = CKSubscription(recordType: "CDBPI", predicate: predicate, options: CKSubscriptionOptions.FiresOnRecordCreation)

        let notificationInfo = CKNotificationInfo()
        notificationInfo.alertLocalizationKey = "Nova requisição de consulta"
        notificationInfo.shouldBadge = true
        subscription.notificationInfo = notificationInfo

        dispatch_async(dispatch_get_main_queue()) { () -> Void in

            indicator.hidden = false
            indicator.startAnimating()

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let container: CKContainer? = CKContainer.defaultContainer() {
                    let database = container!.publicCloudDatabase
                    database.saveRecord(record) { (record, error) -> Void in
                        if error != nil {
                            indicator.stopAnimating()
                            indicator.hidden = true
                            completionHandler(success: false)
                        } else {
                            database.saveSubscription(subscription, completionHandler: { (subscription, error) -> Void in
                                if error != nil {
                                    indicator.hidden = true
                                    indicator.stopAnimating()
                                    print(error)
                                    completionHandler(success: false)
                                } else {
                                    indicator.hidden = true
                                    indicator.stopAnimating()
                                    completionHandler(success: true)
                                }
                            })
                        }
                    }
                } else {
                    completionHandler(success: false)
                }
            })
        }

    }

}
