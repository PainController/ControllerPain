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

    class func createSubscriptionForConsult(userName: String, completionHandler: (success: Bool) -> Void) {
        let predicate = NSPredicate(format: "TRUEPREDICATE", userName)

        let subscription = CKSubscription(recordType: "CDBPI", predicate: predicate, options: .FiresOnRecordCreation)

        let notificationInfo = CKNotificationInfo()
        notificationInfo.alertLocalizationKey = "Nova requisição de consulta"
        notificationInfo.shouldBadge = true
        subscription.notificationInfo = notificationInfo

        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if let container: CKContainer? = CKContainer.defaultContainer() {
                let database = container!.publicCloudDatabase
                database.saveSubscription(subscription, completionHandler: { (subscription, error) -> Void in
                    if error != nil {
                        print(error!)
                        completionHandler(success: false)
                    } else {
                        completionHandler(success: true)
                    }
                })
            } else {
                completionHandler(success: false)
            }
        })

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

        indicator.startAnimating()

        dispatch_async(dispatch_get_main_queue()) { () -> Void in

            indicator.hidden = false

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let container: CKContainer? = CKContainer.defaultContainer() {
                    let database = container!.publicCloudDatabase
                    database.saveRecord(record) { (record, error) -> Void in
                        if error != nil {
                            indicator.stopAnimating()
                            indicator.hidden = true
                            completionHandler(success: false)
                        } else {
                            indicator.hidden = true
                            indicator.stopAnimating()
                            completionHandler(success: true)
                        }
                    }
                } else {
                    indicator.stopAnimating()
                    completionHandler(success: false)
                }
            })
        }

    }

    class func fetchConsultRecord(recordID: CKRecordID, completionHandler: (success: Bool, consult: (CDUserContact, NSData?, String?)?) -> Void) {
        if let container: CKContainer? = CKContainer.defaultContainer() {
            let database = container!.publicCloudDatabase
            database.fetchRecordWithID(recordID, completionHandler: { (record, error) -> Void in
                if error != nil {
                    // tratar
                    completionHandler(success: false, consult: nil)
                } else {
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        let convenium = record?.objectForKey("Convenium") as? String
                        let date = record?.objectForKey("Date") as? NSDate
                        let phone = record?.objectForKey("Telephone") as? String
                        let username = record?.objectForKey("Username") as? String
                        let mail = record?.objectForKey("Email") as? String
                        let images = record?.objectForKey("Images") as? NSData
                        let results = record?.objectForKey("Results") as? String

                        let contact = CDUserContact(name: username, convenio:  convenium, telephone: phone, email: mail, date: date)
                        let consult = (contact , images , results)

                        completionHandler(success: true, consult: consult)
                    }
                }
            })
        }
    }

}
