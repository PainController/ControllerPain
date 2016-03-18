//
//  CDCloudKitStack.swift
//  ControlaDor
//
//  Created by Isaías Lima on 10/03/16.
//  Copyright © 2016 PainController. All rights reserved.
//

import UIKit
import CloudKit

func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func random(min min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}

class CDCloudKitStack {

    private static var recordsToUpload: [CKRecord]!
    private static var index = 0

    private class func createNewRecordWithObject(object: (NSDate,Double,String)) -> CKRecord {
        let recordID = CKRecordID(recordName: "PainDatum : \(random(min: -1, max: 1) * random()) : \(NSDate())")
        let record = CKRecord(recordType: "PainDatum", recordID: recordID)

        record["Date"] = object.0
        record["Intensity"] = object.1
        record["Locais"] = object.2
        record["Name"] = "PainDatum : \(NSDate())"

        return record
    }

    class func uploadRecord(record: CKRecord, completionHandler: (success: Bool) -> Void) {
        if let container: CKContainer? = CKContainer.defaultContainer() {
            let database = container?.publicCloudDatabase
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                database?.saveRecord(record, completionHandler: { (record, error) -> Void in
                    if error == nil {
                        completionHandler(success: true)
                    } else {
                        print(error!)
                        completionHandler(success: false)
                    }
                })
            })
        }
    }

    class func createRecords(request: CDPainDataServerRequest) {
        var records = [CKRecord]()
        for tuple in request.painData {
            let record = createNewRecordWithObject(tuple)
            records.append(record)
        }
        recordsToUpload = records
    }

    class func uploadRecords(completionHandler: ((success: Bool) -> Void)?) {
        if index < recordsToUpload.count {
            uploadRecord(recordsToUpload[index]) { (success) -> Void in
                if success && index < recordsToUpload.count {
                    index++
                    uploadRecords({ (success) -> Void in
                    })
                } else if success && index == recordsToUpload.count {
                    index = 0
                } else if !success {
                    completionHandler?(success: false)
                }
            }
        } else {
            let center = NSNotificationCenter.defaultCenter()
            center.postNotificationName("Alert", object: nil)
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

    class func deleteRecord(recordID: CKRecordID, completionHandler: (success: Bool) -> Void) {
        if let container: CKContainer? = CKContainer.defaultContainer() {
            let database = container!.privateCloudDatabase

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                database.deleteRecordWithID(recordID, completionHandler: { (aRecordID, error) -> Void in
                    if error != nil {
                        print(error)
                        completionHandler(success: false)
                    } else {
                        completionHandler(success: true)
                    }
                })
            })
        }
    }

    class func deleteAllRecords(recordType: String, completionHandler: (success: Bool) -> Void) {
        fetchAllRecords(recordType) { (success, records) -> Void in
            if success {
                if let cloudRecords = records {
                    for record in cloudRecords {
                        deleteRecord(record.recordID, completionHandler: { (success) -> Void in
                            if !success {
                                completionHandler(success: false)
                                return
                            }
                        })
                    }
                    return
                } else {
                    completionHandler(success: false)
                    return
                }
            } else {
                completionHandler(success: false)
                return
            }
        }
    }

    class func fetchAllRecords(recordType: String, completionHandler: (success: Bool, records: [CKRecord]?) -> Void) {
        if let container: CKContainer? = CKContainer.defaultContainer() {
            let database = container!.publicCloudDatabase
            let predicate = NSPredicate(format: "TRUEPREDICATE", recordType)
            let query = CKQuery(recordType: recordType, predicate: predicate)

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                database.performQuery(query, inZoneWithID: nil, completionHandler: { (records, error) -> Void in
                    if error != nil {
                        completionHandler(success: false, records: nil)
                    } else {
                        completionHandler(success: true, records: records)
                    }
                })
            })
        }
    }

}
